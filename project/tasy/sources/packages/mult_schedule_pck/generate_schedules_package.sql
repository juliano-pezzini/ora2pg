-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE ScheduleMainProperties AS (
			nr_seq_agenda			agenda_paciente.nr_sequencia%type,
			cd_agenda				agenda.cd_agenda%type,
			cd_tipo_agenda			agenda.cd_tipo_agenda%type,
			dt_agenda				timestamp,
			ie_status_agenda		agenda_paciente.ie_status_agenda%type,
			ds_agenda				varchar(500),
			nr_minuto_duracao		agenda_paciente.nr_minuto_duracao%type,
			cd_paciente				pessoa_fisica.cd_pessoa_fisica%type,
			cd_medico				pessoa_fisica.cd_pessoa_fisica%type,
			cd_medico_req			pessoa_fisica.cd_pessoa_fisica%type,
			cd_convenio				convenio.cd_convenio%type,
			nr_atendimento			atendimento_paciente.nr_atendimento%type,
			nr_seq_proc_interno		agenda_paciente.nr_seq_proc_interno%type,
			hr_inicio				varchar(50),
			hr_fim					varchar(50),
			nr_seq_horario			agenda_paciente.nr_seq_horario%type,
			ie_agendamento_grupo	varchar(1)
	);
CREATE TYPE ScheduleProperties AS (
		nr_seq_agenda 			agenda_paciente.nr_sequencia%type,
		cd_especialidade 		agenda_consulta.cd_especialidade%type,
		ds_especialidade 		varchar(255),
		nr_seq_classif_agenda 	agenda_paciente.nr_seq_classif_agenda%type,
		ds_classificacao 		varchar(255),
		ds_motivo_bloqueio 		varchar(500),
		ds_indicacao 			varchar(2500),
		ie_delay_check 			varchar(1),
		qt_delaying_time		bigint,
		nr_seq_interno			agenda_paciente.nr_seq_interno%type,
		ie_status_laudo 		varchar(500),
		nr_acesso_dicom 		bigint,
		nr_seq_lista_espera 	agenda_paciente.nr_seq_lista%type,
		ie_sexo_paciente 		varchar(255),
		cd_sexo_paciente 		varchar(255),
		nm_paciente 			varchar(500),
		dt_nascimento 			varchar(150),
		cd_medico 				pessoa_fisica.cd_pessoa_fisica%type,
		nm_medico 				varchar(500),
		nm_medico_req 			varchar(500),
		ds_status_agenda 		varchar(255),
		dt_confirmacao 			timestamp,
		cd_procedimento 		procedimento.cd_procedimento%type,
		ie_origem_proced 		procedimento.ie_origem_proced%type,
		ds_procedimento 		varchar(500),
		nm_contato 				varchar(500),
		nr_telefone 			varchar(150),
		dt_nascto_pac 			varchar(150),
		nm_usuario 				agenda_paciente.nm_usuario%type,
		nr_seq_ageint			agenda_integrada_item.nr_sequencia%type,
		nr_sequencia_ageint		agenda_integrada.nr_sequencia%type,
		cd_convenio  			convenio.cd_convenio%type,
		ds_convenio				varchar(255),
		ds_tipo_convenio 		varchar(255),
		nr_episodio				varchar(15),
		ds_setor_atendimento    varchar(255),
		ds_departamento_medico 	varchar(255),
		ie_planned				varchar(10),
		ds_tipo_episodio 		varchar(255),
		nr_atend_discharge 		atendimento_paciente.nr_atendimento%type,
		ie_urgencia_cpoe 		varchar(2),
		ds_observacao 			varchar(600),
		nm_pessoa_contato 		varchar(255),
		ie_encaixe 				varchar(255),
		nr_seq_episodio 		bigint,
		dt_nascimento_pac		timestamp,
		ie_paciente_isolado		varchar(255),
		nr_seq_person_name		agenda_paciente.nr_seq_person_name%type,
		ie_sc_color 			varchar(255)
		);


CREATE OR REPLACE PROCEDURE mult_schedule_pck.generate_schedules (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_agendas_p text, dt_agenda_inicial_p timestamp, dt_agenda_final_p timestamp, nm_usuario_p usuario.nm_usuario%type, ie_sem_atendimento_p text) AS $body$
DECLARE

	
	ds_sql_completo_w		varchar(30000);
	ds_sql_fields_w			varchar(30000);
	ds_sql_main_w			varchar(30000);
	ds_sql_query_w			varchar(30000);
			
	type schedule_main_data is table of ScheduleMainProperties;
	main 		schedule_main_data;
	
	type schedule_data is table of ScheduleProperties;
	properties 		schedule_data;	
	
	
