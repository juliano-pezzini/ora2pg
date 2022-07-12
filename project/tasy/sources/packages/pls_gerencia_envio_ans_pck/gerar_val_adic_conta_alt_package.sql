-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

-- Alimenta as informaes adicionais conforme primeiro envio da guia



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.gerar_val_adic_conta_alt ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_cd_cbo_executante_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_cnes_prest_exec_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_cpf_cgc_prest_exec_w	pls_util_cta_pck.t_varchar2_table_20;
tb_cd_guia_operadora_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_guia_prestador_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_guia_principal_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_municipio_benef_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_municipio_prest_exec_w	pls_util_cta_pck.t_varchar2_table_20;
tb_cd_versao_tiss_w		pls_util_cta_pck.t_varchar2_table_20;
tb_ie_reembolso_w		pls_util_cta_pck.t_varchar2_table_20;
tb_ie_tipo_atendimento_w	pls_util_cta_pck.t_varchar2_table_20;
tb_ie_tipo_internacao_w		pls_util_cta_pck.t_varchar2_table_20;
tb_nr_cartao_nac_sus_w		pls_util_cta_pck.t_varchar2_table_20;
tb_nr_protocolo_ans_w		pls_util_cta_pck.t_varchar2_table_20;

tb_dt_autorizacao_w		pls_util_cta_pck.t_date_table;
tb_dt_fim_internacao_w		pls_util_cta_pck.t_date_table;
tb_dt_inicio_faturamento_w	pls_util_cta_pck.t_date_table;
tb_dt_nascimento_w		pls_util_cta_pck.t_date_table;
tb_dt_processamento_w		pls_util_cta_pck.t_date_table;
tb_dt_protocolo_w		pls_util_cta_pck.t_date_table;
tb_dt_realizacao_w		pls_util_cta_pck.t_date_table;
tb_dt_solicitacao_w		pls_util_cta_pck.t_date_table;
tb_dt_pagamento_w		pls_util_cta_pck.t_date_table;

tb_ie_carater_atendimento_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_identif_prest_exec_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_indicacao_acidente_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_motivo_encerramento_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_origem_evento_w		pls_util_cta_pck.t_varchar2_table_5;
tb_ie_recem_nasc_w			pls_util_cta_pck.t_varchar2_table_5;
tb_ie_regime_internacao_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_sexo_w				pls_util_cta_pck.t_varchar2_table_5;
tb_ie_tipo_consulta_w		pls_util_cta_pck.t_varchar2_table_5;
tb_ie_tipo_envio_w			pls_util_cta_pck.t_varchar2_table_5;
tb_ie_tipo_evento_w			pls_util_cta_pck.t_varchar2_table_5;
tb_ie_tipo_faturamento_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_tipo_guia_w			pls_util_cta_pck.t_varchar2_table_5;
tb_ie_tipo_atend_oper_w		pls_util_cta_pck.t_varchar2_table_5;

tb_nr_seq_cta_val_w			pls_util_cta_pck.t_number_table;
tb_nr_diarias_acompanhante_w	pls_util_cta_pck.t_number_table;
tb_nr_diarias_uti_w			pls_util_cta_pck.t_number_table;
tb_nr_seq_prestador_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_segurado_w		pls_util_cta_pck.t_number_table;
tb_vl_cobranca_guia_w		pls_util_cta_pck.t_number_table;
tb_vl_total_diaria_w		pls_util_cta_pck.t_number_table;
tb_vl_total_fornecedor_w	pls_util_cta_pck.t_number_table;
tb_vl_total_glosa_w			pls_util_cta_pck.t_number_table;
tb_vl_total_copart_w		pls_util_cta_pck.t_number_table;
tb_vl_total_material_w		pls_util_cta_pck.t_number_table;
tb_vl_total_medicamentos_w	pls_util_cta_pck.t_number_table;
tb_vl_total_opm_w			pls_util_cta_pck.t_number_table;
tb_vl_total_pago_w			pls_util_cta_pck.t_number_table;
tb_vl_total_procedimento_w	pls_util_cta_pck.t_number_table;
tb_vl_total_tabela_propria_w	pls_util_cta_pck.t_number_table;
tb_vl_total_taxa_w			pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_inter_w		pls_util_cta_pck.t_number_table;
tb_nr_ident_pre_estab_w		pls_util_cta_pck.t_number_table;
tb_nr_registro_oper_inter_w 	pls_util_cta_pck.t_number_table;
tb_nr_cpf_benef_w	pls_util_cta_pck.t_varchar2_table_20;
tb_ie_regime_atendimento_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_saude_ocupacional	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_cobertura_especial_w	pls_util_cta_pck.t_varchar2_table_5;
tb_cd_modelo_remuneracao_w	pls_util_cta_pck.t_varchar2_table_5;
dados_beneficiario_w		dados_beneficiario;
dados_conta_update_w		pls_gerencia_envio_ans_pck.dados_monitor_conta_update;
ind_w						integer := 0;
ie_sexo_w			pls_monitor_tiss_cta_val.ie_sexo%type;
dt_nascimento_w 		pls_monitor_tiss_cta_val.dt_nascimento%type;
cd_municipio_benef_w		pls_monitor_tiss_cta_val.cd_municipio_benef%type;
ie_tipo_atend_oper_w		pls_monitor_tiss_cta_val.ie_tipo_atend_oper%type;
nr_ident_pre_estab_w		pls_monitor_tiss_cta_val.nr_ident_pre_estab%type;
nr_seq_repasse_w			pls_segurado_repasse.nr_sequencia%type;
ie_tipo_repasse_w			pls_segurado_repasse.ie_tipo_repasse%type;

