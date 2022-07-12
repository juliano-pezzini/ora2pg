-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW material_comercial_v (cd_material, ds_material, ds_reduzida, cd_classe_material, cd_unidade_medida_compra, cd_unidade_medida_estoque, cd_unidade_medida_consumo, ie_material_estoque, ie_receita, ie_cobra_paciente, ie_baixa_inteira, ie_situacao, qt_dias_validade, dt_cadastramento, dt_atualizacao, nm_usuario, nr_minimo_cotacao, qt_estoque_maximo, qt_estoque_minimo, qt_ponto_pedido, nr_codigo_barras, ie_via_aplicacao, ie_obrig_via_aplicacao, ie_disponivel_mercado, qt_minimo_multiplo_solic, qt_conv_compra_estoque, cd_unidade_medida_solic, ie_prescricao, cd_kit_material, qt_conversao_mg, ie_tipo_material, cd_material_generico, ie_padronizado, qt_conv_estoque_consumo, cd_material_estoque, cd_material_conta, ie_preco_compra, ie_material_direto, ie_consignado, ie_utilizacao_sus, qt_limite_pessoa, cd_unid_med_limite, ds_orientacao_uso, ie_tipo_fonte_prescr, ie_dias_util_medic, ds_orientacao_usuario, cd_medicamento, ie_controle_medico, ie_baixa_estoq_pac, qt_horas_util_pac, qt_dia_interv_ressup, qt_dia_ressup_forn, qt_dia_estoque_minimo, qt_max_prescricao, qt_consumo_mensal, ie_curva_abc, ie_classif_xyz, qt_prioridade_coml, cd_fabricante, nr_seq_grupo_rec, cd_sistema_ant, nr_seq_fabric, ie_bomba_infusao, ie_diluicao, ie_solucao, cd_classif_fiscal, ie_mistura, ie_abrigo_luz, ie_umidade_controlada, nr_seq_ficha_tecnica, ds_precaucao_ordem, cd_unid_med_concetracao, cd_unid_med_base_conc, ds_material_sem_acento, qt_dia_profilatico, qt_dia_terapeutico, nr_seq_familia, nr_seq_localizacao, ie_gravar_obs_prescr, qt_min_aplicacao, dt_atualizacao_nrec, nm_usuario_nrec, qt_dose_prescricao, cd_unidade_medida_prescr, cd_unid_terapeutica, cd_intervalo_padrao, ie_obriga_justificativa, ie_classif_medic, qt_max_dia_aplic, ie_ancora_solucao, ie_custo_benef, ie_dose_limite, nr_certificado_aprovacao, ie_fotosensivel, ie_higroscopico, ie_inf_ultima_compra, nr_seq_forma_farm, ie_exige_lado, ie_obriga_just_dose, dt_validade_certificado_aprov, ie_sexo, ie_mostrar_orientacao, ie_gerar_lote, ie_justificativa_padrao, ie_termolabil, ie_monofasico, ie_justifica_dias_util, nr_seq_modelo_dialisador, ie_alto_risco, ie_fabricante_dist, ie_editar_dose, ds_hint, ie_mensagem_sonda, ie_extravazamento, ie_gera_lote_separado, ie_consiste_dupl, ie_aplicar, qt_concentracao_total, cd_unid_med_conc_total, qt_conv_compra_est, cd_unid_medida, qt_compra_melhor, ds_mensagem, cd_tipo_recomendacao, nr_registro_anvisa, dt_validade_reg_anvisa, ie_consiste_dias, ie_status_envio, dt_integracao, ie_fabric_propria, ie_iat, dt_revisao_fispq, nr_dias_justif, qt_overfill, ie_objetivo, ie_clearance, cd_dcb, nr_seq_divisao, ie_dupla_checagem, nr_seq_dose_terap, qt_dose_terapeutica, nr_registro_ms, ds_material_coml, cd_material_coml) AS select
	a.CD_MATERIAL,a.DS_MATERIAL,a.DS_REDUZIDA,a.CD_CLASSE_MATERIAL,a.CD_UNIDADE_MEDIDA_COMPRA,a.CD_UNIDADE_MEDIDA_ESTOQUE,a.CD_UNIDADE_MEDIDA_CONSUMO,a.IE_MATERIAL_ESTOQUE,a.IE_RECEITA,a.IE_COBRA_PACIENTE,a.IE_BAIXA_INTEIRA,a.IE_SITUACAO,a.QT_DIAS_VALIDADE,a.DT_CADASTRAMENTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.NR_MINIMO_COTACAO,a.QT_ESTOQUE_MAXIMO,a.QT_ESTOQUE_MINIMO,a.QT_PONTO_PEDIDO,a.NR_CODIGO_BARRAS,a.IE_VIA_APLICACAO,a.IE_OBRIG_VIA_APLICACAO,a.IE_DISPONIVEL_MERCADO,a.QT_MINIMO_MULTIPLO_SOLIC,a.QT_CONV_COMPRA_ESTOQUE,a.CD_UNIDADE_MEDIDA_SOLIC,a.IE_PRESCRICAO,a.CD_KIT_MATERIAL,a.QT_CONVERSAO_MG,a.IE_TIPO_MATERIAL,a.CD_MATERIAL_GENERICO,a.IE_PADRONIZADO,a.QT_CONV_ESTOQUE_CONSUMO,a.CD_MATERIAL_ESTOQUE,a.CD_MATERIAL_CONTA,a.IE_PRECO_COMPRA,a.IE_MATERIAL_DIRETO,a.IE_CONSIGNADO,a.IE_UTILIZACAO_SUS,a.QT_LIMITE_PESSOA,a.CD_UNID_MED_LIMITE,a.DS_ORIENTACAO_USO,a.IE_TIPO_FONTE_PRESCR,a.IE_DIAS_UTIL_MEDIC,a.DS_ORIENTACAO_USUARIO,a.CD_MEDICAMENTO,a.IE_CONTROLE_MEDICO,a.IE_BAIXA_ESTOQ_PAC,a.QT_HORAS_UTIL_PAC,a.QT_DIA_INTERV_RESSUP,a.QT_DIA_RESSUP_FORN,a.QT_DIA_ESTOQUE_MINIMO,a.QT_MAX_PRESCRICAO,a.QT_CONSUMO_MENSAL,a.IE_CURVA_ABC,a.IE_CLASSIF_XYZ,a.QT_PRIORIDADE_COML,a.CD_FABRICANTE,a.NR_SEQ_GRUPO_REC,a.CD_SISTEMA_ANT,a.NR_SEQ_FABRIC,a.IE_BOMBA_INFUSAO,a.IE_DILUICAO,a.IE_SOLUCAO,a.CD_CLASSIF_FISCAL,a.IE_MISTURA,a.IE_ABRIGO_LUZ,a.IE_UMIDADE_CONTROLADA,a.NR_SEQ_FICHA_TECNICA,a.DS_PRECAUCAO_ORDEM,a.CD_UNID_MED_CONCETRACAO,a.CD_UNID_MED_BASE_CONC,a.DS_MATERIAL_SEM_ACENTO,a.QT_DIA_PROFILATICO,a.QT_DIA_TERAPEUTICO,a.NR_SEQ_FAMILIA,a.NR_SEQ_LOCALIZACAO,a.IE_GRAVAR_OBS_PRESCR,a.QT_MIN_APLICACAO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.QT_DOSE_PRESCRICAO,a.CD_UNIDADE_MEDIDA_PRESCR,a.CD_UNID_TERAPEUTICA,a.CD_INTERVALO_PADRAO,a.IE_OBRIGA_JUSTIFICATIVA,a.IE_CLASSIF_MEDIC,a.QT_MAX_DIA_APLIC,a.IE_ANCORA_SOLUCAO,a.IE_CUSTO_BENEF,a.IE_DOSE_LIMITE,a.NR_CERTIFICADO_APROVACAO,a.IE_FOTOSENSIVEL,a.IE_HIGROSCOPICO,a.IE_INF_ULTIMA_COMPRA,a.NR_SEQ_FORMA_FARM,a.IE_EXIGE_LADO,a.IE_OBRIGA_JUST_DOSE,a.DT_VALIDADE_CERTIFICADO_APROV,a.IE_SEXO,a.IE_MOSTRAR_ORIENTACAO,a.IE_GERAR_LOTE,a.IE_JUSTIFICATIVA_PADRAO,a.IE_TERMOLABIL,a.IE_MONOFASICO,a.IE_JUSTIFICA_DIAS_UTIL,a.NR_SEQ_MODELO_DIALISADOR,a.IE_ALTO_RISCO,a.IE_FABRICANTE_DIST,a.IE_EDITAR_DOSE,a.DS_HINT,a.IE_MENSAGEM_SONDA,a.IE_EXTRAVAZAMENTO,a.IE_GERA_LOTE_SEPARADO,a.IE_CONSISTE_DUPL,a.IE_APLICAR,a.QT_CONCENTRACAO_TOTAL,a.CD_UNID_MED_CONC_TOTAL,a.QT_CONV_COMPRA_EST,a.CD_UNID_MEDIDA,a.QT_COMPRA_MELHOR,a.DS_MENSAGEM,a.CD_TIPO_RECOMENDACAO,a.NR_REGISTRO_ANVISA,a.DT_VALIDADE_REG_ANVISA,a.IE_CONSISTE_DIAS,a.IE_STATUS_ENVIO,a.DT_INTEGRACAO,a.IE_FABRIC_PROPRIA,a.IE_IAT,a.DT_REVISAO_FISPQ,a.NR_DIAS_JUSTIF,a.QT_OVERFILL,a.IE_OBJETIVO,a.IE_CLEARANCE,a.CD_DCB,a.NR_SEQ_DIVISAO,a.IE_DUPLA_CHECAGEM,a.NR_SEQ_DOSE_TERAP,a.QT_DOSE_TERAPEUTICA,a.NR_REGISTRO_MS,
	a.ds_material ds_material_coml,
	a.cd_material cd_material_coml
