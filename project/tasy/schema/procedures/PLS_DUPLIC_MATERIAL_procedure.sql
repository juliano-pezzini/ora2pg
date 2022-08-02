-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplic_material ( nr_seq_material_p pls_material.nr_sequencia%type, cd_material_p material.cd_material%type, nm_usuario_p text, nr_seq_tuss_mat_item_p pls_material.nr_seq_tuss_mat_item%type, cd_material_ops_p INOUT pls_material.cd_material_ops%type, nr_seq_pls_material_p INOUT pls_material.nr_sequencia%type) AS $body$
DECLARE

				
cd_material_w		material.cd_material%type;
nr_seq_pls_material_w	pls_material.nr_sequencia%type;
nr_seq_prec_item_w	pls_material_preco_item.nr_sequencia%type;

c01 CURSOR(	nr_seq_material_pc	pls_material.nr_sequencia%type,
		cd_material_pc		material.cd_material%type,
		cd_material_novo_pc	material.cd_material%type,
		nr_seq_tuss_mat_item_pc	pls_material.nr_seq_tuss_mat_item%type) FOR
	SELECT	cd_estabelecimento,
		cd_farmacia_com,
		cd_grupo_proc,
		cd_material_novo_pc cd_material,
		cd_material_a900,
		coalesce(substr(obter_dados_mat_tuss(nr_seq_tuss_mat_item_pc, 'C'), 1, 20), cd_material_ops) cd_material_ops,
		cd_material_ops_number,
		cd_material_ops_orig,
		cd_material_tuss_a900,
		cd_simpro,
		cd_tiss_brasindice,
		cd_unidade_medida,
		ds_grupo_proc,
		ds_material,
		ds_material_sem_acento,
		ds_medicamento,
		ds_motivo_exclusao,
		ds_nome_comercial,
		ds_observacao,
		ds_versao_tiss,
		dt_atualizacao,
		dt_atualizacao_nrec,
		dt_exclusao,
		dt_fim_vigencia_ref,
		dt_inclusao,
		dt_inclusao_ref,
		dt_limite_utilizacao,
		dt_referencia,
		dt_validade,
		ie_nao_gera_brasindice,
		ie_nao_gera_simpro,
		ie_origem,
		ie_pis_cofins,
		ie_revisar,
		ie_sistema_ant,
		ie_situacao,
		ie_tipo_despesa,
		CASE WHEN coalesce(nr_seq_tuss_mat_item_pc::text, '') = '' THEN  '00'  ELSE '19' END  ie_tipo_tabela,
		nm_usuario,
		nm_usuario_nrec,
		nr_registro_anvisa,
		nr_seq_estrut_mat,
		nr_seq_grupo_ajuste,
		nr_seq_marca,
		nr_seq_material_unimed,
		nr_seq_mat_uni_fed_sc,
		nr_seq_tipo_uso,
		nr_seq_tuss_mat_item_pc nr_seq_tuss_mat_item,
		nr_sequencia,
		qt_conversao,
		qt_conversao_a900,
		qt_conversao_farm,
		qt_conversao_prest,
		qt_conversao_simpro
	from	pls_material
	where	cd_material	= cd_material_pc
	and	ie_situacao	= 'A'
	and	coalesce(dt_exclusao::text, '') = ''
	
union

	SELECT	cd_estabelecimento,
		cd_farmacia_com,
		cd_grupo_proc,
		cd_material,
		cd_material_a900,
		coalesce(substr(obter_dados_mat_tuss(nr_seq_tuss_mat_item_pc, 'C'), 1, 20), cd_material_ops) cd_material_ops,
		cd_material_ops_number,
		cd_material_ops_orig,
		cd_material_tuss_a900,
		cd_simpro,
		cd_tiss_brasindice,
		cd_unidade_medida,
		ds_grupo_proc,
		ds_material,
		ds_material_sem_acento,
		ds_medicamento,
		ds_motivo_exclusao,
		ds_nome_comercial,
		ds_observacao,
		ds_versao_tiss,
		dt_atualizacao,
		dt_atualizacao_nrec,
		dt_exclusao,
		dt_fim_vigencia_ref,
		dt_inclusao,
		dt_inclusao_ref,
		dt_limite_utilizacao,
		dt_referencia,
		dt_validade,
		ie_nao_gera_brasindice,
		ie_nao_gera_simpro,
		ie_origem,
		ie_pis_cofins,
		ie_revisar,
		ie_sistema_ant,
		ie_situacao,
		ie_tipo_despesa,
		CASE WHEN coalesce(nr_seq_tuss_mat_item_pc::text, '') = '' THEN  '00'  ELSE '19' END  ie_tipo_tabela,
		nm_usuario,
		nm_usuario_nrec,
		nr_registro_anvisa,
		nr_seq_estrut_mat,
		nr_seq_grupo_ajuste,
		nr_seq_marca,
		nr_seq_material_unimed,
		nr_seq_mat_uni_fed_sc,
		nr_seq_tipo_uso,
		nr_seq_tuss_mat_item_pc nr_seq_tuss_mat_item,
		nr_sequencia,
		qt_conversao,
		qt_conversao_a900,
		qt_conversao_farm,
		qt_conversao_prest,
		qt_conversao_simpro
	from	pls_material
	where	nr_sequencia = nr_seq_material_pc;
	
