-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_pre_pagto_pck.gerar_prot_conta_pre_pagto ( nr_seq_prot_gerado_p pls_faturamento_prot.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

					
nr_seq_lote_protocolo_w	pls_lote_protocolo_conta.nr_sequencia%type;
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_w		pls_conta_mat.nr_sequencia%type;
ds_processo_w			varchar(255);
ds_erro_w			varchar(4000);
ds_log_w			varchar(4000);
ie_orig_prot_w		pls_protocolo_conta.ie_origem_protocolo%type;

c01 CURSOR(	nr_seq_prot_gerado_pc	pls_faturamento_prot.nr_sequencia%type) FOR
	SELECT	b.nr_sequencia nr_seq_conta,									-- PARAMETRO PARA OS CURSORES 2 e 4
		CASE WHEN a.ie_tipo_faturamento='PRE' THEN  'F' WHEN a.ie_tipo_faturamento='POS' THEN  'I'  ELSE '' END  ie_tipo_protocolo,			-- 								pls_protocolo_conta.ie_tipo_protocolo
		a.cd_versao_tiss,										-- 								pls_protocolo_conta.cd_versao_tiss
		coalesce(coalesce(a.dt_mes_competencia_conv, b.dt_atendimento), clock_timestamp()) dt_mes_competencia,		-- 								pls_protocolo_conta.dt_mes_competencia
		a.cd_cpf_prestador,										-- 								pls_protocolo_conta.nr_cpf_prestador_imp
		a.nr_seq_outorgante nr_seq_congenere,								--								pls_protocolo_conta.nr_seq_congenere
		a.ie_guia_fisica_conv ie_guia_fisica,								--								pls_protocolo_conta.ie_guia_fisica
		CASE WHEN a.ie_tipo_faturamento='PRE' THEN  'Z' WHEN a.ie_tipo_faturamento='POS' THEN  'A'  ELSE '' END  ie_origem_protocolo,			-- pls_conta.ie_origem_conta						pls_protocolo_conta.ie_origem_protocolo
		a.cd_ans,											-- 
		a.cd_ans_destino,										-- pls_conta.cd_ans
		b.cd_guia_prestador,										-- pls_conta.cd_guia
		b.cd_usuario_plano,										-- pls_conta.cd_usuario_plano_imp
		b.ie_recem_nascido,										-- pls_conta.ie_recem_nascido
		b.nm_segurado_imp,										-- pls_conta.nm_segurado_imp
		b.cd_cpf_prest_solic,										-- pls_conta.cd_cpf_prestador_imp
		b.cd_cgc_prest_solic,										-- pls_conta.cd_cgc_prestador_imp
		b.nm_prestador_imp,										-- pls_conta.nm_prestador_imp
		b.sg_conselho_solic_imp,									-- pls_conta.sg_conselho_solic_imp
		b.nr_crm_solic_imp,										-- pls_conta.nr_crm_solic_imp
		b.uf_crm_solic_imp,										-- pls_conta.uf_crm_solic_imp
		b.cd_cbo_saude_solic_imp,									-- pls_conta.cd_cbo_saude_solic_imp
		b.cd_cpf_prest_exec,										-- pls_conta.cd_cpf_executor_imp
		b.cd_cgc_prest_exec,										-- pls_conta.cd_cgc_executor_imp
		b.nm_prestador_exec_imp,									-- pls_conta.nm_prestador_exec_imp
		b.ie_tipo_atendimento,										-- pls_conta.ie_tipo_atendimento_imp
		b.ie_indicacao_acidente,									-- pls_conta.ie_indicacao_acidente
		b.vl_total_imp,											-- pls_conta.vl_total			pls_conta.vl_total_imp
		b.ie_tipo_guia,											-- pls_conta.ie_tipo_guia
		b.ie_carater_atendimento,									-- 
		b.cd_cnes,											-- pls_conta.cd_cnes
		b.cd_guia_principal,										-- pls_conta.cd_guia_referencia
		b.dt_autorizacao,										-- pls_conta.dt_autorizacao
		b.cd_senha,											-- pls_conta.cd_senha
		b.vl_procedimentos_imp,										-- pls_conta.vl_procedimentos		pls_conta.vl_procedimentos_imp
		b.ie_motivo_encerramento,									-- pls_conta.ie_motivo_encerramento
		b.ie_regime_internacao,										-- pls_conta.ie_regime_internacao
		b.ie_tipo_internacao,										-- pls_conta.ie_tipo_internado		pls_conta.nr_seq_clinica
		b.dt_fim_faturamento,										-- pls_conta.dt_fim_faturamento		pls_conta.dt_fim_faturamento_imp
		b.dt_inicio_faturamento,									-- pls_conta.dt_inicio_faturamento		pls_conta.dt_inicio_faturamento_imp
		CASE WHEN b.ie_tipo_faturamento=1 THEN  'P' WHEN b.ie_tipo_faturamento=2 THEN  'F' WHEN b.ie_tipo_faturamento=3 THEN  'C' WHEN b.ie_tipo_faturamento=4 THEN  'T' END  ie_tipo_faturamento,		-- pls_conta.ie_tipo_faturamento
		b.sg_conselho_exec_imp,										-- pls_conta.sg_conselho_exec_imp
		b.nr_crm_exec_imp,										-- pls_conta.nr_crm_exec_imp
		b.uf_crm_exec_imp,										-- pls_conta.uf_crm_exec_imp
		b.cd_cbo_saude_exec_imp,									-- pls_conta.cd_cbo_saude_exec_imp
		b.ie_tipo_consulta,										-- pls_conta.ie_tipo_consulta
		b.dt_autorizacao dt_atendimento,								-- pls_conta.dt_atendimento		pls_conta.dt_atendimento_referencia
		b.cd_cnes_hosp_exec, 										-- 
		b.nm_hosp_exec, 										-- 
		b.cd_cnpj_hosp_exec,										-- 
		CASE WHEN b.ie_tipo_internacao=1 THEN  'E' WHEN b.ie_tipo_internacao=2 THEN  'U' END  ie_carater_internacao,				-- pls_conta.ie_carater_internacao
		b.vl_diarias_imp,										-- pls_conta.vl_diarias
		b.vl_taxas_imp,											-- pls_conta.vl_taxas
		b.vl_materiais_imp,										-- pls_conta.vl_materiais
		b.vl_medicamentos_imp,										-- pls_conta.vl_medicamentos
		b.vl_gases_imp,											-- pls_conta.vl_gases
		b.vl_opm_imp,											-- pls_conta.vl_opm
		b.nr_seq_segurado_conv,										-- pls_conta.nr_seq_segurado
		a.cd_cgc_prestador,										-- 
		b.dt_validade_senha,										-- pls_conta.dt_validade_senha
		b.nr_seq_prest_inter nr_seq_prest_inter_cta,							-- pls_conta.nr_seq_prest_inter
		CASE WHEN a.ie_tipo_faturamento='PRE' THEN  '7'  ELSE '2' END  ie_status_protocolo,				-- pls_protocolo_conta.ie_status
		CASE WHEN a.ie_tipo_faturamento='PRE' THEN  'S'  ELSE 'U' END  ie_status_conta,					-- pls_conta.ie_status
		b.ie_cobertura_especial,									-- pls_conta.ie_cobertura_especial
		b.ie_regime_atendimento,									-- pls_conta.ie_regime_atendimento
		b.ie_saude_ocupacional 										-- pls_conta.ie_saude_ocupacional
	from	pls_faturamento_prot 	a,
		pls_faturamento_conta 	b
	where	a.nr_sequencia 		= nr_seq_prot_gerado_pc
	and	a.nr_sequencia 		= b.nr_seq_protocolo;
	
c02 CURSOR(	nr_seq_conta_pc	pls_faturamento_conta.nr_sequencia%type) FOR
	SELECT	d.nr_sequencia nr_seq_conta_proc,								-- 
		c.nr_sequencia nr_seq_item,									-- 
		c.ie_tipo_despesa,										-- 
		d.dt_execucao_conv dt_execucao,									-- pls_conta_proc.dt_procedimento
		d.cd_procedimento_conv cd_procedimento,								-- pls_conta_proc.cd_procedimento
		d.qt_executado,											-- pls_conta_proc.qt_procedimento_imp
		d.tx_reducao_acrescimo,										-- pls_conta_proc.tx_reducao_acrescimo_imp
		d.vl_unitario,											-- pls_conta_proc.vl_unitario_imp
		d.vl_total,											-- pls_conta_proc.vl_procedimento_imp
		c.ds_procedimento,										-- pls_conta_proc.ds_procedimento_imp
		d.cd_tipo_tabela_conv,										-- pls_conta_proc.cd_tipo_tabela			pls_conta_proc.cd_tipo_tabela_imp
		c.ie_tipo_item,											-- 
		c.ie_tipo_item_conv,										-- 
		d.ie_origem_proced_conv,									-- pls_conta_proc.ie_origem_proced
		CASE WHEN d.ie_tecnica_utilizada_conv=1 THEN  'C' WHEN d.ie_tecnica_utilizada_conv=2 THEN  'V' WHEN d.ie_tecnica_utilizada_conv=3 THEN  'R' END  ie_tecnica_utilizada,		-- pls_conta_proc.ie_tecnica_utilizada		pls_conta_proc.ie_tecnica_utilizada_imp
		CASE WHEN d.ie_via_acesso_conv=1 THEN  'U' WHEN d.ie_via_acesso_conv=2 THEN  'M' WHEN d.ie_via_acesso_conv=3 THEN  'D' END  ie_via_acesso,				-- pls_conta_proc.ie_via_acesso			pls_conta_proc.ie_via_acesso_imp
		d.nr_seq_setor_atend_conv nr_seq_setor_atend,							-- pls_conta_proc.nr_seq_setor_atend
		d.dt_inicio dt_inicio_proc,									-- pls_conta_proc.dt_inicio_proc
		d.dt_fim dt_fim_proc,										-- pls_conta_proc.dt_fim_proc
		d.tx_item_via_acesso_conv tx_item 								-- pls_conta_proc.tx_item
	from	pls_faturamento_conta b,
		pls_fat_conta_item c,
		pls_fat_conta_proc d
	where	b.nr_sequencia = nr_seq_conta_pc
	and	c.nr_seq_conta = b.nr_sequencia
	and	c.nr_sequencia = d.nr_seq_item_conta;
	
c03 CURSOR(	nr_seq_item_pc	pls_fat_conta_item_equipe.nr_sequencia%type) FOR
	SELECT	cd_cbo_saude_profissional,									-- pls_proc_participante.cd_cbo_saude_imp
		cd_cpf_prestador,										-- pls_proc_participante.nr_cpf_imp
		cd_grau_partic,											-- pls_proc_participante.cd_grau_partic_imp
		nm_profissional,										-- pls_proc_participante.nm_medico_executor_imp
		nr_conselho_profissional,									-- pls_proc_participante.ie_conselho_profissional
		nr_seq_grau_partic_conv	nr_seq_grau_partic,							-- pls_proc_participante.nr_seq_grau_partic
		nr_seq_prest_inter,										-- pls_proc_participante.nr_seq_prest_inter
		sg_conselho_imp,										-- pls_proc_participante.sg_conselho_imp
		uf_conselho 											-- pls_proc_participante.uf_conselho
	from	pls_fat_conta_item_equipe
	where	nr_seq_item_conta = nr_seq_item_pc;
	
c04 CURSOR(	nr_seq_conta_pc	pls_faturamento_conta.nr_sequencia%type ) FOR
	SELECT	d.nr_sequencia nr_seq_conta_mat,								-- 
		c.ie_tipo_despesa,										-- 
		d.dt_execucao_conv dt_execucao,									-- pls_conta_mat.dt_atendimento
		d.cd_material_conv cd_procedimento,								-- pls_conta_mat.cd_material
		d.qt_executado,											-- pls_conta_mat.qt_material_imp
		d.tx_reducao_acrescimo,										-- pls_conta_mat.tx_reducao_acrescimo
		d.vl_unitario,											-- pls_conta_mat.vl_unitario_imp
		d.vl_total,											-- pls_conta_mat.vl_material_imp
		c.ds_procedimento,										-- pls_conta_mat.ds_material_imp
		d.cd_tipo_tabela_conv,										-- pls_conta_mat.cd_tipo_tabela_imp
		c.ie_tipo_item,											-- 
		c.ie_tipo_item_conv,										-- 
		d.cd_ref_fabricante,										-- pls_conta_mat.cd_ref_fabricante			pls_conta_mat.cd_ref_fabricante_imp
		d.cd_unidade_medida,										-- pls_conta_mat.cd_unidade_medida		pls_conta_mat.cd_unidade_medida_imp
		d.ie_tipo_cobertura,										-- pls_conta_mat.ie_tipo_cobertura
		d.nr_registro_anvisa,										-- pls_conta_mat.nr_registro_anvisa
		d.dt_inicio dt_inicio_atend,									-- pls_conta_mat.dt_inicio_atend
		d.dt_fim dt_fim_atend,										-- pls_conta_mat.dt_fim_atend
		d.nr_seq_material_conv
	from	pls_faturamento_conta b,
		pls_fat_conta_item c,
		pls_fat_conta_mat d
	where	b.nr_sequencia = nr_seq_conta_pc
	and	c.nr_seq_conta = b.nr_sequencia
	and	c.nr_sequencia = d.nr_seq_item_conta;
	
c05 CURSOR(	nr_seq_conta_pc	pls_faturamento_conta.nr_sequencia%type ) FOR
	SELECT	cd_doenca,
		cd_doenca_conv,
		dt_atualizacao,
		dt_atualizacao_nrec,
		ie_classificacao_conv,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_conta,
		nr_sequencia
	from	pls_fat_diagnostico_conta
	where	nr_seq_conta = nr_seq_conta_pc;
	
c06 CURSOR(	nr_seq_conta_pc	pls_faturamento_conta.nr_sequencia%type ) FOR
	SELECT	ie_indicador_dorn,
		nr_declaracao
	from	pls_fat_decl_conta_vivo
	where	nr_seq_conta = nr_seq_conta_pc;
	
c07 CURSOR(	nr_seq_conta_pc	pls_faturamento_conta.nr_sequencia%type ) FOR
	SELECT	cd_doenca_obito,
		cd_doenca_obito_conv,
		ie_indicador_dorn,
		nr_declaracao
	from	pls_fat_decl_conta_obito
	where	nr_seq_conta = nr_seq_conta_pc;
	
C08 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_protocolo_conta
	where	nr_seq_lote_conta = nr_seq_lote_protocolo_w;	
	
BEGIN

nr_seq_lote_protocolo_w	:= null;
nr_seq_protocolo_w	:= null;

for r_c01_w in c01( nr_seq_prot_gerado_p ) loop

	if (coalesce(nr_seq_lote_protocolo_w::text, '') = '') then
		insert into pls_lote_protocolo_conta(nr_sequencia,				dt_atualizacao,			nm_usuario,
			dt_atualizacao_nrec,			nm_usuario_nrec,		dt_lote,
			cd_estabelecimento,			nr_seq_congenere,		ie_tipo_lote,
			ie_status)	
		values (	nextval('pls_lote_protocolo_conta_seq'),	clock_timestamp(),			nm_usuario_p,
			clock_timestamp(),				nm_usuario_p,			clock_timestamp(),
			cd_estabelecimento_p,			r_c01_w.nr_seq_congenere,	'I',
			'U') returning nr_sequencia into nr_seq_lote_protocolo_w;
	end if;
	
	if (nr_seq_lote_protocolo_w IS NOT NULL AND nr_seq_lote_protocolo_w::text <> '') then
		if (coalesce(nr_seq_protocolo_w::text, '') = '') then
			insert into pls_protocolo_conta(	nr_sequencia,				dt_atualizacao, 		nm_usuario,
								dt_atualizacao_nrec,			nm_usuario_nrec,		cd_estabelecimento,
								dt_mes_competencia,			ie_situacao,			ie_status,
								ie_tipo_protocolo,			ie_origem_protocolo,		ie_tipo_guia,
								nr_seq_congenere,			ie_apresentacao,		cd_versao_tiss,
								nr_cpf_prestador_imp,			ie_guia_fisica,			nr_seq_lote_conta)
							values (nextval('pls_protocolo_conta_seq'), 	clock_timestamp(), 			nm_usuario_p,
								clock_timestamp(), 				nm_usuario_p, 			cd_estabelecimento_p,
								r_c01_w.dt_mes_competencia,		'EV',				r_c01_w.ie_status_protocolo,
								r_c01_w.ie_tipo_protocolo,		r_c01_w.ie_origem_protocolo,	r_c01_w.ie_tipo_guia,
								r_c01_w.nr_seq_congenere,		'A',				r_c01_w.cd_versao_tiss,
								r_c01_w.cd_cpf_prestador,		r_c01_w.ie_guia_fisica,		nr_seq_lote_protocolo_w) returning nr_sequencia into nr_seq_protocolo_w;
								
			update	pls_faturamento_prot
			set	dt_integracao		= clock_timestamp(),
				nr_seq_protocolo	= nr_seq_protocolo_w
			where	nr_sequencia		= nr_seq_prot_gerado_p;
		end if;
		
		if (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') then
			insert into pls_conta(		nr_sequencia, 				nm_usuario,			dt_atualizacao,
							nm_usuario_nrec,			dt_atualizacao_nrec,		cd_estabelecimento,
							nr_seq_protocolo,			ie_status,			ie_origem_conta,
							cd_ans,					cd_guia,			cd_usuario_plano_imp,
							ie_recem_nascido,			nm_segurado_imp,		cd_cpf_prestador_imp,
							cd_cgc_prestador_imp,			nm_prestador_imp,		sg_conselho_solic_imp,
							nr_crm_solic_imp,			uf_crm_solic_imp,		cd_cbo_saude_solic_imp,
							cd_cpf_executor_imp,			cd_cgc_executor_imp,		nm_prestador_exec_imp,
							ie_tipo_atendimento_imp,		ie_indicacao_acidente,		vl_total_imp,
							ie_tipo_guia,				ie_carater_internacao,		cd_cnes,
							cd_guia_referencia,			dt_autorizacao,			cd_senha,
							vl_procedimentos_imp,			ie_motivo_encerramento,		ie_regime_internacao,
							ie_tipo_internado,			dt_inicio_faturamento,		dt_fim_faturamento,
							dt_inicio_faturamento_imp,		dt_fim_faturamento_imp,		ie_tipo_faturamento,
							sg_conselho_exec_imp,			nr_crm_exec_imp,		uf_crm_exec_imp,
							cd_cbo_saude_exec_imp,			ie_tipo_consulta,		dt_atendimento,
							dt_atendimento_referencia,		nr_seq_prest_inter,		dt_entrada,
							dt_alta,				vl_procedimentos,		vl_diarias,
							vl_taxas,				vl_materiais,			vl_medicamentos,
							vl_gases,				vl_opm,				vl_glosa,
							vl_saldo,				vl_cobrado,			vl_total,
							vl_coparticipacao,			vl_total_beneficiario,		nr_seq_clinica,
							nr_seq_segurado,			nr_cartao_nac_sus_imp,		dt_validade_senha,
							vl_adic_materiais,			vl_adic_procedimento,		vl_adic_co,
							cd_ans_imp,				ie_cobertura_especial,		ie_regime_atendimento,
							ie_saude_ocupacional)
						values (	nextval('pls_conta_seq'),			nm_usuario_p,			clock_timestamp(),
							nm_usuario_p,				clock_timestamp(),			cd_estabelecimento_p,
							nr_seq_protocolo_w,			r_c01_w.ie_status_conta,	r_c01_w.ie_origem_protocolo,
							r_c01_w.cd_ans_destino,			r_c01_w.cd_guia_prestador,	r_c01_w.cd_usuario_plano,
							r_c01_w.ie_recem_nascido,		r_c01_w.nm_segurado_imp,	r_c01_w.cd_cpf_prest_solic,
							r_c01_w.cd_cgc_prest_solic,		r_c01_w.nm_prestador_imp,	r_c01_w.sg_conselho_solic_imp,
							r_c01_w.nr_crm_solic_imp,		r_c01_w.uf_crm_solic_imp,	r_c01_w.cd_cbo_saude_solic_imp,
							r_c01_w.cd_cpf_prest_exec,		r_c01_w.cd_cgc_prest_exec,	r_c01_w.nm_prestador_exec_imp,
							r_c01_w.ie_tipo_atendimento,		r_c01_w.ie_indicacao_acidente,	r_c01_w.vl_total_imp,
							r_c01_w.ie_tipo_guia,			r_c01_w.ie_carater_internacao,	r_c01_w.cd_cnes,
							r_c01_w.cd_guia_principal,		r_c01_w.dt_autorizacao,		r_c01_w.cd_senha,
							r_c01_w.vl_procedimentos_imp,		r_c01_w.ie_motivo_encerramento,	r_c01_w.ie_regime_internacao,
							r_c01_w.ie_tipo_internacao,		r_c01_w.dt_inicio_faturamento,	r_c01_w.dt_fim_faturamento,
							r_c01_w.dt_inicio_faturamento,		r_c01_w.dt_fim_faturamento,	r_c01_w.ie_tipo_faturamento,
							r_c01_w.sg_conselho_exec_imp,		r_c01_w.nr_crm_exec_imp,	r_c01_w.uf_crm_exec_imp,
							r_c01_w.cd_cbo_saude_exec_imp,		r_c01_w.ie_tipo_consulta,	r_c01_w.dt_atendimento,
							r_c01_w.dt_atendimento,			r_c01_w.nr_seq_prest_inter_cta,	r_c01_w.dt_inicio_faturamento,
							r_c01_w.dt_fim_faturamento,		r_c01_w.vl_procedimentos_imp,	r_c01_w.vl_diarias_imp,
							r_c01_w.vl_taxas_imp,			r_c01_w.vl_materiais_imp,	r_c01_w.vl_medicamentos_imp,
							r_c01_w.vl_gases_imp,			r_c01_w.vl_opm_imp,		0,
							0,					0,				r_c01_w.vl_total_imp,
							0,					0,				r_c01_w.ie_tipo_internacao,
							r_c01_w.nr_seq_segurado_conv,		r_c01_w.cd_cnes,		r_c01_w.dt_validade_senha,
							0,					0,				0,
							r_c01_w.cd_ans_destino,			r_c01_w.ie_cobertura_especial,	r_c01_w.ie_regime_atendimento,
							r_c01_w.ie_saude_ocupacional) returning nr_sequencia into nr_seq_conta_w;
							
			update	pls_faturamento_conta
			set	nr_seq_conta	= nr_seq_conta_w
			where	nr_sequencia 	= r_c01_w.nr_seq_conta;
							
			for r_c02_w in c02( r_c01_w.nr_seq_conta ) loop
				insert into pls_conta_proc(	nr_sequencia,			nm_usuario,			dt_atualizacao,
								nm_usuario_nrec,		dt_atualizacao_nrec,		ie_situacao,
								ie_status,			nr_seq_conta,			cd_procedimento_imp,
								dt_procedimento,		cd_procedimento,		qt_procedimento_imp,
								tx_reducao_acrescimo_imp,	vl_unitario_imp,		vl_procedimento_imp,
								ds_procedimento_imp,		cd_tipo_tabela,			cd_tipo_tabela_imp,
								ie_origem_proced,		ie_tecnica_utilizada,		ie_tecnica_utilizada_imp,
								ie_via_acesso,			ie_via_acesso_imp,		nr_seq_setor_atend,
								dt_inicio_proc,			dt_fim_proc,			tx_item,
								dt_procedimento_imp)
							values (nextval('pls_conta_proc_seq'),	nm_usuario_p,			clock_timestamp(),
								nm_usuario_p,			clock_timestamp(),			'B',
								r_c01_w.ie_status_conta,	nr_seq_conta_w,			r_c02_w.cd_procedimento,
								r_c02_w.dt_execucao,		r_c02_w.cd_procedimento,	r_c02_w.qt_executado,
								r_c02_w.tx_reducao_acrescimo,	r_c02_w.vl_unitario,		r_c02_w.vl_total,
								r_c02_w.ds_procedimento,	r_c02_w.cd_tipo_tabela_conv,	r_c02_w.cd_tipo_tabela_conv,
								r_c02_w.ie_origem_proced_conv,	r_c02_w.ie_tecnica_utilizada,	r_c02_w.ie_tecnica_utilizada,
								r_c02_w.ie_via_acesso,		r_c02_w.ie_via_acesso,		r_c02_w.nr_seq_setor_atend,
								r_c02_w.dt_inicio_proc,		r_c02_w.dt_fim_proc,		r_c02_w.tx_item,
								r_c02_w.dt_execucao) returning nr_sequencia into nr_seq_conta_proc_w;
								
				for r_c03_w in c03( r_c02_w.nr_seq_item ) loop
					insert	into pls_proc_participante(	nr_sequencia,				nm_usuario,				dt_atualizacao,
										nm_usuario_nrec,			dt_atualizacao_nrec,			nr_seq_conta_proc,
										ie_status,
										cd_cbo_saude_imp,			nr_cpf_imp,				cd_grau_partic_imp,
										nm_medico_executor_imp,			ie_conselho_profissional,		nr_seq_grau_partic,
										nr_seq_prest_inter,			sg_conselho_imp,			uf_conselho)
									values (nextval('pls_proc_participante_seq'),	nm_usuario_p,				clock_timestamp(),
										nm_usuario_p,				clock_timestamp(),				nr_seq_conta_proc_w,
										'U',
										r_c03_w.cd_cbo_saude_profissional,	r_c03_w.cd_cpf_prestador,		r_c03_w.cd_grau_partic,
										r_c03_w.nm_profissional,		r_c03_w.nr_conselho_profissional,	r_c03_w.nr_seq_grau_partic,
										r_c03_w.nr_seq_prest_inter,		r_c03_w.sg_conselho_imp,		r_c03_w.uf_conselho);
				end loop;
				
				CALL pls_gerar_coparticipacao_proc(nr_seq_conta_proc_w, 'N', nm_usuario_p);
			end loop;
			
			for r_c04_w in c04( r_c01_w.nr_seq_conta ) loop
				insert into pls_conta_mat(	nr_sequencia,			nm_usuario,			dt_atualizacao,
								nm_usuario_nrec,		dt_atualizacao_nrec,		ie_situacao,
								ie_status,			nr_seq_conta,			cd_material_imp,
								dt_atendimento,			cd_material,			qt_material_imp,
								tx_reducao_acrescimo,		vl_unitario_imp,		vl_material_imp,
								ds_material_imp,		cd_tipo_tabela_imp,		cd_ref_fabricante,
								cd_ref_fabricante_imp,		cd_unidade_medida,		cd_unidade_medida_imp,
								ie_tipo_cobertura,		nr_registro_anvisa,		dt_inicio_atend,
								dt_fim_atend,			nr_seq_material)
							values (nextval('pls_conta_mat_seq'),	nm_usuario_p,			clock_timestamp(),
								nm_usuario_p,			clock_timestamp(),			'I',
								r_c01_w.ie_status_conta,	nr_seq_conta_w,			r_c04_w.cd_procedimento,
								r_c04_w.dt_execucao,		null,				r_c04_w.qt_executado,
								r_c04_w.tx_reducao_acrescimo,	r_c04_w.vl_unitario,		r_c04_w.vl_total,
								r_c04_w.ds_procedimento,	r_c04_w.cd_tipo_tabela_conv,	r_c04_w.cd_ref_fabricante,
								r_c04_w.cd_ref_fabricante,	r_c04_w.cd_unidade_medida,	r_c04_w.cd_unidade_medida,
								r_c04_w.ie_tipo_cobertura,	r_c04_w.nr_registro_anvisa,	r_c04_w.dt_inicio_atend,
								r_c04_w.dt_fim_atend,		r_c04_w.nr_seq_material_conv) returning nr_sequencia into nr_seq_conta_mat_w;
								
				CALL pls_gerar_coparticipacao_mat(nr_seq_conta_mat_w, nm_usuario_p, cd_estabelecimento_p);
			end loop;
			
			for r_c05_w in c05( r_c01_w.nr_seq_conta ) loop
				insert into pls_diagnostico_conta(	nr_sequencia,				cd_doenca,			cd_doenca_imp,
									dt_atualizacao,				dt_atualizacao_nrec,		ie_classificacao,
									ie_classificacao_imp,			nm_usuario,			nm_usuario_nrec,
									nr_seq_conta)
								values (nextval('pls_diagnostico_conta_seq'),	r_c05_w.cd_doenca_conv,		r_c05_w.cd_doenca,
									clock_timestamp(),				clock_timestamp(),			r_c05_w.ie_classificacao_conv,
									r_c05_w.ie_classificacao_conv,		nm_usuario_p,			nm_usuario_p,
									nr_seq_conta_w);
			end loop;
			
			for r_c06_w in c06( r_c01_w.nr_seq_conta ) loop
				insert into pls_diagnostico_nasc_vivo(	nr_sequencia,				dt_atualizacao,			dt_atualizacao_nrec,
									ie_indicador_dorn,			ie_indicador_dorn_imp,		nm_usuario,
									nm_usuario_nrec,			nr_decl_nasc_vivo,		nr_decl_nasc_vivo_imp,
									nr_seq_conta)
								values (nextval('pls_diagnostico_nasc_vivo_seq'),	clock_timestamp(),			clock_timestamp(),
									r_c06_w.ie_indicador_dorn,		r_c06_w.ie_indicador_dorn,	nm_usuario_p,
									nm_usuario_p,				r_c06_w.nr_declaracao,		r_c06_w.nr_declaracao,
									nr_seq_conta_w);
			end loop;
			
			for r_c07_w in c07( r_c01_w.nr_seq_conta ) loop
				insert into pls_diagnost_conta_obito(	nr_sequencia,				cd_doenca,			cd_doenca_imp,
									dt_atualizacao,				dt_atualizacao_nrec,		ie_indicador_dorn,
									ie_indicador_dorn_imp,			nm_usuario,			nm_usuario_nrec,
									nr_declaracao_obito,			nr_declaracao_obito_imp,	nr_seq_conta)
								values (nextval('pls_diagnost_conta_obito_seq'),	r_c07_w.cd_doenca_obito_conv,	r_c07_w.cd_doenca_obito,
									clock_timestamp(),				clock_timestamp(),			r_c07_w.ie_indicador_dorn,
									r_c07_w.ie_indicador_dorn,		nm_usuario_p,			nm_usuario_p,
									r_c07_w.nr_declaracao,			r_c07_w.nr_declaracao,		nr_seq_conta_w);
			end loop;
			
			CALL pls_gerar_coparticipacao_conta(nr_seq_conta_w, null, nm_usuario_p);
			
		end if;
	end if;
end loop;

if (nr_seq_lote_protocolo_w IS NOT NULL AND nr_seq_lote_protocolo_w::text <> '') then

	select  max(ie_origem_protocolo)
	into STRICT	ie_orig_prot_w
	from	pls_protocolo_conta
	where 	nr_seq_lote_conta = nr_seq_lote_protocolo_w;

	
	--Como essa rotina e chamada tanto para geracao de pre e pos-pagamento, entao aqui tratamos conforme a origem do protocolo recem gerada

	if ( ie_orig_prot_w = 'Z') then
		
		for r_c08_w in C08 loop
			begin
				ds_processo_w := 'Gerar as analises.';
				-- Gera as analises para as contas geradas

				pls_analise_cta_pck.gerar_analise(null, r_c08_w.nr_sequencia, null, null,	nm_usuario_p, cd_estabelecimento_p, 'N', 'N', 'S');

				ds_processo_w := 'Fehchar as analises.';
				-- Fecha a analise e gera a nota de pos caso o usuario possua permissao / Atualiza o tipo de origem da analise (IE_ORIGEM_ANALISE) para "Contas de A700"

				CALL pls_gerar_contas_a700_pck.fechar_analise_conta_a700(nr_seq_protocolo_w, nm_usuario_p, cd_estabelecimento_p);

				ds_processo_w := 'Finalizar o lote';
				--ira finalizar setar o lote de analie para iniciada

				CALL pls_gerar_contas_a700_pck.fechar_lote_prot_conta_a700( r_c08_w.nr_sequencia, nm_usuario_p, cd_estabelecimento_p);
				
				ds_processo_w := 'Definir o "conta_resumo" do lote.';
				-- Atualiza o status da conta para "A700 finalizado" / Elimina o resumo da conta medica

				CALL pls_gerar_contas_a700_pck.definir_conta_resumo_a700( r_c08_w.nr_sequencia, nm_usuario_p, cd_estabelecimento_p);
				
			exception
			when others then
				ds_erro_w := substr(sqlerrm, 0, 4000);
				ds_log_w := substr(	'Processo executado: ' || ds_processo_w || pls_util_pck.enter_w ||
							'Erro: ' || pls_util_pck.enter_w ||
							ds_erro_w, 1, 4000);
							
				insert	into	pls_log_geracao_cta_a700(	ds_log, dt_atualizacao, dt_atualizacao_nrec,
						nm_usuario, nm_usuario_nrec, nr_seq_serv_pre_pagto,
						nr_sequencia)
				values (	ds_log_w, clock_timestamp(), clock_timestamp(),
						nm_usuario_p, nm_usuario_p, null,
						nextval('pls_log_geracao_cta_a700_seq'));
			end;
		end loop;
								
	else
		CALL pls_gerar_analise_lote( nr_seq_lote_protocolo_w, 'N', 'N', cd_estabelecimento_p, nm_usuario_p, null, 'N', null);
	end if;
		
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_pre_pagto_pck.gerar_prot_conta_pre_pagto ( nr_seq_prot_gerado_p pls_faturamento_prot.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;