C01 CURSOR(nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type) FOR
	SELECT	coalesce(pls_gerencia_envio_ans_pck.obter_cbo_executor_conta(x.nr_sequencia,x.cd_estabelecimento),b.cd_cbo_executante), b.cd_cnes_prest_exec, b.cd_cpf_cgc_prest_exec,
		b.cd_guia_operadora, b.cd_guia_prestador, b.cd_guia_principal,
		b.cd_municipio_benef, b.cd_municipio_prest_exec, b.cd_versao_tiss,
		b.dt_autorizacao, b.dt_fim_internacao, b.dt_inicio_faturamento,
		b.dt_nascimento, b.dt_processamento, b.dt_protocolo,
		b.dt_realizacao, b.dt_solicitacao, b.ie_carater_atendimento,
		b.ie_identif_prest_exec, b.ie_indicacao_acidente, b.ie_motivo_encerramento,
		b.ie_origem_evento, b.ie_recem_nasc, b.ie_reembolso,
		b.ie_regime_internacao, b.ie_sexo, b.ie_tipo_atendimento,
		b.ie_tipo_consulta, b.ie_tipo_envio, b.ie_tipo_evento,
		b.ie_tipo_faturamento, b.ie_tipo_guia, b.ie_tipo_internacao,
		(SELECT	p.nr_cartao_nac_sus
		from 	pessoa_fisica p
		where 	p.cd_pessoa_fisica = c.cd_pessoa_fisica) , b.nr_diarias_acompanhante, b.nr_diarias_uti,
		b.nr_protocolo_ans, b.nr_seq_prestador, b.nr_seq_segurado,
		b.vl_cobranca_guia, b.vl_total_diaria, b.vl_total_fornecedor,
		b.vl_total_glosa, b.vl_total_material, b.vl_total_medicamentos,
		b.vl_total_opm, b.vl_total_pago, b.vl_total_procedimento,
		b.vl_total_tabela_propria, b.vl_total_taxa, a.nr_sequencia,
		b.nr_seq_prest_inter, b.ie_tipo_atend_oper, b.nr_ident_pre_estab,
		b.nr_registro_operadora_inter, b.dt_pagamento_previsto, b.vl_total_copart,
		b.nr_cpf_benef, b.ie_regime_atendimento, b.ie_saude_ocupacional,
		b.ie_cobertura_especial, b.cd_modelo_remuneracao
	from	pls_monitor_tiss_cta_val a,
		pls_monitor_tiss_guia b,
		pls_conta	x,
		pls_segurado	c
	where	a.nr_seq_monitor_guia 	= b.nr_sequencia
	and	b.nr_seq_conta		= x.nr_sequencia
	and	x.nr_seq_segurado 	= c.nr_sequencia
	and	a.nr_seq_lote_monitor 	= nr_seq_lote_pc;
	
