-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_agenda_v (dt_referencia, cd_estabelecimento, cd_tipo_agenda, cd_agenda, ie_status_agenda, hr_inicio, hr_inicio_char, cd_motivo_canc, cd_medico, cd_convenio, qt_min_duracao, qt_agenda, ie_carater_cirurgia, cd_setor_atendimento, nm_usuario_agenda, ds_cod_proced, ds_procedimento_princ, cd_proc_princ, ie_origem_proc_princ, ds_cod_proc_adic, ds_procedimento_adic, cd_proc_adic, ie_origem_proc_adic, ds_classif_agenda, ie_classif_agenda, ds_setor_execucao, cd_setor_execucao, ds_inicio, ds_inicio_char, ds_agenda, ds_convenio, ds_motivo_cancelamento, ds_motivo_cancel_cirur, nm_medico, ds_status, ds_tipo_agenda, nm_medico_agenda, ds_carater_cirurgia, ds_setor_atendimento, ds_setor_exclusivo, cd_tipo_convenio, ds_tipo_convenio, ds_sala, ds_classificacao, nr_seq_classif_agenda, ie_tipo_proc_agenda, nr_seq_sala, nm_usuario_original, ds_tipo_indicacao, nr_seq_indicacao, ds_min_espera, ds_min_consulta, ds_proc_interno, ds_proced_princ_int, ds_proced_adic_int, ds_lado, ie_lado, ds_estabelecimento, ds_especialidade, qt_min_duracao_canc, qt_cancelada, qt_executada, qt_livre, qt_aguardando, qt_normal, qt_atendido, qt_falta_just, qt_em_atendimento, qt_falt_n_just, qt_finalizada, cd_empresa, ds_curta, ds_complemento, qt_atendimento, cd_procedencia, ds_procedencia, ds_complexidade, qt_tempo_chegada, qt_tempo_espera, qt_tempo_atendimento, qt_tempo_espera_exame, qt_tempo_em_exame, qt_tempo_exec, cd_setor_exclusivo, nr_seq_motivo_trans, ds_motivo_trans, cd_medico_exec, nm_medico_exec, qt_procedimento, ie_tipo_atendimento, ds_tipo_atendimento, ie_forma_agendamento, ds_forma_agendamento, cd_especialidade, nm_usuario_confirm, nr_seq_motivo_bloqueio, ds_motivo_bloqueio, cd_estab_usuario, ds_estab_usuario, hr_agendamento, ie_clinica, ds_clinica, cd_medico_req, nm_medico_req, ie_classif_tasy, ds_classif_tasy, ie_clinica_agenda, ds_clinica_agenda, nr_seq_proc_interno, nm_usuario_cancelamento, nr_seq_area_atuacao, ds_area_atuacao, hr_confirmacao, hr_marcacao, dt_agendamento, dt_ref_confirmacao, hr_cancelamento, dt_ref_cancelamento, cd_estab_usuario_canc, ds_estab_usuario_canc, cd_estab_usuario_orig, ds_estab_usuario_orig, cd_estab_usuario_confirm, ds_estab_usuario_confirm, cd_especialidade_agenda, ds_especialidade_agenda, nr_seq_modelo, ds_modelo, ie_atrasado, nr_seq_motivo_atraso, ds_motivo_atraso, ds_agenda_combo, ds_classif_curta, cd_categoria, ds_categoria, ie_clinica_pac, ds_clinica_pac, ds_porte, ie_porte, cd_turno, ds_turno, nr_seq_origem, ds_origem_conv, nr_seq_grupo_classif, ds_grupo_classif, nr_seq_forma_confirmacao, ds_forma_confirmacao, ds_usuario_original, ds_usuario_agenda, ds_usuario_confirm, ds_login_alternativo, ds_login_alt_confirm, ds_login_alt_orig, dt_copia_trans, ds_autorizacao, ie_autorizacao, ie_dia_semana, ds_dia_semana, ds_grupo_motivo_cancel, cd_grupo_motivo_cancel, ds_status_paciente, nr_seq_status_pac, cd_grupo_proc_princ, ds_grupo_proc_princ, ds_mot_bloq_cons, hr_inicio_number) AS SELECT	a.DT_REFERENCIA     ,
	a.CD_ESTABELECIMENTO   , 
	a.CD_TIPO_AGENDA     , 
	a.CD_AGENDA       , 
	a.IE_STATUS_AGENDA    , 
	LPAD(TO_CHAR(a.hr_inicio),2,'0') HR_INICIO, 
	LPAD(TO_CHAR(a.hr_inicio),2,'0') hr_inicio_char, 
	a.CD_MOTIVO_CANC     , 
	a.CD_MEDICO       , 
	a.CD_CONVENIO      , 
	a.QT_MIN_DURACAO     , 
	a.QT_AGENDA       , 
	a.IE_CARATER_CIRURGIA  , 
	a.CD_SETOR_ATENDIMENTO, 
	a.NM_USUARIO_AGENDA  , 
	a.CD_PROC_PRINC||' - '||SUBSTR(Obter_Descricao_Procedimento(a.CD_PROC_PRINC,a.IE_ORIGEM_PROC_PRINC),1,50) ds_cod_proced,	 
	SUBSTR(Obter_Descricao_Procedimento(a.CD_PROC_PRINC,a.IE_ORIGEM_PROC_PRINC),1,150) ds_procedimento_princ, 
	a.CD_PROC_PRINC     , 
	a.IE_ORIGEM_PROC_PRINC, 
	a.CD_PROC_ADIC||' - '||SUBSTR(Obter_Descricao_Procedimento(a.CD_PROC_ADIC,a.IE_ORIGEM_PROC_ADIC),1,50) ds_cod_proc_adic, 
	SUBSTR(Obter_Descricao_Procedimento(a.CD_PROC_ADIC,a.IE_ORIGEM_PROC_ADIC),1,150) ds_procedimento_adic, 
	a.CD_PROC_ADIC     ,  
	a.IE_ORIGEM_PROC_ADIC  , 
	SUBSTR(obter_desc_clas_agenda_cons(a.IE_CLASSIF_AGENDA),1,150) ds_classif_agenda, 
	a.IE_CLASSIF_AGENDA   , 
	SUBSTR(OBTER_NOME_SETOR(a.CD_SETOR_EXECUCAO),1,150) ds_setor_execucao, 
	a.CD_SETOR_EXECUCAO   , 
	a.hr_inicio ds_inicio, 
	LPAD(TO_CHAR(a.hr_inicio),2,'0') ds_inicio_char, 
	obter_descricao_padrao('AGENDA','DS_AGENDA',a.CD_AGENDA) ds_agenda, 
	obter_nome_convenio(a.cd_convenio) ds_convenio, 
	SUBSTR(obter_motivo_canc_agecons(cd_motivo_canc,'D'),1,255) ds_motivo_cancelamento, 
	SUBSTR(obter_motivo_canc_agecir(cd_motivo_canc,'D'),1,255) ds_motivo_cancel_cirur, 
