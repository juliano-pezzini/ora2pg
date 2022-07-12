-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nut_atend_serv_classif_v (nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_servico, dt_servico, nm_usuario_lib, cd_setor_atendimento, ds_observacao, ie_status, nr_atendimento, dt_liberacao, ie_status_adep, dt_fim_horario, nm_usuario_adm, dt_suspensao, nm_usuario_susp, nr_prescricao, nr_seq_material, nr_seq_horario, nr_solic_compra, nr_seq_classif_servico, ie_acompanhante, nm_usuario_atend, dt_atend_servico, cd_copeira, dt_bloqueio, dt_desbloqueio, nr_seq_justif_bloqueio, ie_data_atualizada, dt_descarte, nm_usuario_descarte, nm_usuario_bloqueio, dt_conferencia, nm_usuario_conf, dt_desfazer_conf, nm_usu_desf_conf, dt_recolhimento, nm_usuario_recolhimento, ds_classif, ds_servico) AS SELECT	a.NR_SEQUENCIA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.NR_SEQ_SERVICO,a.DT_SERVICO,a.NM_USUARIO_LIB,a.CD_SETOR_ATENDIMENTO,a.DS_OBSERVACAO,a.IE_STATUS,a.NR_ATENDIMENTO,a.DT_LIBERACAO,a.IE_STATUS_ADEP,a.DT_FIM_HORARIO,a.NM_USUARIO_ADM,a.DT_SUSPENSAO,a.NM_USUARIO_SUSP,a.NR_PRESCRICAO,a.NR_SEQ_MATERIAL,a.NR_SEQ_HORARIO,a.NR_SOLIC_COMPRA,a.NR_SEQ_CLASSIF_SERVICO,a.IE_ACOMPANHANTE,a.NM_USUARIO_ATEND,a.DT_ATEND_SERVICO,a.CD_COPEIRA,a.DT_BLOQUEIO,a.DT_DESBLOQUEIO,a.NR_SEQ_JUSTIF_BLOQUEIO,a.IE_DATA_ATUALIZADA,a.DT_DESCARTE,a.NM_USUARIO_DESCARTE,a.NM_USUARIO_BLOQUEIO,a.DT_CONFERENCIA,a.NM_USUARIO_CONF,a.DT_DESFAZER_CONF,a.NM_USU_DESF_CONF,a.DT_RECOLHIMENTO,a.NM_USUARIO_RECOLHIMENTO,
		SUBSTR(OBTER_CLASSIF_AVAL(NR_SEQ_CLASSIF_SERVICO),1,255) ds_classif,
		substr(obter_desc_nut_servico(a.nr_seq_servico),1,50) ds_servico
FROM  	nut_atend_serv_dia a
WHERE	a.nr_seq_classif_servico IS NOT NULL;

