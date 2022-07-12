-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION schedule_daily_calendar_pck.get_data ( dt_filter_p agenda_paciente.dt_agenda%type, cd_anestesista_p agenda_paciente.cd_anestesista%type, cd_medico_p agenda_paciente.cd_medico%type, cd_procedimento_p agenda_paciente.cd_procedimento%type, nr_seq_proc_interno_p agenda_paciente.nr_seq_proc_interno%type, ie_origem_proced_p agenda_paciente.ie_origem_proced%type, ie_status_agenda_p agenda_paciente.ie_status_agenda%type, cd_turno_p agenda_paciente.cd_turno%type, cd_pessoa_fisica_p agenda_paciente.cd_pessoa_fisica%type, cd_agendas_p text, ds_health_funds_p text, hr_inicio_p agenda_paciente.hr_inicio%type, hr_final_p timestamp, ie_horario_p text, cd_departamento_medico_p agenda_horario.cd_departamento_medico%type, ie_carater_p agenda_paciente.ie_carater_cirurgia%type, ie_horarios_p text, ds_regra_p text, ie_status_autor_p agenda_pac_opme.ie_autorizado%type, qt_tempo_p agenda_paciente.nr_minuto_duracao%type, cd_depto_pac_p agenda_paciente_auxiliar.cd_depto_medico%type, cd_convenio_p agenda_paciente.cd_convenio%type, ie_opme_pend_p text, nr_sequencia_p agenda_paciente.nr_sequencia%type, nr_reserva_p agenda_paciente.nr_reserva%type) RETURNS SETOF TIMESLOT_RECORD_DATA AS $body$
DECLARE


ds_where_w 		varchar(4000);
timeslot_record_data_w	timeslot_record_data;
timeslot_record_type_w 	timeslot_record_type;