c02 CURSOR(	nr_seq_material_pc	pls_material_restricao.nr_seq_material%type,
		nr_seq_pls_material_pc	pls_material.nr_sequencia%type) FOR
	SELECT	dt_atualizacao,
		dt_atualizacao_nrec,
		dt_fim_vigencia,
		dt_fim_vigencia_ref,
		dt_inicio_vigencia,
		dt_inicio_vigencia_ref,
		ie_autorizacao,
		ie_bloqueia_autor,
		ie_bloqueia_custo_op,
		ie_bloqueia_intercambio,
		ie_bloqueia_pre_pag,
		ie_bloqueia_prod_nao_reg,
		ie_bloqueia_prod_reg,
		ie_nota_fiscal,
		ie_sexo_exclusivo,
		ie_taxa_comercial,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_pls_material_pc nr_seq_material,
		nr_sequencia,
		qt_idade_maxima,
		qt_idade_minima,
		qt_maxima,
		qt_minima
	from	pls_material_restricao
	where	nr_seq_material = nr_seq_material_pc;

c03 CURSOR(	nr_seq_material_pc	pls_regra_autorizacao.nr_seq_material%type,
		nr_seq_pls_material_pc	pls_material.nr_sequencia%type) FOR
	SELECT	a.cd_area_procedimento,
		a.cd_especialidade,
		a.cd_especialidade_medica,
		a.cd_estabelecimento,
		a.cd_grupo_proc,
		a.cd_material,
		a.cd_procedimento,
		a.dt_atualizacao,
		a.dt_atualizacao_nrec,
		a.dt_fim_vigencia,
		a.dt_fim_vigencia_ref,
		a.dt_inicio_vigencia,
		a.dt_inicio_vigencia_ref,
		a.ie_aceitar_sem_guia,
		a.ie_carater_internacao,
		a.ie_guia_valida,
		a.ie_liberado,
		a.ie_origem_proced,
		a.ie_preco,
		a.ie_restricao_intercambio,
		a.ie_situacao,
		a.ie_tipo_atendimento,
		a.ie_tipo_congenere,
		a.ie_tipo_guia,
		a.ie_tipo_intercambio,
		a.ie_tipo_segurado,
		a.nm_usuario,
		a.nm_usuario_nrec,
		a.nr_seq_anterior,
		a.nr_seq_estrut_mat,
		a.nr_seq_grupo_contrato,
		a.nr_seq_grupo_produto,
		a.nr_seq_grupo_servico,
		nr_seq_pls_material_pc nr_seq_material,
		a.nr_seq_motivo_glosa,
		a.nr_seq_prestador,
		a.nr_seq_tipo_atendimento,
		a.nr_sequencia,
		a.ie_regime_atendimento,
		a.ie_saude_ocupacional
	from	pls_regra_autorizacao a
	where	a.nr_seq_material = nr_seq_material_pc;

c04 CURSOR(	nr_seq_material_pc	pls_material_preco_item.nr_seq_material%type,
		nr_seq_pls_material_pc	pls_material.nr_sequencia%type) FOR
	SELECT	cd_cgc_fornecedor,
		cd_material,
		cd_moeda,
		dt_atualizacao,
		dt_atualizacao_nrec,
		dt_inicio_vigencia,
		ie_situacao,
		nm_usuario,
		nm_usuario_nrec,
		nr_item_nf,
		nr_seq_pls_material_pc nr_seq_material,
		nr_seq_material_preco,
		nr_sequencia,
		nr_sequencia_nf,
		vl_material
	from	pls_material_preco_item
	where	nr_seq_material = nr_seq_material_pc;
	
