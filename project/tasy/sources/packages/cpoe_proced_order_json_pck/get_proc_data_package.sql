-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION cpoe_proced_order_json_pck.get_proc_data (nr_cpoe_proc_p bigint) RETURNS PHILIPS_JSON_LIST AS $body$
DECLARE


	json_item_w		philips_json;
	json_item_list_w	philips_json_list;

	C01 CURSOR FOR
    SELECT p.nr_atendimento,
      p.nr_sequencia,
      Obter_Desc_Proc_Interno(p.NR_SEQ_PROC_INTERNO) desc_proc_interno,
      null    proc_code_value,
      null    proc_code_system,
      p.NR_SEQ_PROC_INTERNO, 
      p.NR_SEQ_TOPOGRAFIA,
      p.IE_LADO, 
      obter_conv_envio('CPOE_MATERIAL', 'IE_LADO', p.IE_LADO, 'S')  site_code_system,
      obter_conv_envio('CPOE_MATERIAL', 'IE_LADO', p.IE_LADO, 'E')  site_code_value,
      Obter_Descricao_Dominio(1372,p.IE_LADO) desc_site_text,
      p.QT_PROCEDIMENTO, 
      p.CD_MATERIAL_EXAME, 
      p.DS_MATERIAL_ESPECIAL,
      p.NR_SEQ_PROT_GLIC,
      p.CD_INTERVALO,
      obter_conv_envio('INTERVALO_PRESCRICAO', 'CD_INTERVALO', p.CD_INTERVALO, 'E')  interval_code_vale, 
      p.IE_ADMINISTRACAO ,
      p.DT_INICIO,
      p.DT_FIM,
      p.IE_URGENCIA,
      p.DS_HORARIOS,
      p.QT_TEMPO_EXECUCAO, 
      CASE WHEN coalesce(p.DS_DADO_CLINICO::text, '') = '' THEN ''  ELSE '. ' ||elimina_acentuacao(p.DS_DADO_CLINICO) END  DS_DADO_CLINICO,
      CASE WHEN coalesce(p.DS_OBSERVACAO::text, '') = '' THEN ''  ELSE '. ' ||elimina_acentuacao(p.DS_OBSERVACAO) END  DS_OBSERVACAO,
      CASE WHEN coalesce(p.DS_JUSTIFICATIVA::text, '') = '' THEN ''  ELSE '. ' ||elimina_acentuacao(p.DS_JUSTIFICATIVA) END  DS_JUSTIFICATIVA,
      CASE WHEN coalesce(p.DS_MOTIVO_SUSP::text, '') = '' THEN ''  ELSE '. ' ||elimina_acentuacao(p. DS_MOTIVO_SUSP) END  DS_MOTIVO_SUSP,
      p.NR_SEQ_MOTIVO_SUSP, 
      obter_motivo_suspensao_prescr(p.NR_SEQ_MOTIVO_SUSP) ds_motivo_suspensao_prescr,
      p.NR_SEQ_TIPO_REMOCAO,
      substr(TR_OBTER_DESC_REMOCAO(p.NR_SEQ_TIPO_REMOCAO),1,200) desc_desc_remocao, 
      obter_conv_envio('TRANS_TIPO_REMOCAO', 'NR_SEQUENCIA', p.NR_SEQ_TIPO_REMOCAO, 'E')    cd_tipo_remocao_value,
      obter_conv_envio('TRANS_TIPO_REMOCAO', 'NR_SEQUENCIA', p.NR_SEQ_TIPO_REMOCAO, 'S')    cd_tipo_remocao_system, 
      obter_desc_queixa(x.nr_seq_queixa) ds_queixa,
      obter_conv_envio('QUEIXA_PACIENTE', 'NR_SEQUENCIA', x.nr_seq_queixa, 'E')    cd_seq_queixa_value,
      obter_conv_envio('QUEIXA_PACIENTE', 'NR_SEQUENCIA', x.nr_seq_queixa, 'S')    cd_seq_queixa_system, 
      obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', 'Min', 'S')  minute_code_system,
      obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', 'Min', 'E')  minute_code_value,
      obter_minutos_hora(p.QT_TEMPO_EXECUCAO)  MIN_QT_TEMPO_EXECUCAO,
      obter_se_proc_IVC(p.NR_SEQ_PROC_INTERNO) ie_ivc,
      coalesce(x.cd_estabelecimento, obter_estabelecimento_ativo) cd_estabelecmento,
      DT_LIBERACAO      requested_date_time, 
      DT_LIB_SUSPENSAO  suspended_time, 
      adep_obter_desc_info_material(nr_sequencia,'P')  desc_info_item,
      cpoe_obter_dt_suspensao(nr_sequencia,'P') dt_suspensao,
      cd_medico ordering_provider_id_number,
      obter_dados_pf(cd_medico,'PNG') ordering_provider_given_name,
      obter_dados_pf(cd_medico,'PNL') ordering_provider_last_name,
      obter_dados_pf(cd_medico,'PNM') ordering_provider_middle_name, 
      substr(obter_nome_pf(cd_medico),1,80) nm_medico_solicitante,
      Obter_Pessoa_Fisica_Usuario(p.nm_usuario_nrec,'C') ordering_user_id_number,
      Obter_Pessoa_Fisica_Usuario(nm_usuario_susp,'C') order_prov_susp_id_number,
      -- Solucao 1 
        p.QT_DOSE_MAT1,
        substr(OBTER_DESC_material(p.CD_MAT_PROC1),1,200) desc_material_proc1, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC1, 'E')    cd_mat_proc1_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC1, 'S')    cd_mat_proc1_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_MAT1)  unidade_medida_mat1_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT1, 'S')  unid_med_mat1_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT1, 'E')  unid_med_mat1_code_value, 
        QT_DOSE_DIL1,
                  p.IE_VIA_MAT_PROC1,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', IE_VIA_MAT_PROC1, 'S')  via_code1_system,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', IE_VIA_MAT_PROC1, 'E')  via_code1_vale, 
                  Obter_Desc_via(IE_VIA_MAT_PROC1)   desc_via1,
        substr(OBTER_DESC_material(p.CD_MAT_DIL1),1,200) desc_mat_dil1, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL1, 'E')    cd_mat_dil1_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL1, 'S')    cd_mat_dil1_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_DIL1)  unidade_medida_dil1_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL1, 'S')  unid_med_dil1_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL1, 'E')  unid_med_dil1_code_value,
      -- Solucao 2 
        p.QT_DOSE_MAT2,
        substr(OBTER_DESC_material(p.CD_MAT_PROC2),1,200) desc_material_proc2, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC2, 'E')    cd_mat_proc2_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC2, 'S')    cd_mat_proc2_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_MAT2)  unidade_medida_mat2_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT2, 'S')  unid_medida_mat2_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT2, 'E')  unidade_medida_mat2_code_value, 
                  QT_DOSE_DIL2,
                  p.IE_VIA_MAT_PROC2,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC2, 'S')  via_code2_system,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC2, 'E')  via_code2_vale, 
                  Obter_Desc_via(p.IE_VIA_MAT_PROC2)   desc_via2,
        substr(OBTER_DESC_material(p.CD_MAT_DIL2),2,200) desc_mat_dil2, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL2, 'E')    cd_mat_dil2_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL2, 'S')    cd_mat_dil2_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_DIL2)  unidade_medida_dil2_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL2, 'S')  unid_med_dil2_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL2, 'E')  unid_med_dil2_code_value, 
      -- Solucao 3
        p.QT_DOSE_MAT3,
        substr(OBTER_DESC_material(CD_MAT_PROC3),1,200) desc_material_proc3, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC3, 'E')    cd_mat_proc3_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC3, 'S')    cd_mat_proc3_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_MAT3)  unidade_medida_mat3_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT3, 'S')  unid_med_mat3_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT3, 'E')  unid_med_mat3_code_value, 
        p.QT_DOSE_DIL3,
                  p.IE_VIA_MAT_PROC3,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC3, 'S')  via_code3_system,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC3, 'E')  via_code3_vale, 
                  Obter_Desc_via(p.IE_VIA_MAT_PROC3)   desc_via3,
        substr(OBTER_DESC_material(p.CD_MAT_DIL3),1,200) desc_mat_dil3, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL3, 'E')    cd_mat_dil3_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL3, 'S')    cd_mat_dil3_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_DIL3)  unidade_medida_dil3_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL3, 'S')  un_med_dil3_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL3, 'E')  un_med_dil3_code_value, 
      -- Solucao 4
        QT_DOSE_MAT4,
        substr(OBTER_DESC_material(p.CD_MAT_PROC4),1,200) desc_material_proc4, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC4, 'E')    cd_mat_proc4_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC4, 'S')    cd_mat_proc4_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_MAT4)  unidade_medida_mat4_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT4, 'S')  unid_med_mat4_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT4, 'E')  unid_med_mat4_code_value, 
        QT_DOSE_DIL4,
                  p.IE_VIA_MAT_PROC4,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC4, 'S')  via_code4_system,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC4, 'E')  via_code4_vale, 
                  Obter_Desc_via(p.IE_VIA_MAT_PROC4)   desc_via4,
        substr(OBTER_DESC_material(CD_MAT_DIL4),1,200) desc_mat_dil4, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL4, 'E')    cd_mat_dil4_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL4, 'S')    cd_mat_dil4_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_DIL4)  unidade_medida_dil4_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL4, 'S')  unid_med_dil4_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL4, 'E')  unid_med_dil4_code_value ,
      -- Solucao 5
        QT_DOSE_MAT5,
        substr(OBTER_DESC_material(p.CD_MAT_PROC5),1,200) desc_material_proc5, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC5, 'E')    cd_mat_proc5_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC5, 'S')    cd_mat_proc5_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_MAT5)  unid_med_mat5_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT5, 'S')  unid_med_mat5_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT5, 'E')  unid_med_mat5_code_value, 
        QT_DOSE_DIL5,
                  p.IE_VIA_MAT_PROC5,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC5, 'S')  via_code5_system,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC5, 'E')  via_code5_vale, 
                  Obter_Desc_via(p.IE_VIA_MAT_PROC5)   desc_via5,
        substr(OBTER_DESC_material(CD_MAT_DIL5),1,200) desc_mat_dil5, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL5, 'E')    cd_mat_dil5_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL5, 'S')    cd_mat_dil5_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_DIL5)  unidade_medida_dil5_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL5, 'S')  unid_med_dil5_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL5, 'E')  unid_med_dil5_code_value, 
      -- Solucao 6
        QT_DOSE_MAT6,
        substr(OBTER_DESC_material(p.CD_MAT_PROC6),1,200) desc_material_proc6, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC6, 'E')    cd_mat_proc6_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC6, 'S')    cd_mat_proc6_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_MAT6)  unidade_medida_mat6_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT6, 'S')  unid_med_mat6_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT6, 'E')  unid_med_mat6_code_value, 
        QT_DOSE_DIL6,
                  p.IE_VIA_MAT_PROC6,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC6, 'S')  via_code6_system,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC6, 'E')  via_code6_vale, 
                  Obter_Desc_via(p.IE_VIA_MAT_PROC6)   desc_via6,
        substr(OBTER_DESC_material(p.CD_MAT_DIL6),1,200) desc_mat_dil6, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL6, 'E')    cd_mat_dil6_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL6, 'S')    cd_mat_dil6_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_DIL6)  unidade_medida_dil6_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL6, 'S')  unid_med_dil6_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL6, 'E')  unid_med_dil6_code_value, 
      -- Solucao 7
        QT_DOSE_MAT7,
        substr(OBTER_DESC_material(p.CD_MAT_PROC7),1,200) desc_material_proc7, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC7, 'E')    cd_mat_proc7_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_PROC7, 'S')    cd_mat_proc7_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_MAT7)  unidade_medida_mat7_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT7, 'S')  unid_med_mat7_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_MAT7, 'E')  unid_med_mat7_code_value, 
        QT_DOSE_DIL7,
                  p.IE_VIA_MAT_PROC7,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC7, 'S')  via_code7_system,
                  obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', p.IE_VIA_MAT_PROC7, 'E')  via_code7_vale, 
                  Obter_Desc_via(p.IE_VIA_MAT_PROC7)   desc_via7,
        substr(OBTER_DESC_material(p.CD_MAT_DIL7),7,700) desc_mat_dil7, 
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL7, 'E')    cd_mat_dil7_value,
        obter_conv_envio('MATERIAL', 'CD_MATERIAL', p.CD_MAT_DIL7, 'S')    cd_mat_dil7_system, 
        obter_desc_unidade_medida(p.CD_UNID_MEDIDA_DOSE_DIL7)  unidade_medida_dil7_text,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL7, 'S')  unid_med_dil7_code_system,
        obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', p.CD_UNID_MEDIDA_DOSE_DIL7, 'E')  unid_med_dil7_code_value
      from cpoe_procedimento p , atendimento_paciente  x
      where p.nr_atendimento = x.nr_atendimento 
      and NR_SEQUENCIA = nr_cpoe_proc_p;

		
	
