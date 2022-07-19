-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_conta_guia_prod_out ( nr_seq_guia_p bigint, nr_seq_prestador_atend_p bigint, ie_origem_dados_p bigint, cd_medico_exec_p INOUT bigint, cd_guia_p INOUT text, dt_autorizacao_p INOUT timestamp, cd_senha_p INOUT text, dt_validade_senha_p INOUT timestamp, nr_seq_segurado_p INOUT bigint, cd_medico_solicitante_p INOUT text, ie_tipo_guia_p INOUT text, ie_carater_internacao_p INOUT text, nr_seq_prestador_p INOUT bigint, ie_status_p INOUT text, cd_guia_principal_p INOUT text, nr_crm_exec_p INOUT text, uf_crm_exec_p INOUT text, nr_conselho_exec_p INOUT text, nr_seq_tipo_atendimento_p INOUT bigint, nr_seq_clinica_p INOUT bigint, ie_regime_internacao_p INOUT text, nr_seq_tipo_acomodacao_p INOUT bigint, ie_tipo_consulta_p INOUT text, cd_cooperativa_p INOUT text, ie_recem_nascido_p INOUT text, nm_recem_nascido_p INOUT text, dt_nasc_recem_nascido_p INOUT timestamp, ie_tipo_saida_p INOUT text, ds_indicacao_clinica_p INOUT pls_conta.ds_indicacao_clinica%type, cd_especialidade_p INOUT bigint, ie_tipo_guia_dois_p INOUT text, nr_seq_saida_consulta_p INOUT bigint, ie_origem_conta_p INOUT text, nr_Seq_cbo_saude_p INOUT bigint, ie_indicacao_acidente_p INOUT text, cd_doenca_p INOUT text, nr_seq_prestador_atend_dois_p INOUT bigint, dt_emissao_p INOUT timestamp, dt_atendimento_p INOUT timestamp, nr_seq_prestador_exec_p INOUT bigint, cd_guia_prestador_p INOUT text, ie_cobertura_especial_p INOUT text, ie_regime_atendimento_p INOUT text, ie_saude_ocupacional_p INOUT text) AS $body$
DECLARE


cd_guia_w			varchar(20);
dt_autorizacao_w		timestamp;
cd_senha_w			varchar(20);
dt_validade_senha_w		timestamp;
nr_seq_segurado_w		bigint;
cd_medico_solicitante_w		varchar(10);
ie_tipo_guia_w			varchar(2);
dt_emissao_w			timestamp;
ie_carater_internacao_w		varchar(1);
nr_seq_prestador_w		bigint;
ie_status_w			varchar(2);
cd_guia_principal_w		varchar(20);
cd_estabelecimento_w		smallint;
nr_seq_conta_w			bigint;
nr_crm_exec_w			varchar(20);
nr_seq_cbo_saude_w		bigint;
uf_crm_exec_w			varchar(2);
nr_conselho_exec_w		varchar(20);
nr_seq_tipo_atendimento_w	bigint;
nr_seq_clinica_w		bigint;
ie_regime_internacao_w		varchar(1);
nr_seq_tipo_acomodacao_w	bigint;
nr_seq_prestador_atend_w	bigint;
ie_origem_conta_w		varchar(1);
ie_tipo_consulta_w		smallint;
ie_imp_med_exec_solic_w		varchar(2);
cd_medico_exec_w		bigint;
cd_cooperativa_w		varchar(10);
ie_recem_nascido_w		varchar(1);		
nm_recem_nascido_w		varchar(60);
dt_nasc_recem_nascido_w		timestamp;
ie_tipo_saida_w			varchar(1);
nr_seq_saida_consulta_w		bigint;
ie_indicacao_acidente_w		varchar(1);
cd_especialidade_w		bigint;
cd_doenca_w			varchar(10);
ie_tipo_guia_ww			smallint;
dt_atendimento_w		timestamp;
qt_execucao_requisicao_w	bigint;
nr_seq_prestador_exec_w		bigint;
cd_pessoa_fis_exec_w		pls_prestador.cd_pessoa_fisica%type;
ds_indicacao_clinica_w		pls_conta.ds_indicacao_clinica%type;
nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type;
cd_medico_executor_w		pls_execucao_req_item.cd_medico_executor%type;
cd_guia_prestador_w		pls_guia_plano.cd_guia_prestador%type;
ie_cbo_autorizado_w		pls_parametros.ie_cbo_autorizado%type;
ie_cobertura_especial_w	pls_guia_plano.ie_cobertura_especial%type;
ie_regime_atendimento_w	pls_guia_plano.ie_regime_atendimento%type;
ie_saude_ocupacional_w  pls_guia_plano.ie_saude_ocupacional%type;