c05 CURSOR(	nr_seq_preco_item_pc	pls_material_valor_item.nr_seq_preco_item%type,
		nr_seq_prec_item_pc	pls_material_valor_item.nr_seq_preco_item%type) FOR
	SELECT	cd_moeda,
		ds_observacao,
		dt_atualizacao,
		dt_atualizacao_nrec,
		dt_inicio_vigencia,
		ie_tipo_preco,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_prec_item_pc nr_seq_preco_item,
		nr_sequencia,
		qt_convercao,
		vl_material
	from	pls_material_valor_item
	where	nr_seq_preco_item = nr_seq_preco_item_pc;

c06 CURSOR(	nr_seq_material_pc	pls_material_a900.nr_seq_material%type,
		nr_seq_pls_material_pc	pls_material.nr_sequencia%type)  FOR
	SELECT	cd_material_a900,
		dt_atualizacao,
		dt_atualizacao_nrec,
		dt_fim_vigencia,
		dt_inicio_vigencia,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_pls_material_pc nr_seq_material,
		nr_seq_material_unimed,
		nr_sequencia,
		qt_conversao_a900
	from	pls_material_a900
	where	nr_seq_material = nr_seq_material_pc;

c07 CURSOR(	nr_seq_material_pc	pls_preco_material.nr_seq_material%type,
		nr_seq_pls_material_pc	pls_material.nr_sequencia%type) FOR
	SELECT	dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_estrutura_mat,
		nr_seq_grupo,
		nr_seq_pls_material_pc nr_seq_material,
		nr_sequencia
	from	pls_preco_material
	where	nr_seq_material = nr_seq_material_pc;

BEGIN

-- Quando executado pela 'Gestao do Cadastro de Materiais' a rotina recebe 'cd_material_p', pode ou nao receber 'nr_seq_tuss_mat_item_p' e retorna 'cd_material_ops_p'

