-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consiste_glosa_proc ( nr_seq_conta_p pls_conta.nr_sequencia%type, ie_tipo_consiste_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
********* SE FOR ALTERAR ALGUMA COISA NESTA ROTINA, FAVOR VERIFICAR A pls_consiste_procedimento. ELA E UTILIZADA NO PROCESSO ANTIGO DE CONTAS MEDICAS. *********************
********* HOUVE DUPLICACAO DE CODIGO PARA MANTERMOS AS GLOSAS FUNCIONANDO NOS DOIS MODELOS *****************************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/


/* IE_TIPO_CONSISTE_P - dominio 1977
	IG 	|Importacao do arquivo guia
	CC             	|Consistir Conta
	CG             	|Consistir Guia
	IA             	|Importacao do arquivo conta
	CR             	|Consistir Reembolso
	DC	|Digitacao da conta no portal
	I5	Importacao do arquivo PTU A500
*/
nr_seq_conta_proc_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_tipo_atendimento_w	bigint;
nr_seq_prestador_w		bigint;
nr_seq_acao_regra_w		bigint;
ds_retorno_w			varchar(2000);
ie_tipo_guia_w			varchar(2);
ie_tipo_despesa_w		varchar(1);
ds_tipo_guia_w			varchar(255);
nr_seq_grupo_ans_w		bigint	:= null;
ie_via_acesso_w			varchar(2);
ie_tipo_internacao_w		varchar(1);
nr_seq_conta_w			bigint;
nr_seq_clinica_w		bigint;
qt_procedimento_w		double precision;
cd_medico_executor_w		varchar(20);
ie_regime_internacao_w		varchar(1);
ie_tipo_conta_w			bigint;
nr_seq_conselho_w		bigint;
	
cd_procedimento_ant_w		bigint	:= 0;
ie_origem_proced_ant_w		bigint	:= 0;
ie_tipo_conta_ant_w		bigint	:= 0;
ie_origem_conta_w		pls_conta.ie_origem_conta%type;
ie_gerar_grupo_ans_w		varchar(1);

C01 CURSOR FOR
	SELECT	1,
		nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		ie_tipo_despesa,
		ie_via_acesso,
		qt_procedimento_imp
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_conta_p
	and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '')
	and	(ie_origem_proced IS NOT NULL AND ie_origem_proced::text <> '')
	and	ie_tipo_consiste_p in ('CC','DC','I5')
	
union

	SELECT	2,
		nr_sequencia,
		coalesce(cd_procedimento,cd_procedimento_imp),
		ie_origem_proced,
		ie_tipo_despesa,
		ie_via_acesso_imp,
		qt_procedimento_imp
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_tipo_consiste_p = 'IA'
	order by
		1,
		cd_procedimento,
		ie_origem_proced;


BEGIN

if (ie_tipo_consiste_p	in ('CC','DC','I5')) then
	/* Obter dados da conta */

	begin
		select	a.nr_sequencia,
			a.nr_seq_tipo_atendimento,
			a.ie_tipo_guia,
			a.cd_medico_executor,
			a.ie_regime_internacao,
			a.nr_seq_clinica,
			b.nr_seq_prestador,
			a.ie_origem_conta
		into STRICT	nr_seq_conta_w,
			nr_seq_tipo_atendimento_w,
			ie_tipo_guia_w,
			cd_medico_executor_w,
			ie_regime_internacao_w,
			nr_seq_clinica_w,
			nr_seq_prestador_w,
			ie_origem_conta_w
		from	pls_conta		a,
			pls_protocolo_conta 	b
		where	a.nr_seq_protocolo 	= b.nr_sequencia
		and	a.nr_sequencia		= nr_seq_conta_p;
	exception
	when others then
		nr_seq_conta_w		:= null;
		nr_seq_tipo_atendimento_w := null;
		ie_tipo_guia_w		:= null;
		ie_regime_internacao_w	:= null;
		cd_medico_executor_w	:= null;
		nr_seq_clinica_w	:= null;
		nr_seq_prestador_w	:= null;
	end;
elsif (ie_tipo_consiste_p	= 'IA') then
	begin
		select	a.nr_sequencia,
			pls_obter_tipo_atend_tiss(a.ie_tipo_atendimento_imp, cd_estabelecimento_p),
			a.ie_tipo_guia,
			a.ie_regime_internacao_imp,
			pls_obter_dados_gerar_conta(a.nr_sequencia,'M'),
			a.nr_seq_clinica,
			b.nr_seq_prestador,
			a.ie_origem_conta
		into STRICT	nr_seq_conta_w,
			nr_seq_tipo_atendimento_w,
			ie_tipo_guia_w,
			ie_regime_internacao_w,
			cd_medico_executor_w,
			nr_seq_clinica_w,
			nr_seq_prestador_w,
			ie_origem_conta_w
		from	pls_conta		a,
			pls_protocolo_conta 	b
		where	a.nr_seq_protocolo 	= b.nr_sequencia
		and	a.nr_sequencia		= nr_seq_conta_p;
	exception
	when others then
		nr_seq_conta_w		:= null;
		nr_seq_tipo_atendimento_w := null;
		ie_tipo_guia_w		:= null;
		ie_regime_internacao_w	:= null;
		cd_medico_executor_w	:= null;
		nr_seq_clinica_w	:= null;
		nr_seq_prestador_w	:= null;
	end;
