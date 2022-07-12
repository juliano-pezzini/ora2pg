-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hmod_eis_receb_prescricao (nr_prescricao, cd_setor_atendimento, ds_setor, dt_recebimento, dt_prescricao, dt_liberacao, qt_tempo_atend, qt_tempo_lib, qt_media, nm_usuario, nm_medico) AS select a.nr_prescricao,
 b.cd_setor_atendimento,
 substr(obter_nome_setor(b.cd_setor_atendimento),1,30)ds_setor,
 b.dt_recebimento,
 a.dt_prescricao,
 a.dt_liberacao,
dividir(sum(obter_min_entre_datas(a.DT_LIBERACAO,b.DT_RECEBIMENTO,1)),count(a.nr_prescricao)) qt_tempo_atend,
dividir(sum(obter_min_entre_datas(a.DT_PRESCRICAO,a.DT_LIBERACAO,1)),count(a.nr_prescricao)) qt_tempo_lib,
dividir(sum(obter_min_entre_datas(a.DT_LIBERACAO,b.DT_RECEBIMENTO,1)),count(a.nr_prescricao)) qt_media,
 substr(obter_nome_usuario(b.nm_usuario),1,30)nm_usuario,
 substr(obter_nome_medico(a.cd_medico,'N'),1,30)nm_medico
FROM prescr_medica a,
 PRESCR_MEDIC_SETOR b
where  a.nr_prescricao = b.nr_prescricao
group by a.nr_prescricao,
  b.cd_setor_atendimento,
  b.dt_recebimento,
  a.dt_prescricao,
  a.dt_liberacao,
  a.cd_medico,
  b.nm_usuario
;