/*	obter_valor_dominio(1011, a.cd_motivo_canc) ds_motivo_cancelamento,*/
 
	obter_nome_pessoa_fisica(a.cd_medico, NULL) nm_medico, 
	obter_valor_dominio(83, a.ie_status_agenda) ds_status, 
	obter_valor_dominio(34, a.cd_tipo_agenda) ds_tipo_agenda, 
	obter_nome_pf(b.cd_pessoa_fisica) nm_medico_agenda, 
	SUBSTR(obter_valor_dominio(1016, a.ie_carater_cirurgia),1,15) ds_carater_cirurgia, 
	obter_nome_setor(cd_setor_atendimento) ds_setor_atendimento, 
	SUBSTR(obter_nome_setor(a.cd_setor_exclusivo),1,100) ds_setor_exclusivo, 
	Obter_Tipo_Convenio(a.CD_CONVENIO) cd_tipo_convenio, 
	SUBSTR(obter_valor_dominio(11, Obter_Tipo_Convenio(a.CD_CONVENIO)),1,100) ds_tipo_convenio, 
	SUBSTR(Obter_Desc_Sala_Consulta(nr_seq_sala),1,150) ds_sala, 
	SUBSTR(obter_desc_classif_agenda_pac(nr_seq_classif_agenda),1,80) ds_classificacao, 
	a.nr_seq_classif_agenda, 
	ie_tipo_proc_agenda, 
	a.NR_SEQ_SALA, 
	a.nm_usuario_original, 
	SUBSTR(obter_descricao_padrao('TIPO_INDICACAO', 'DS_INDICACAO', a.NR_SEQ_INDICACAO),1,100) ds_tipo_indicacao, 
	a.NR_SEQ_INDICACAO, 
	obter_intervalo_minutos(qt_aguardando) ds_min_espera, 
	obter_intervalo_minutos(qt_consulta) ds_min_consulta, 
	SUBSTR(obter_desc_proc_interno(nr_seq_proc_interno),1,200) ds_proc_interno, 
	SUBSTR(obter_desc_int_proc(cd_proc_princ, ie_origem_proc_princ),1,200) ds_proced_princ_int, 
	SUBSTR(obter_desc_int_proc(cd_proc_adic, ie_origem_proc_adic),1,200) ds_proced_adic_int, 
	SUBSTR(obter_valor_dominio(1372, ie_lado),1,200) ds_lado, 
	ie_lado, 
	SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	SUBSTR(obter_especialidade_medico(a.cd_medico,'D'),1,80) ds_especialidade, 
	CASE WHEN a.ie_status_agenda='C' THEN a.QT_MIN_DURACAO  ELSE 0 END  QT_MIN_DURACAO_CANC, 
	CASE WHEN ie_status_agenda='C' THEN 1  ELSE 0 END  qt_cancelada, 
	CASE WHEN ie_status_agenda='E' THEN 1  ELSE 0 END  qt_executada, 
	CASE WHEN ie_status_agenda='L' THEN 1  ELSE 0 END  qt_livre, 
	CASE WHEN ie_status_agenda='A' THEN 1  ELSE 0 END  qt_aguardando, 
	CASE WHEN ie_status_agenda='N' THEN 1  ELSE 0 END  qt_normal, 
	CASE WHEN ie_status_agenda='AD' THEN 1  ELSE 0 END  qt_atendido, 
	CASE WHEN ie_status_agenda='F' THEN 1  ELSE 0 END  qt_falta_just, 
	CASE WHEN ie_status_agenda='O' THEN 1  ELSE 0 END  qt_em_atendimento, 
	CASE WHEN ie_status_agenda='I' THEN 1  ELSE 0 END  qt_falt_n_just, 
	CASE WHEN obter_dados_cirurgia(a.nr_cirurgia,'DT') IS NULL THEN 0  ELSE 1 END  qt_finalizada, 
	obter_empresa_estab(a.cd_estabelecimento) cd_empresa, 
	b.ds_curta, 
	b.ds_complemento, 
	a.qt_atendimento, 
	a.cd_procedencia, 
	SUBSTR(coalesce(obter_desc_procedencia(a.cd_procedencia),Obter_Desc_Expressao(622834)),1,100) ds_procedencia, 
	SUBSTR(coalesce(sus_obter_complexidade_proced(a.cd_proc_princ, a.ie_origem_proc_princ, 'D'), Obter_Desc_Expressao(327119)),1,255) ds_complexidade, 
	ROUND(((a.dt_chegada - a.dt_agendamento) * 1440),0) qt_tempo_chegada, 
	ROUND(((a.dt_atendimento - a.dt_chegada) * 1440),0) qt_tempo_espera, 
	ROUND(((a.dt_atendimento - a.dt_atendido) * 1440),0) qt_tempo_atendimento, 
	ROUND(((a.dt_em_exame - a.dt_atendido) * 1440),0) qt_tempo_espera_exame, 
	ROUND(((a.dt_executada - a.dt_em_exame) * 1440),0) qt_tempo_em_exame, 
	ROUND(((a.dt_executada - a.dt_agendamento) * 1440),0) qt_tempo_exec, 
	a.cd_setor_exclusivo, 
	a.nr_seq_motivo_trans, 
	SUBSTR(obter_desc_motivo_transf(a.nr_seq_motivo_trans),1,255) ds_motivo_trans, 
	a.cd_medico_exec, 
	SUBSTR(obter_nome_pf(a.cd_medico_exec),1,100) nm_medico_exec, 
	a.qt_procedimento, 
	a.ie_tipo_atendimento, 
	SUBSTR(obter_valor_dominio(12,a.ie_tipo_atendimento),1,100) ds_tipo_atendimento, 
	a.ie_forma_agendamento, 
	obter_valor_dominio(2441, a.ie_forma_agendamento) ds_forma_agendamento, 
	SUBSTR(obter_especialidade_medico(a.cd_medico,NULL),1,5) cd_especialidade, 
	a.nm_usuario_confirm, 
	a.nr_seq_motivo_bloqueio, 
	SUBSTR(obter_valor_dominio(1007,a.nr_seq_motivo_bloqueio),1,255) ds_motivo_bloqueio, 
	SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_agenda,'CE'),1,255) cd_estab_usuario, 
	SUBSTR(obter_nome_estabelecimento(obter_dados_usuario_opcao(a.nm_usuario_agenda,'CE')),1,255) ds_estab_usuario, 
	TO_CHAR(a.dt_inicio_agendamento,'hh24') hr_agendamento, 
	a.ie_clinica, 
	SUBSTR(obter_valor_dominio(17,a.ie_clinica),1,100) ds_clinica, 
	a.cd_medico_req, 
	SUBSTR(obter_nome_medico(a.cd_medico_req,'N'),1,255) nm_medico_req, 
	a.ie_classif_tasy, 
	SUBSTR(obter_valor_dominio(1006,a.ie_classif_tasy),1,255) ds_classif_tasy, 
	a.ie_clinica_agenda, 
	SUBSTR(obter_valor_dominio(17,a.ie_clinica_agenda),1,100) ds_clinica_agenda, 
	a.nr_seq_proc_interno, 
	a.nm_usuario_cancelamento, 
	a.nr_seq_area_atuacao, 
	SUBSTR(obter_desc_area_atuacao_medica(a.nr_seq_area_atuacao),1,255) ds_area_atuacao, 
	TO_CHAR(a.dt_confirmacao,'hh24') hr_confirmacao, 
	TO_CHAR(a.dt_agendamento,'hh24') hr_marcacao,	 
	TRUNC(CASE WHEN b.cd_tipo_agenda=2 THEN a.dt_inicio_agendamento  ELSE a.dt_agendamento END ,'dd') dt_agendamento, 
	TRUNC(a.dt_confirmacao,'dd') dt_ref_confirmacao, 
	TO_CHAR(a.dt_cancelamento,'hh24') hr_cancelamento, 
	TRUNC(a.dt_cancelamento,'dd') dt_ref_cancelamento, 
	SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_cancelamento,'CE'),1,255) cd_estab_usuario_canc, 
	SUBSTR(obter_nome_estabelecimento(obter_dados_usuario_opcao(a.nm_usuario_cancelamento,'CE')),1,255) ds_estab_usuario_canc, 
	SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_original,'CE'),1,255) cd_estab_usuario_orig, 
	SUBSTR(obter_nome_estabelecimento(obter_dados_usuario_opcao(a.nm_usuario_original,'CE')),1,255) ds_estab_usuario_orig, 
	SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_confirm,'CE'),1,255) cd_estab_usuario_confirm, 
	SUBSTR(obter_nome_estabelecimento(obter_dados_usuario_opcao(a.nm_usuario_confirm,'CE')),1,255) ds_estab_usuario_confirm, 
	a.cd_especialidade_agenda, 
	SUBSTR(obter_nome_especialidade(a.cd_especialidade_agenda),1,255) ds_especialidade_agenda, 
	ageserv_obter_modelo_agend(a.nr_seq_rp_mod_item,'C') nr_seq_modelo, 
	SUBSTR(ageserv_obter_modelo_agend(a.nr_seq_rp_mod_item,'D'),1,255) ds_modelo, 
	a.ie_atrasado, 
	a.nr_seq_motivo_atraso, 
	SUBSTR(obter_motivo_atraso_pac(a.nr_seq_motivo_atraso,a.cd_estabelecimento),1,255) ds_motivo_atraso, 
	SUBSTR(obter_nome_medico_combo_agcons(b.cd_estabelecimento,b.cd_agenda,b.cd_tipo_agenda,coalesce(b.ie_ordenacao,'N')),1,255) ds_agenda_combo, 
	SUBSTR(obter_desc_clas_curta_cons(a.IE_CLASSIF_AGENDA),1,7) ds_classif_curta, 
	a.cd_categoria, 
	SUBSTR(obter_categoria_convenio(a.cd_convenio,a.cd_categoria),1,255) ds_categoria, 
	a.ie_clinica_pac, 
	SUBSTR(obter_valor_dominio(17,a.ie_clinica_pac),1,255) ds_clinica_pac, 
	SUBSTR(CASE WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='P' THEN Obter_Desc_Expressao(489957) WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='M' THEN  Obter_Desc_Expressao(293174) WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='G' THEN Obter_Desc_Expressao(489958) WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='E' THEN  Obter_Desc_Expressao(289428) WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='S' THEN  Obter_Desc_Expressao(298957)  ELSE Obter_Desc_Expressao(327119) END ,1,200) ds_porte, 
	SUBSTR(OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno),1,200) ie_porte, 
	a.cd_turno, 
	SUBSTR(CASE WHEN a.cd_turno='0' THEN Obter_Desc_Expressao(487774)  ELSE Obter_Desc_Expressao(487775) END ,1,50) ds_turno, 
	a.nr_seq_origem, 
	SUBSTR(Obter_desc_origem_conv(a.nr_seq_origem),1,60) ds_origem_conv, 
	SUBSTR(obter_grupo_classif(a.ie_classif_agenda,'C'),1,255) nr_seq_grupo_classif, 
	SUBSTR(obter_grupo_classif(a.ie_classif_agenda,'D'),1,255) ds_grupo_classif, 
	a.nr_seq_forma_confirmacao, 
	SUBSTR(obter_desc_forma_conf(a.nr_seq_forma_confirmacao),1,90) ds_forma_confirmacao, 
	SUBSTR(Obter_Nome_Usuario(a.nm_usuario_original),1,255) ds_usuario_original, 
	SUBSTR(Obter_Nome_Usuario(a.nm_usuario_agenda),1,255) ds_usuario_agenda, 
	SUBSTR(Obter_Nome_Usuario(a.nm_usuario_confirm),1,255) ds_usuario_confirm, 
	SUBSTR(Obter_Dados_Usuario_Opcao(a.nm_usuario_cancelamento,'LA'),1,255) ds_login_alternativo, 
	SUBSTR(Obter_Dados_Usuario_Opcao(a.nm_usuario_confirm,'LA'),1,255) ds_login_alt_confirm, 
	SUBSTR(Obter_Dados_Usuario_Opcao(a.nm_usuario_original,'LA'),1,255) ds_login_alt_orig, 
	a.dt_copia_trans, 
	SUBSTR(obter_valor_dominio(1227, a.ie_autorizacao),1,255) ds_autorizacao, 
	a.ie_autorizacao ie_autorizacao, 
	obter_cod_dia_semana(dt_referencia) ie_dia_semana, 
	SUBSTR(obter_valor_dominio(35,obter_cod_dia_semana(dt_referencia)),1,150) ds_dia_semana, 
	obter_dados_motivo_cancel(cd_motivo_canc,'G') ds_grupo_motivo_cancel, 
	obter_dados_motivo_cancel(cd_motivo_canc,'CG') cd_grupo_motivo_cancel, 
	SUBSTR(obter_desc_status_pac_ag(nr_seq_status_pac),1,100) DS_STATUS_PACIENTE, 
	a.nr_seq_status_pac, 
	SUBSTR(obter_grupo_procedimento(a.CD_PROC_PRINC,a.IE_ORIGEM_PROC_PRINC,'C'),1,50) CD_GRUPO_PROC_PRINC, 
	SUBSTR(obter_grupo_procedimento(a.CD_PROC_PRINC,a.IE_ORIGEM_PROC_PRINC,'D'),1,50) DS_GRUPO_PROC_PRINC, 
	SUBSTR(obter_desc_agenda_motivo(a.nr_seq_motivo_bloqueio),1,255) ds_mot_bloq_cons, 
	(LPAD(TO_CHAR(a.hr_inicio),2,'0'))::numeric  hr_inicio_number 