/*IE_ORIGEM_DADOS_P
Verifica se dados especificos serao buscados da autorizacao ou da requisicao
se o parametro for igual a 1 entao ira buscar da requisicao
se nao busca da autorizacao.*/


-- Dados da Requisicao X Execucao X Autorizacao (PLS_REQUISICAO, PLS_EXECUCAO_REQUISICAO)
C01 CURSOR(nr_seq_guia_p	pls_guia_plano.nr_sequencia%type) FOR
	SELECT	a.dt_execucao		dt_execucao,
		a.nr_seq_prestador	nr_seq_prestador_exec,/*Deve buscar o prestador da execucao*/
		b.nr_seq_prestador	nr_seq_prestador,
		b.cd_medico_solicitante	cd_medico_solicitante,
		b.ie_tipo_consulta	ie_tipo_consulta,
		a.nr_sequencia		nr_seq_execucao
	from	pls_execucao_requisicao	a,
		pls_requisicao		b
	where	a.nr_seq_guia	= nr_seq_guia_p
	and	b.nr_sequencia	= a.nr_seq_requisicao;
	
-- Dados do diagnostico da guia. (PLS_DIAGNOSTICO)
C02 CURSOR(nr_seq_guia_p	pls_guia_plano.nr_sequencia%type) FOR
	SELECT  a.ie_indicacao_acidente ie_indicacao_acidente,
		a.cd_doenca cd_doenca
	from    pls_diagnostico	a
	where   a.nr_seq_guia = nr_seq_guia_p
	and     ((a.ie_classificacao = 'P') or (a.ie_classificacao_imp = 'P'))
	order by a.qt_tempo desc,
		coalesce(a.ie_indicacao_acidente,'5'),
		coalesce(a.ie_tipo_doenca, '0') desc;


BEGIN
-- Dados do diagnostico da guia (pls_diagnostico). 
ie_indicacao_acidente_w	:= null;
cd_doenca_w		:= null;
for	r_C02_w in C02(nr_seq_guia_p) loop
	ie_indicacao_acidente_w		:= r_C02_w.ie_indicacao_acidente;
        cd_doenca_w			:= r_C02_w.cd_doenca;
end loop; -- C02

/*Dados da guia*/

