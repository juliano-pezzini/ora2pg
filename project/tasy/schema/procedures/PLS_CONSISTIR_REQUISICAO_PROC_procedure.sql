-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_requisicao_proc ( nr_seq_requisicao_proc_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realiza a consistencia dos procedimentos da requisicao, cobertura, carencia, limitacao e ocorrencias.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
1 - Tomar muito cuidado com a performance
2 - Tomar cuidado pois as consistencias de cobertura, carencia, limitacao e ocorrencias. nao podem para de fuincionar.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_segurado_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
qt_glosa_w			bigint;
ie_status_w			varchar(2);
nr_seq_requisicao_w		bigint;
ie_tipo_guia_w			varchar(2);
nr_seq_plano_w			bigint;
qt_solicitada_grupo_w		pls_requisicao_proc.qt_solicitado%type;
dt_requisicao_w			timestamp;
nr_seq_regra_limitacao_w	bigint;
qt_solicitado_w			pls_requisicao_proc.qt_solicitado%type;
nr_seq_prestador_w		bigint;
nr_seq_uni_exec_w		bigint;
ie_tipo_processo_w		varchar(4);
nr_seq_congenere_w		bigint;
ie_regulamentacao_w		varchar(2);
ie_segmentacao_w		varchar(3);
ie_proc_inativo_w		varchar(1) := 'S';
qt_dias_vencido_w		bigint;
ie_tipo_pagador_w		varchar(2);
ie_tipo_intercambio_w		varchar(10);
nr_seq_regra_w			bigint;
ie_permite_w			varchar(2);
ie_tipo_gat_w			varchar(1);
ie_proc_audioria_w		varchar(1);
ie_cheque_w			varchar(1);
qt_idade_segurado_w		bigint;
ie_consulta_urgencia_w		varchar(1);
nr_seq_prestador_exec_w		bigint;
ie_carencia_abrangencia_ant_w	varchar(10);
ie_carater_atendimento_w	pls_requisicao.ie_carater_atendimento%type;
ie_gerar_nova_req_w		pls_param_importacao_guia.ie_gerar_nova_req%type;


BEGIN

-- gerencia a atualizacao da tabela TM para estrutura de materiais
CALL PLS_GERENCIA_UPD_OBJ_PCK.ATUALIZAR_OBJETOS('Tasy', 'PLS_CONSISTIR_REQUISICAO_PROC', 'PLS_ESTRUTURA_MATERIAL_TM');
--Atualizando a tabela de grupo de procedimentos
CALL PLS_GERENCIA_UPD_OBJ_PCK.ATUALIZAR_OBJETOS('Tasy', 'PLS_CONSISTIR_REQUISICAO_PROC', 'PLS_GRUPO_SERVICO_TM');
-- gerencia a atualizacao da tabela TM para para grupos de materiais
CALL PLS_GERENCIA_UPD_OBJ_PCK.ATUALIZAR_OBJETOS('Tasy', 'PLS_CONSISTIR_REQUISICAO_PROC', 'PLS_GRUPO_MATERIAL_TM');

select	a.nr_seq_segurado,
	b.cd_procedimento,
	b.ie_origem_proced,
	a.nr_sequencia,
	a.ie_tipo_guia,
	a.nr_seq_plano,
	a.nr_seq_prestador,
	a.nr_seq_uni_exec,
	a.ie_tipo_processo,
	a.dt_requisicao,
	a.ie_tipo_intercambio,
	a.ie_tipo_gat,
	b.qt_solicitado,
	a.ie_consulta_urgencia,
	a.nr_seq_prestador_exec,
	a.ie_carater_atendimento
into STRICT	nr_seq_segurado_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	nr_seq_requisicao_w,
	ie_tipo_guia_w,
	nr_seq_plano_w,
	nr_seq_prestador_w,
	nr_seq_uni_exec_w,
	ie_tipo_processo_w,
	dt_requisicao_w,
	ie_tipo_intercambio_w,
	ie_tipo_gat_w,
	qt_solicitado_w,
	ie_consulta_urgencia_w,
	nr_seq_prestador_exec_w,
	ie_carater_atendimento_w
from	pls_requisicao	   a,
	pls_requisicao_proc	   b
where	a.nr_sequencia	= b.nr_seq_requisicao
and	b.nr_sequencia	= nr_seq_requisicao_proc_p;

/* 1806 - Quantidade de procedimento deve ser maior que zero*/

if (qt_solicitado_w <= 0) then /*Diego OS - 331185 - Deve considerar quantidade negativas.*/
	CALL pls_gravar_requisicao_glosa('1806', null, nr_seq_requisicao_proc_p,
				null, '', nm_usuario_p,
				nr_seq_prestador_w, cd_estabelecimento_p, null,
				'');
end if;

qt_dias_vencido_w	:= pls_obter_dias_inadimplencia(nr_seq_segurado_w);
ie_cheque_w		:= pls_obter_se_cheque_devolucao(nr_seq_segurado_w);

begin
	select	coalesce(ie_carencia_abrangencia_ant,'N')
	into STRICT	ie_carencia_abrangencia_ant_w
	from	pls_parametros
	where	cd_estabelecimento	= cd_estabelecimento_p;
exception
when others then
	select	coalesce(max(ie_carencia_abrangencia_ant),'N')
	into STRICT	ie_carencia_abrangencia_ant_w
	from	pls_parametros;
end;

begin
select	CASE WHEN b.cd_cgc='' THEN 'PF'  ELSE 'PJ' END
into STRICT	ie_tipo_pagador_w
from	pls_contrato_pagador	b,
	pls_segurado		a
where	a.nr_sequencia		= nr_seq_segurado_w
and	a.nr_seq_pagador	= b.nr_sequencia;
exception
	when others then
	ie_tipo_pagador_w	:= 'A';
end;

ie_proc_inativo_w :=	pls_obter_se_proc_inativo(cd_procedimento_w,ie_origem_proced_w,dt_requisicao_w);

if (ie_proc_inativo_w = 'N') then
	CALL pls_gravar_requisicao_glosa('9920', null, nr_seq_requisicao_proc_p,
				null, 'Procedimento inativo ou fora de vigencia. (Funcao: Procedimentos)', nm_usuario_p,
				nr_seq_prestador_w, cd_estabelecimento_p, null,
				'');
end if;

if (coalesce(ie_tipo_intercambio_w,'X')	<> 'I') then
	if (coalesce(pls_obter_regra_limitacao(cd_procedimento_w,null,ie_origem_proced_w,nr_seq_segurado_w,null),'0') <> '0') then			
		select	pls_obter_regra_limitacao(cd_procedimento_w,null,ie_origem_proced_w,nr_seq_segurado_w,null),
			coalesce(a.qt_solicitado,0)
		into STRICT	nr_seq_regra_limitacao_w,
			qt_solicitada_grupo_w
		from	pls_requisicao_proc a
		where	a.nr_sequencia	= nr_seq_requisicao_proc_p;
	else
		qt_solicitada_grupo_w := qt_solicitado_w;				

	end if;
	
	select	ie_regulamentacao,
		ie_segmentacao
	into STRICT	ie_regulamentacao_w,
		ie_segmentacao_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_plano_w;

	qt_glosa_w := pls_consistir_cobertura_proc(	nr_seq_segurado_w, null, null, null, cd_procedimento_w, ie_origem_proced_w, clock_timestamp(), ie_segmentacao_w, cd_estabelecimento_p, nr_seq_requisicao_proc_p, nm_usuario_p, qt_glosa_w, 'R');

	if (coalesce(qt_glosa_w,0) = 0) then
		CALL pls_consistir_limitacao_proc(nr_seq_segurado_w, null, null, null, nr_seq_requisicao_proc_p, cd_procedimento_w, ie_origem_proced_w,
						qt_solicitada_grupo_w, null, cd_estabelecimento_p, nm_usuario_p);
		CALL pls_consistir_carencia_proc(nr_seq_segurado_w, null, null, null, nr_seq_requisicao_proc_p, cd_procedimento_w,
						ie_origem_proced_w, dt_requisicao_w, cd_estabelecimento_p, nm_usuario_p,
						null,ie_carencia_abrangencia_ant_w);
	end if;
	
	CALL pls_consistir_cpt(	nr_seq_segurado_w, null, null,
					null, nr_seq_requisicao_proc_p, cd_procedimento_w, 
					ie_origem_proced_w, dt_requisicao_w, cd_estabelecimento_p, 
					nm_usuario_p);
	
	begin
		select	coalesce(ie_gerar_nova_req, 'N')
		into STRICT	ie_gerar_nova_req_w
		from	pls_param_importacao_guia;
	exception
	when others then
		ie_gerar_nova_req_w	:= 'N';
	end;
	
	/*
	Alexandre , OS  353551. Nao pode gerar a glosa 1214 para as requisicoes;
	pls_consistir_proc_prestador(nr_seq_prestador_w, null, null, nr_seq_requisicao_proc_p, null, cd_estabelecimento_p, nm_usuario_p,null);
	Djavan, OS 458107. Realizar esta consistencia somente quando for requisicao feita no portal web de consulta ou consulta urgencia
	*/
	if (coalesce(nr_seq_prestador_exec_w,0) > 0) and (((ie_tipo_processo_w	= 'P') and ((ie_tipo_guia_w	= '3') or (ie_consulta_urgencia_w	= 'S')))
		or (ie_tipo_processo_w	= 'E' AND ie_gerar_nova_req_w	= 'S')) then			
		CALL pls_consistir_proc_prestador(nr_seq_prestador_exec_w, null, null, nr_seq_requisicao_proc_p, null, cd_estabelecimento_p, nm_usuario_p,null);
	end if;

	qt_idade_segurado_w := pls_obter_idade_segurado(nr_seq_segurado_w, dt_requisicao_w, 'A');

	CALL pls_consistir_benef_proc(nr_seq_segurado_w,null, null, nr_seq_requisicao_proc_p, 'CG', nm_usuario_p, cd_estabelecimento_p,qt_idade_segurado_w);
end if;

-- OS 1450412, nao deve consistir a abrangencia geografica nos atendimentos de urgencia/emergencia
if (coalesce(ie_carater_atendimento_w,'X') <> 'U') then	
	SELECT * FROM pls_consiste_rede_atend(null, null, null, nr_seq_requisicao_w, null, null, null, nr_seq_requisicao_proc_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_regra_w, ie_permite_w) INTO STRICT nr_seq_regra_w, ie_permite_w;
end if;

/*
select	count(1)
into	qt_registros_w
from	pls_requisicao_glosa
where	nr_seq_req_proc	= nr_seq_requisicao_proc_p;
*/
ie_proc_audioria_w	:= pls_obter_se_gerar_analise(nr_seq_requisicao_w,nr_seq_requisicao_proc_p,5);

begin
select	nr_seq_congenere
into STRICT	nr_seq_congenere_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_w;
exception
when others then
	nr_seq_congenere_w	:= null;
end;

if (coalesce(ie_proc_audioria_w,'N')	= 'N') then
	update	pls_requisicao_proc
	set	ie_status	= 'N',
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_requisicao_proc_p;
else
	/*pls_gerar_ocorrencia(	nr_seq_segurado_w, nr_seq_requisicao_w, null,
				null, nr_seq_requisicao_proc_p, null, 
				cd_procedimento_w, ie_origem_proced_w, null,
				ie_tipo_guia_w, nr_seq_plano_w, 'A',
				null, null,  nr_seq_prestador_w,
				null,'I','',
				'',nm_usuario_p, cd_estabelecimento_p,
				nr_seq_uni_exec_w,'N', null, null, null);*/
				
	CALL pls_gerar_ocorrencia_aut(nr_seq_segurado_w, nr_seq_requisicao_w, null,
				null, nr_seq_requisicao_proc_p, null,
				cd_procedimento_w, ie_origem_proced_w, null,
				ie_tipo_guia_w, nr_seq_plano_w, 
				qt_dias_vencido_w, ie_tipo_pagador_w,  nr_seq_prestador_w,
				null,'I','',
				'',nm_usuario_p, cd_estabelecimento_p,
				nr_seq_congenere_w, ie_cheque_w, null);
				
	select	ie_status
	into STRICT	ie_status_w
	from	pls_requisicao_proc
	where	nr_sequencia = nr_seq_requisicao_proc_p;

	if (ie_status_w not in ('A','N')) then
		--pls_obter_regra_exe_requisicao( cd_estabelecimento_p ,cd_procedimento_w,ie_origem_proced_w,0,nr_seq_grupo_execucao_w);
			
		if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') and (ie_tipo_gat_w <> 'S') then
			update	pls_requisicao_proc
			set	ie_status		= 'I',
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p,
				qt_procedimento		= qt_solicitado
			where	nr_sequencia		= nr_seq_requisicao_proc_p;
		else
			update	pls_requisicao_proc
			set	ie_status		= 'S',
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p,
				qt_procedimento		= qt_solicitado
			where	nr_sequencia		= nr_seq_requisicao_proc_p;
		end if;
	end if;	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_requisicao_proc ( nr_seq_requisicao_proc_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

