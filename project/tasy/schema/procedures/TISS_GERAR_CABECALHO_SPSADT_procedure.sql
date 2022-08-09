-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_cabecalho_spsadt ( nr_seq_conta_guia_p bigint, nr_seq_guia_nova_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE


cd_ans_w		varchar(255);
cd_autorizacao_w		varchar(255);
cd_senha_w		varchar(255);
ie_tipo_atendimento_w	varchar(255);
ie_tipo_saida_w		varchar(255);
cd_medico_executor_w	varchar(255);
ie_somar_opm_w		varchar(255);
ie_tipo_acidente_w		varchar(255);
ie_trazer_executor_w	varchar(255);
cd_doenca_cid_w		varchar(255);
ds_observacao_w		varchar(4000);
ds_carater_internacao_w	varchar(255);
ie_tiss_tipo_guia_w		varchar(255);
cd_usuario_convenio_w	varchar(255);
nr_atendimento_w		bigint;
nr_interno_conta_w		bigint;
cd_categoria_conv_w	varchar(255);
qt_proc_guia_w		bigint;
nr_seq_guia_w		bigint;
vl_taxas_w		double precision;
vl_diarias_w		double precision;
vl_medicamentos_w	double precision;
vl_materiais_w		double precision;
vl_gases_w		double precision;
vl_proc_total_w		double precision;
vl_unitario_w		double precision;
vl_alugueis_w		double precision;
nr_seq_tipo_acidente_w	bigint;
vl_total_w		double precision := 0;
vl_opms_w		double precision;
nr_seq_protocolo_w	bigint;
dt_validade_senha_w	timestamp;
dt_emissao_guia_w		timestamp;
dt_autorizacao_w	timestamp;
cd_convenio_w		bigint;
cd_medico_convenio_w	varchar(255);
nr_sequencia_autor_W	bigint;
nr_seq_apresent_W	bigint;
cd_estabelecimento_w	bigint;
ie_medico_solic_atend_w	varchar(255);
nr_seq_conta_guia_w	bigint;
dt_atendimento_w	timestamp;

cd_autorizacao_princ_w	varchar(255);
cd_cgc_prestador_w	varchar(255);
ie_agrupar_proc_w	varchar(255);
cd_prestador_convenio_w	varchar(255) := '';
ie_honorario_w		varchar(255) := '';
ds_indicacao_w		varchar(255);
ds_assinatura_solic_w	varchar(255);
ds_assinatura_resp_w	varchar(255);
ds_assinatura_exec_w	varchar(255);
dt_assin_prest_w		timestamp;
ie_assinatura_solic_w	varchar(255);
ie_data_ass_prest_w	varchar(255);
ds_categoria_w		varchar(255) := null;
ie_desc_plano_w		varchar(255) := null;
ie_clinica_w		bigint;
qt_tempo_cid_w		varchar(255);
ie_unidade_tempo_cid_w	varchar(255);
nr_seq_classif_atend_w	bigint;
dt_assinatura_resp_w	timestamp;	
ie_dt_assin_solic_w	varchar(255);
dt_assin_solic_w	timestamp;
nr_atend_med_w		bigint;
dt_validade_carteira_w	timestamp;
cd_pessoa_fisica_W	varchar(255);
nm_pessoa_fisica_W	varchar(255);
nr_cartao_nac_sus_W	varchar(20);
ds_plano_w		varchar(255);
w_40SADT_w		varchar(255);
w_41SADT_w		varchar(255);
w_45ASADT_w		varchar(255);
nr_guia_prestador_w	varchar(255);
ie_cd_autorizacao_relat_w	varchar(255);
cd_setor_entrada_w	bigint;
ie_tipo_atend_tiss_w	varchar(10);
ie_proc_solic_spsadt_w	varchar(10);
dt_solic_guia_w		timestamp;
ie_crm_contrat_solic_w	varchar(255);
nr_crm_contrat_solic_w	varchar(255);
cd_cgc_w		varchar(255);
cd_interno_w		varchar(255);
nr_cpf_w		varchar(255);
nr_crm_solic_w		varchar(255);
ie_tipo_atend_w		varchar(255);
ie_assinatura_exec_w	varchar(255);
ie_data_entrada_w	varchar(10);
ie_tipo_atend_conta_w	smallint;
ds_versao_w		varchar(20);
ie_atendimento_rn_w	varchar(1);
ie_tipo_consulta_w	varchar(5);
dt_assin_resp_w		timestamp;
ie_data_assin_autor_w	varchar(2);
vl_taxas_alugueis_w	double precision;
dt_mesano_referencia_w	timestamp;
nm_usuario_ass_contrat_w	tiss_parametros_convenio.nm_usuario_assinatura_contrat%type;
ds_assinatura_contrat_w	varchar(255);

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	b.nr_atendimento,
	a.nr_interno_conta,
	a.cd_autorizacao,
	lpad(a.ie_tipo_atend_tiss, 2, 0),
	a.ie_tipo_saida,
	'4' ie_tiss_tipo_guia,
	a.cd_autorizacao_princ,
	a.cd_cgc_prestador,
	a.dt_autorizacao,
	a.cd_senha,
	a.dt_validade_senha,
	a.dt_emissao_guia,
	b.dt_entrada,
	b.ie_carater_internacao,
	a.cd_medico_executor,
	a.cd_ans,
	a.cd_convenio,
	coalesce(a.vl_taxas, 0),
	coalesce(a.vl_diarias, 0),
	coalesce(a.vl_medicamentos, 0),
	coalesce(a.vl_materiais, 0),
	coalesce(a.vl_gases, 0),
	coalesce(a.vl_servicos, 0),
	coalesce(a.vl_opms, 0),
	coalesce(a.vl_total, 0),
	coalesce(a.vl_alugueis, 0),
	coalesce(a.vl_taxas_alugueis, 0),
	ie_honorario,
	a.cd_cid,
	a.ds_indicacao,
	b.cd_usuario_convenio,
	a.ds_observacao,
	c.cd_estabelecimento,
	a.qt_tempo_cid,
	a.ie_unidade_tempo_cid,
	null nr_atend_med,
	b.ds_plano,
	a.nr_guia_prestador,
	b.ie_atendimento_rn,
	b.ie_tipo_consulta,
	b.cd_pessoa_fisica,
	substr(b.nm_pessoa_fisica,1,150),
	b.nr_cartao_nac_sus,	
	b.dt_validade_carteira,
	b.ds_plano,
	c.ie_tipo_atend_tiss
FROM tiss_conta_atend b, tiss_conta_guia a
LEFT OUTER JOIN conta_paciente c ON (a.nr_interno_conta = c.nr_interno_conta)
WHERE a.nr_interno_conta	= b.nr_interno_conta and a.nr_sequencia		= nr_seq_conta_guia_p  and a.ie_tiss_tipo_guia	= '4' and coalesce(a.nr_atend_med::text, '') = '' and coalesce(a.nr_seq_reap_conta::text, '') = ''

union all

select	a.nr_sequencia,
	b.nr_atendimento,
	a.nr_interno_conta,
	a.cd_autorizacao,
	lpad(a.ie_tipo_atend_tiss, 2, 0),
	a.ie_tipo_saida,
	'4' ie_tiss_tipo_guia,
	a.cd_autorizacao_princ,
	a.cd_cgc_prestador,
	a.dt_autorizacao,
	a.cd_senha,
	a.dt_validade_senha,
	a.dt_emissao_guia,
	b.dt_entrada,
	b.ie_carater_internacao,
	a.cd_medico_executor,
	a.cd_ans,
	a.cd_convenio,
	coalesce(a.vl_taxas, 0),
	coalesce(a.vl_diarias, 0),
	coalesce(a.vl_medicamentos, 0),
	coalesce(a.vl_materiais, 0),
	coalesce(a.vl_gases, 0),
	coalesce(a.vl_servicos, 0),
	coalesce(a.vl_opms, 0),
	coalesce(a.vl_total, 0),
	coalesce(a.vl_alugueis, 0),
	coalesce(a.vl_taxas_alugueis, 0),
	ie_honorario,
	a.cd_cid,
	a.ds_indicacao,
	b.cd_usuario_convenio,
	a.ds_observacao,
	wheb_usuario_pck.get_cd_estabelecimento,
	a.qt_tempo_cid,
	a.ie_unidade_tempo_cid,
	c.nr_atendimento nr_atend_med,
	b.ds_plano,
	a.nr_guia_prestador,
	b.ie_atendimento_rn,
	b.ie_tipo_consulta,
	b.cd_pessoa_fisica,
	substr(b.nm_pessoa_fisica,1,150),
	b.nr_cartao_nac_sus,	
	b.dt_validade_carteira,
	b.ds_plano,
	null ie_tipo_atend_tiss
FROM tiss_conta_atend b, tiss_conta_guia a
LEFT OUTER JOIN med_atendimento c ON (a.nr_atend_med = c.nr_atendimento)
WHERE a.nr_atend_med		= b.nr_atend_med and a.nr_sequencia		= nr_seq_conta_guia_p  and a.ie_tiss_tipo_guia	in ('2', '3') and (a.nr_atend_med IS NOT NULL AND a.nr_atend_med::text <> '') and coalesce(a.nr_seq_reap_conta::text, '') = ''
 
union all

select	a.nr_sequencia,
	c.nr_atendimento,
	a.nr_interno_conta,
	a.cd_autorizacao,
	lpad(a.ie_tipo_atend_tiss, 2, 0),
	a.ie_tipo_saida,
	'4' ie_tiss_tipo_guia,
	a.cd_autorizacao_princ,
	a.cd_cgc_prestador,
	a.dt_autorizacao,
	a.cd_senha,
	a.dt_validade_senha,
	a.dt_emissao_guia,
	b.dt_entrada,
	b.ie_carater_internacao,
	a.cd_medico_executor,
	a.cd_ans,
	a.cd_convenio,
	coalesce(a.vl_taxas, 0),
	coalesce(a.vl_diarias, 0),
	coalesce(a.vl_medicamentos, 0),
	coalesce(a.vl_materiais, 0),
	coalesce(a.vl_gases, 0),
	coalesce(a.vl_servicos, 0),
	coalesce(a.vl_opms, 0),
	coalesce(a.vl_total, 0),
	coalesce(a.vl_alugueis, 0),
	coalesce(a.vl_taxas_alugueis, 0),
	ie_honorario,
	a.cd_cid,
	a.ds_indicacao,
	b.cd_usuario_convenio,
	a.ds_observacao,
	c.cd_estabelecimento,
	a.qt_tempo_cid,
	a.ie_unidade_tempo_cid,
	null nr_atend_med,
	b.ds_plano,
	a.nr_guia_prestador,
	b.ie_atendimento_rn,
	b.ie_tipo_consulta,
	b.cd_pessoa_fisica,
	substr(b.nm_pessoa_fisica,1,150),
	b.nr_cartao_nac_sus,	
	b.dt_validade_carteira,
	b.ds_plano,
	c.ie_tipo_atend_tiss
FROM tiss_conta_atend b, tiss_conta_guia a
LEFT OUTER JOIN conta_paciente c ON (a.nr_interno_conta = c.nr_interno_conta)
WHERE a.nr_seq_reap_conta	= b.nr_seq_reap_conta and a.nr_sequencia		= nr_seq_conta_guia_p  and a.ie_tiss_tipo_guia	= '4' and (a.nr_seq_reap_conta IS NOT NULL AND a.nr_seq_reap_conta::text <> '');

c02 CURSOR FOR
SELECT	ie_data_entrada
from	tiss_regra_data_int
where	cd_estabelecimento				= cd_estabelecimento_w
and	coalesce(cd_convenio,coalesce(cd_convenio_w,0))		= coalesce(cd_convenio_w,0)
and	coalesce(ie_tipo_atend_conta,coalesce(ie_tipo_atend_conta_w,0))	= coalesce(ie_tipo_atend_conta_w,0)
order by 	coalesce(cd_convenio,0),
	coalesce(ie_tipo_atend_conta,0);


BEGIN

if (coalesce(nr_seq_conta_guia_p,0) > 0) then

	open c01;
	loop
	fetch c01 into
		nr_seq_conta_guia_w,
		nr_atendimento_w,
		nr_interno_conta_w,
		cd_autorizacao_w,
		ie_tipo_atendimento_w,
		ie_tipo_saida_w,
		ie_tiss_tipo_guia_w,
		cd_autorizacao_princ_w,
		cd_cgc_prestador_w,
		dt_autorizacao_w,
		cd_senha_w,
		dt_validade_senha_w,
		dt_emissao_guia_w,
		dt_atendimento_w,
		ds_carater_internacao_w,
		cd_medico_executor_w,
		cd_ans_w,
		cd_convenio_w,
		vl_taxas_w,
		vl_diarias_w,
		vl_medicamentos_w,
		vl_materiais_w,
		vl_gases_w,
		vl_proc_total_w,
		vl_opms_w,
		vl_total_w,
		vl_alugueis_w,
		vl_taxas_alugueis_w,
		ie_honorario_w,
		cd_doenca_cid_w,
		ds_indicacao_w,
		cd_usuario_convenio_w,
		ds_observacao_w,
		cd_estabelecimento_w,
		qt_tempo_cid_w,
		ie_unidade_tempo_cid_w,
		nr_atend_med_w,
		ds_plano_w,
		nr_guia_prestador_w,
		ie_atendimento_rn_w,
		ie_tipo_consulta_w,
		cd_pessoa_fisica_w,
		nm_pessoa_fisica_w,
		nr_cartao_nac_sus_w,
		dt_validade_carteira_w,
		ds_plano_w,
		ie_tipo_atend_tiss_w;		
	EXIT WHEN NOT FOUND; /* apply on c01 */

		if (coalesce(nr_atend_med_w::text, '') = '') then
			select	max((obter_clinica_atend(nr_atendimento_w, 'C'))::numeric ),
				max((Obter_Classificacao_Atend(nr_atendimento_w,'C'))::numeric ),
				max(obter_setor_atendimento(nr_atendimento_w))
			into STRICT	ie_clinica_w,
				nr_seq_classif_atend_w,
				cd_setor_entrada_w
			;
			
			select	max(coalesce(ie_tipo_atend_tiss_w,ie_tipo_atend_tiss)),
				max(ie_tipo_atendimento)
			into STRICT	ie_tipo_atend_tiss_w,
				ie_tipo_atend_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_w;
		end if;

		select	coalesce(max(ie_agrupar_proc), 'S'),
			coalesce(max(ie_exec_spsadt), 'N'),
			coalesce(max(ie_totalizar_opm), 'N'),
			coalesce(max(ie_assinatura_solic), 'N'),
			coalesce(max(ie_data_ass_prest), 'X'),
			coalesce(max(ie_desc_plano),'P'),
			coalesce(max(ie_dt_assin_solic),'N'),
			coalesce(max(ie_cd_autorizacao_relat),'O'),
			coalesce(max(ie_proc_solic_spsadt),'AC'),
			coalesce(max(ie_crm_contrat_solic),'N'),
			coalesce(max(ie_assinatura_exec), 'N'),
			coalesce(max(ie_data_entrada_ri), 'E'),
			coalesce(max(ie_data_assin_autor), 'N'),
			max(nm_usuario_assinatura_contrat)			
		into STRICT	ie_agrupar_proc_w,
			ie_trazer_executor_w,
			ie_somar_opm_w,
			ie_assinatura_solic_w,
			ie_data_ass_prest_w,
			ie_desc_plano_w,
			ie_dt_assin_solic_w,
			ie_cd_autorizacao_relat_w,
			ie_proc_solic_spsadt_w,
			ie_crm_contrat_solic_w,
			ie_assinatura_exec_w,
			ie_data_entrada_w,
			ie_data_assin_autor_w,
			nm_usuario_ass_contrat_w
		from	tiss_parametros_convenio
		where	cd_estabelecimento	= cd_estabelecimento_w
		and	cd_convenio		= cd_convenio_w;
		
		begin
			select 	max(cd_pessoa_fisica)
			into STRICT	ds_assinatura_contrat_w
			from 	usuario
			where 	nm_usuario = nm_usuario_ass_contrat_w;			
		exception
		when others then
			null;			
		end;
		
		select	max(nr_seq_apresent),
			max(cd_categoria_parametro),
			max(ie_tipo_atend_conta),
			max(dt_mesano_referencia)
		into STRICT	nr_seq_apresent_w,
			cd_categoria_conv_w,
			ie_tipo_atend_conta_w,
			dt_mesano_referencia_w
		from	conta_paciente
		where	nr_interno_conta	= nr_interno_conta_w;

		select	tiss_obter_versao(cd_convenio_w,cd_estabelecimento_w,dt_mesano_referencia_w)
		into STRICT	ds_versao_w
		;		

		if (ie_assinatura_solic_w	= 'S') then
			select	max(nm_solicitante)
			into STRICT	ds_assinatura_solic_w
			from	tiss_conta_contrat_solic
			where	nr_seq_guia	= nr_seq_conta_guia_p;

			if (coalesce(ds_assinatura_solic_w::text, '') = '') then
				ds_assinatura_solic_w		:= '   ____________________________';
			end if;
		else
			ds_assinatura_solic_w		:= coalesce(tiss_obter_regra_campo(4, 'DS_ASSINATURA_SOLIC', cd_convenio_W, ds_assinatura_solic_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'), '   ____________________________');
		end if;
		
		if (ie_assinatura_exec_w  = 'S') then
			select	substr((max(nm_exec_compl)||' (CRM '||max(nr_crm_compl)||')'),1,255)
			into STRICT	ds_assinatura_exec_w
			from	tiss_conta_contrat_exec
			where	nr_seq_guia		= nr_seq_conta_guia_w;	
			
			if (coalesce(ds_assinatura_exec_w::text, '') = '') then
				ds_assinatura_exec_w	:= '   ____________________________';
			end if;
		else
			ds_assinatura_exec_w		:= coalesce(tiss_obter_regra_campo(4, 'DS_ASSINATURA_EXEC', cd_convenio_W, ds_assinatura_exec_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'), '   ____________________________');
		end if;
		
		ds_assinatura_resp_w		:= coalesce(tiss_obter_regra_campo(4, 'DS_ASSINATURA_RESP', cd_convenio_W, ds_assinatura_resp_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'), '   ____________________________');
		
		/*Lhlaves OS360692 em 30/09/2011 - Se esta definido para gerar como procedimento solicitado 
		o procedimento executado, busca como data de solicitacao da guia de SP/SADT, a data da autorizacao do item.
		Se nao existe autorizacao, gera a data que sempre gerou, conforme o parametro */
			
		if (ie_proc_solic_spsadt_w = 'PE') then 	
		
			select	coalesce(max(a.dt_envio),max(a.dt_autorizacao))
			into STRICT	dt_solic_guia_w
			from	autorizacao_convenio a
			where	a.nr_atendimento	= nr_atendimento_w
			and	a.cd_autorizacao	= cd_autorizacao_w
			and	a.nr_sequencia		=
							(SELECT	max(x.nr_sequencia)
							from	autorizacao_convenio x
							where	x.nr_atendimento	= nr_atendimento_w
							and	x.cd_autorizacao	= cd_autorizacao_w);

			dt_atendimento_w	:= coalesce(	dt_solic_guia_w,dt_atendimento_w);			
		end if;	

		if (ie_data_entrada_w = 'R') then
			open c02;
			loop
			fetch c02 into
				ie_data_entrada_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
			end loop;
			close c02;
			
			if (ie_data_entrada_w = 'P') then
				select	coalesce(coalesce(min(dt_inicio_cir),min(dt_procedimento)),dt_atendimento_w)
				into STRICT	dt_atendimento_w
				from	tiss_conta_proc
				where	nr_seq_guia	= nr_seq_conta_guia_w;			
			end if;
		end if;		

		if (coalesce(ie_data_ass_prest_w,'N') = 'S') and (coalesce(nr_atend_med_w::text, '') = '') then
			--dt_assin_prest_w	:= dt_atendimento_w;
			/*lhalves OS235435 em 07/08/2010 - Sempre gerar a data do atendimento do paciente*/

			select 	max(dt_entrada)
			into STRICT 	dt_assin_prest_w
			from 	atendimento_paciente
			where 	nr_atendimento	= nr_atendimento_w;

			dt_assinatura_resp_w	:= dt_assin_prest_w;
			
		elsif (coalesce(ie_data_ass_prest_w,'X') = 'N')then
			dt_assin_prest_w	:= clock_timestamp();
			dt_assinatura_resp_w	:= clock_timestamp();
			
		elsif (coalesce(ie_data_ass_prest_w,'N') = 'V')then		
			dt_assin_prest_w	:= null;
			dt_assinatura_resp_w	:= null;
		end if;

		/*lhalves OS245314 em 31/08/2010*/

		if (ie_dt_assin_solic_w = 'S') then
			dt_assin_solic_w	:= dt_atendimento_w;
		else
			dt_assin_solic_w	:= dt_assinatura_resp_w;
		end if;

		if (coalesce(ie_cd_autorizacao_relat_w,'O') = 'P') then
			cd_autorizacao_w	:= coalesce(nr_guia_prestador_w,cd_autorizacao_w);
		end if;		
		
		dt_assin_prest_w	:= to_date(tiss_obter_regra_campo(4, 'DT_ASSINATURA_EXEC', cd_convenio_W, to_char(dt_assin_prest_w, 'dd/mm/yyyy hh24:mi:ss'), ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),'dd/mm/yyyy hh24:mi:ss');
		dt_assinatura_resp_w	:= to_date(tiss_obter_regra_campo(4, 'DT_ASSINATURA_RESP', cd_convenio_W, to_char(dt_assinatura_resp_w, 'dd/mm/yyyy hh24:mi:ss'), ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),'dd/mm/yyyy hh24:mi:ss');
		dt_assin_solic_w	:= to_date(tiss_obter_regra_campo(4, 'DT_ASSINATURA_SOLIC', cd_convenio_W, to_char(dt_assin_solic_w, 'dd/mm/yyyy hh24:mi:ss'), ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),'dd/mm/yyyy hh24:mi:ss');
		
		if (ie_data_assin_autor_w = 'E') then
			dt_assin_resp_w	:= dt_emissao_guia_w;
		elsif (ie_data_assin_autor_w = 'A') then
			dt_assin_resp_w	:= clock_timestamp();
		end if;		

		select	nextval('w_tiss_guia_seq')
		into STRICT	nr_seq_guia_w
		;

		insert	into w_tiss_guia(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_ans,
			cd_autorizacao,
			dt_autorizacao,
			cd_senha,
			dt_validade_senha,
			dt_emissao_guia,
			nr_interno_conta,
			nr_seq_protocolo,
			nr_sequencia_autor,
			nr_atendimento,
			cd_autorizacao_princ,
			nr_seq_apresentacao,
			ds_observacao,
			ie_tiss_tipo_guia,
			dt_entrada,
			ds_assinatura_solic,
			ds_assinatura_resp,
			ds_assinatura_exec,
			DT_ASSIN_PREST,
			DT_ASSIN_SOLIC,
			nr_seq_conta_guia,
			ds_versao,
			ie_atendimento_rn,
			nr_guia_prestador,
			dt_assin_resp,
			ds_assinatura_contrat)
		values (nr_seq_guia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_ans_w,
			cd_autorizacao_w,
			dt_autorizacao_w,
			cd_senha_w,
			dt_validade_senha_w,
			dt_emissao_guia_w,
			nr_interno_conta_w,
			null,
			null,
			nr_atendimento_w,
			tiss_obter_regra_campo(4, 'CD_AUTORIZACAO_PRINC', cd_convenio_w, cd_autorizacao_princ_w, ie_tipo_atend_w, cd_categoria_conv_w,'N', 0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
			nr_seq_apresent_w,
			--nvl(ds_observacao_w, tiss_obter_regra_campo(4, 'DS_OBSERVACAO', cd_convenio_w, ds_observacao_w, ie_tipo_atendimento_w, cd_categoria_conv_w,'N', 0, cd_estabelecimento_w, ie_clinica_w)),
			tiss_obter_regra_campo(4, 'DS_OBSERVACAO', cd_convenio_w, ds_observacao_w, ie_tipo_atend_w, cd_categoria_conv_w,'N', 0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
			'4',
			--dt_atendimento_w,
			dt_assinatura_resp_w,
			ds_assinatura_solic_w,
			ds_assinatura_resp_w,
			ds_assinatura_exec_w,
			DT_ASSIN_PREST_w,
			dt_assin_solic_w,
			nr_seq_conta_guia_w,
			ds_versao_w,
			ie_atendimento_rn_w,
			nr_guia_prestador_w,
			dt_assin_resp_w,
			ds_assinatura_contrat_w);

		if (ie_desc_plano_w = 'C') and (coalesce(nr_atend_med_w::text, '') = '') then
		
			select	max(substr(obter_categoria_convenio(b.cd_convenio, b.cd_categoria),1,40)) ds_categoria
			into STRICT	ds_categoria_w
			from	pessoa_fisica c,
				atend_categoria_convenio b,
				atendimento_paciente a
			where	a.nr_atendimento	= b.nr_atendimento
			and	b.nr_seq_interno	= Obter_Atecaco_Atend_conv(a.nr_atendimento,cd_convenio_w) --lhalves OS287839 - Tem que buscar conforme o convenio da conta.
			and	a.cd_pessoa_fisica	= c.cd_pessoa_fisica
			and	a.nr_atendimento	= nr_atendimento_w;				
		end if;

		if (coalesce(nr_atend_med_w::text, '') = '') then

			/*lhalves OS305885 em 30/03/2011 - substituido a view pelo select - Performance*/

			insert	into w_tiss_beneficiario(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				cd_pessoa_fisica,
				nm_pessoa_fisica,
				nr_cartao_nac_sus,
				ds_plano,
				dt_validade_carteira,
				cd_usuario_convenio)
			SELECT	nextval('w_tiss_beneficiario_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				cd_pessoa_fisica_w,
				nm_pessoa_fisica_w,
				tiss_obter_regra_campo(ie_tiss_tipo_guia_w, 'NR_CARTAO_NAC_SUS', cd_convenio_w, nr_cartao_nac_sus_w, ie_tipo_atend_w,
									cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				coalesce(ds_categoria_w, ds_plano_w),
				dt_validade_carteira_W,
				cd_usuario_convenio_w
			;
		else
			select 	max(cd_pessoa_fisica),
				max(nm_pessoa_fisica),
				max(nr_cartao_nac_sus),
				max(ds_plano),
				max(dt_validade_carteira)
			into STRICT	cd_pessoa_fisica_w,
				nm_pessoa_fisica_w,
				nr_cartao_nac_sus_w,
				ds_plano_w,
				dt_validade_carteira_W
			from	tiss_dados_paciente_v
			where	ds_versao		= '2.01.01'
			and	nr_med_atendimento	= nr_atend_med_w
			and	ie_origem		= 'MED';

			insert	into w_tiss_beneficiario(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				cd_pessoa_fisica,
				nm_pessoa_fisica,
				nr_cartao_nac_sus,
				ds_plano,
				dt_validade_carteira,
				cd_usuario_convenio)
			values (nextval('w_tiss_beneficiario_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				cd_pessoa_fisica_w,
				nm_pessoa_fisica_w,
				tiss_obter_regra_campo(ie_tiss_tipo_guia_w, 'NR_CARTAO_NAC_SUS', cd_convenio_w, nr_cartao_nac_sus_w, ie_tipo_atend_w,
									cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				coalesce(ds_categoria_w, ds_plano_w),
				dt_validade_carteira_w,
				cd_usuario_convenio_w);
		end if;

		select	max(nr_seq_protocolo)
		into STRICT	nr_seq_protocolo_w
		from	conta_paciente
		where	nr_interno_conta	= nr_interno_conta_w;

		/*Diego 31/03/09 - cd_prestador_convenio so pode ser gerado no cabecalho do XML.
		select	max(cd_prestador_convenio)
		into	cd_prestador_convenio_w
		from	protocolo_convenio
		where	nr_seq_protocolo	= nr_seq_protocolo_w;
		*/
		if (coalesce(ie_honorario_w,'N') = 'S') then
			select	tiss_obter_dados_guia_prest(nr_seq_conta_guia_w,3),
				tiss_obter_dados_guia_prest(nr_seq_conta_guia_w,4),
				tiss_obter_dados_guia_prest(nr_seq_conta_guia_w,5)
			into STRICT	w_40SADT_w,
				w_41SADT_w,
				w_45ASADT_w
			;
		else
			select	tiss_obter_dados_guia_prest(nr_seq_conta_guia_w,1),
				tiss_obter_dados_guia_prest(nr_seq_conta_guia_w,2),
				tiss_obter_dados_guia_prest(nr_seq_conta_guia_w,6)
			into STRICT	w_40SADT_w,
				w_41SADT_w,
				w_45ASADT_w
			;
		end if;

		-- ie_trazer_executor_w
		-- 'S' Medico executor
		-- 'MC' Medico executor se conveniado
		-- 'N' Medico do atendimento
		-- 'R' Conforme regra de definicao
		-- 'F' Funcionario
		if (ie_trazer_executor_w	in ('MC','S','N','R','F','L')) then

			insert	into w_tiss_contratado_exec(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				cd_cgc,
				cd_interno,
				nr_cpf,
				nm_contratado,
				ds_tipo_logradouro,
				ds_logradouro,
				nm_municipio,
				sg_estado,
				cd_municipio_ibge,
				cd_cep,
				cd_cnes,
				nm_medico_executor,
				sg_conselho,
				nr_crm,
				uf_crm,
				cd_cbo_saude,
				ds_funcao_medico)
			SELECT	nextval('w_tiss_contratado_exec_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				cd_cgc,
				substr(coalesce(cd_interno, nr_cpf),1,20),
				CASE WHEN w_40SADT_w='X' THEN null  ELSE coalesce(w_40SADT_w,tiss_obter_regra_campo(4, 'CD_INTERNO', cd_convenio_w, coalesce(cd_interno_compl, nr_cpf_compl), ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@')) END ,
				nm_contratado,
				tiss_obter_regra_campo(4, 'DS_TIPO_LOGRADOURO', cd_convenio_w, ie_tipo_acomodacao, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				tiss_obter_regra_campo(4, 'DS_ENDERECO', cd_convenio_w, (ds_logradouro || ' ' || nr_endereco || ' ' || ds_complemento), ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w,cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),				
				tiss_obter_regra_campo(4, 'DS_MUNICIPIO', cd_convenio_w, nm_municipio, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),				
				tiss_obter_regra_campo(4, 'SG_ESTADO', cd_convenio_w, sg_estado, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),				
				tiss_obter_regra_campo(4, 'CD_MUNICIPIO_IBGE', cd_convenio_w, cd_municipio_ibge, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				tiss_obter_regra_campo(4, 'CD_CEP', cd_convenio_w, cd_cep, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				tiss_obter_regra_campo(4, 'CD_CNES', cd_convenio_w, cd_cnes, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),				
				CASE WHEN w_41SADT_w='X' THEN null  ELSE coalesce(w_41SADT_w ,tiss_obter_regra_campo(4, 'NM_EXECUTOR', cd_convenio_w, nm_exec_compl, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@')) END ,
				tiss_obter_regra_campo(4, 'SG_CONSELHO', cd_convenio_w, sg_conselho_compl, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				substr(tiss_obter_regra_campo(4, 'NR_CRM', cd_convenio_w, nr_crm_compl, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'), 1, 20),
				tiss_obter_regra_campo(4, 'UF_CRM', cd_convenio_w, uf_conselho_compl, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				cd_cbos_compl,
				CASE WHEN w_45ASADT_w='X' THEN null  ELSE coalesce(w_45ASADT_w,ie_funcao_medico_compl) END
			from	tiss_conta_contrat_exec
			where	nr_seq_guia		= nr_seq_conta_guia_w;
		else
			insert	into w_tiss_contratado_exec(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				cd_cgc,
				cd_interno,
				nr_cpf,
				nm_contratado,
				ds_tipo_logradouro,
				ds_logradouro,
				nm_municipio,
				sg_estado,
				cd_municipio_ibge,
				cd_cep,
				cd_cnes,
				nm_medico_executor,
				sg_conselho,
				nr_crm,
				uf_crm,
				cd_cbo_saude)
			SELECT	nextval('w_tiss_contratado_exec_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				cd_cgc,
				coalesce(cd_interno,nr_cpf),
				null,
				nm_contratado,
				tiss_obter_regra_campo(4, 'DS_TIPO_LOGRADOURO', cd_convenio_w, ie_tipo_acomodacao, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				tiss_obter_regra_campo(4, 'DS_ENDERECO', cd_convenio_w, (ds_logradouro || ' ' || nr_endereco || ' ' || ds_complemento), ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),				
				tiss_obter_regra_campo(4, 'DS_MUNICIPIO', cd_convenio_w, nm_municipio, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),				
				tiss_obter_regra_campo(4, 'SG_ESTADO', cd_convenio_w, sg_estado, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),				
				tiss_obter_regra_campo(4, 'CD_MUNICIPIO_IBGE', cd_convenio_w, cd_municipio_ibge, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				tiss_obter_regra_campo(4, 'CD_CEP', cd_convenio_w, cd_cep, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				tiss_obter_regra_campo(4, 'CD_CNES', cd_convenio_w, cd_cnes, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
				null,
				null,
				null,
				null,
				null
			from	tiss_conta_contrat_exec
			where	nr_seq_guia		= nr_seq_conta_guia_w;

		end if;

		select	max(nr_seq_tipo_acidente)
		into STRICT	nr_seq_tipo_acidente_w
		from	atendimento_paciente
		where	nr_atendimento	= nr_atendimento_w;

		/* OS76811. 11/12/2007. So gerar o tipo de acidente caso exista diagnostico. */

		if (coalesce(cd_doenca_cid_w,'X') <> 'X') or (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S') then
			select	max(ie_tipo_acidente)
			into STRICT	ie_tipo_acidente_w
			from	tiss_tipo_acidente
			where	nr_seq_acidente		= nr_seq_tipo_acidente_w;
		end if;		

		insert	into w_tiss_dados_atendimento(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			ie_tipo_atendimento,
			ie_tipo_saida,
			ie_tipo_acidente,
			ie_tipo_consulta)
		values (nextval('w_tiss_dados_atendimento_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			ie_tipo_atendimento_w,
			ie_tipo_saida_w,
			tiss_obter_regra_campo(4, 'IE_TIPO_ACIDENTE', cd_convenio_w, ie_tipo_acidente_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
			ie_tipo_consulta_w);

		insert into w_tiss_solicitacao(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			ie_carater_solic,
			cd_cid,
			ds_indicacao,
			dt_solicitacao,
			qt_tempo,
			ie_unidade_tempo)
		values (nextval('w_tiss_solicitacao_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			tiss_obter_regra_campo(4, 'IE_CARATER_SOLIC', cd_convenio_w, ds_carater_internacao_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
			tiss_obter_regra_campo(2, 'CD_DOENCA_CID', cd_convenio_w, cd_doenca_cid_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'),
			ds_indicacao_w,
			dt_atendimento_w,
			qt_tempo_cid_w,
			ie_unidade_tempo_cid_w);
				
		select	max(cd_medico_convenio)
		into STRICT	cd_medico_convenio_w
		from	tiss_dados_solicitante_v
		where	nr_atendimento		= nr_atendimento_w
		and	ds_versao		= '2.01.01'
		and	ie_origem		= 'AP'
		and	cd_convenio		= cd_convenio_w;

		select	max(nr_sequencia)
		into STRICT	nr_sequencia_autor_w
		from	autorizacao_convenio
		where	nr_atendimento	= nr_atendimento_w
		and	cd_autorizacao	= cd_autorizacao_w;

		if (ie_crm_contrat_solic_w = 'S') then
		
			select	cd_cgc,
				cd_interno,
				nr_cpf,
				nr_crm_solic
			into STRICT	cd_cgc_w,
				cd_interno_w,
				nr_cpf_w,
				nr_crm_solic_w
			from	tiss_conta_contrat_solic
			where	nr_seq_guia	= nr_seq_conta_guia_p;
			
			if (coalesce(cd_cgc_w::text, '') = '') and (coalesce(cd_interno_w::text, '') = '') and (coalesce(nr_cpf_w::text, '') = '') then
				nr_crm_contrat_solic_w	:= nr_crm_solic_w;
			end if;
		end if;
		
		
		insert into w_tiss_contratado_solic(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			cd_cgc,
			cd_interno,
			nr_cpf,
			nm_contratado,
			nm_solicitante,
			cd_cnes,
			sg_conselho,
			nr_crm,
			uf_crm,
			cd_cbo_saude)
		SELECT	nextval('w_tiss_contratado_solic_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			cd_cgc,
			substr(coalesce(cd_interno,nr_crm_contrat_solic_w),1,20),
			nr_cpf,
			nm_contratado,
			nm_solicitante,
			cd_cnes,
			sg_conselho_solic,
			nr_crm_solic,
			uf_conselho_solic,
			cd_cbos_solic
		from	tiss_conta_contrat_solic
		where	nr_Seq_guia	= nr_seq_conta_guia_p;

		/* 17/12/2007. Inclui esta linha pois o campo se refere ao valor das taxas + alugueis. */

		vl_taxas_w	:= vl_taxas_w + vl_alugueis_w;

		insert	into w_tiss_totais(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			vl_procedimentos,
			vl_taxas,
			vl_materiais,
			vl_medicamentos,
			vl_diarias,
			vl_gases,
			vl_total_geral,
			vl_total_geral_opm,
			vl_taxas_alugueis)
		values (nextval('w_tiss_totais_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			(tiss_obter_regra_campo(4, 'VL_TOTAL_PROCEDIMENTO', cd_convenio_w, vl_proc_total_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'))::numeric ,
			(tiss_obter_regra_campo(4, 'VL_TAXAS', cd_convenio_w, vl_taxas_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'))::numeric ,
			(tiss_obter_regra_campo(4, 'VL_MATERIAIS', cd_convenio_w, vl_materiais_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'))::numeric ,
			(tiss_obter_regra_campo(4, 'VL_MEDICAMENTOS', cd_convenio_w, vl_medicamentos_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'))::numeric ,
			(tiss_obter_regra_campo(4, 'VL_DIARIAS', cd_convenio_w, vl_diarias_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'))::numeric ,
			(tiss_obter_regra_campo(4, 'VL_GASES', cd_convenio_w, vl_gases_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'))::numeric ,
			(tiss_obter_regra_campo(4, 'VL_TOTAL', cd_convenio_w, vl_total_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'))::numeric ,
			vl_opms_w,
			(tiss_obter_regra_campo(4, 'VL_TAXAS', cd_convenio_w, vl_taxas_alugueis_w, ie_tipo_atend_w, cd_categoria_conv_w,'N',0, cd_estabelecimento_w, ie_clinica_w, nr_seq_classif_atend_w, cd_setor_entrada_w, ie_tipo_atend_tiss_w||'#@'))::numeric );
		nr_seq_guia_nova_p	:= nr_seq_guia_w;

	end loop;
	close c01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_cabecalho_spsadt ( nr_seq_conta_guia_p bigint, nr_seq_guia_nova_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