select	a.cd_guia,
	a.dt_autorizacao,
	coalesce(a.cd_senha,null),
	a.dt_validade_senha,
	a.nr_seq_segurado,
	coalesce(a.cd_medico_solicitante,null),
	CASE WHEN a.ie_tipo_guia=2 THEN 4 WHEN a.ie_tipo_guia=3 THEN 3  ELSE 5 END ,
	a.dt_emissao,
	a.ie_carater_internacao,
	a.nr_seq_prestador,
	a.ie_status,
	a.cd_guia_principal,
	a.cd_estabelecimento,
	substr(obter_dados_medico(cd_medico_exec_p,'CRM'),1,255),
	substr(obter_dados_medico(cd_medico_exec_p,'UFCRM'),1,255),
	substr(pls_obter_seq_conselho_prof(cd_medico_exec_p),1,255),
	(select max(x.nr_sequencia)
	 from	pls_tipo_atendimento	x
	 where	(x.cd_tiss)::numeric  = (a.ie_tipo_atend_tiss)::numeric 
	 and	x.cd_estabelecimento	= a.cd_estabelecimento),
	a.nr_seq_clinica,
	a.ie_regime_internacao,
	a.nr_seq_tipo_acomodacao,
	a.ie_tipo_consulta,
	substr(obter_cooperativa_benef(a.nr_seq_segurado,a.cd_estabelecimento),1,4),	
	a.ie_recem_nascido,	
	a.nm_recem_nascido,
	a.dt_nasc_recem_nascido,	
	a.ie_tipo_saida,
	substr(a.ds_indicacao_clinica,1,500),
	coalesce(cd_especialidade,0),
	a.ie_tipo_guia,
	coalesce(a.cd_guia_prestador, a.cd_guia),
	nr_seq_cbo_saude,
	ie_cobertura_especial,
	ie_regime_atendimento,
	ie_saude_ocupacional
into STRICT	cd_guia_w,
	dt_autorizacao_w,
	cd_senha_w,
	dt_validade_senha_w,
	nr_seq_segurado_w,
	cd_medico_solicitante_w,
	ie_tipo_guia_w,
	dt_emissao_w,
	ie_carater_internacao_w,
	nr_seq_prestador_w,
	ie_status_w,
	cd_guia_principal_w,
	cd_estabelecimento_w,
	nr_crm_exec_w,
	uf_crm_exec_w,
	nr_conselho_exec_w,
	nr_seq_tipo_atendimento_w,
	nr_seq_clinica_w,
	ie_regime_internacao_w,
	nr_seq_tipo_acomodacao_w,
	ie_tipo_consulta_w,
	cd_cooperativa_w,	
	ie_recem_nascido_w,
	nm_recem_nascido_w,
	dt_nasc_recem_nascido_w,	
	ie_tipo_saida_w,
	ds_indicacao_clinica_w,
	cd_especialidade_w,
	ie_tipo_guia_ww,
	cd_guia_prestador_w,
	nr_seq_cbo_saude_w,
	ie_cobertura_especial_w,
	ie_regime_atendimento_w,
	ie_saude_ocupacional_w
from	pls_guia_plano	a
where	nr_sequencia	= nr_seq_guia_p;


nr_seq_prestador_atend_w := null;
/*So busca os dados da requisicao se o parametro [10] estiver como 1 drquadros - 582305*/

if (ie_origem_dados_p = 1) then
	-- Dados da Requisicao X Execucao X Autorizacao
	dt_atendimento_w		:= null;
	nr_seq_prestador_exec_w		:= null;
	nr_seq_prestador_atend_w	:= null;
	cd_medico_solicitante_w		:= null;
	for	r_C01_w in C01(nr_seq_guia_p) loop
		dt_atendimento_w		:= r_C01_w.dt_execucao;
		dt_emissao_w			:= r_C01_w.dt_execucao;
		nr_seq_prestador_exec_w		:= r_C01_w.nr_seq_prestador_exec;
		nr_seq_prestador_atend_w	:= r_C01_w.nr_seq_prestador;
		cd_medico_solicitante_w		:= r_C01_w.cd_medico_solicitante;
		ie_tipo_consulta_w		:= r_C01_w.ie_tipo_consulta;
		/*Conforme visto com Felipe da unimed SJRP ira bucar o max dos executores do item quando for para buscar as informacoes da execucao drquadros 582244 */

		select 	max(cd_medico_executor)
		into STRICT	cd_medico_executor_w
		from	pls_execucao_req_item
		where	nr_seq_execucao = r_C01_w.nr_seq_execucao;
		
		begin
			cd_medico_exec_p	:=  (cd_medico_executor_w)::numeric;		
		exception
		when others then
			cd_medico_exec_p	:= null;
		end;
	end loop;-- C01