FROM	agenda b, 
	eis_agenda a 
WHERE	a.cd_agenda	= b.cd_agenda 
AND	a.CD_PROC_ADIC	IS NULL 

UNION ALL
 
SELECT	a.DT_REFERENCIA     , 
	a.CD_ESTABELECIMENTO   , 
	a.CD_TIPO_AGENDA     , 
	a.CD_AGENDA       , 
	a.IE_STATUS_AGENDA    , 
	LPAD(TO_CHAR(a.hr_inicio),2,'0') HR_INICIO, 
	LPAD(TO_CHAR(a.hr_inicio),2,'0') hr_inicio_char, 
	a.CD_MOTIVO_CANC     , 
	a.CD_MEDICO       , 
	a.CD_CONVENIO      , 
	a.QT_MIN_DURACAO     , 
	1 QT_AGENDA       , 
	a.IE_CARATER_CIRURGIA  , 
	a.CD_SETOR_ATENDIMENTO, 
	a.NM_USUARIO_AGENDA  , 
	a.CD_PROC_PRINC||' - '||SUBSTR(Obter_Descricao_Procedimento(a.CD_PROC_PRINC,a.IE_ORIGEM_PROC_PRINC),1,50) ds_cod_proced, 
	SUBSTR(Obter_Descricao_Procedimento(a.CD_PROC_PRINC,a.IE_ORIGEM_PROC_PRINC),1,150) ds_procedimento_princ, 
	a.CD_PROC_PRINC     , 
	a.IE_ORIGEM_PROC_PRINC, 
	a.CD_PROC_ADIC||' - '||SUBSTR(Obter_Descricao_Procedimento(a.CD_PROC_ADIC,a.IE_ORIGEM_PROC_ADIC),1,50) ds_cod_proc_adic, 
	SUBSTR(Obter_Descricao_Procedimento(a.CD_PROC_ADIC,a.IE_ORIGEM_PROC_ADIC),1,150) ds_procedimento_adic, 
	a.CD_PROC_ADIC     ,  
	a.IE_ORIGEM_PROC_ADIC  , 
	SUBSTR(obter_desc_clas_agenda_cons(a.IE_CLASSIF_AGENDA),1,150) ds_classif_agenda, 
	a.IE_CLASSIF_AGENDA   , 
	SUBSTR(OBTER_NOME_SETOR(a.CD_SETOR_EXECUCAO),1,150) ds_setor_execucao, 
	a.CD_SETOR_EXECUCAO   , 
	a.hr_inicio ds_inicio, 
	LPAD(TO_CHAR(a.hr_inicio),2,'0') ds_inicio_char, 
	obter_descricao_padrao('AGENDA','DS_AGENDA',a.CD_AGENDA) ds_agenda, 
	obter_nome_convenio(a.cd_convenio) ds_convenio, 
	SUBSTR(obter_motivo_canc_agecons(cd_motivo_canc,'D'),1,255) ds_motivo_cancelamento, 
	SUBSTR(obter_motivo_canc_agecir(cd_motivo_canc,'D'),1,255) ds_motivo_cancel_cirur, 
