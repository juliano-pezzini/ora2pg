-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_replicar_guia_sadt (nr_seq_guia_original_p bigint, qt_vias_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_vias_w	integer;
nr_seq_guia_w	bigint;


BEGIN

qt_vias_w	:= qt_vias_p;

if (coalesce(qt_vias_w,0) > 1) then

	while qt_vias_w > 1 loop
		begin

		select	nextval('w_tiss_guia_seq')
		into STRICT	nr_seq_guia_w
		;

		insert	into w_tiss_guia(nr_sequencia,		dt_atualizacao,		nm_usuario,		dt_atualizacao_nrec,
			nm_usuario_nrec,	cd_ans,			cd_autorizacao,		dt_autorizacao,
			cd_senha,		dt_validade_senha,	dt_emissao_guia,	nr_interno_conta,
			nr_seq_protocolo,	nr_sequencia_autor,	nr_seq_guia_origem,	nr_atendimento,
			cd_autorizacao_princ,	nr_seq_apresentacao,	ds_observacao,		ie_tiss_tipo_guia,
			dt_entrada,		nr_seq_conta_guia,	ds_assinatura_solic,	ds_assinatura_resp,
			ds_assinatura_exec,	dt_assinatura_contrat,	ds_data_assin_benef,	ds_data_assin_med,
			dt_assin_prest,		dt_assin_solic,		nr_guia_operadora,	nr_guia_prestador,
			ie_atendimento_rn,	nr_ordem_apresentacao,	dt_inicio_faturamento,	dt_fim_faturamento,
			ds_versao,		ds_justificativa,	ds_especific_mat,	nr_ciclos,
			nr_intervalo_ciclo,	nr_ciclo_atual)
		SELECT	nr_seq_guia_w,		clock_timestamp(),		nm_usuario_p,		clock_timestamp(),
			nm_usuario_p,		cd_ans,			cd_autorizacao,		dt_autorizacao,
			cd_senha,		dt_validade_senha,	dt_emissao_guia,	nr_interno_conta,
			nr_seq_protocolo,	nr_sequencia_autor,	nr_seq_guia_origem,	nr_atendimento,
			cd_autorizacao_princ,	nr_seq_apresentacao,	ds_observacao,		ie_tiss_tipo_guia,
			dt_entrada,		nr_seq_conta_guia,	ds_assinatura_solic,	ds_assinatura_resp,
			ds_assinatura_exec,	dt_assinatura_contrat,	ds_data_assin_benef,	ds_data_assin_med,
			dt_assin_prest,		dt_assin_solic,		nr_guia_operadora,	nr_guia_prestador,
			ie_atendimento_rn,	nr_ordem_apresentacao,	dt_inicio_faturamento,	dt_fim_faturamento,
			ds_versao,		ds_justificativa,	ds_especific_mat,	nr_ciclos,
			nr_intervalo_ciclo,	nr_ciclo_atual
		from	w_tiss_guia
		where	nr_sequencia	= nr_seq_guia_original_p;

		insert	into w_tiss_beneficiario(nr_sequencia,			dt_atualizacao,		nm_usuario,		dt_atualizacao_nrec,
			nm_usuario_nrec,		nr_seq_guia,		cd_pessoa_fisica,	nm_pessoa_fisica,
			nr_cartao_nac_sus,		ds_plano,		dt_validade_carteira,	cd_usuario_convenio,
			nr_seq_conta,			qt_peso,		qt_altura,		qt_superficie_corporal,
			qt_idade,			ie_sexo)
		SELECT	nextval('w_tiss_beneficiario_seq'),clock_timestamp(),		nm_usuario_p,		clock_timestamp(),
			nm_usuario_p,			nr_seq_guia_w,		cd_pessoa_fisica,	nm_pessoa_fisica,
			nr_cartao_nac_sus,		ds_plano,		dt_validade_carteira,	cd_usuario_convenio,
			nr_seq_conta,			qt_peso,		qt_altura,		qt_superficie_corporal,
			qt_idade,			ie_sexo
		from	w_tiss_beneficiario
		where	nr_seq_guia	= nr_seq_guia_original_p;

		insert	into w_tiss_dados_atendimento(nr_sequencia,				dt_atualizacao,		nm_usuario,		nr_seq_guia,
			ie_tipo_atendimento,			ie_tipo_saida,		ie_tipo_acidente,	nr_seq_conta,
			ie_tipo_consulta)
		SELECT	nextval('w_tiss_dados_atendimento_seq'),	clock_timestamp(),		nm_usuario_p,		nr_seq_guia_w,
			ie_tipo_atendimento,			ie_tipo_saida,		ie_tipo_acidente,	nr_seq_conta,
			ie_tipo_consulta
		from	w_tiss_dados_atendimento
		where	nr_seq_guia	= nr_seq_guia_original_p;

		insert 	into w_tiss_contratado_solic(nr_sequencia,				dt_atualizacao,		nm_usuario,		nr_seq_guia,
			cd_cgc,					cd_interno,		nr_cpf,			nm_contratado,
			nm_solicitante,				cd_cnes,		sg_conselho,		nr_crm,
			uf_crm,					cd_cbo_sus,		cd_cbo_saude,		cd_cgc_internacao,
			cd_interno_internacao,			nm_contratado_internacao,nr_seq_conta,		nr_telefone_contrat,
			ds_email_contrat)
		SELECT	nextval('w_tiss_contratado_solic_seq'),	clock_timestamp(),		nm_usuario_p,		nr_seq_guia_w,
			cd_cgc,					cd_interno,		nr_cpf,			nm_contratado,
			nm_solicitante,				cd_cnes,		sg_conselho,		nr_crm,
			uf_crm,					cd_cbo_sus,		cd_cbo_saude,		cd_cgc_internacao,
			cd_interno_internacao,			nm_contratado_internacao,nr_seq_conta,		nr_telefone_contrat,
			ds_email_contrat
		from	w_tiss_contratado_solic
		where	nr_seq_guia	= nr_seq_guia_original_p;

		insert 	into w_tiss_solicitacao(nr_sequencia,			dt_atualizacao,		nm_usuario,		nr_seq_guia,
			dt_solicitacao,			ie_carater_solic,	cd_cid,			ds_indicacao,
			ie_tipo_internacao,		ie_regime_internacao,	qt_dia_solicitado,	ie_tipo_doenca,
			ie_unidade_tempo,		qt_tempo,		ie_tipo_acidente,	nr_seq_conta,
			cd_estadiamento_tumor,		cd_finalidade_tratamento,cd_ecog,		ds_diag_histopatologico,
			ds_info_relevantes,		cd_tipo_quimio,		ds_plano_terapeutico)
		SELECT	nextval('w_tiss_solicitacao_seq'),	clock_timestamp(),		nm_usuario_p,		nr_seq_guia_w,
			dt_solicitacao,			ie_carater_solic,	cd_cid,			ds_indicacao,
			ie_tipo_internacao,		ie_regime_internacao,	qt_dia_solicitado,	ie_tipo_doenca,
			ie_unidade_tempo,		qt_tempo,		ie_tipo_acidente,	nr_seq_conta,
			cd_estadiamento_tumor,		cd_finalidade_tratamento,cd_ecog,		ds_diag_histopatologico,
			ds_info_relevantes,		cd_tipo_quimio,		ds_plano_terapeutico
		from	w_tiss_solicitacao
		where	nr_seq_guia	= nr_seq_guia_original_p;

		insert	into w_tiss_proc_solic(nr_sequencia,			dt_atualizacao,		nm_usuario,		nr_seq_guia,
			cd_procedimento,		cd_edicao_amb,		ds_procedimento,	qt_solicitada,
			qt_autorizada,			nr_seq_apresentacao,	nr_seq_conta)
		SELECT	nextval('w_tiss_proc_solic_seq'),	clock_timestamp(),		nm_usuario_p,		nr_seq_guia_w,
			cd_procedimento,		cd_edicao_amb,		ds_procedimento,	qt_solicitada,
			qt_autorizada,			nr_seq_apresentacao,	nr_seq_conta
		from	w_tiss_proc_solic
		where	nr_seq_guia	= nr_seq_guia_original_p;

		insert	into w_tiss_proc_paciente(nr_sequencia,				dt_atualizacao,		nm_usuario,		nr_seq_guia,
			cd_procedimento,			cd_edicao_amb,		qt_procedimento,	vl_reducao_acrescimo,
			vl_procedimento,			dt_entrada,		dt_alta,		ie_via_acesso,
			vl_unitario,				ds_procedimento,	dt_procedimento,	nr_seq_apresentacao,
			dt_inicio_cirurgia,			dt_fim_cirurgia,	ie_tecnica_utilizada,	nr_seq_conta,
			ie_funcao_medico)
		SELECT	nextval('w_tiss_proc_paciente_seq'),	clock_timestamp(),		nm_usuario_p,		nr_seq_guia_w,
			cd_procedimento,			cd_edicao_amb,		qt_procedimento,	vl_reducao_acrescimo,
			vl_procedimento,			dt_entrada,		dt_alta,		ie_via_acesso,
			vl_unitario,				ds_procedimento,	dt_procedimento,	nr_seq_apresentacao,
			dt_inicio_cirurgia,			dt_fim_cirurgia,	ie_tecnica_utilizada,	nr_seq_conta,
			ie_funcao_medico
		from	w_tiss_proc_paciente
		where	nr_seq_guia	= nr_seq_guia_original_p;

		insert	into w_tiss_contratado_exec(nr_sequencia,				dt_atualizacao,			nm_usuario,		nr_seq_guia,
			cd_cgc,					cd_interno,			nr_cpf,			nm_contratado,
			ds_tipo_logradouro,			ds_logradouro,			nm_municipio,		sg_estado,
			cd_municipio_ibge,			cd_cep,				cd_cnes,		nm_medico_executor,
			sg_conselho,				nr_crm,				uf_crm,			cd_cbo_sus,
			cd_cbo_saude,				ds_funcao_medico,		nr_endereco,		nr_cpf_prof,
			nr_seq_conta)
		SELECT	nextval('w_tiss_contratado_exec_seq'),	clock_timestamp(),			nm_usuario_p,		nr_seq_guia_w,
			cd_cgc,					cd_interno,			nr_cpf,			nm_contratado,
			ds_tipo_logradouro,			ds_logradouro,			nm_municipio,		sg_estado,
			cd_municipio_ibge,			cd_cep,				cd_cnes,		nm_medico_executor,
			sg_conselho,				nr_crm,				uf_crm,			cd_cbo_sus,
			cd_cbo_saude,				ds_funcao_medico,		nr_endereco,		nr_cpf_prof,
			nr_seq_conta
		from	w_tiss_contratado_exec
		where	nr_seq_guia	= nr_seq_guia_original_p;

		insert	into w_tiss_totais(nr_sequencia,				dt_atualizacao,			nm_usuario,		nr_seq_guia,
			vl_procedimentos,			vl_taxas,			vl_materiais,		vl_medicamentos,
			vl_diarias,				vl_gases,			vl_total_geral,		ie_tipo_faturamento,
			vl_total_geral_opm,			nr_seq_conta)
		SELECT	nextval('w_tiss_totais_seq'),		clock_timestamp(),			nm_usuario_p,		nr_seq_guia_w,
			vl_procedimentos,			vl_taxas,			vl_materiais,		vl_medicamentos,
			vl_diarias,				vl_gases,			vl_total_geral,		ie_tipo_faturamento,
			vl_total_geral_opm,			nr_seq_conta
		from	w_tiss_totais
		where	nr_seq_guia	= nr_seq_guia_original_p;

		insert	into w_tiss_opm(nr_sequencia,			dt_atualizacao,			nm_usuario,		dt_atualizacao_nrec,
			nm_usuario_nrec,		nr_seq_guia,			cd_opm,			cd_edicao,
			ds_opm,				qt_solicitada,			qt_autorizada,		ds_fabricante,
			vl_opm,				vl_unitario,			nr_seq_apresentacao,	nr_seq_conta,
			nr_registro_anvisa,		cd_ref_fabricante,		nr_autorizacao_func,	ie_opcao_fabricante,
			dt_prevista,			qt_frequencia,			ie_via_aplicacao)
		SELECT	nextval('w_tiss_opm_seq'),		clock_timestamp(),			nm_usuario_p,		clock_timestamp(),
			nm_usuario_p,			nr_seq_guia_w,			cd_opm,			cd_edicao,
			ds_opm,				qt_solicitada,			qt_autorizada,		ds_fabricante,
			vl_opm,				vl_unitario,			nr_seq_apresentacao,	nr_seq_conta,
			nr_registro_anvisa,		cd_ref_fabricante,		nr_autorizacao_func,	ie_opcao_fabricante,
			dt_prevista,			qt_frequencia,			ie_via_aplicacao
		from	w_tiss_opm
		where	nr_seq_guia	= nr_seq_guia_original_p;

		insert	into w_tiss_opm_exec(nr_sequencia,			dt_atualizacao,			nm_usuario,		dt_atualizacao_nrec,
			nm_usuario_nrec,		nr_seq_guia,			cd_opm,			cd_edicao,
			ds_opm,				qt_solicitada,			qt_autorizada,		ds_fabricante,
			vl_opm,				vl_unitario,			nr_seq_apresentacao,	nr_interno_conta,
			nr_seq_conta,			cd_barras)
		SELECT	nextval('w_tiss_opm_exec_seq'),	clock_timestamp(),			nm_usuario_p,		clock_timestamp(),
			nm_usuario_p,			nr_seq_guia_w,			cd_opm,			cd_edicao,
			ds_opm,				qt_solicitada,			qt_autorizada,		ds_fabricante,
			vl_opm,				vl_unitario,			nr_seq_apresentacao,	nr_interno_conta,
			nr_seq_conta,			cd_barras
		from	w_tiss_opm_exec
		where	nr_seq_guia	= nr_seq_guia_original_p;

		qt_vias_w	:= qt_vias_w - 1;

		end;
	end loop;
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_replicar_guia_sadt (nr_seq_guia_original_p bigint, qt_vias_p bigint, nm_usuario_p text) FROM PUBLIC;