BEGIN
	json_item_list_w	:= philips_json_list();
	
	for r_c01 in c01 loop
		begin
		json_item_w		:= philips_json();

    select CD_INTEGRACAO, DS_INTERFACE_IDENTIFIER
    into STRICT r_c01.PROC_CODE_VALUE, r_c01.PROC_CODE_SYSTEM
    from PROC_INTERNO_INTEGRACAO
    where NR_SEQ_PROC_INTERNO = r_c01.NR_SEQ_PROC_INTERNO  order by nr_sequencia desc LIMIT 1;

    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'nrAtendimento', r_c01.NR_ATENDIMENTO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'nrSequencia', r_c01.NR_SEQUENCIA);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descProcInterno', r_c01.DESC_PROC_INTERNO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'procCodeValue', r_c01.PROC_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'procCodeSystem', r_c01.PROC_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'nrSeqProcInterno', r_c01.NR_SEQ_PROC_INTERNO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'nrSeqTopografia', r_c01.NR_SEQ_TOPOGRAFIA);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieLado', r_c01.IE_LADO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'siteCodeSystem', r_c01.SITE_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'siteCodeValue', r_c01.SITE_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descSiteText', r_c01.DESC_SITE_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtProcedimento', r_c01.QT_PROCEDIMENTO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMaterialExame', r_c01.CD_MATERIAL_EXAME);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dsMaterialEspecial', r_c01.DS_MATERIAL_ESPECIAL);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'nrSeqProtGlic', r_c01.NR_SEQ_PROT_GLIC);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdIntervalo', r_c01.CD_INTERVALO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'intervalCodeVale', r_c01.INTERVAL_CODE_VALE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieAdministracao', r_c01.IE_ADMINISTRACAO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dtInicio', r_c01.DT_INICIO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dtFim', r_c01.DT_FIM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieUrgencia', r_c01.IE_URGENCIA);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dsHorarios', r_c01.DS_HORARIOS);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtTempoExecucao', r_c01.QT_TEMPO_EXECUCAO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dsDadoClinico', r_c01.DS_DADO_CLINICO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dsObservacao', r_c01.DS_OBSERVACAO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dsJustificativa', r_c01.DS_JUSTIFICATIVA);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dsMotivoSusp', r_c01.DS_MOTIVO_SUSP);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'nrSeqMotivoSusp', r_c01.NR_SEQ_MOTIVO_SUSP);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dsMotivoSuspensaoPrescr', r_c01.DS_MOTIVO_SUSPENSAO_PRESCR);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'nrSeqTipoRemocao', r_c01.NR_SEQ_TIPO_REMOCAO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descDescRemocao', r_c01.DESC_DESC_REMOCAO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdTipoRemocaoValue', r_c01.CD_TIPO_REMOCAO_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdTipoRemocaoSystem', r_c01.CD_TIPO_REMOCAO_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dsQueixa', r_c01.DS_QUEIXA);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdSeqQueixaValue', r_c01.CD_SEQ_QUEIXA_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdSeqQueixaSystem', r_c01.CD_SEQ_QUEIXA_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'minuteCodeSystem', r_c01.MINUTE_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'minuteCodeValue', r_c01.MINUTE_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'minQtTempoExecucao', r_c01.MIN_QT_TEMPO_EXECUCAO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieIvc', r_c01.IE_IVC);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdEstabelecmento', r_c01.CD_ESTABELECMENTO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'requestedDateTime', r_c01.REQUESTED_DATE_TIME);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'suspendedTime', r_c01.SUSPENDED_TIME);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descInfoItem', r_c01.DESC_INFO_ITEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'dtSuspensao', r_c01.DT_SUSPENSAO);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'orderingProviderIdNumber', r_c01.ORDERING_PROVIDER_ID_NUMBER);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'orderingProviderGivenName', r_c01.ORDERING_PROVIDER_GIVEN_NAME);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'orderingProviderLastName', r_c01.ORDERING_PROVIDER_LAST_NAME);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'orderingProviderMiddleName', r_c01.ORDERING_PROVIDER_MIDDLE_NAME);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'nmMedicoSolicitante', r_c01.NM_MEDICO_SOLICITANTE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'orderingUserIdNumber', r_c01.ORDERING_USER_ID_NUMBER);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'orderProvSuspIdNumber', r_c01.ORDER_PROV_SUSP_ID_NUMBER);
    -- Solucao 1 
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseMat1', r_c01.QT_DOSE_MAT1);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMaterialProc1', r_c01.DESC_MATERIAL_PROC1);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc1Value', r_c01.CD_MAT_PROC1_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc1System', r_c01.CD_MAT_PROC1_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaMat1Text', r_c01.UNIDADE_MEDIDA_MAT1_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat1CodeSystem', r_c01.UNID_MED_MAT1_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat1CodeValue', r_c01.UNID_MED_MAT1_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseDil1', r_c01.QT_DOSE_DIL1);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieViaMatProc1', r_c01.IE_VIA_MAT_PROC1);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode1System', r_c01.VIA_CODE1_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode1Vale', r_c01.VIA_CODE1_VALE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descVia1', r_c01.DESC_VIA1);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMatDil1', r_c01.DESC_MAT_DIL1);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil1Value', r_c01.CD_MAT_DIL1_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil1System', r_c01.CD_MAT_DIL1_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaDil1Text', r_c01.UNIDADE_MEDIDA_DIL1_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil1CodeSystem', r_c01.UNID_MED_DIL1_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil1CodeValue', r_c01.UNID_MED_DIL1_CODE_VALUE);
    -- Solucao 2 
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseMat2', r_c01.QT_DOSE_MAT2);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMaterialProc2', r_c01.DESC_MATERIAL_PROC2);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc2Value', r_c01.CD_MAT_PROC2_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc2System', r_c01.CD_MAT_PROC2_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaMat2Text', r_c01.UNIDADE_MEDIDA_MAT2_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedidaMat2CodeSystem', r_c01.UNID_MEDIDA_MAT2_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaMat2CodeValue', r_c01.UNIDADE_MEDIDA_MAT2_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseDil2', r_c01.QT_DOSE_DIL2);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieViaMatProc2', r_c01.IE_VIA_MAT_PROC2);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode2System', r_c01.VIA_CODE2_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode2Vale', r_c01.VIA_CODE2_VALE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descVia2', r_c01.DESC_VIA2);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMatDil2', r_c01.DESC_MAT_DIL2);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil2Value', r_c01.CD_MAT_DIL2_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil2System', r_c01.CD_MAT_DIL2_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaDil2Text', r_c01.UNIDADE_MEDIDA_DIL2_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil2CodeSystem', r_c01.UNID_MED_DIL2_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil2CodeValue', r_c01.UNID_MED_DIL2_CODE_VALUE);
    -- Solucao 3
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseMat3', r_c01.QT_DOSE_MAT3);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMaterialProc3', r_c01.DESC_MATERIAL_PROC3);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc3Value', r_c01.CD_MAT_PROC3_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc3System', r_c01.CD_MAT_PROC3_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaMat3Text', r_c01.UNIDADE_MEDIDA_MAT3_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat3CodeSystem', r_c01.UNID_MED_MAT3_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat3CodeValue', r_c01.UNID_MED_MAT3_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseDil3', r_c01.QT_DOSE_DIL3);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieViaMatProc3', r_c01.IE_VIA_MAT_PROC3);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode3System', r_c01.VIA_CODE3_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode3Vale', r_c01.VIA_CODE3_VALE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descVia3', r_c01.DESC_VIA3);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMatDil3', r_c01.DESC_MAT_DIL3);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil3Value', r_c01.CD_MAT_DIL3_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil3System', r_c01.CD_MAT_DIL3_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaDil3Text', r_c01.UNIDADE_MEDIDA_DIL3_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unMedDil3CodeSystem', r_c01.UN_MED_DIL3_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unMedDil3CodeValue', r_c01.UN_MED_DIL3_CODE_VALUE);
    -- Solucao 4
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseMat4', r_c01.QT_DOSE_MAT4);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMaterialProc4', r_c01.DESC_MATERIAL_PROC4);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc4Value', r_c01.CD_MAT_PROC4_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc4System', r_c01.CD_MAT_PROC4_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaMat4Text', r_c01.UNIDADE_MEDIDA_MAT4_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat4CodeSystem', r_c01.UNID_MED_MAT4_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat4CodeValue', r_c01.UNID_MED_MAT4_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseDil4', r_c01.QT_DOSE_DIL4);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieViaMatProc4', r_c01.IE_VIA_MAT_PROC4);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode4System', r_c01.VIA_CODE4_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode4Vale', r_c01.VIA_CODE4_VALE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descVia4', r_c01.DESC_VIA4);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMatDil4', r_c01.DESC_MAT_DIL4);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil4Value', r_c01.CD_MAT_DIL4_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil4System', r_c01.CD_MAT_DIL4_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaDil4Text', r_c01.UNIDADE_MEDIDA_DIL4_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil4CodeSystem', r_c01.UNID_MED_DIL4_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil4CodeValue', r_c01.UNID_MED_DIL4_CODE_VALUE);
    -- Solucao 5
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseMat5', r_c01.QT_DOSE_MAT5);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMaterialProc5', r_c01.DESC_MATERIAL_PROC5);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc5Value', r_c01.CD_MAT_PROC5_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc5System', r_c01.CD_MAT_PROC5_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat5Text', r_c01.UNID_MED_MAT5_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat5CodeSystem', r_c01.UNID_MED_MAT5_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat5CodeValue', r_c01.UNID_MED_MAT5_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseDil5', r_c01.QT_DOSE_DIL5);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieViaMatProc5', r_c01.IE_VIA_MAT_PROC5);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode5System', r_c01.VIA_CODE5_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode5Vale', r_c01.VIA_CODE5_VALE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descVia5', r_c01.DESC_VIA5);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMatDil5', r_c01.DESC_MAT_DIL5);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil5Value', r_c01.CD_MAT_DIL5_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil5System', r_c01.CD_MAT_DIL5_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaDil5Text', r_c01.UNIDADE_MEDIDA_DIL5_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil5CodeSystem', r_c01.UNID_MED_DIL5_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil5CodeValue', r_c01.UNID_MED_DIL5_CODE_VALUE);
    -- Solucao 6
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseMat6', r_c01.QT_DOSE_MAT6);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMaterialProc6', r_c01.DESC_MATERIAL_PROC6);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc6Value', r_c01.CD_MAT_PROC6_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc6System', r_c01.CD_MAT_PROC6_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaMat6Text', r_c01.UNIDADE_MEDIDA_MAT6_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat6CodeSystem', r_c01.UNID_MED_MAT6_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat6CodeValue', r_c01.UNID_MED_MAT6_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseDil6', r_c01.QT_DOSE_DIL6);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieViaMatProc6', r_c01.IE_VIA_MAT_PROC6);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode6System', r_c01.VIA_CODE6_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode6Vale', r_c01.VIA_CODE6_VALE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descVia6', r_c01.DESC_VIA6);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMatDil6', r_c01.DESC_MAT_DIL6);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil6Value', r_c01.CD_MAT_DIL6_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil6System', r_c01.CD_MAT_DIL6_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaDil6Text', r_c01.UNIDADE_MEDIDA_DIL6_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil6CodeSystem', r_c01.UNID_MED_DIL6_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil6CodeValue', r_c01.UNID_MED_DIL6_CODE_VALUE);
    -- Solucao 7
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseMat7', r_c01.QT_DOSE_MAT7);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMaterialProc7', r_c01.DESC_MATERIAL_PROC7);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc7Value', r_c01.CD_MAT_PROC7_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatProc7System', r_c01.CD_MAT_PROC7_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaMat7Text', r_c01.UNIDADE_MEDIDA_MAT7_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat7CodeSystem', r_c01.UNID_MED_MAT7_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedMat7CodeValue', r_c01.UNID_MED_MAT7_CODE_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'qtDoseDil7', r_c01.QT_DOSE_DIL7);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'ieViaMatProc7', r_c01.IE_VIA_MAT_PROC7);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode7System', r_c01.VIA_CODE7_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'viaCode7Vale', r_c01.VIA_CODE7_VALE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descVia7', r_c01.DESC_VIA7);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'descMatDil7', r_c01.DESC_MAT_DIL7);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil7Value', r_c01.CD_MAT_DIL7_VALUE);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'cdMatDil7System', r_c01.CD_MAT_DIL7_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidadeMedidaDil7Text', r_c01.UNIDADE_MEDIDA_DIL7_TEXT);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil7CodeSystem', r_c01.UNID_MED_DIL7_CODE_SYSTEM);
    json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'unidMedDil7CodeValue', r_c01.UNID_MED_DIL7_CODE_VALUE);

		if (r_c01.IE_ADMINISTRACAO in ('N', 'C')) then
      json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'priority', 'PRN');
    elsif (r_c01.IE_URGENCIA = '0') then
      json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'priority', 'S');
    elsif (r_c01.IE_URGENCIA = '5') then
      json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'priority', 'TM5');
    elsif (r_c01.IE_URGENCIA = '10') then
      json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'priority', 'TM10');
    elsif (r_c01.IE_URGENCIA = '15') then
      json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'priority', 'TM15');
    else
      json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'priority', 'R');
    end if;

		if (r_c01.dt_fim IS NOT NULL AND r_c01.dt_fim::text <> '') then
				json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'numberOfDays', OBTER_DIAS_ENTRE_DATAS(r_c01.DT_INICIO, r_c01.dt_fim));
		end if;

    if (r_c01.MIN_QT_TEMPO_EXECUCAO IS NOT NULL AND r_c01.MIN_QT_TEMPO_EXECUCAO::text <> '') then
      json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'occurrenceDurationId', r_c01.MINUTE_CODE_VALUE || r_c01.MIN_QT_TEMPO_EXECUCAO);
      --cpoe_proced_order_json_pck.add_json_value(json_item_w, 'occurrenceDurationText', r_c01.HR_QT_HORA_MIN_SESSAO || ' ' || r_c01.DESC_UNIDADE_MEDIDA);
      json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'occurrenceDurationCodeSystem', r_c01.MINUTE_CODE_SYSTEM);
    end if;

		json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'effectiveDate', coalesce(r_c01.SUSPENDED_TIME, r_c01.REQUESTED_DATE_TIME));
		json_item_w := cpoe_proced_order_json_pck.add_json_value(json_item_w, 'enteredBy', coalesce(r_c01.order_prov_susp_id_number, r_c01.ordering_user_id_number));

		json_item_list_w.append(json_item_w.to_json_value());
		end;
	end loop;
	
	return json_item_list_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION cpoe_proced_order_json_pck.get_proc_data (nr_cpoe_proc_p bigint) FROM PUBLIC;