-- Quando executado pela 'OPS - Cadastro de Materiais' a rotina recebe 'nr_seq_material_p', pode ou nao receber 'nr_seq_tuss_mat_item_p' e retorna 'nr_seq_pls_material_p'
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select	nextval('material_seq')
	into STRICT	cd_material_w
	;
	
	insert into material(	cd_classe_material,		cd_classif_fiscal,		cd_cnpj_cadastro,		cd_dcb,				cd_fabricante,
				cd_intervalo_padrao,		cd_kit_material,		cd_material,			cd_material_conta,		cd_material_estoque,
				cd_material_generico,		cd_material_subs,		cd_medicamento,			cd_sistema_ant,			cd_tipo_recomendacao,
				cd_unidade_medida_compra,	cd_unidade_medida_consumo,	cd_unidade_medida_estoque,	cd_unidade_medida_prescr,	cd_unidade_medida_solic,
				cd_unid_med_base_conc,		cd_unid_med_concetracao,	cd_unid_med_conc_total,		cd_unid_med_dose_emb,		cd_unid_medida,
				cd_unid_med_limite,		cd_unid_terapeutica,		ds_abrev_solucao,		ds_dose_embalagem,		ds_hint,
				ds_material,			ds_material_sem_acento,		ds_mensagem,			ds_orientacao_uso,		ds_orientacao_usuario,
				ds_precaucao_ordem,		ds_reduzida,			dt_atualizacao,			dt_atualizacao_nrec,		dt_cadastramento,
				dt_integracao,			dt_revisao_fispq,		dt_validade_certificado_aprov,	dt_validade_reg_anvisa,		ie_abrigo_luz,
				ie_alta_vigilancia,		ie_alto_risco,			ie_ancora_solucao,		ie_aplicar,			ie_avaliacao_rep,
				ie_baixa_estoq_pac,		ie_baixa_inteira,		ie_bomba_infusao,		ie_catalogo,			ie_classif_medic,
				ie_classif_xyz,			ie_clearance,			ie_cobra_paciente,		ie_consignado,			ie_consiste_dias,
				ie_consiste_dupl,		ie_consiste_estoque,		ie_controle_medico,		ie_curva_abc,			ie_custo_benef,
				ie_dias_util_medic,		ie_diluicao,			ie_disponivel_mercado,		ie_dose_limite,			ie_dupla_checagem,
				ie_editar_dose,			ie_embalagem_multipla,		ie_esterilizavel,		ie_exige_lado,			ie_extravazamento,
				ie_fabricante_dist,		ie_fabric_propria,		ie_fotosensivel,		ie_gera_lote_separado,		ie_gerar_lote,
				ie_gravar_obs_prescr,		ie_higroscopico,		ie_iat,				ie_inf_ultima_compra,		ie_justifica_dias_util,
				ie_justificativa_padrao,	ie_latex,			ie_manipulado,			ie_material_direto,		ie_material_estoque,
				ie_medic_paciente,		ie_medic_soro_oral,		ie_mensagem_sonda,		ie_mistura,			ie_monofasico,
				ie_mostrar_orientacao,		ie_multidose,			ie_nova_molecula,		ie_objetivo,			ie_obriga_just_dose,
				ie_obriga_justificativa,	ie_obriga_tempo_aplic,		ie_obrig_via_aplicacao,		ie_pactuado,			ie_padrao_cpoe,
				ie_padronizado,			ie_perecivel,			ie_permite_fracionado,		ie_permite_lactante,		ie_preco_compra,
				ie_prescricao,			ie_protocolo_tev,		ie_receita,			ie_restrito,			ie_sexo,
				ie_situacao,			ie_solucao,			ie_status_envio,		ie_tamanho_embalagem,		ie_termolabil,
				ie_tipo_fonte_prescr,		ie_tipo_material,		ie_tipo_solucao,		ie_tipo_solucao_cpoe,		ie_umidade_controlada,
				ie_unid_med_padrao,		ie_utilizacao_sus,		ie_vancomicina,			ie_via_aplicacao,		ie_volumoso,
				nm_usuario,			nm_usuario_nrec,		nr_certificado_aprovacao,	nr_codigo_barras,		nr_dias_justif,
				nr_minimo_cotacao,		nr_registro_anvisa,		nr_registro_ms,			nr_seq_classif_risco,		nr_seq_divisao,
				nr_seq_dose_terap,		nr_seq_fabric,			nr_seq_familia,			nr_seq_ficha_tecnica,		nr_seq_forma_farm,
				nr_seq_grupo_rec,		nr_seq_localizacao,		nr_seq_modelo_dialisador,	qt_altura_cm,			qt_compra_melhor,
				qt_comprimento_cm,		qt_concentracao_total,		qt_consumo_mensal,		qt_conv_compra_est,		qt_conv_compra_estoque,
				qt_conversao_mg,		qt_conv_estoque_consumo,	qt_dia_estoque_minimo,		qt_dia_interv_profilaxia,	qt_dia_interv_ressup,
				qt_dia_profilatico,		qt_dia_ressup_forn,		qt_dias_validade,		qt_dia_terapeutico,		qt_dose_prescricao,
				qt_dose_terapeutica,		qt_estoque_maximo,		qt_estoque_minimo,		qt_horas_util_pac,		qt_largura_cm,
				qt_limite_pessoa,		qt_max_dia_aplic,		qt_maxima_planej,		qt_max_prescricao,		qt_meia_vida,
				qt_min_aplicacao,		qt_minima_planej,		qt_minimo_multiplo_solic,	qt_overfill,			qt_peso_kg,
				qt_ponto_pedido,		qt_prioridade_apres,		qt_prioridade_coml)
			(SELECT	cd_classe_material,		cd_classif_fiscal,		cd_cnpj_cadastro,		cd_dcb,				cd_fabricante,
				cd_intervalo_padrao,		cd_kit_material,		cd_material_w,			cd_material_conta,		cd_material_estoque,
				cd_material_generico,		cd_material_subs,		cd_medicamento,			cd_sistema_ant,			cd_tipo_recomendacao,
				cd_unidade_medida_compra,	cd_unidade_medida_consumo,	cd_unidade_medida_estoque,	cd_unidade_medida_prescr,	cd_unidade_medida_solic,
				cd_unid_med_base_conc,		cd_unid_med_concetracao,	cd_unid_med_conc_total,		cd_unid_med_dose_emb,		cd_unid_medida,
				cd_unid_med_limite,		cd_unid_terapeutica,		ds_abrev_solucao,		ds_dose_embalagem,		ds_hint,
				ds_material,			ds_material_sem_acento,		ds_mensagem,			ds_orientacao_uso,		ds_orientacao_usuario,
				ds_precaucao_ordem,		ds_reduzida,			clock_timestamp(),			clock_timestamp(),			dt_cadastramento,
				dt_integracao,			dt_revisao_fispq,		dt_validade_certificado_aprov,	dt_validade_reg_anvisa,		ie_abrigo_luz,
				ie_alta_vigilancia,		ie_alto_risco,			ie_ancora_solucao,		ie_aplicar,			ie_avaliacao_rep,
				ie_baixa_estoq_pac,		ie_baixa_inteira,		ie_bomba_infusao,		ie_catalogo,			ie_classif_medic,
				ie_classif_xyz,			ie_clearance,			ie_cobra_paciente,		ie_consignado,			ie_consiste_dias,
				ie_consiste_dupl,		ie_consiste_estoque,		ie_controle_medico,		ie_curva_abc,			ie_custo_benef,	
				ie_dias_util_medic,		ie_diluicao,			ie_disponivel_mercado,		ie_dose_limite,			ie_dupla_checagem,
				ie_editar_dose,			ie_embalagem_multipla,		ie_esterilizavel,		ie_exige_lado,			ie_extravazamento,
				ie_fabricante_dist,		ie_fabric_propria,		ie_fotosensivel,		ie_gera_lote_separado,		ie_gerar_lote,	
				ie_gravar_obs_prescr,		ie_higroscopico,		ie_iat,				ie_inf_ultima_compra,		ie_justifica_dias_util,
				ie_justificativa_padrao,	ie_latex,			ie_manipulado,			ie_material_direto,		ie_material_estoque,	
				ie_medic_paciente,		ie_medic_soro_oral,		ie_mensagem_sonda,		ie_mistura,			ie_monofasico,	
				ie_mostrar_orientacao,		ie_multidose,			ie_nova_molecula,		ie_objetivo,			ie_obriga_just_dose,
				ie_obriga_justificativa,	ie_obriga_tempo_aplic,		ie_obrig_via_aplicacao,		ie_pactuado,			ie_padrao_cpoe,	
				ie_padronizado,			ie_perecivel,			ie_permite_fracionado,		ie_permite_lactante,		ie_preco_compra,
				ie_prescricao,			ie_protocolo_tev,		ie_receita,			ie_restrito,			ie_sexo,	
				ie_situacao,			ie_solucao,			ie_status_envio,		ie_tamanho_embalagem,		ie_termolabil,	
				ie_tipo_fonte_prescr,		ie_tipo_material,		ie_tipo_solucao,		ie_tipo_solucao_cpoe,		ie_umidade_controlada,
				ie_unid_med_padrao,		ie_utilizacao_sus,		ie_vancomicina,			ie_via_aplicacao,		ie_volumoso,	
				nm_usuario_p,			nm_usuario_p,			nr_certificado_aprovacao,	nr_codigo_barras,		nr_dias_justif,	
				nr_minimo_cotacao,		nr_registro_anvisa,		nr_registro_ms,			nr_seq_classif_risco,		nr_seq_divisao,	
				nr_seq_dose_terap,		nr_seq_fabric,			nr_seq_familia,			nr_seq_ficha_tecnica,		nr_seq_forma_farm,
				nr_seq_grupo_rec,		nr_seq_localizacao,		nr_seq_modelo_dialisador,	qt_altura_cm,			qt_compra_melhor,
				qt_comprimento_cm,		qt_concentracao_total,		qt_consumo_mensal,		qt_conv_compra_est,		qt_conv_compra_estoque,
				qt_conversao_mg,		qt_conv_estoque_consumo,	qt_dia_estoque_minimo,		qt_dia_interv_profilaxia,	qt_dia_interv_ressup,	
				qt_dia_profilatico,		qt_dia_ressup_forn,		qt_dias_validade,		qt_dia_terapeutico,		qt_dose_prescricao,	
				qt_dose_terapeutica,		qt_estoque_maximo,		qt_estoque_minimo,		qt_horas_util_pac,		qt_largura_cm,	
				qt_limite_pessoa,		qt_max_dia_aplic,		qt_maxima_planej,		qt_max_prescricao,		qt_meia_vida,	
				qt_min_aplicacao,		qt_minima_planej,		qt_minimo_multiplo_solic,	qt_overfill,			qt_peso_kg,	
				qt_ponto_pedido,		qt_prioridade_apres,		qt_prioridade_coml
			from	material
			where	cd_material = cd_material_p);
			
	insert into material_tipo_local_est(	cd_material,		dt_atualizacao,		dt_atualizacao_nrec,		ie_distribuidora,		ie_farmacia,
						ie_operadora,		ie_prestador,		nm_usuario,			nm_usuario_nrec,		nr_sequencia)
					(SELECT	cd_material_w,		clock_timestamp(),		clock_timestamp(),			ie_distribuidora,		ie_farmacia,
						ie_operadora,		ie_prestador,		nm_usuario_p,			nm_usuario_p,			nextval('material_tipo_local_est_seq')
					from	material_tipo_local_est
					where	cd_material = cd_material_p);