BEGIN

	if (pkg_i18n.get_user_locale in ('de_DE', 'de_AT')) then
		ds_where_w := schedule_daily_calendar_pck.get_data_germany(	dt_filter_p,
						cd_anestesista_p,
						cd_medico_p,
						cd_procedimento_p,
						nr_seq_proc_interno_p,
						ie_origem_proced_p,
						ie_status_agenda_p,
						cd_turno_p,
						cd_pessoa_fisica_p,
						cd_agendas_p,
						ds_health_funds_p,
						hr_inicio_p,
						hr_final_p,
						ie_horario_p,
						cd_departamento_medico_p,
						ie_carater_p,
						ie_horarios_p,
						ds_regra_p,
						ie_status_autor_p,
						qt_tempo_p,
						cd_depto_pac_p,
						cd_convenio_p,
						ie_opme_pend_p,
						nr_sequencia_p,
						nr_reserva_p);
	else
		ds_where_w := schedule_daily_calendar_pck.get_data_global(	dt_filter_p,
						cd_anestesista_p,
						cd_medico_p,
						cd_procedimento_p,
						nr_seq_proc_interno_p,
						ie_origem_proced_p,
						ie_status_agenda_p,
						cd_turno_p,
						cd_pessoa_fisica_p,
						cd_agendas_p,
						ds_health_funds_p,
                        cd_departamento_medico_p);
	end if;

	begin


		EXECUTE current_setting('schedule_daily_calendar_pck.ds_binds_w')::varchar(4000) || current_setting('schedule_daily_calendar_pck.ds_select_query_w')::varchar(4000) || ds_where_w
		bulk collect into STRICT timeslot_record_data_w
		using dt_filter_p, hr_inicio_p, hr_final_p;

		for indx in timeslot_record_data_w.first .. timeslot_record_data_w.last
		loop
			timeslot_record_type_w.date_of_birth 				:= timeslot_record_data_w[indx].date_of_birth;
			timeslot_record_type_w.patient_gender 				:= timeslot_record_data_w[indx].patient_gender;
			timeslot_record_type_w.procedure_desc 				:= timeslot_record_data_w[indx].procedure_desc;
			timeslot_record_type_w.internal_procedure_desc			:= timeslot_record_data_w[indx].internal_procedure_desc;
			timeslot_record_type_w.doctor_name 				:= timeslot_record_data_w[indx].doctor_name;
			timeslot_record_type_w.anest_name 				:= timeslot_record_data_w[indx].anest_name;
			timeslot_record_type_w.anesthesia_type 				:= timeslot_record_data_w[indx].anesthesia_type;
			timeslot_record_type_w.schedule_name				:= timeslot_record_data_w[indx].schedule_name;
			timeslot_record_type_w.rfc_code 				:= timeslot_record_data_w[indx].rfc_code;
			timeslot_record_type_w.ie_agenda_perm_cirur_param		:= timeslot_record_data_w[indx].ie_agenda_perm_cirur_param;
			timeslot_record_type_w.ie_agenda_regra_dia 			:= timeslot_record_data_w[indx].ie_agenda_regra_dia;
			timeslot_record_type_w.age 					:= timeslot_record_data_w[indx].age;
			timeslot_record_type_w.ie_autor_desdobrada 			:= timeslot_record_data_w[indx].ie_autor_desdobrada;
			timeslot_record_type_w.ie_tipo_classif 				:= timeslot_record_data_w[indx].ie_tipo_classif;
			timeslot_record_type_w.patient_alerts 				:= timeslot_record_data_w[indx].patient_alerts;
			timeslot_record_type_w.nr_seq_apresent 				:= timeslot_record_data_w[indx].nr_seq_apresent;
			timeslot_record_type_w.ie_evento_cir_pac 			:= timeslot_record_data_w[indx].ie_evento_cir_pac;
			timeslot_record_type_w.ie_status_agenda 			:= timeslot_record_data_w[indx].ie_status_agenda;
			timeslot_record_type_w.cd_agenda 				:= timeslot_record_data_w[indx].cd_agenda;
			timeslot_record_type_w.nr_sequencia 				:= timeslot_record_data_w[indx].nr_sequencia;
			timeslot_record_type_w.nm_paciente 				:= timeslot_record_data_w[indx].nm_paciente;
			timeslot_record_type_w.nr_atendimento 				:= timeslot_record_data_w[indx].nr_atendimento;
			timeslot_record_type_w.nr_cirurgia 				:= timeslot_record_data_w[indx].nr_cirurgia;
			timeslot_record_type_w.dt_agenda 				:= timeslot_record_data_w[indx].dt_agenda;
			timeslot_record_type_w.hr_inicio 				:= timeslot_record_data_w[indx].hr_inicio;
			timeslot_record_type_w.cd_convenio 				:= timeslot_record_data_w[indx].cd_convenio;
			timeslot_record_type_w.cd_tipo_acomodacao			:= timeslot_record_data_w[indx].cd_tipo_acomodacao;
			timeslot_record_type_w.cd_pessoa_fisica 			:= timeslot_record_data_w[indx].cd_pessoa_fisica;
			timeslot_record_type_w.dt_confirmacao				:= timeslot_record_data_w[indx].dt_confirmacao;
			timeslot_record_type_w.ie_autorizacao				:= timeslot_record_data_w[indx].ie_autorizacao;
			timeslot_record_type_w.nr_minuto_duracao			:= timeslot_record_data_w[indx].nr_minuto_duracao;
			timeslot_record_type_w.ie_schedule_closed			:= timeslot_record_data_w[indx].ie_schedule_closed;
			timeslot_record_type_w.ie_lado					:= timeslot_record_data_w[indx].ie_lado;
			timeslot_record_type_w.dt_nascimento_pac			:= timeslot_record_data_w[indx].dt_nascimento_pac;
			timeslot_record_type_w.cd_setor_origem				:= timeslot_record_data_w[indx].cd_setor_origem;
			timeslot_record_type_w.cd_doenca_cid				:= timeslot_record_data_w[indx].cd_doenca_cid;
			timeslot_record_type_w.ds_observacao				:= timeslot_record_data_w[indx].ds_observacao;
			timeslot_record_type_w.nr_seq_proc_interno			:= timeslot_record_data_w[indx].nr_seq_proc_interno;
			timeslot_record_type_w.cd_setor_atendimento			:= timeslot_record_data_w[indx].cd_setor_atendimento;
			timeslot_record_type_w.ds_setor_atendimento			:= timeslot_record_data_w[indx].ds_setor_atendimento;
			timeslot_record_type_w.dt_agendamento				:= timeslot_record_data_w[indx].dt_agendamento;
			timeslot_record_type_w.ds_week					:= timeslot_record_data_w[indx].ds_week;
			timeslot_record_type_w.ds_popover_info				:= timeslot_record_data_w[indx].ds_popover_info;
			timeslot_record_type_w.ds_card_info				:= timeslot_record_data_w[indx].ds_card_info;
   			timeslot_record_type_w.ie_allergy				:= timeslot_record_data_w[indx].ie_allergy;
   			timeslot_record_type_w.ie_isolation				:= timeslot_record_data_w[indx].ie_isolation;
            timeslot_record_type_w.ie_sexo				    := timeslot_record_data_w[indx].ie_sexo;
            timeslot_record_type_w.IE_CONTIDO_HORARIO_SALA	:= timeslot_record_data_w[indx].IE_CONTIDO_HORARIO_SALA;
            timeslot_record_type_w.dt_bloqueio_faturamento	:= timeslot_record_data_w[indx].dt_bloqueio_faturamento;
            timeslot_record_type_w.dt_bloqueio	            := timeslot_record_data_w[indx].dt_bloqueio;
            timeslot_record_type_w.cd_medico	            := timeslot_record_data_w[indx].cd_medico;
            timeslot_record_type_w.ie_tipo_atendimento      := timeslot_record_data_w[indx].ie_tipo_atendimento;
            timeslot_record_type_w.cd_categoria             := timeslot_record_data_w[indx].cd_categoria;
			timeslot_record_type_w.ie_horario_passado       := timeslot_record_data_w[indx].ie_horario_passado;
            timeslot_record_type_w.CD_PROCEDIMENTO	        := timeslot_record_data_w[indx].CD_PROCEDIMENTO;
            timeslot_record_type_w.nr_prescr_agenda	        := timeslot_record_data_w[indx].nr_prescr_agenda;

			RETURN NEXT timeslot_record_type_w;
		end loop;
	exception
		when others then
			return;
	end;

	return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION schedule_daily_calendar_pck.get_data ( dt_filter_p agenda_paciente.dt_agenda%type, cd_anestesista_p agenda_paciente.cd_anestesista%type, cd_medico_p agenda_paciente.cd_medico%type, cd_procedimento_p agenda_paciente.cd_procedimento%type, nr_seq_proc_interno_p agenda_paciente.nr_seq_proc_interno%type, ie_origem_proced_p agenda_paciente.ie_origem_proced%type, ie_status_agenda_p agenda_paciente.ie_status_agenda%type, cd_turno_p agenda_paciente.cd_turno%type, cd_pessoa_fisica_p agenda_paciente.cd_pessoa_fisica%type, cd_agendas_p text, ds_health_funds_p text, hr_inicio_p agenda_paciente.hr_inicio%type, hr_final_p timestamp, ie_horario_p text, cd_departamento_medico_p agenda_horario.cd_departamento_medico%type, ie_carater_p agenda_paciente.ie_carater_cirurgia%type, ie_horarios_p text, ds_regra_p text, ie_status_autor_p agenda_pac_opme.ie_autorizado%type, qt_tempo_p agenda_paciente.nr_minuto_duracao%type, cd_depto_pac_p agenda_paciente_auxiliar.cd_depto_medico%type, cd_convenio_p agenda_paciente.cd_convenio%type, ie_opme_pend_p text, nr_sequencia_p agenda_paciente.nr_sequencia%type, nr_reserva_p agenda_paciente.nr_reserva%type) FROM PUBLIC;