end if;
ie_origem_conta_w		:= 'D';
-- Se nao tiver prestador na requisicao ou nao tiver requisicao faz o processo normal
if (coalesce(nr_seq_prestador_atend_w::text, '') = '') then
	if (nr_seq_prestador_atend_p IS NOT NULL AND nr_seq_prestador_atend_p::text <> '') then
		nr_seq_prestador_atend_w	:= nr_seq_prestador_atend_p;
	else
		nr_seq_prestador_atend_w := nr_seq_prestador_w;
	end if;
end if;

if (coalesce(cd_medico_exec_p::text, '') = '') and (nr_seq_prestador_exec_w IS NOT NULL AND nr_seq_prestador_exec_w::text <> '') and (ie_tipo_guia_w	in ('3','6')) then
	
	select   max(a.cd_pessoa_fisica)
	into STRICT     cd_medico_exec_w
	from     pls_prestador   a
	where    (a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	and      a.nr_sequencia   = nr_seq_prestador_exec_w;
	
	
	if (cd_medico_exec_w IS NOT NULL AND cd_medico_exec_w::text <> '') then
		select 	substr(obter_dados_medico(cd_medico_exec_w,'CRM'),1,255),
			substr(obter_dados_medico(cd_medico_exec_w,'UFCRM'),1,255),
			substr(pls_obter_seq_conselho_prof(cd_medico_exec_w),1,255)
		into STRICT	nr_crm_exec_w,
			uf_crm_exec_w,
			nr_conselho_exec_w	
		;
		
		cd_medico_exec_p := cd_medico_exec_w;
	end if;
end if;

select	max(nr_sequencia)
into STRICT	nr_seq_saida_consulta_w
from	pls_motivo_saida_consulta
where	cd_tiss			= ie_tipo_saida_w
and	cd_estabelecimento	= cd_estabelecimento_w;

select 	max(ie_cbo_autorizado)
into STRICT 	ie_cbo_autorizado_w
from	pls_parametros
where	cd_estabelecimento = cd_estabelecimento_w;

if (ie_cbo_autorizado_w = 'S') then
	nr_seq_cbo_saude_w := nr_seq_cbo_saude_w;
else
	nr_seq_cbo_saude_w := null;
	
  /*Se campo CD_ESPECIALIADE e informado  (    da requisicao para  a autorizacao ) , entao insere na conta o CBO_SAUDE do codigo informado*/

	if (cd_especialidade_w > 0) then	
		select	max(nr_seq_cbo_saude)
		into STRICT	nr_Seq_cbo_saude_w
		from	especialidade_medica
		where	cd_especialidade	= cd_especialidade_w;		
	else
		--	jjung - Usar a function para centralizar o tratamento.
		select	max(pls_obter_cbo_medico(cd_medico_solicitante_w))
		into STRICT	nr_seq_cbo_saude_w
		;
	end if;
end if;	

cd_guia_p			:= cd_guia_w;
dt_autorizacao_p		:= dt_autorizacao_w;
cd_senha_p			:= cd_senha_w;
dt_validade_senha_p		:= dt_validade_senha_w;
nr_seq_segurado_p		:= nr_seq_segurado_w;
cd_medico_solicitante_p		:= cd_medico_solicitante_w;
ie_tipo_guia_p			:= ie_tipo_guia_w;
ie_carater_internacao_p		:= ie_carater_internacao_w;
nr_seq_prestador_p		:= nr_seq_prestador_w;
ie_status_p			:= 'U';
cd_guia_principal_p		:= cd_guia_principal_w;
nr_crm_exec_p			:= nr_crm_exec_w;
uf_crm_exec_p			:= uf_crm_exec_w;
nr_conselho_exec_p		:= nr_conselho_exec_w;
nr_seq_tipo_atendimento_p	:= nr_seq_tipo_atendimento_w;
nr_seq_clinica_p		:= nr_seq_clinica_w;
ie_regime_internacao_p		:= ie_regime_internacao_w;
nr_seq_tipo_acomodacao_p	:= nr_seq_tipo_acomodacao_w;
ie_tipo_consulta_p		:= ie_tipo_consulta_w;
cd_cooperativa_p		:= cd_cooperativa_w;
ie_recem_nascido_p		:= ie_recem_nascido_w;
nm_recem_nascido_p		:= nm_recem_nascido_w;
dt_nasc_recem_nascido_p		:= dt_nasc_recem_nascido_w;
ie_tipo_saida_p			:= ie_tipo_saida_w;
ds_indicacao_clinica_p		:= substr(ds_indicacao_clinica_w,1,255);
cd_especialidade_p		:= cd_especialidade_w;
ie_tipo_guia_dois_p		:= ie_tipo_guia_ww;
nr_seq_saida_consulta_p		:= nr_seq_saida_consulta_w;
nr_seq_prestador_atend_dois_p	:= nr_seq_prestador_atend_w;
ie_origem_conta_p		:= ie_origem_conta_w;
nr_seq_cbo_saude_p		:= nr_seq_cbo_saude_w;
ie_indicacao_acidente_p		:= ie_indicacao_acidente_w;
cd_doenca_p			:= cd_doenca_w;
dt_emissao_p			:= dt_emissao_w;
dt_atendimento_p		:= dt_atendimento_w;
nr_seq_prestador_p		:= nr_seq_prestador_w;
nr_seq_prestador_exec_p		:= nr_seq_prestador_exec_w;
cd_guia_prestador_p		:= cd_guia_prestador_w;
ie_cobertura_especial_p		:= ie_cobertura_especial_w;
ie_regime_atendimento_p		:= ie_regime_atendimento_w;
ie_saude_ocupacional_p 		:= ie_saude_ocupacional_w;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_conta_guia_prod_out ( nr_seq_guia_p bigint, nr_seq_prestador_atend_p bigint, ie_origem_dados_p bigint, cd_medico_exec_p INOUT bigint, cd_guia_p INOUT text, dt_autorizacao_p INOUT timestamp, cd_senha_p INOUT text, dt_validade_senha_p INOUT timestamp, nr_seq_segurado_p INOUT bigint, cd_medico_solicitante_p INOUT text, ie_tipo_guia_p INOUT text, ie_carater_internacao_p INOUT text, nr_seq_prestador_p INOUT bigint, ie_status_p INOUT text, cd_guia_principal_p INOUT text, nr_crm_exec_p INOUT text, uf_crm_exec_p INOUT text, nr_conselho_exec_p INOUT text, nr_seq_tipo_atendimento_p INOUT bigint, nr_seq_clinica_p INOUT bigint, ie_regime_internacao_p INOUT text, nr_seq_tipo_acomodacao_p INOUT bigint, ie_tipo_consulta_p INOUT text, cd_cooperativa_p INOUT text, ie_recem_nascido_p INOUT text, nm_recem_nascido_p INOUT text, dt_nasc_recem_nascido_p INOUT timestamp, ie_tipo_saida_p INOUT text, ds_indicacao_clinica_p INOUT pls_conta.ds_indicacao_clinica%type, cd_especialidade_p INOUT bigint, ie_tipo_guia_dois_p INOUT text, nr_seq_saida_consulta_p INOUT bigint, ie_origem_conta_p INOUT text, nr_Seq_cbo_saude_p INOUT bigint, ie_indicacao_acidente_p INOUT text, cd_doenca_p INOUT text, nr_seq_prestador_atend_dois_p INOUT bigint, dt_emissao_p INOUT timestamp, dt_atendimento_p INOUT timestamp, nr_seq_prestador_exec_p INOUT bigint, cd_guia_prestador_p INOUT text, ie_cobertura_especial_p INOUT text, ie_regime_atendimento_p INOUT text, ie_saude_ocupacional_p INOUT text) FROM PUBLIC;