C02 CURSOR(nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
			a.nr_seq_conta,
			d.cd_pessoa_fisica,
			(	SELECT max(cd_pessoa_fisica)
				from 	pls_segurado
				where 	nr_sequencia = d.nr_seq_titular
			) 	cd_pessoa_fisica_titular,
			d.nr_seq_contrato
	from	pls_monitor_tiss_cta_val a,
			pls_monitor_tiss_guia b,
			pls_conta c,
			pls_segurado d
	where	a.nr_seq_monitor_guia = b.nr_sequencia
	and 	a.nr_seq_conta = c.nr_sequencia
	and 	c.nr_seq_segurado = d.nr_sequencia
	and		a.nr_seq_lote_monitor = nr_seq_lote_pc
	and 	coalesce(b.dt_nascimento::text, '') = ''
	
union

	select	a.nr_sequencia,
			a.nr_seq_conta,
			d.cd_pessoa_fisica,
			(	select max(cd_pessoa_fisica)
				from 	pls_segurado
				where 	nr_sequencia = d.nr_seq_titular
			) 	cd_pessoa_fisica_titular,
			d.nr_seq_contrato
	from	pls_monitor_tiss_cta_val a,
			pls_monitor_tiss_guia b,
			pls_conta c,
			pls_segurado d
	where	a.nr_seq_monitor_guia = b.nr_sequencia
	and 	a.nr_seq_conta = c.nr_sequencia
	and 	c.nr_seq_segurado = d.nr_sequencia
	and		a.nr_seq_lote_monitor = nr_seq_lote_pc
	and 	coalesce(b.cd_municipio_benef::text, '') = ''
	
union

	select	a.nr_sequencia,
			a.nr_seq_conta,
			d.cd_pessoa_fisica,
			(	select max(cd_pessoa_fisica)
				from 	pls_segurado
				where 	nr_sequencia = d.nr_seq_titular
			) 	cd_pessoa_fisica_titular,
			d.nr_seq_contrato
	from	pls_monitor_tiss_cta_val a,
			pls_monitor_tiss_guia b,
			pls_conta c,
			pls_segurado d
	where	a.nr_seq_monitor_guia = b.nr_sequencia
	and 	a.nr_seq_conta = c.nr_sequencia
	and 	c.nr_seq_segurado = d.nr_sequencia
	and		a.nr_seq_lote_monitor = nr_seq_lote_pc
	and 	coalesce(b.dt_nascimento::text, '') = '';	
	
C03 CURSOR(nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type) FOR
SELECT	a.nr_sequencia,
		b.nr_registro_operadora_inter,
		c.dt_atendimento_referencia,
		c.nr_seq_segurado,
		coalesce(c.nr_seq_congenere, d.nr_seq_congenere) nr_seq_congenere
from	pls_monitor_tiss_cta_val a,
		pls_monitor_tiss_guia b,
		pls_conta c,
		pls_protocolo_conta d
where	a.nr_seq_monitor_guia = b.nr_sequencia
and		a.nr_seq_lote_monitor = nr_seq_lote_pc
and 	(b.nr_registro_operadora_inter IS NOT NULL AND b.nr_registro_operadora_inter::text <> '')
and 	c.nr_sequencia = a.nr_seq_conta
and		d.nr_sequencia = c.nr_seq_protocolo;	
	
BEGIN

open C01(nr_seq_lote_p);
loop

	tb_cd_cbo_executante_w.delete;
	tb_cd_cnes_prest_exec_w.delete;
	tb_cd_cpf_cgc_prest_exec_w.delete;
	tb_cd_guia_operadora_w.delete;
	tb_cd_guia_prestador_w.delete;
	tb_cd_guia_principal_w.delete;
	tb_cd_municipio_benef_w.delete;
	tb_cd_municipio_prest_exec_w.delete;
	tb_cd_versao_tiss_w.delete;
	tb_dt_autorizacao_w.delete;
	tb_dt_fim_internacao_w.delete;
	tb_dt_inicio_faturamento_w.delete;
	tb_dt_nascimento_w.delete;
	tb_dt_processamento_w.delete;
	tb_dt_protocolo_w.delete;
	tb_dt_realizacao_w.delete;
	tb_dt_solicitacao_w.delete;
	tb_ie_carater_atendimento_w.delete;
	tb_ie_identif_prest_exec_w.delete;
	tb_ie_indicacao_acidente_w.delete;
	tb_ie_motivo_encerramento_w.delete;
	tb_ie_origem_evento_w.delete;
	tb_ie_recem_nasc_w.delete;
	tb_ie_reembolso_w.delete;
	tb_ie_regime_internacao_w.delete;
	tb_ie_sexo_w.delete;
	tb_ie_tipo_atendimento_w.delete;
	tb_ie_tipo_consulta_w.delete;
	tb_ie_tipo_envio_w.delete;
	tb_ie_tipo_evento_w.delete;
	tb_ie_tipo_faturamento_w.delete;
	tb_ie_tipo_guia_w.delete;
	tb_ie_tipo_internacao_w.delete;
	tb_nr_seq_cta_val_w.delete;
	tb_nr_cartao_nac_sus_w.delete;
	tb_nr_diarias_acompanhante_w.delete;
	tb_nr_diarias_uti_w.delete;
	tb_nr_protocolo_ans_w.delete;
	tb_nr_seq_prestador_w.delete;
	tb_nr_seq_segurado_w.delete;
	tb_vl_cobranca_guia_w.delete;
	tb_vl_total_diaria_w.delete;
	tb_vl_total_fornecedor_w.delete;
	tb_vl_total_glosa_w.delete;
	tb_vl_total_material_w.delete;
	tb_vl_total_medicamentos_w.delete;
	tb_vl_total_opm_w.delete;
	tb_vl_total_pago_w.delete;
	tb_vl_total_procedimento_w.delete;
	tb_vl_total_tabela_propria_w.delete;
	tb_vl_total_taxa_w.delete;
	tb_nr_seq_prest_inter_w.delete;
	tb_nr_ident_pre_estab_w.delete;
	tb_ie_tipo_atend_oper_w.delete;
	tb_nr_registro_oper_inter_w.delete;
	tb_dt_pagamento_w.delete;
	tb_vl_total_copart_w.delete;
	tb_nr_cpf_benef_w.delete;
	tb_ie_regime_atendimento_w.delete;	
	tb_ie_saude_ocupacional.delete;
	tb_ie_cobertura_especial_w.delete;
	tb_cd_modelo_remuneracao_w.delete;

	fetch C01 bulk collect into 	tb_cd_cbo_executante_w, tb_cd_cnes_prest_exec_w, tb_cd_cpf_cgc_prest_exec_w,
					tb_cd_guia_operadora_w, tb_cd_guia_prestador_w, tb_cd_guia_principal_w,
					tb_cd_municipio_benef_w, tb_cd_municipio_prest_exec_w, tb_cd_versao_tiss_w,
					tb_dt_autorizacao_w, tb_dt_fim_internacao_w, tb_dt_inicio_faturamento_w,
					tb_dt_nascimento_w, tb_dt_processamento_w, tb_dt_protocolo_w,
					tb_dt_realizacao_w, tb_dt_solicitacao_w, tb_ie_carater_atendimento_w,
					tb_ie_identif_prest_exec_w, tb_ie_indicacao_acidente_w, tb_ie_motivo_encerramento_w,
					tb_ie_origem_evento_w, tb_ie_recem_nasc_w, tb_ie_reembolso_w,
					tb_ie_regime_internacao_w, tb_ie_sexo_w, tb_ie_tipo_atendimento_w,
					tb_ie_tipo_consulta_w, tb_ie_tipo_envio_w, tb_ie_tipo_evento_w,
					tb_ie_tipo_faturamento_w, tb_ie_tipo_guia_w, tb_ie_tipo_internacao_w,
					tb_nr_cartao_nac_sus_w, tb_nr_diarias_acompanhante_w, tb_nr_diarias_uti_w,
					tb_nr_protocolo_ans_w, tb_nr_seq_prestador_w, tb_nr_seq_segurado_w,
					tb_vl_cobranca_guia_w, tb_vl_total_diaria_w, tb_vl_total_fornecedor_w,
					tb_vl_total_glosa_w, tb_vl_total_material_w, tb_vl_total_medicamentos_w,
					tb_vl_total_opm_w, tb_vl_total_pago_w, tb_vl_total_procedimento_w,
					tb_vl_total_tabela_propria_w, tb_vl_total_taxa_w, tb_nr_seq_cta_val_w,
					tb_nr_seq_prest_inter_w, tb_ie_tipo_atend_oper_w, tb_nr_ident_pre_estab_w,
					tb_nr_registro_oper_inter_w, tb_dt_pagamento_w, tb_vl_total_copart_w,
					tb_nr_cpf_benef_w, tb_ie_regime_atendimento_w, tb_ie_saude_ocupacional,
					tb_ie_cobertura_especial_w, tb_cd_modelo_remuneracao_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_nr_seq_cta_val_w.count = 0;

	forall i in tb_nr_seq_cta_val_w.first .. tb_nr_seq_cta_val_w.last
		update	pls_monitor_tiss_cta_val
		set	cd_cbo_executante		= CASE WHEN tb_cd_cbo_executante_w(i)='999999' THEN null  ELSE tb_cd_cbo_executante_w(i) END ,
			cd_cnes_prest_exec		= tb_cd_cnes_prest_exec_w(i),
			cd_cpf_cgc_prest_exec 		= tb_cd_cpf_cgc_prest_exec_w(i),
			cd_guia_operadora 		= tb_cd_guia_operadora_w(i),
			cd_guia_prestador		= tb_cd_guia_prestador_w(i),
			cd_municipio_benef 		= tb_cd_municipio_benef_w(i),
			cd_municipio_prest_exec 	= tb_cd_municipio_prest_exec_w(i),
			dt_atualizacao			= clock_timestamp(),
			dt_autorizacao			= tb_dt_autorizacao_w(i),
			dt_fim_internacao       	= tb_dt_fim_internacao_w(i),
			dt_inicio_faturamento 		= tb_dt_inicio_faturamento_w(i),
			dt_nascimento 			= tb_dt_nascimento_w(i),
			cd_guia_principal		= tb_cd_guia_principal_w(i),
			dt_protocolo			= tb_dt_protocolo_w(i),
			dt_solicitacao			= tb_dt_solicitacao_w(i),
			ie_carater_atendimento 		= tb_ie_carater_atendimento_w(i),
			ie_identif_prest_exec 		= tb_ie_identif_prest_exec_w(i),
			ie_indicacao_acidente		= tb_ie_indicacao_acidente_w(i),
			ie_origem_evento		= tb_ie_origem_evento_w(i),
			ie_recem_nasc 			= tb_ie_recem_nasc_w(i),
			ie_reembolso 			= tb_ie_reembolso_w(i),
			ie_regime_internacao		= tb_ie_regime_internacao_w(i),
			ie_sexo 			= tb_ie_sexo_w(i),
			ie_tipo_consulta		= tb_ie_tipo_consulta_w(i),
			ie_tipo_faturamento     	= tb_ie_tipo_faturamento_w(i),
			nr_seq_segurado 		= tb_nr_seq_segurado_w(i),
			nr_cartao_nac_sus 		= tb_nr_cartao_nac_sus_w(i),
			nr_diarias_acompanhante		 = NULL,
			nr_diarias_uti          	 = NULL,
			nr_protocolo_ans 		= tb_nr_protocolo_ans_w(i),
			nr_seq_prestador		= tb_nr_seq_prestador_w(i),
			vl_cobranca_guia		= tb_vl_cobranca_guia_w(i),
			vl_total_diaria 		= tb_vl_total_diaria_w(i),
			vl_total_glosa			= tb_vl_total_glosa_w(i),
			vl_total_material		= tb_vl_total_material_w(i),
			vl_total_medicamentos 		= tb_vl_total_medicamentos_w(i),
			vl_total_opm			= tb_vl_total_opm_w(i),
			vl_total_pago			= tb_vl_total_pago_w(i),
			vl_total_procedimento		= tb_vl_total_procedimento_w(i),
			vl_total_tabela_propria		= tb_vl_total_tabela_propria_w(i),
			vl_total_taxa			= tb_vl_total_taxa_w(i),
			vl_total_fornecedor		= tb_vl_total_fornecedor_w(i),
			dt_pagamento_previsto		= tb_dt_pagamento_w(i),
			dt_pagamento_recurso		 = NULL,
			dt_conta_fechada_recurso	 = NULL,
			dt_conta_fechada		 = NULL,
			dt_cancelamento_conta		 = NULL,
			dt_exclusao_conta		= tb_dt_processamento_w(i),
			cd_versao_tiss			= tb_cd_versao_tiss_w(i),
			ie_tipo_envio			= tb_ie_tipo_envio_w(i),
			ie_tipo_guia			= tb_ie_tipo_guia_w(i),
			dt_realizacao			= tb_dt_realizacao_w(i),
			ie_motivo_encerramento		= tb_ie_motivo_encerramento_w(i),
			ie_tipo_atendimento		= tb_ie_tipo_atendimento_w(i),
			ie_tipo_internacao		= tb_ie_tipo_internacao_w(i),
			nr_seq_prest_inter		= tb_nr_seq_prest_inter_w(i),
			ie_tipo_atend_oper		= tb_ie_tipo_atend_oper_w(i),
			nr_ident_pre_estab		= tb_nr_ident_pre_estab_w(i),
			nr_registro_operadora_inter	= tb_nr_registro_oper_inter_w(i),
			vl_total_copart			= tb_vl_total_copart_w(i),
			nr_cpf_benef	=	tb_nr_cpf_benef_w(i),
			ie_regime_atendimento	=	tb_ie_regime_atendimento_w(i),	
			ie_saude_ocupacional	=	tb_ie_saude_ocupacional(i),
			ie_cobertura_especial	=	tb_ie_cobertura_especial_w(i),
			cd_modelo_remuneracao	=	tb_cd_modelo_remuneracao_w(i)
		where	nr_sequencia 			= tb_nr_seq_cta_val_w(i);
	commit;

end loop;


for r_c02_w in C02(nr_seq_lote_p) loop

	dados_beneficiario_w 	:= pls_gerencia_envio_ans_pck.obter_dados_beneficiario( r_c02_w.cd_pessoa_fisica, r_c02_w.nr_seq_contrato );
	dt_nascimento_w			:= dados_beneficiario_w.dt_nascimento;
	ie_sexo_w				:= dados_beneficiario_w.ie_sexo;
	
	if (dados_beneficiario_w.cd_municipio_benef IS NOT NULL AND dados_beneficiario_w.cd_municipio_benef::text <> '') then
		cd_municipio_benef_w	:= dados_beneficiario_w.cd_municipio_benef || calcula_digito('MODULO10',substr(dados_beneficiario_w.cd_municipio_benef,1,10));
	elsif (r_c02_w.cd_pessoa_fisica_titular IS NOT NULL AND r_c02_w.cd_pessoa_fisica_titular::text <> '') then
		dados_beneficiario_w 	:= pls_gerencia_envio_ans_pck.obter_dados_beneficiario( r_c02_w.cd_pessoa_fisica_titular, r_c02_w.nr_seq_contrato );
		cd_municipio_benef_w	:= dados_beneficiario_w.cd_municipio_benef || calcula_digito('MODULO10',substr(dados_beneficiario_w.cd_municipio_benef,1,10));
	end if;
	
	dados_conta_update_w.dt_nascimento(ind_w) := dt_nascimento_w;
	dados_conta_update_w.cd_municipio_benef(ind_w) := cd_municipio_benef_w;
	dados_conta_update_w.ie_sexo(ind_w) := ie_sexo_w;
	dados_conta_update_w.nr_sequencia(ind_w) := r_c02_w.nr_sequencia;
	
	if ( ind_w > current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer ) then
		
		if (dados_conta_update_w.nr_sequencia.count > 0) then
			forall i in dados_conta_update_w.nr_sequencia.first .. dados_conta_update_w.nr_sequencia.last
				update	pls_monitor_tiss_cta_val
				set		dt_nascimento = dados_conta_update_w.dt_nascimento(i),
						cd_municipio_benef = dados_conta_update_w.cd_municipio_benef(i),
						ie_sexo	= dados_conta_update_w.ie_sexo(i)
				where	nr_sequencia = dados_conta_update_w.nr_sequencia(i);
			commit;
		end if;	
		ind_w := 0;
		dados_conta_update_w.dt_nascimento.delete;
		dados_conta_update_w.cd_municipio_benef.delete;
		dados_conta_update_w.ie_sexo.delete;
		dados_conta_update_w.nr_sequencia.delete;
		
	else
		ind_w := ind_w + 1;
	
	end if;
	
end loop;

if (dados_conta_update_w.nr_sequencia.count > 0) then
	
	forall i in dados_conta_update_w.nr_sequencia.first .. dados_conta_update_w.nr_sequencia.last
	update	pls_monitor_tiss_cta_val
	set		dt_nascimento = dados_conta_update_w.dt_nascimento(i),
			cd_municipio_benef = dados_conta_update_w.cd_municipio_benef(i),
			ie_sexo	= dados_conta_update_w.ie_sexo(i)
	where	nr_sequencia = dados_conta_update_w.nr_sequencia(i);
	commit;
			
	ind_w := 0;
	dados_conta_update_w.dt_nascimento.delete;
	dados_conta_update_w.cd_municipio_benef.delete;
	dados_conta_update_w.ie_sexo.delete;
	dados_conta_update_w.nr_sequencia.delete;

end if;	

/*Faz a busca pela informacao do ie_tipo_atend_oper. Separei em novo cursor para nao afetar a boa performance do bulk collect e 
forall utilizados no cursor1. Aqui apenas  e iterado sobre os registros que devam mesmo ser atualizados*/

ind_w := 0;
for r_c03_w in C03(nr_seq_lote_p) loop

	ie_tipo_atend_oper_w := '1';

	-- Busca um registro pre-estabelecido enviado por essa operadora para essa competencia

	select	max(nr_identificador)
	into STRICT	nr_ident_pre_estab_w
	from	pls_monit_tiss_pre_est_val a,
			pls_monitor_tiss_lote b
	where	b.nr_sequencia = a.nr_seq_lote_monitor
	and	a.nr_registro_operadora_inter = r_c03_w.nr_registro_operadora_inter
	and	r_C03_w.dt_atendimento_referencia between trunc(b.dt_mes_competencia,'month') and fim_mes(b.dt_mes_competencia)
	and	b.ie_status = 'LG';

	-- Caso encontre automaticamente o tipo de atendimento deve ser 2

	select	max(nr_sequencia),
			max(ie_tipo_repasse)
	into STRICT	nr_seq_repasse_w,
			ie_tipo_repasse_w
	from	pls_segurado_repasse
	where	nr_seq_segurado		= r_C03_w.nr_seq_segurado
	and		nr_seq_congenere 	= r_C03_w.nr_seq_congenere
	and		dt_repasse			<= r_C03_w.dt_atendimento_referencia
	and		(( dt_fim_repasse  	>= r_C03_w.dt_atendimento_referencia) or ( coalesce(dt_fim_repasse::text, '') = ''));
	--necessario realizar o tratamento para caso seja beneficiario de repasse em custo pos, seja linto o identificador de pre.

	
	if ( ie_tipo_repasse_w = 'C'	) or ( coalesce(ie_tipo_repasse_w::text, '') = ''	) then
		nr_ident_pre_estab_w := null;
	end if;

	if (nr_seq_repasse_w IS NOT NULL AND nr_seq_repasse_w::text <> '') or (nr_ident_pre_estab_w IS NOT NULL AND nr_ident_pre_estab_w::text <> '') then
		ie_tipo_atend_oper_w := '2';
	end if;
	
	dados_conta_update_w.nr_sequencia(ind_w) := r_c03_w.nr_sequencia;
	dados_conta_update_w.ie_tipo_atend_oper(ind_w) := ie_tipo_atend_oper_w;
	
	if ( ind_w > current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer ) then
		
		if (dados_conta_update_w.nr_sequencia.count > 0) then
			forall i in dados_conta_update_w.nr_sequencia.first .. dados_conta_update_w.nr_sequencia.last
				update	pls_monitor_tiss_cta_val
				set		ie_tipo_atend_oper	= dados_conta_update_w.ie_tipo_atend_oper(i)
				where	nr_sequencia = dados_conta_update_w.nr_sequencia(i);
			commit;
		end if;	
		ind_w := 0;
		dados_conta_update_w.ie_tipo_atend_oper.delete;
		dados_conta_update_w.nr_sequencia.delete;
		
	else
		ind_w := ind_w + 1;
	
	end if;
	
	
end loop;

if (dados_conta_update_w.nr_sequencia.count > 0) then
	
	forall i in dados_conta_update_w.nr_sequencia.first .. dados_conta_update_w.nr_sequencia.last
	update	pls_monitor_tiss_cta_val
	set		ie_tipo_atend_oper	= dados_conta_update_w.ie_tipo_atend_oper(i)
	where	nr_sequencia = dados_conta_update_w.nr_sequencia(i);
	commit;
			
	ind_w := 0;
	dados_conta_update_w.ie_tipo_atend_oper.delete;
	dados_conta_update_w.nr_sequencia.delete;

end if;	
		
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.gerar_val_adic_conta_alt ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;