FROM material a
where a.ie_tipo_material <> 3

union

select
	a.CD_MATERIAL,a.DS_MATERIAL,a.DS_REDUZIDA,a.CD_CLASSE_MATERIAL,a.CD_UNIDADE_MEDIDA_COMPRA,a.CD_UNIDADE_MEDIDA_ESTOQUE,a.CD_UNIDADE_MEDIDA_CONSUMO,a.IE_MATERIAL_ESTOQUE,a.IE_RECEITA,a.IE_COBRA_PACIENTE,a.IE_BAIXA_INTEIRA,a.IE_SITUACAO,a.QT_DIAS_VALIDADE,a.DT_CADASTRAMENTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.NR_MINIMO_COTACAO,a.QT_ESTOQUE_MAXIMO,a.QT_ESTOQUE_MINIMO,a.QT_PONTO_PEDIDO,a.NR_CODIGO_BARRAS,a.IE_VIA_APLICACAO,a.IE_OBRIG_VIA_APLICACAO,a.IE_DISPONIVEL_MERCADO,a.QT_MINIMO_MULTIPLO_SOLIC,a.QT_CONV_COMPRA_ESTOQUE,a.CD_UNIDADE_MEDIDA_SOLIC,a.IE_PRESCRICAO,a.CD_KIT_MATERIAL,a.QT_CONVERSAO_MG,a.IE_TIPO_MATERIAL,a.CD_MATERIAL_GENERICO,a.IE_PADRONIZADO,a.QT_CONV_ESTOQUE_CONSUMO,a.CD_MATERIAL_ESTOQUE,a.CD_MATERIAL_CONTA,a.IE_PRECO_COMPRA,a.IE_MATERIAL_DIRETO,a.IE_CONSIGNADO,a.IE_UTILIZACAO_SUS,a.QT_LIMITE_PESSOA,a.CD_UNID_MED_LIMITE,a.DS_ORIENTACAO_USO,a.IE_TIPO_FONTE_PRESCR,a.IE_DIAS_UTIL_MEDIC,a.DS_ORIENTACAO_USUARIO,a.CD_MEDICAMENTO,a.IE_CONTROLE_MEDICO,a.IE_BAIXA_ESTOQ_PAC,a.QT_HORAS_UTIL_PAC,a.QT_DIA_INTERV_RESSUP,a.QT_DIA_RESSUP_FORN,a.QT_DIA_ESTOQUE_MINIMO,a.QT_MAX_PRESCRICAO,a.QT_CONSUMO_MENSAL,a.IE_CURVA_ABC,a.IE_CLASSIF_XYZ,a.QT_PRIORIDADE_COML,a.CD_FABRICANTE,a.NR_SEQ_GRUPO_REC,a.CD_SISTEMA_ANT,a.NR_SEQ_FABRIC,a.IE_BOMBA_INFUSAO,a.IE_DILUICAO,a.IE_SOLUCAO,a.CD_CLASSIF_FISCAL,a.IE_MISTURA,a.IE_ABRIGO_LUZ,a.IE_UMIDADE_CONTROLADA,a.NR_SEQ_FICHA_TECNICA,a.DS_PRECAUCAO_ORDEM,a.CD_UNID_MED_CONCETRACAO,a.CD_UNID_MED_BASE_CONC,a.DS_MATERIAL_SEM_ACENTO,a.QT_DIA_PROFILATICO,a.QT_DIA_TERAPEUTICO,a.NR_SEQ_FAMILIA,a.NR_SEQ_LOCALIZACAO,a.IE_GRAVAR_OBS_PRESCR,a.QT_MIN_APLICACAO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.QT_DOSE_PRESCRICAO,a.CD_UNIDADE_MEDIDA_PRESCR,a.CD_UNID_TERAPEUTICA,a.CD_INTERVALO_PADRAO,a.IE_OBRIGA_JUSTIFICATIVA,a.IE_CLASSIF_MEDIC,a.QT_MAX_DIA_APLIC,a.IE_ANCORA_SOLUCAO,a.IE_CUSTO_BENEF,a.IE_DOSE_LIMITE,a.NR_CERTIFICADO_APROVACAO,a.IE_FOTOSENSIVEL,a.IE_HIGROSCOPICO,a.IE_INF_ULTIMA_COMPRA,a.NR_SEQ_FORMA_FARM,a.IE_EXIGE_LADO,a.IE_OBRIGA_JUST_DOSE,a.DT_VALIDADE_CERTIFICADO_APROV,a.IE_SEXO,a.IE_MOSTRAR_ORIENTACAO,a.IE_GERAR_LOTE,a.IE_JUSTIFICATIVA_PADRAO,a.IE_TERMOLABIL,a.IE_MONOFASICO,a.IE_JUSTIFICA_DIAS_UTIL,a.NR_SEQ_MODELO_DIALISADOR,a.IE_ALTO_RISCO,a.IE_FABRICANTE_DIST,a.IE_EDITAR_DOSE,a.DS_HINT,a.IE_MENSAGEM_SONDA,a.IE_EXTRAVAZAMENTO,a.IE_GERA_LOTE_SEPARADO,a.IE_CONSISTE_DUPL,a.IE_APLICAR,a.QT_CONCENTRACAO_TOTAL,a.CD_UNID_MED_CONC_TOTAL,a.QT_CONV_COMPRA_EST,a.CD_UNID_MEDIDA,a.QT_COMPRA_MELHOR,a.DS_MENSAGEM,a.CD_TIPO_RECOMENDACAO,a.NR_REGISTRO_ANVISA,a.DT_VALIDADE_REG_ANVISA,a.IE_CONSISTE_DIAS,a.IE_STATUS_ENVIO,a.DT_INTEGRACAO,a.IE_FABRIC_PROPRIA,a.IE_IAT,a.DT_REVISAO_FISPQ,a.NR_DIAS_JUSTIF,a.QT_OVERFILL,a.IE_OBJETIVO,a.IE_CLEARANCE,a.CD_DCB,a.NR_SEQ_DIVISAO,a.IE_DUPLA_CHECAGEM,a.NR_SEQ_DOSE_TERAP,a.QT_DOSE_TERAPEUTICA,a.NR_REGISTRO_MS,
	b.ds_material ds_material_coml,
	b.cd_material cd_material_coml