end if;


/*Conselho do medico executor*/

begin
select	nr_seq_conselho
into STRICT	nr_seq_conselho_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_medico_executor_w;
exception
	when others then
	nr_seq_conselho_w	:= null;
end;

open C01;
loop
fetch C01 into	
	ie_tipo_conta_w,
	nr_seq_conta_proc_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	ie_tipo_despesa_w,
	ie_via_acesso_w,
	qt_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	SELECT * FROM pls_obter_acao_regra_conta(nr_seq_conta_proc_w, ie_tipo_consiste_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_clinica_w, nr_seq_acao_regra_w, ds_retorno_w) INTO STRICT nr_seq_acao_regra_w, ds_retorno_w;
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		CALL pls_gravar_conta_glosa('9910', nr_seq_conta_p, null,
					null, 'N', ds_retorno_w || '(Regra: '||nr_seq_acao_regra_w||')',
					nm_usuario_p, 'A', ie_tipo_consiste_p,
					nr_seq_prestador_w, cd_estabelecimento_p, '',null);
	
	end if;
	
	/* OS 101173 - Felipe */

	if (ie_tipo_despesa_w	= '3') and (ie_tipo_guia_w		<> '5') then
		CALL pls_gravar_conta_glosa('9913', nr_seq_conta_p, nr_seq_conta_proc_w,
					null, 'N', 'As diarias podem ser lancadas somente em contas de guia Resumo de internacao (Guia conta: ' || ds_tipo_guia_w || ') ' ||
					nr_seq_tipo_atendimento_w, nm_usuario_p, 'A', 
					ie_tipo_consiste_p, nr_seq_prestador_w, cd_estabelecimento_p, '', null);
	end if;
	if (ie_tipo_despesa_w	= '1') then /* Felipe - 16/10/2008 - OS 113220 */
		CALL pls_consiste_participante(nr_seq_conta_proc_w, ie_tipo_consiste_p, nm_usuario_p, cd_estabelecimento_p);
	end if;

	if (ie_gerar_grupo_ans_w = 'S') and
		((cd_procedimento_w <> cd_procedimento_ant_w) or (ie_origem_proced_w <> ie_origem_proced_ant_w) or (ie_tipo_conta_w <> ie_tipo_conta_ant_w)) then
		nr_seq_grupo_ans_w	:= pls_obter_grupo_ans(	cd_procedimento_w, ie_origem_proced_w, nr_seq_conselho_w,
							nr_seq_tipo_atendimento_w, ie_tipo_guia_w, ie_regime_internacao_w,
							ie_tipo_conta_w, 'G',cd_estabelecimento_p, nr_seq_conta_w);
	end if;

	if (coalesce(nr_seq_grupo_ans_w::text, '') = '') and (ie_gerar_grupo_ans_w = 'S') then
		CALL pls_gravar_conta_glosa('9908','', nr_seq_conta_proc_w,null,'N',
					'Verificar as regras de procedimento X Grupo ANS',
					nm_usuario_p,'A',ie_tipo_consiste_p,nr_seq_prestador_w,
					cd_estabelecimento_p, '', null);
	end if;
	
	ie_tipo_internacao_w	:= pls_obter_se_internado(nr_seq_conta_w,'');
	
	select	CASE WHEN ie_tipo_internacao_w='S' THEN  'I'  ELSE 'A' END
	into STRICT	ie_tipo_internacao_w
	;
	
	-- 1423 - Quantidade solicitada acima da quantidade permitida
	CALL pls_consistir_qtde_proc(nr_seq_conta_p, cd_procedimento_w, ie_origem_proced_w,
				nr_seq_conta_proc_w, ie_tipo_consiste_p, ie_tipo_guia_w,
				ie_tipo_internacao_w, '', cd_estabelecimento_p,
				nm_usuario_p);
	
	cd_procedimento_ant_w	:= cd_procedimento_w;
	ie_origem_proced_ant_w	:= ie_origem_proced_w;
	ie_tipo_conta_ant_w	:= ie_tipo_conta_w;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consiste_glosa_proc ( nr_seq_conta_p pls_conta.nr_sequencia%type, ie_tipo_consiste_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

