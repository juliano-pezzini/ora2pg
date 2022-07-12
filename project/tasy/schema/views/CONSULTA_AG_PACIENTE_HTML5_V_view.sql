-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW consulta_ag_paciente_html5_v (cd_agenda, ds_agenda, dt_agenda, nr_sequencia, hr_inicio, nm_paciente, ds_convenio, cd_convenio, nm_medico, cd_medico, nm_medico_exec, cd_medico_exec, nm_anestesista, cd_anestesista, ie_carater_cirurgia, ds_status_agenda, nr_atendimento, ds_procedimento, nr_seq_proc_interno, ie_origem_proced, cd_procedimento, ds_observacao, ds_motivo_cancelamento, dt_limite_agenda, ie_status_agenda, dt_confirmacao, dt_servico, nr_cirurgia, nm_regra, cd_usuario_convenio, cd_pessoa_fisica, nr_reserva, dt_agendamento, ds_senha, ie_autorizacao, cd_turno, ie_tipo_atendimento, cd_procedencia, dt_bloqueio_faturamento) AS select	a.cd_agenda,
	a.ds_agenda,
	b.dt_agenda,
	b.nr_sequencia,
	to_date(to_char(b.dt_agenda,'dd/mm/yyyy') || ' ' || to_char(b.hr_inicio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') hr_inicio,
	coalesce(substr(obter_nome_pf(b.cd_pessoa_fisica),1,60), substr(b.nm_paciente,1,60)) nm_paciente,
	substr(obter_nome_convenio(b.cd_convenio),1,40) ds_convenio,
	b.cd_convenio,
	substr(obter_nome_pf(b.cd_medico),1,60) nm_medico,
	b.cd_medico,
	substr(obter_nome_pf(b.cd_medico_exec),1,60) nm_medico_exec,
	b.cd_medico_exec,
	substr(obter_nome_pf(b.cd_anestesista),1,60) nm_anestesista,
	b.cd_anestesista,
  substr(obter_valor_dominio(1016,b.ie_carater_cirurgia),1,100) ie_carater_cirurgia,
	substr(obter_valor_dominio(83,b.ie_status_agenda),1,30) ds_status_agenda,
	b.nr_atendimento,
	substr(obter_exame_agenda(b.cd_procedimento, b.ie_origem_proced, b.nr_seq_proc_interno),1,240) ds_procedimento,
	b.nr_seq_proc_interno,
	b.ie_origem_proced,
	b.cd_procedimento,
	substr(b.ds_observacao,1,240) ds_observacao,
	substr(obter_motivo_agenda(b.nr_sequencia),1,255) ds_motivo_cancelamento,
	b.dt_limite_agenda,
	b.ie_status_agenda,
	b.dt_confirmacao,
	substr(to_char(obter_data_agenda_servico(b.nr_sequencia),'dd/mm/yyyy hh24:mi:ss'),1,30) dt_servico,
	b.nr_cirurgia,
  SUBSTR(obter_regra_agenda_cirurgica(b.cd_agenda,b.cd_turno,b.hr_inicio),1,255) nm_regra,
	CD_USUARIO_CONVENIO,
	b.cd_pessoa_fisica cd_pessoa_fisica,
	b.nr_reserva,
	b.dt_agendamento,
	b.ds_senha,
	b.ie_autorizacao,
   b.cd_turno,
   b.ie_tipo_atendimento,
   b.cd_procedencia,
   b.dt_bloqueio_faturamento
FROM	agenda a,
	agenda_paciente b
where	a.cd_agenda = b.cd_agenda
and	a.cd_tipo_agenda = 1;