from Material b, Material a
where a.ie_tipo_material = 3
  and b.cd_material =
	(select min(cd_material)
	from material c
	where c.cd_material_generico = a.cd_material)

union

select
	a.CD_MATERIAL,a.DS_MATERIAL,a.DS_REDUZIDA,a.CD_CLASSE_MATERIAL,a.CD_UNIDADE_MEDIDA_COMPRA,a.CD_UNIDADE_MEDIDA_ESTOQUE,a.CD_UNIDADE_MEDIDA_CONSUMO,a.IE_MATERIAL_ESTOQUE,a.IE_RECEITA,a.IE_COBRA_PACIENTE,a.IE_BAIXA_INTEIRA,a.IE_SITUACAO,a.QT_DIAS_VALIDADE,a.DT_CADASTRAMENTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.NR_MINIMO_COTACAO,a.QT_ESTOQUE_MAXIMO,a.QT_ESTOQUE_MINIMO,a.QT_PONTO_PEDIDO,a.NR_CODIGO_BARRAS,a.IE_VIA_APLICACAO,a.IE_OBRIG_VIA_APLICACAO,a.IE_DISPONIVEL_MERCADO,a.QT_MINIMO_MULTIPLO_SOLIC,a.QT_CONV_COMPRA_ESTOQUE,a.CD_UNIDADE_MEDIDA_SOLIC,a.IE_PRESCRICAO,a.CD_KIT_MATERIAL,a.QT_CONVERSAO_MG,a.IE_TIPO_MATERIAL,a.CD_MATERIAL_GENERICO,a.IE_PADRONIZADO,a.QT_CONV_ESTOQUE_CONSUMO,a.CD_MATERIAL_ESTOQUE,a.CD_MATERIAL_CONTA,a.IE_PRECO_COMPRA,a.IE_MATERIAL_DIRETO,a.IE_CONSIGNADO,a.IE_UTILIZACAO_SUS,a.QT_LIMITE_PESSOA,a.CD_UNID_MED_LIMITE,a.DS_ORIENTACAO_USO,a.IE_TIPO_FONTE_PRESCR,a.IE_DIAS_UTIL_MEDIC,a.DS_ORIENTACAO_USUARIO,a.CD_MEDICAMENTO,a.IE_CONTROLE_MEDICO,a.IE_BAIXA_ESTOQ_PAC,a.QT_HORAS_UTIL_PAC,a.QT_DIA_INTERV_RESSUP,a.QT_DIA_RESSUP_FORN,a.QT_DIA_ESTOQUE_MINIMO,a.QT_MAX_PRESCRICAO,a.QT_CONSUMO_MENSAL,a.IE_CURVA_ABC,a.IE_CLASSIF_XYZ,a.QT_PRIORIDADE_COML,a.CD_FABRICANTE,a.NR_SEQ_GRUPO_REC,a.CD_SISTEMA_ANT,a.NR_SEQ_FABRIC,a.IE_BOMBA_INFUSAO,a.IE_DILUICAO,a.IE_SOLUCAO,a.CD_CLASSIF_FISCAL,a.IE_MISTURA,a.IE_ABRIGO_LUZ,a.IE_UMIDADE_CONTROLADA,a.NR_SEQ_FICHA_TECNICA,a.DS_PRECAUCAO_ORDEM,a.CD_UNID_MED_CONCETRACAO,a.CD_UNID_MED_BASE_CONC,a.DS_MATERIAL_SEM_ACENTO,a.QT_DIA_PROFILATICO,a.QT_DIA_TERAPEUTICO,a.NR_SEQ_FAMILIA,a.NR_SEQ_LOCALIZACAO,a.IE_GRAVAR_OBS_PRESCR,a.QT_MIN_APLICACAO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.QT_DOSE_PRESCRICAO,a.CD_UNIDADE_MEDIDA_PRESCR,a.CD_UNID_TERAPEUTICA,a.CD_INTERVALO_PADRAO,a.IE_OBRIGA_JUSTIFICATIVA,a.IE_CLASSIF_MEDIC,a.QT_MAX_DIA_APLIC,a.IE_ANCORA_SOLUCAO,a.IE_CUSTO_BENEF,a.IE_DOSE_LIMITE,a.NR_CERTIFICADO_APROVACAO,a.IE_FOTOSENSIVEL,a.IE_HIGROSCOPICO,a.IE_INF_ULTIMA_COMPRA,a.NR_SEQ_FORMA_FARM,a.IE_EXIGE_LADO,a.IE_OBRIGA_JUST_DOSE,a.DT_VALIDADE_CERTIFICADO_APROV,a.IE_SEXO,a.IE_MOSTRAR_ORIENTACAO,a.IE_GERAR_LOTE,a.IE_JUSTIFICATIVA_PADRAO,a.IE_TERMOLABIL,a.IE_MONOFASICO,a.IE_JUSTIFICA_DIAS_UTIL,a.NR_SEQ_MODELO_DIALISADOR,a.IE_ALTO_RISCO,a.IE_FABRICANTE_DIST,a.IE_EDITAR_DOSE,a.DS_HINT,a.IE_MENSAGEM_SONDA,a.IE_EXTRAVAZAMENTO,a.IE_GERA_LOTE_SEPARADO,a.IE_CONSISTE_DUPL,a.IE_APLICAR,a.QT_CONCENTRACAO_TOTAL,a.CD_UNID_MED_CONC_TOTAL,a.QT_CONV_COMPRA_EST,a.CD_UNID_MEDIDA,a.QT_COMPRA_MELHOR,a.DS_MENSAGEM,a.CD_TIPO_RECOMENDACAO,a.NR_REGISTRO_ANVISA,a.DT_VALIDADE_REG_ANVISA,a.IE_CONSISTE_DIAS,a.IE_STATUS_ENVIO,a.DT_INTEGRACAO,a.IE_FABRIC_PROPRIA,a.IE_IAT,a.DT_REVISAO_FISPQ,a.NR_DIAS_JUSTIF,a.QT_OVERFILL,a.IE_OBJETIVO,a.IE_CLEARANCE,a.CD_DCB,a.NR_SEQ_DIVISAO,a.IE_DUPLA_CHECAGEM,a.NR_SEQ_DOSE_TERAP,a.QT_DOSE_TERAPEUTICA,a.NR_REGISTRO_MS,
	a.ds_material ds_material_coml,
	a.cd_material cd_material_coml
from Material a
where a.ie_tipo_material = 3
  and not exists (select 1
	from material c
	where c.cd_material_generico = a.cd_material);
