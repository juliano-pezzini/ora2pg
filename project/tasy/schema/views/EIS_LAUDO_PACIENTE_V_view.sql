-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_laudo_paciente_v (cd_estabelecimento, dt_referencia, dt_atualizacao, nm_usuario, cd_convenio, cd_medico_laudo, cd_setor_atendimento, qt_hora_atraso, qt_ocorrencia, ie_tipo_atendimento, cd_tipo_procedimento, nm_usuario_digitacao, nm_usuario_seg_aprov, cd_medico_prescr, cd_tecnico_resp, dt_desaprovacao, cd_residente, nr_seq_proc_interno, ds_convenio, ds_setor_atendimento, ds_tipo_procedimento, ds_tipo_atendimento, nm_medico, nm_medico_prescr, cd_setor_usuario_dig, ds_setor_usuario_dig, nm_usuario_dig, nm_usuario_seg_aprovacao, ds_estabelecimento, cd_empresa, nm_tecnico_resp, nm_residente, ds_proc_interno) AS SELECT
  a.CD_ESTABELECIMENTO, 
  a.DT_REFERENCIA, 
  a.DT_ATUALIZACAO, 
  a.NM_USUARIO, 
  a.CD_CONVENIO, 
  a.CD_MEDICO_LAUDO, 
  a.CD_SETOR_ATENDIMENTO, 
  CAST(coalesce(a.QT_HORA_ATRASO,0) AS bigint) QT_HORA_ATRASO, 
  a.QT_OCORRENCIA, 
  a.IE_TIPO_ATENDIMENTO, 
  a.CD_TIPO_PROCEDIMENTO, 
  a.NM_USUARIO_DIGITACAO, 
  a.NM_USUARIO_SEG_APROV, 
  a.CD_MEDICO_PRESCR, 
  a.CD_TECNICO_RESP, 
  a.DT_DESAPROVACAO, 
  a.CD_RESIDENTE, 
  a.NR_SEQ_PROC_INTERNO, 
  obter_nome_convenio(a.cd_convenio) ds_convenio, 
  obter_nome_setor(a.cd_setor_atendimento) ds_setor_atendimento, 
  obter_valor_dominio(95, a.cd_tipo_procedimento) ds_tipo_procedimento, 
  obter_valor_dominio(12, a.ie_tipo_atendimento) ds_tipo_atendimento, 
  obter_nome_pessoa_fisica(a.cd_medico_laudo, NULL) nm_medico, 
  obter_nome_pessoa_fisica(a.cd_medico_prescr, NULL) nm_medico_prescr, 
  SUBSTR(obter_setor_usuario(nm_usuario_digitacao),1,50) cd_setor_usuario_dig, 
  SUBSTR(obter_nome_setor(obter_setor_usuario(nm_usuario_digitacao)),1,100) ds_setor_usuario_dig, 
  SUBSTR(obter_nome_usuario(nm_usuario_digitacao),1,50) nm_usuario_dig, 
  SUBSTR(obter_nome_usuario(nm_usuario_seg_aprov),1,50) nm_usuario_seg_aprovacao, 
  SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
  obter_empresa_estab(a.cd_estabelecimento) cd_empresa, 
  SUBSTR(obter_nome_pf(a.cd_tecnico_resp),1,100) nm_tecnico_resp, 
  SUBSTR(obter_nome_pf(a.cd_residente),1,100) nm_residente, 
  SUBSTR(coalesce(obter_desc_proc_interno(a.nr_seq_proc_interno),'Não informado'), 
  1,255) ds_proc_interno 
 FROM 
  eis_laudo_paciente a;