/*	obter_valor_dominio(1011, a.cd_motivo_canc) ds_motivo_cancelamento,*/
 
	obter_nome_pessoa_fisica(a.cd_medico, NULL) nm_medico, 
	obter_valor_dominio(83, a.ie_status_agenda) ds_status, 
	obter_valor_dominio(34, a.cd_tipo_agenda) ds_tipo_agenda, 
	obter_nome_pf(b.cd_pessoa_fisica) nm_medico_agenda, 
	SUBSTR(obter_valor_dominio(1016, a.ie_carater_cirurgia),1,15) ds_carater_cirurgia, 
	obter_nome_setor(cd_setor_atendimento) ds_setor_atendimento, 
	SUBSTR(obter_nome_setor(a.cd_setor_exclusivo),1,100) ds_setor_exclusivo, 
	Obter_Tipo_Convenio(a.CD_CONVENIO) cd_tipo_convenio, 
	SUBSTR(obter_valor_dominio(11, Obter_Tipo_Convenio(a.CD_CONVENIO)),1,100) ds_tipo_convenio, 
	SUBSTR(Obter_Desc_Sala_Consulta(nr_seq_sala),1,150) ds_sala, 
	SUBSTR(obter_desc_classif_agenda_pac(nr_seq_classif_agenda),1,80) ds_classificacao, 
	a.nr_seq_classif_agenda, 
	ie_tipo_proc_agenda, 
	a.NR_SEQ_SALA, 
	a.nm_usuario_original, 
	SUBSTR(obter_descricao_padrao('TIPO_INDICACAO', 'DS_INDICACAO', a.NR_SEQ_INDICACAO),1,100) ds_tipo_indicacao, 
	a.NR_SEQ_INDICACAO, 
	obter_intervalo_minutos(qt_aguardando) ds_min_espera, 
	obter_intervalo_minutos(qt_consulta) ds_min_consulta, 
	SUBSTR(obter_desc_proc_interno(nr_seq_proc_interno),1,200) ds_proc_interno, 
	SUBSTR(obter_desc_int_proc(cd_proc_princ, ie_origem_proc_princ),1,200) ds_proced_princ_int, 
	SUBSTR(obter_desc_int_proc(cd_proc_adic, ie_origem_proc_adic),1,200) ds_proced_adic_int, 
	SUBSTR(obter_valor_dominio(1372, ie_lado),1,200) ds_lado, 
	ie_lado, 
	SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	SUBSTR(obter_especialidade_medico(a.cd_medico,'D'),1,80) ds_especialidade, 
	CASE WHEN a.ie_status_agenda='C' THEN a.QT_MIN_DURACAO  ELSE 0 END  qt_min_duracao_canc, 
	CASE WHEN ie_status_agenda='C' THEN 1  ELSE 0 END  qt_cancelada, 
	CASE WHEN ie_status_agenda='E' THEN 1  ELSE 0 END  qt_executada, 
	CASE WHEN ie_status_agenda='L' THEN 1  ELSE 0 END  qt_livre, 
	CASE WHEN ie_status_agenda='A' THEN 1  ELSE 0 END  qt_aguardando, 
	CASE WHEN ie_status_agenda='N' THEN 1  ELSE 0 END  qt_normal, 
	CASE WHEN ie_status_agenda='AD' THEN 1  ELSE 0 END  qt_atendido, 
	CASE WHEN ie_status_agenda='F' THEN 1  ELSE 0 END  qt_falta_just, 
	CASE WHEN ie_status_agenda='O' THEN 1  ELSE 0 END  qt_em_atendimento, 
	CASE WHEN ie_status_agenda='I' THEN 1  ELSE 0 END  qt_falt_n_just, 
	CASE WHEN obter_dados_cirurgia(a.nr_cirurgia,'DT') IS NULL THEN 0  ELSE 1 END  qt_finalizada, 
	obter_empresa_estab(a.cd_estabelecimento) cd_empresa, 
	b.ds_curta, 
	b.ds_complemento, 
	a.qt_atendimento, 
	a.cd_procedencia, 
	SUBSTR(coalesce(obter_desc_procedencia(a.cd_procedencia),Obter_Desc_Expressao(622834)),1,100) ds_procedencia, 
	SUBSTR(coalesce(sus_obter_complexidade_proced(a.cd_proc_adic, a.ie_origem_proc_adic, 'D'), Obter_Desc_Expressao(327119)),1,255) ds_complexidade, 
	ROUND(((a.dt_chegada - a.dt_agendamento) * 1440),0) qt_tempo_chegada, 
	ROUND(((a.dt_atendimento - a.dt_chegada) * 1440),0) qt_tempo_espera, 
	ROUND(((a.dt_atendimento - a.dt_atendido) * 1440),0) qt_tempo_atendimento, 
	ROUND(((a.dt_em_exame - a.dt_atendido) * 1440),0) qt_tempo_espera_exame, 
	ROUND(((a.dt_executada - a.dt_em_exame) * 1440),0) qt_tempo_em_exame, 
	ROUND(((a.dt_executada - a.dt_agendamento) * 1440),0) qt_tempo_exec, 
	a.cd_setor_exclusivo, 
	a.nr_seq_motivo_trans, 
	SUBSTR(obter_desc_motivo_transf(a.nr_seq_motivo_trans),1,255), 
	a.cd_medico_exec, 
	SUBSTR(obter_nome_pf(a.cd_medico_exec),1,100) nm_medico_exec, 
	a.qt_procedimento, 
	a.ie_tipo_atendimento, 
	SUBSTR(obter_valor_dominio(12,a.ie_tipo_atendimento),1,100) ds_tipo_atendimento, 
	a.ie_forma_agendamento, 
	obter_valor_dominio(2441, a.ie_forma_agendamento) ds_forma_agendamento, 
	SUBSTR(obter_especialidade_medico(a.cd_medico,NULL),1,5) cd_especialidade, 
	a.nm_usuario_confirm, 
	a.nr_seq_motivo_bloqueio, 
	SUBSTR(obter_valor_dominio(1007,a.nr_seq_motivo_bloqueio),1,255) ds_motivo_bloqueio, 
	SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_agenda,'CE'),1,255) cd_estab_usuario, 
	SUBSTR(obter_nome_estabelecimento(obter_dados_usuario_opcao(a.nm_usuario_agenda,'CE')),1,255) ds_estab_usuario, 
	TO_CHAR(a.dt_inicio_agendamento,'hh24') hr_agendamento, 
	a.ie_clinica, 
	SUBSTR(obter_valor_dominio(17,a.ie_clinica),1,100) ds_clinica, 
	a.cd_medico_req, 
	SUBSTR(obter_nome_medico(a.cd_medico_req,'N'),1,255) nm_medico_req, 
	a.ie_classif_tasy, 
	SUBSTR(obter_valor_dominio(1006,a.ie_classif_tasy),1,255) ds_classif_tasy, 
	a.ie_clinica_agenda, 
	SUBSTR(obter_valor_dominio(17,a.ie_clinica_agenda),1,100) ds_clinica_agenda, 
	a.nr_seq_proc_interno, 
	a.nm_usuario_cancelamento, 
	a.nr_seq_area_atuacao, 
	SUBSTR(obter_desc_area_atuacao_medica(a.nr_seq_area_atuacao),1,255) ds_area_atuacao, 
	TO_CHAR(a.dt_confirmacao,'hh24') hr_confirmacao, 
	TO_CHAR(a.dt_agendamento,'hh24') hr_marcacao,	 
	TRUNC(CASE WHEN b.cd_tipo_agenda=2 THEN a.dt_inicio_agendamento  ELSE a.dt_agendamento END ,'dd') dt_agendamento, 
	TRUNC(a.dt_confirmacao,'dd') dt_ref_confirmacao, 
	TO_CHAR(a.dt_cancelamento,'hh24') hr_cancelamento, 
	TRUNC(a.dt_cancelamento,'dd') dt_ref_cancelamento, 
	SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_cancelamento,'CE'),1,255) cd_estab_usuario_canc, 
	SUBSTR(obter_nome_estabelecimento(obter_dados_usuario_opcao(a.nm_usuario_cancelamento,'CE')),1,255) ds_estab_usuario_canc, 
	SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_original,'CE'),1,255) cd_estab_usuario_orig, 
	SUBSTR(obter_nome_estabelecimento(obter_dados_usuario_opcao(a.nm_usuario_original,'CE')),1,255) ds_estab_usuario_orig, 
	SUBSTR(obter_dados_usuario_opcao(a.nm_usuario_confirm,'CE'),1,255) cd_estab_usuario_confirm, 
	SUBSTR(obter_nome_estabelecimento(obter_dados_usuario_opcao(a.nm_usuario_confirm,'CE')),1,255) ds_estab_usuario_confirm, 
	a.cd_especialidade_agenda, 
	SUBSTR(obter_nome_especialidade(a.cd_especialidade_agenda),1,255) ds_especialidade_agenda, 
	ageserv_obter_modelo_agend(a.nr_seq_rp_mod_item,'C') nr_seq_modelo, 
	SUBSTR(ageserv_obter_modelo_agend(a.nr_seq_rp_mod_item,'D'),1,255) ds_modelo, 
	a.ie_atrasado, 
	a.nr_seq_motivo_atraso, 
	SUBSTR(obter_motivo_atraso_pac(a.nr_seq_motivo_atraso,a.cd_estabelecimento),1,255) ds_motivo_atraso, 
	SUBSTR(obter_nome_medico_combo_agcons(b.cd_estabelecimento,b.cd_agenda,b.cd_tipo_agenda,coalesce(b.ie_ordenacao,'N')),1,255) ds_agenda_combo, 
	SUBSTR(obter_desc_clas_curta_cons(a.IE_CLASSIF_AGENDA),1,7) ds_classif_curta, 
	a.cd_categoria, 
	SUBSTR(obter_categoria_convenio(a.cd_convenio,a.cd_categoria),1,255) ds_categoria, 
	a.ie_clinica_pac, 
	SUBSTR(obter_valor_dominio(17,a.ie_clinica_pac),1,255) ds_clinica_pac, 
	SUBSTR(CASE WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='P' THEN Obter_Desc_Expressao(489957) WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='M' THEN Obter_Desc_Expressao(293174) WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='G' THEN  Obter_Desc_Expressao(489958) WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='E' THEN  Obter_Desc_Expressao(289428) WHEN OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno)='S' THEN Obter_Desc_Expressao(298957)  ELSE Obter_Desc_Expressao(327119) END ,1,200) ds_porte, 
	SUBSTR(OBTER_PORTE_PROCEDIMENTO(a.cd_proc_princ,a.ie_origem_proc_princ,a.nr_seq_proc_interno),1,200) ie_porte, 
	a.cd_turno, 
	SUBSTR(CASE WHEN a.cd_turno='0' THEN Obter_Desc_Expressao(487774) WHEN a.cd_turno='1' THEN Obter_Desc_Expressao(487775)  ELSE Obter_Desc_Expressao(308326) END ,1,50) ds_turno, 
	a.nr_seq_origem, 
	SUBSTR(Obter_desc_origem_conv(a.nr_seq_origem),1,60) ds_origem_conv, 
	SUBSTR(obter_grupo_classif(a.ie_classif_agenda,'C'),1,255) nr_seq_grupo_classif, 
	SUBSTR(obter_grupo_classif(a.ie_classif_agenda,'D'),1,255) ds_grupo_classif, 
	a.nr_seq_forma_confirmacao, 
	SUBSTR(obter_desc_forma_conf(a.nr_seq_forma_confirmacao),1,90) ds_forma_confirmacao, 
	SUBSTR(Obter_Nome_Usuario(a.nm_usuario_original),1,255) ds_usuario_original, 
	SUBSTR(Obter_Nome_Usuario(a.nm_usuario_agenda),1,255) ds_usuario_agenda, 
	SUBSTR(Obter_Nome_Usuario(a.nm_usuario_confirm),1,255) ds_usuario_confirm, 
	SUBSTR(Obter_Dados_Usuario_Opcao(a.nm_usuario_cancelamento,'LA'),1,255) ds_login_alternativo, 
	SUBSTR(Obter_Dados_Usuario_Opcao(a.nm_usuario_confirm,'LA'),1,255) ds_login_alt_confirm, 
	SUBSTR(Obter_Dados_Usuario_Opcao(a.nm_usuario_original,'LA'),1,255) ds_login_alt_orig, 
	a.dt_copia_trans, 
	SUBSTR(obter_valor_dominio(1227, a.ie_autorizacao),1,255) ds_autorizacao, 
	a.ie_autorizacao ie_autorizacao, 
	obter_cod_dia_semana(dt_referencia) ie_dia_semana, 
	SUBSTR(obter_valor_dominio(35,obter_cod_dia_semana(dt_referencia)),1,150) ds_dia_semana, 
	obter_dados_motivo_cancel(cd_motivo_canc,'G') DS_GRUPO_MOTIVO_CANCEL, 
	obter_dados_motivo_cancel(cd_motivo_canc,'CG') cd_grupo_motivo_cancel, 
	SUBSTR(obter_desc_status_pac_ag(a.nr_seq_status_pac),1,100) DS_STATUS_PACIENTE, 
	a.nr_seq_status_pac, 
	SUBSTR(obter_grupo_procedimento(a.CD_PROC_PRINC,a.IE_ORIGEM_PROC_PRINC,'C'),1,50) CD_GRUPO_PROC_PRINC, 
	SUBSTR(obter_grupo_procedimento(a.CD_PROC_PRINC,a.IE_ORIGEM_PROC_PRINC,'D'),1,50) DS_GRUPO_PROC_PRINC, 
	SUBSTR(obter_desc_agenda_motivo(a.nr_seq_motivo_bloqueio),1,255) DS_MOT_BLOQ_CONS, 
	(LPAD(TO_CHAR(a.hr_inicio),2,'0'))::numeric  hr_inicio_number 
FROM	agenda b, 
	eis_agenda a 
WHERE	a.cd_agenda	= b.cd_agenda 
AND	a.CD_PROC_ADIC	IS NOT NULL;