BEGIN
		/* Clear old registers */

		CALL exec_sql_dinamico(nm_usuario_p, 'truncate table w_mult_schedule_t');	
		
		/* Generate new registers */

		ds_sql_main_w	:=	mult_schedule_pck.get_main_informations(cd_estabelecimento_p, cd_agendas_p, dt_agenda_inicial_p, dt_agenda_final_p, nm_usuario_p, ie_sem_atendimento_p);
		
		EXECUTE ds_sql_main_w bulk collect into STRICT main;
		
		if (main.count > 0) then
			for m in main.first..main.last loop
				if (main[m].nr_seq_horario > 0 ) then
					CALL mult_schedule_pck.insert_registers(main[m].cd_agenda,
									 main[m].cd_tipo_agenda,
									 main[m].dt_agenda,
									 main[m].ie_status_agenda,
									 main[m].ds_agenda,
									 null,
									 main[m].nr_seq_agenda,
									 null,
									 main[m].nr_seq_horario,
									 main[m].hr_inicio,
									 main[m].hr_fim,
									 main[m].ie_agendamento_grupo,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 main[m].nr_minuto_duracao,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 null,
									 nm_usuario_p
									);
				else			   
					ds_sql_fields_w     :=  mult_schedule_pck.get_all_informations(
																 main[m].cd_agenda, 
																 main[m].dt_agenda, 
																 main[m].nr_seq_agenda,
																 main[m].cd_tipo_agenda,
																 nm_usuario_p, 
																 main[m].cd_paciente,
																 main[m].cd_medico,
																 main[m].cd_medico_req,
																 main[m].cd_convenio,
																 main[m].nr_atendimento,
																 main[m].nr_seq_proc_interno,
																 main[m].hr_inicio,
																 main[m].hr_fim,
																 cd_estabelecimento_p
																 );
					ds_sql_query_w		:=  mult_schedule_pck.get_sql_query(main[m].nr_seq_agenda, main[m].cd_tipo_agenda, ie_sem_atendimento_p);
					ds_sql_completo_w   :=  ds_sql_fields_w || ds_sql_query_w;
					
					EXECUTE ds_sql_completo_w bulk collect into STRICT properties;
					
					if (properties.count > 0) then
						for i in properties.first..properties.last loop
							CALL mult_schedule_pck.insert_registers(   main[m].cd_agenda,
												main[m].cd_tipo_agenda,
												main[m].dt_agenda,
												main[m].ie_status_agenda,
												main[m].ds_agenda,
												main[m].cd_paciente,
												main[m].nr_seq_agenda,
												main[m].nr_seq_proc_interno,
												main[m].nr_seq_horario,
												main[m].hr_inicio,
												main[m].hr_fim,
												main[m].ie_agendamento_grupo,
												properties[i].cd_especialidade,
												properties[i].ds_especialidade,
												properties[i].nr_seq_classif_agenda,
												properties[i].ds_classificacao,
												properties[i].ds_motivo_bloqueio,
												properties[i].ds_indicacao,
												properties[i].ie_delay_check,
												properties[i].qt_delaying_time,
												properties[i].nr_seq_interno,
												properties[i].ie_status_laudo,
												properties[i].nr_acesso_dicom,
												properties[i].nr_seq_lista_espera,
												properties[i].ie_sexo_paciente,
												properties[i].cd_sexo_paciente,
												properties[i].nm_paciente,
												properties[i].dt_nascimento,
												properties[i].cd_medico,
												main[m].cd_medico_req,
												properties[i].nm_medico,
												properties[i].nm_medico_req,
												main[m].nr_minuto_duracao,
												properties[i].ds_status_agenda,
												properties[i].dt_confirmacao,
												main[m].nr_atendimento,
												properties[i].cd_procedimento,
												properties[i].ie_origem_proced,
												properties[i].ds_procedimento,
												properties[i].nm_contato,
												properties[i].nr_telefone,
												properties[i].dt_nascto_pac,
												properties[i].nm_usuario,
												properties[i].nr_seq_ageint,
												properties[i].nr_sequencia_ageint,
												properties[i].cd_convenio,
												properties[i].ds_convenio,
												properties[i].ds_tipo_convenio,
												properties[i].nr_episodio,
												properties[i].ds_setor_atendimento,
												properties[i].ds_departamento_medico,
												properties[i].ie_planned,
												properties[i].ds_tipo_episodio,
												properties[i].nr_atend_discharge,
												properties[i].ie_urgencia_cpoe,
												properties[i].ds_observacao,
												properties[i].ie_encaixe,
												properties[i].ie_encaixe,
												properties[i].nr_seq_episodio,
												properties[i].dt_nascimento_pac,
												properties[i].ie_paciente_isolado,
												properties[i].nr_seq_person_name,
												properties[i].ie_sc_color,
												nm_usuario_p
											);
						end loop;
					end if;	
				end if;
			end loop;
		end if;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mult_schedule_pck.generate_schedules (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_agendas_p text, dt_agenda_inicial_p timestamp, dt_agenda_final_p timestamp, nm_usuario_p usuario.nm_usuario%type, ie_sem_atendimento_p text) FROM PUBLIC;
