-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW unidade_atend_livre_inativa_v (ds_setor_atendimento, nm_unidade, cd_unidade_basica, cd_unidade_compl, cd_setor_atendimento, cd_tipo_acomodacao, ie_temporario, ie_situacao, dt_atualizacao, nm_usuario, ie_status_unidade, nr_atendimento, dt_entrada_unidade, cd_paciente_reserva, nm_usuario_reserva, ie_classe_acomodacao, ie_sexo_paciente, ie_sexo_fixo, ie_higienizacao, dt_higienizacao, nm_usuario_higienizacao, dt_inicio_higienizacao, nr_seq_interno, ds_observacao, cd_motivo_interdicao, nr_atendimento_acomp, nr_ramal, dt_criacao, qt_max_visitante, qt_max_acomp, qt_idade_minima, qt_idade_maxima, ds_ocupacao, nr_seq_superior, nr_agrupamento, qt_peso_maximo, qt_altura_maxima, cd_convenio_reserva, ie_status_ant_unidade, qt_tempo_prev_higien, nr_seq_motivo_reserva, nr_seq_computador, nm_usuario_fim_higienizacao, ie_tipo_limpeza, nr_seq_computador_leito, nr_seq_apresent, qt_pac_unidade, ds_unidade_atend, ie_leito_monitorado, ie_permite_alt_eup, ie_inativar_leito_temp, ie_radioterapia, ie_interditado_radiacao, ie_exibir_cc, nr_seq_local_pa, qt_idade_dias_min, qt_idade_dias_max, ie_tipo_reserva, ie_mostra_gestao_disp, ie_inativa_setor_auto, ie_necessita_isol_reserva, nr_seq_unidade_rn, qt_max_diario, qt_max_simultaneo, cd_motivo_manutencao, nm_setor_integracao, nr_atendimento_ant, ds_agrupamento, nr_seq_classif, qt_dias_prev_interd, nr_seq_mot_isol, dt_interdicao, ie_observacao_pa, nr_internacao_aghos, dt_aguard_higienizacao, ie_controle_faixa_etaria, nr_externo, nr_seq_unid_bloq, ie_bloq_unid_ant, nr_seq_grupo_equip_ca, ie_leito_adaptado, nm_pac_reserva, ie_leito_retaguarda, ie_retaguarda_atual, nm_leito_integracao, ie_ignorar_checklist, ie_bloqueio_transf, nr_seq_classif_pac_leito, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_modelo, nr_seq_location, ie_gerint, nr_seq_room_number, ie_monitorizacao_externa, ie_family_room, dt_start_reservation, dt_end_reservation, nr_seq_genero, ie_leito_prox_posto_enf, cd_unidade, cd_unidade_classif, ds_tipo_acomodacao, ds_cor, cd_classif_setor, ie_leito_adapt) AS select 	d.ds_setor_atendimento,
	(d.nm_unidade_basica || '/'||d.nm_unidade_compl) nm_unidade,
	a.CD_UNIDADE_BASICA,
	a.CD_UNIDADE_COMPL,
	a.CD_SETOR_ATENDIMENTO,
	a.CD_TIPO_ACOMODACAO,
	a.IE_TEMPORARIO,
	a.IE_SITUACAO,
	a.DT_ATUALIZACAO,
	a.NM_USUARIO,
	a.IE_STATUS_UNIDADE,
	a.NR_ATENDIMENTO,
	a.DT_ENTRADA_UNIDADE,
	a.CD_PACIENTE_RESERVA,
	a.NM_USUARIO_RESERVA,
	a.IE_CLASSE_ACOMODACAO,
	a.IE_SEXO_PACIENTE,
	a.IE_SEXO_FIXO,
	a.IE_HIGIENIZACAO,
	a.DT_HIGIENIZACAO,
	a.NM_USUARIO_HIGIENIZACAO,
	a.DT_INICIO_HIGIENIZACAO,
	a.NR_SEQ_INTERNO,
	a.DS_OBSERVACAO,
	a.CD_MOTIVO_INTERDICAO,
	a.NR_ATENDIMENTO_ACOMP,
	a.NR_RAMAL,
	a.DT_CRIACAO,
	a.QT_MAX_VISITANTE,
	a.QT_MAX_ACOMP,
	a.QT_IDADE_MINIMA,
	a.QT_IDADE_MAXIMA,
	a.DS_OCUPACAO,
	a.NR_SEQ_SUPERIOR,
	a.NR_AGRUPAMENTO,
	a.QT_PESO_MAXIMO,
	a.QT_ALTURA_MAXIMA,
	a.CD_CONVENIO_RESERVA,
	a.IE_STATUS_ANT_UNIDADE,
	a.QT_TEMPO_PREV_HIGIEN,
	a.NR_SEQ_MOTIVO_RESERVA,
	a.NR_SEQ_COMPUTADOR,
	a.NM_USUARIO_FIM_HIGIENIZACAO,
	a.IE_TIPO_LIMPEZA,
	a.NR_SEQ_COMPUTADOR_LEITO,
	a.NR_SEQ_APRESENT,
	a.QT_PAC_UNIDADE,
	a.DS_UNIDADE_ATEND,
	a.IE_LEITO_MONITORADO,
	a.IE_PERMITE_ALT_EUP,
	a.IE_INATIVAR_LEITO_TEMP,
	a.IE_RADIOTERAPIA,
	a.IE_INTERDITADO_RADIACAO,
	a.IE_EXIBIR_CC,
	a.NR_SEQ_LOCAL_PA,
	a.QT_IDADE_DIAS_MIN,
	a.QT_IDADE_DIAS_MAX,
	a.IE_TIPO_RESERVA,
	a.IE_MOSTRA_GESTAO_DISP,
	a.IE_INATIVA_SETOR_AUTO,
	a.IE_NECESSITA_ISOL_RESERVA,
	a.NR_SEQ_UNIDADE_RN,
	a.QT_MAX_DIARIO,
	a.QT_MAX_SIMULTANEO,
	a.CD_MOTIVO_MANUTENCAO,
	a.NM_SETOR_INTEGRACAO,
	a.NR_ATENDIMENTO_ANT,
	a.DS_AGRUPAMENTO,
	a.NR_SEQ_CLASSIF,
	a.QT_DIAS_PREV_INTERD,
	a.NR_SEQ_MOT_ISOL,
	a.DT_INTERDICAO,
	a.IE_OBSERVACAO_PA,
	a.NR_INTERNACAO_AGHOS,
	a.DT_AGUARD_HIGIENIZACAO,
	a.IE_CONTROLE_FAIXA_ETARIA,
	a.NR_EXTERNO,
	a.NR_SEQ_UNID_BLOQ,
	a.IE_BLOQ_UNID_ANT,
	a.NR_SEQ_GRUPO_EQUIP_CA,
	a.IE_LEITO_ADAPTADO,
	a.NM_PAC_RESERVA,
	a.IE_LEITO_RETAGUARDA,
	a.IE_RETAGUARDA_ATUAL,
	a.NM_LEITO_INTEGRACAO,
	a.IE_IGNORAR_CHECKLIST,
	a.IE_BLOQUEIO_TRANSF,
	a.NR_SEQ_CLASSIF_PAC_LEITO,
	a.DT_ATUALIZACAO_NREC,
	a.NM_USUARIO_NREC,
	a.NR_SEQ_MODELO,
	a.NR_SEQ_LOCATION,
	a.IE_GERINT,
	a.NR_SEQ_ROOM_NUMBER,
	a.IE_MONITORIZACAO_EXTERNA,
	a.IE_FAMILY_ROOM,
	a.DT_START_RESERVATION,
	a.DT_END_RESERVATION,
	a.NR_SEQ_GENERO,
	a.IE_LEITO_PROX_POSTO_ENF,
	(a.cd_unidade_basica || ' ' || a.cd_unidade_compl) cd_unidade,
	(a.cd_unidade_basica || a.cd_unidade_compl) cd_unidade_classif,
	b.ds_tipo_acomodacao,
	b.ds_cor,
	d.cd_classif_setor,
	coalesce(a.IE_LEITO_ADAPTADO, 'N') IE_LEITO_ADAPT
FROM tipo_acomodacao b,
     setor_atendimento d,
     unidade_atendimento a
where a.cd_tipo_acomodacao    = b.cd_tipo_acomodacao
  and a.cd_setor_atendimento  = d.cd_setor_atendimento
  and a.ie_situacao           = 'I'
  and a.ie_status_unidade     in ('L');