end if;

for r_c01_w in c01( nr_seq_material_p, cd_material_p, cd_material_w, nr_seq_tuss_mat_item_p ) loop
	insert into pls_material(	cd_estabelecimento,		cd_farmacia_com,		cd_grupo_proc,			cd_material,			cd_material_a900,
					cd_material_ops,		cd_material_ops_number,		cd_material_ops_orig,		cd_material_tuss_a900,		cd_simpro,
					cd_tiss_brasindice,		cd_unidade_medida,		ds_grupo_proc,			ds_material,			ds_material_sem_acento,
					ds_medicamento,			ds_motivo_exclusao,		ds_nome_comercial,		ds_observacao,			ds_versao_tiss,
					dt_atualizacao,			dt_atualizacao_nrec,		dt_exclusao,			dt_fim_vigencia_ref,		dt_inclusao,
					dt_inclusao_ref,		dt_limite_utilizacao,		dt_referencia,			dt_validade,			ie_nao_gera_brasindice,
					ie_nao_gera_simpro,		ie_origem,			ie_pis_cofins,			ie_revisar,			ie_sistema_ant,
					ie_situacao,			ie_tipo_despesa,		ie_tipo_tabela,			nm_usuario,			nm_usuario_nrec,
					nr_registro_anvisa,		nr_seq_estrut_mat,		nr_seq_grupo_ajuste,		nr_seq_marca,			nr_seq_material_unimed,
					nr_seq_mat_uni_fed_sc,		nr_seq_tipo_uso,		nr_seq_tuss_mat_item,		nr_sequencia,			qt_conversao,
					qt_conversao_a900,		qt_conversao_farm,		qt_conversao_prest,		qt_conversao_simpro)
				values (	r_c01_w.cd_estabelecimento,	r_c01_w.cd_farmacia_com,	r_c01_w.cd_grupo_proc,		r_c01_w.cd_material,		r_c01_w.cd_material_a900,
					r_c01_w.cd_material_ops,	r_c01_w.cd_material_ops_number,	r_c01_w.cd_material_ops_orig,	r_c01_w.cd_material_tuss_a900,	r_c01_w.cd_simpro,
					r_c01_w.cd_tiss_brasindice,	r_c01_w.cd_unidade_medida,	r_c01_w.ds_grupo_proc,		r_c01_w.ds_material,		r_c01_w.ds_material_sem_acento,
					r_c01_w.ds_medicamento,		r_c01_w.ds_motivo_exclusao,	r_c01_w.ds_nome_comercial,	r_c01_w.ds_observacao,		r_c01_w.ds_versao_tiss,
					clock_timestamp(),			clock_timestamp(),			r_c01_w.dt_exclusao,		r_c01_w.dt_fim_vigencia_ref,	r_c01_w.dt_inclusao,
					r_c01_w.dt_inclusao_ref,	r_c01_w.dt_limite_utilizacao,	r_c01_w.dt_referencia,		r_c01_w.dt_validade,		r_c01_w.ie_nao_gera_brasindice,
					r_c01_w.ie_nao_gera_simpro,	r_c01_w.ie_origem,		r_c01_w.ie_pis_cofins,		r_c01_w.ie_revisar,		r_c01_w.ie_sistema_ant,
					r_c01_w.ie_situacao,		r_c01_w.ie_tipo_despesa,	r_c01_w.ie_tipo_tabela,		nm_usuario_p,			nm_usuario_p,
					r_c01_w.nr_registro_anvisa,	r_c01_w.nr_seq_estrut_mat,	r_c01_w.nr_seq_grupo_ajuste,	r_c01_w.nr_seq_marca,		r_c01_w.nr_seq_material_unimed,
					r_c01_w.nr_seq_mat_uni_fed_sc,	r_c01_w.nr_seq_tipo_uso,	r_c01_w.nr_seq_tuss_mat_item,	nextval('pls_material_seq'),	r_c01_w.qt_conversao,
					r_c01_w.qt_conversao_a900,	r_c01_w.qt_conversao_farm,	r_c01_w.qt_conversao_prest,	r_c01_w.qt_conversao_simpro) returning nr_sequencia into nr_seq_pls_material_w;
					
	-- Caso o NR_SEQ_TUSS_MAT_ITEM_P for nulo o CD_MATERIAL_OPS e gerado atraves da rotina PLS_GERAR_COD_MATERIAL - jtrindade OS 1797931
	if (coalesce(nr_seq_tuss_mat_item_p::text, '') = '') then
		CALL pls_gerar_cod_material(nr_seq_pls_material_w, nm_usuario_p);
	end if;
	
	select 	cd_material_ops
	into STRICT	cd_material_ops_p
	from	pls_material
	where	nr_sequencia = nr_seq_pls_material_w;
	
	nr_seq_pls_material_p	:= nr_seq_pls_material_w;
	
	for r_c02_w in c02( r_c01_w.nr_sequencia, nr_seq_pls_material_w ) loop
		insert into pls_material_restricao(	dt_atualizacao,			dt_atualizacao_nrec,			dt_fim_vigencia,			dt_fim_vigencia_ref,		dt_inicio_vigencia,
							dt_inicio_vigencia_ref,		ie_autorizacao,				ie_bloqueia_autor,			ie_bloqueia_custo_op,		ie_bloqueia_intercambio,
							ie_bloqueia_pre_pag,		ie_bloqueia_prod_nao_reg,		ie_bloqueia_prod_reg,			ie_nota_fiscal,			ie_sexo_exclusivo,
							ie_taxa_comercial,		nm_usuario,				nm_usuario_nrec,			nr_seq_material,		nr_sequencia,
							qt_idade_maxima,		qt_idade_minima,			qt_maxima,				qt_minima)
					values ( 	clock_timestamp(),			clock_timestamp(),				r_c02_w.dt_fim_vigencia,		r_c02_w.dt_fim_vigencia_ref,	r_c02_w.dt_inicio_vigencia,
							r_c02_w.dt_inicio_vigencia_ref,	r_c02_w.ie_autorizacao,			r_c02_w.ie_bloqueia_autor,		r_c02_w.ie_bloqueia_custo_op,	r_c02_w.ie_bloqueia_intercambio,
							r_c02_w.ie_bloqueia_pre_pag,	r_c02_w.ie_bloqueia_prod_nao_reg,	r_c02_w.ie_bloqueia_prod_reg,		r_c02_w.ie_nota_fiscal,		r_c02_w.ie_sexo_exclusivo,
							r_c02_w.ie_taxa_comercial,	nm_usuario_p,				nm_usuario_p,				r_c02_w.nr_seq_material,	nextval('pls_material_restricao_seq'),
							r_c02_w.qt_idade_maxima,	r_c02_w.qt_idade_minima,		r_c02_w.qt_maxima,			r_c02_w.qt_minima);
	end loop;
	
	for r_c03_w in c03( r_c01_w.nr_sequencia, nr_seq_pls_material_w ) loop
		insert into pls_regra_autorizacao(	cd_area_procedimento,		cd_especialidade,			cd_especialidade_medica,		cd_estabelecimento,		cd_grupo_proc,
							cd_material,			cd_procedimento,			dt_atualizacao,				dt_atualizacao_nrec,		dt_fim_vigencia,
							dt_fim_vigencia_ref,		dt_inicio_vigencia,			dt_inicio_vigencia_ref,			ie_aceitar_sem_guia,		ie_carater_internacao,
							ie_guia_valida,			ie_liberado,				ie_origem_proced,			ie_preco,			ie_restricao_intercambio,
							ie_situacao,			ie_tipo_atendimento,			ie_tipo_congenere,			ie_tipo_guia,			ie_tipo_intercambio,
							ie_tipo_segurado,		nm_usuario,				nm_usuario_nrec,			nr_seq_anterior,		nr_seq_estrut_mat,
							nr_seq_grupo_contrato,		nr_seq_grupo_produto,			nr_seq_grupo_servico,			nr_seq_material,		nr_seq_motivo_glosa,
							nr_seq_prestador,		nr_seq_tipo_atendimento,		nr_sequencia,				ie_regime_atendimento,		ie_saude_ocupacional)
					values (		r_c03_w.cd_area_procedimento,	r_c03_w.cd_especialidade,		r_c03_w.cd_especialidade_medica,	r_c03_w.cd_estabelecimento,	r_c03_w.cd_grupo_proc,
							r_c03_w.cd_material,		r_c03_w.cd_procedimento,		clock_timestamp(),				clock_timestamp(),			r_c03_w.dt_fim_vigencia,
							r_c03_w.dt_fim_vigencia_ref,	r_c03_w.dt_inicio_vigencia,		r_c03_w.dt_inicio_vigencia_ref,		r_c03_w.ie_aceitar_sem_guia,	r_c03_w.ie_carater_internacao,
							r_c03_w.ie_guia_valida,		r_c03_w.ie_liberado,			r_c03_w.ie_origem_proced,		r_c03_w.ie_preco,		r_c03_w.ie_restricao_intercambio,
							r_c03_w.ie_situacao,		r_c03_w.ie_tipo_atendimento,		r_c03_w.ie_tipo_congenere,		r_c03_w.ie_tipo_guia,		r_c03_w.ie_tipo_intercambio,
							r_c03_w.ie_tipo_segurado,	nm_usuario_p,				nm_usuario_p,				r_c03_w.nr_seq_anterior,	r_c03_w.nr_seq_estrut_mat,
							r_c03_w.nr_seq_grupo_contrato,	r_c03_w.nr_seq_grupo_produto,		r_c03_w.nr_seq_grupo_servico,		r_c03_w.nr_seq_material,	r_c03_w.nr_seq_motivo_glosa,
							r_c03_w.nr_seq_prestador,	r_c03_w.nr_seq_tipo_atendimento,	nextval('pls_regra_autorizacao_seq'),	r_c03_w.ie_regime_atendimento,	r_c03_w.ie_saude_ocupacional);
	end loop;
	
	for r_c04_w in c04( r_c01_w.nr_sequencia, nr_seq_pls_material_w ) loop
		insert into pls_material_preco_item(	cd_cgc_fornecedor,		cd_material,				cd_moeda,				dt_atualizacao,			dt_atualizacao_nrec,
							dt_inicio_vigencia,		ie_situacao,				nm_usuario,				nm_usuario_nrec,		nr_item_nf,
							nr_seq_material,		nr_seq_material_preco,			nr_sequencia,				nr_sequencia_nf,		vl_material)
					values (		r_c04_w.cd_cgc_fornecedor,	r_c04_w.cd_material,			r_c04_w.cd_moeda,			clock_timestamp(),			clock_timestamp(),
							r_c04_w.dt_inicio_vigencia,	r_c04_w.ie_situacao,			nm_usuario_p,				nm_usuario_p,			r_c04_w.nr_item_nf,
							r_c04_w.nr_seq_material,	r_c04_w.nr_seq_material_preco,		nextval('pls_material_preco_item_seq'),	r_c04_w.nr_sequencia_nf,	r_c04_w.vl_material) returning nr_sequencia into nr_seq_prec_item_w;
							
		for r_c05_w in c05( r_c04_w.nr_sequencia, nr_seq_prec_item_w ) loop
			insert into pls_material_valor_item(	cd_moeda,		ds_observacao,			dt_atualizacao,			dt_atualizacao_nrec,		dt_inicio_vigencia,
								ie_tipo_preco,		nm_usuario,			nm_usuario_nrec,		nr_seq_preco_item,		nr_sequencia,
								qt_convercao,		vl_material)
						values (		r_c05_w.cd_moeda,	r_c05_w.ds_observacao,		clock_timestamp(),			clock_timestamp(),			r_c05_w.dt_inicio_vigencia,
								r_c05_w.ie_tipo_preco,	nm_usuario_p,			nm_usuario_p,			r_c05_w.nr_seq_preco_item,	nextval('pls_material_valor_item_seq'),
								r_c05_w.qt_convercao,	r_c05_w.vl_material);
		end loop;
	end loop;
	
	for r_c06_w in c06( r_c01_w.nr_sequencia, nr_seq_pls_material_w ) loop
		insert into pls_material_a900(		cd_material_a900,		dt_atualizacao,				dt_atualizacao_nrec,			dt_fim_vigencia,		dt_inicio_vigencia,
							nm_usuario,			nm_usuario_nrec,			nr_seq_material,			nr_seq_material_unimed,		nr_sequencia,
							qt_conversao_a900)
					values (		r_c06_w.cd_material_a900,	clock_timestamp(),				clock_timestamp(),				r_c06_w.dt_fim_vigencia,	r_c06_w.dt_inicio_vigencia,
							nm_usuario_p,			nm_usuario_p,				r_c06_w.nr_seq_material,		r_c06_w.nr_seq_material_unimed,	nextval('pls_material_a900_seq'),
							r_c06_w.qt_conversao_a900);
	end loop;
	
	for r_c07_w in c07( r_c01_w.nr_sequencia, nr_seq_pls_material_w ) loop
		insert into pls_preco_material(	dt_atualizacao,			dt_atualizacao_nrec,			nm_usuario,				nm_usuario_nrec,		nr_seq_estrutura_mat,
							nr_seq_grupo,			nr_seq_material,			nr_sequencia)
					values (		clock_timestamp(),			clock_timestamp(),				nm_usuario_p,				nm_usuario_p,			r_c07_w.nr_seq_estrutura_mat,
							r_c07_w.nr_seq_grupo,		r_c07_w.nr_seq_material,		nextval('pls_preco_material_seq'));
	end loop;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplic_material ( nr_seq_material_p pls_material.nr_sequencia%type, cd_material_p material.cd_material%type, nm_usuario_p text, nr_seq_tuss_mat_item_p pls_material.nr_seq_tuss_mat_item%type, cd_material_ops_p INOUT pls_material.cd_material_ops%type, nr_seq_pls_material_p INOUT pls_material.nr_sequencia%type) FROM PUBLIC;

