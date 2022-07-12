-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_interface_pck.unexecutedorder_surgery (nr_seq_registro_p bigint, ds_file_output_p INOUT text, ie_tipo_file_p text) AS $body$
DECLARE

	current_setting('nais_interface_pck.nm_usuario_w')::varchar(20)     varchar(10);
    ward_code_w      NAIS_CONVERSION_MASTER%ROWTYPE;
	nm_maquina_w     varchar(10);
	cd_department_w  varchar(10);
	cd_especialidade_w  varchar(10);
	cd_dept_affair_w    nais_conversion_master%rowtype;

	c01 CURSOR FOR
		SELECT	current_setting('nais_interface_pck.nr_serial_w')::bigint serial_number,
				'H' system_code,
				'MJ' message_type_code,
				'E' continuation_flag, 
				'M' destination_code,
				'D' sender_code,
				clock_timestamp() processing_date,
				clock_timestamp() processing_time,
				coalesce(nm_maquina_w, ' ') device_name,
				coalesce(current_setting('nais_interface_pck.nm_usuario_w')::varchar(20), ' ') user_number, 
				current_setting('nais_interface_pck.ie_processing_classification_w')::varchar(32556) processing_classification,
				' ' response_class,
				810  telegram_length,
				' ' eot,
				' ' med_institution_code,
				' ' blankitution_code,
				' ' blank
		;

	c02 CURSOR FOR
		SELECT
			'01' processing_classification,                          
			'S0' order_class,
			a.nr_order_patient_seq order_number,                                   
			substr(obter_prontuario_pf(obter_estab_atend(c.nr_atendimento),c.cd_pessoa_fisica),1,10) patient_id,
			to_char(c.dt_inicio, 'YYYYMMDD') dt_of_consultation, 
			coalesce(cd_dept_affair_w.cd_medical_affair, '00') department_code,
			CASE WHEN get_patient_type(v.encounter_id, NULL)='IN' THEN  2 WHEN get_patient_type(v.encounter_id, NULL)='OP' THEN  1 END                     inpatient_outpatient,
            CASE WHEN get_patient_type(v.encounter_id, NULL) ='IN' THEN coalesce(v.bed_id, ' ') WHEN get_patient_type(v.encounter_id, NULL) ='OP' THEN  ' ' END   ward_code,                 
            CASE WHEN get_patient_type(v.encounter_id, NULL) ='IN' THEN coalesce(v.room_id, ' ') WHEN get_patient_type(v.encounter_id, NULL) ='OP' THEN  ' ' END  room_number,  
			1 medical_dental,         
			0 applied_insurance_sel_num,
			f.cd_medico doctor_code,
			' ' newborn,
			' ' prescription_classification,
			' ' requestor,
			' ' exclusion_control,
			' ' medical_department_number,
			' ' blank,
			' ' blank_01,
			' ' execution_classification,
			to_char(c.dt_inicio, 'YYYYMMDD')  scheduled_date_of_execution,
			to_char(c.dt_inicio, 'HH24MI') schedule_time_of_execution,
			' ' executing_operator_code,
			' ' execution_update_flag,
			'000000' weight,
			' ' off_hours_flag,
			' ' blank_02,
			' ' slip_code, 
			0 number_of_details,
			' ' medical_treatment_detail_01, 
			' ' medical_treatment_detail_02, 
			' ' medical_treatment_detail_03, 
			' ' medical_treatment_detail_04, 
			' ' medical_treatment_detail_05, 
			' ' medical_treatment_detail_06, 
			' ' medical_treatment_detail_07, 
			' ' medical_treatment_detail_08, 
			' ' medical_treatment_detail_09, 
			' ' medical_treatment_detail_10, 
			' ' blank_03,
			' ' eot      
		from 
			cpoe_order_unit a,
			cpoe_tipo_pedido b,
			cpoe_procedimento c,
			prescr_procedimento d,               
			prescr_medica f,
			atendimento_paciente g,
            bft_encounter_v v
		where
			a.nr_seq_cpoe_tipo_pedido = b.nr_sequencia
			and a.nr_sequencia 		  = c.nr_seq_cpoe_order_unit    
			and c.nr_sequencia 		  = d.nr_seq_proc_cpoe
			and d.nr_prescricao       = f.nr_prescricao
			and a.nr_atendimento      = g.nr_atendimento
            and a.nr_atendimento      = v.encounter_id
			and b.nr_seq_sub_grp      = 'S'
			and d.nr_seq_interno      = (SELECT max(y.nr_seq_interno) from prescr_procedimento y where y.nr_prescricao = nr_seq_registro_p)
			and   ie_tipo_file_p       like '%unexecutedOrderMessageRequestSurgery%'		
	
union all
		
		select  
			'03' processing_classification,                          
			'S0' order_class,
			a.nr_order_patient_seq order_number,                                   
			substr(obter_prontuario_pf(obter_estab_atend(c.nr_atendimento),c.cd_pessoa_fisica),1,10) patient_id,
			to_char(c.dt_inicio, 'YYYYMMDD') dt_of_consultation, 
			coalesce(cd_dept_affair_w.cd_medical_affair, '00') department_code,
            CASE WHEN get_patient_type(v.encounter_id, NULL)='IN' THEN  2 WHEN get_patient_type(v.encounter_id, NULL)='OP' THEN  1 END                     inpatient_outpatient,
            CASE WHEN get_patient_type(v.encounter_id, NULL) ='IN' THEN coalesce(v.bed_id, ' ') WHEN get_patient_type(v.encounter_id, NULL) ='OP' THEN  ' ' END   ward_code,                 
            CASE WHEN get_patient_type(v.encounter_id, NULL) ='IN' THEN coalesce(v.room_id, ' ') WHEN get_patient_type(v.encounter_id, NULL) ='OP' THEN  ' ' END  room_number,
			1 medical_dental,         
			0 applied_insurance_sel_num,
			f.cd_medico doctor_code,
			' ' newborn,
			' ' prescription_classification,
			' ' requestor,
			' ' exclusion_control,
			' ' medical_department_number,
			' ' blank,
			' ' blank_01,
			' ' execution_classification,
			to_char(c.dt_inicio, 'YYYYMMDD')  scheduled_date_of_execution,
			to_char(c.dt_inicio, 'HH24MI') schedule_time_of_execution,
			' ' executing_operator_code,
			' ' execution_update_flag,
			'000000' weight,
			' ' off_hours_flag,
			' ' blank_02,
			' ' slip_code, 
			0 number_of_details,
			' ' medical_treatment_detail_01, 
			' ' medical_treatment_detail_02, 
			' ' medical_treatment_detail_03, 
			' ' medical_treatment_detail_04, 
			' ' medical_treatment_detail_05, 
			' ' medical_treatment_detail_06, 
			' ' medical_treatment_detail_07, 
			' ' medical_treatment_detail_08, 
			' ' medical_treatment_detail_09, 
			' ' medical_treatment_detail_10, 
			' ' blank_03,
			' ' eot      
		from 
			cpoe_order_unit a,
			cpoe_tipo_pedido b,
			cpoe_procedimento c,
			prescr_procedimento d,             
			prescr_medica f,
			atendimento_paciente g,
            bft_encounter_v v
		where
			a.nr_seq_cpoe_tipo_pedido = b.nr_sequencia
			and a.nr_sequencia 		  = c.nr_seq_cpoe_order_unit    
			and c.nr_sequencia 		  = d.nr_seq_proc_cpoe
			and d.nr_prescricao       = f.nr_prescricao
			and a.nr_atendimento      = g.nr_atendimento
            and a.nr_atendimento      = v.encounter_id
			and b.nr_seq_sub_grp      = 'S'
			and d.nr_seq_interno      = nr_seq_registro_p
			and (select count(k.nr_seq_interno) from prescr_procedimento k where k.nr_prescricao = d.nr_prescricao and coalesce(k.dt_suspensao::text, '') = '') = 0
			and ie_tipo_file_p        like '%unexecutedOrderMessageCancelSurgery%';
	
BEGIN

		PERFORM set_config('nais_interface_pck.ds_line_w', null, false);
        PERFORM set_config('nais_interface_pck.json_output_w', philips_json(), false);
        PERFORM set_config('nais_interface_pck.json_output_list_w', philips_json_list(), false);

		if (ie_tipo_file_p = 'unexecutedOrderMessageRequestSurgery') then
            begin             
				PERFORM set_config('nais_interface_pck.ie_processing_classification_w', '01', false);

				select	f.dt_prescricao,
						f.nr_prescricao,
						f.nm_usuario,
						f.cd_estabelecimento,
						coalesce(a.cd_departamento_med, ''),
						coalesce(a.cd_especialidade_med, '')						
				into STRICT 	current_setting('nais_interface_pck.dt_suspencao_w')::timestamp,
						current_setting('nais_interface_pck.nr_prescricao_w')::prescr_procedimento.nr_prescricao%type,
						current_setting('nais_interface_pck.nm_usuario_w')::varchar(20),
						current_setting('nais_interface_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type,
						cd_department_w,
						cd_especialidade_w
				from 	cpoe_order_unit a,
						cpoe_tipo_pedido b,
						cpoe_procedimento c,
						prescr_procedimento d,              
						prescr_medica f
				where	a.nr_seq_cpoe_tipo_pedido = b.nr_sequencia
						and a.nr_sequencia 		  = c.nr_seq_cpoe_order_unit    
						and c.nr_sequencia 		  = d.nr_seq_proc_cpoe
						and d.nr_prescricao       = f.nr_prescricao
						and d.nr_seq_interno      = (SELECT max(y.nr_seq_interno) from prescr_procedimento y where y.nr_prescricao = nr_seq_registro_p);

				if (cd_department_w IS NOT NULL AND cd_department_w::text <> '') then
					cd_dept_affair_w := get_medicalaffair_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', cd_department_w, null, null);		
				elsif (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') then
					cd_dept_affair_w := get_medicalaffair_code('OS', 'ESPECIALIDADE_MEDICA', 'CD_ESPECIALIDADE', cd_especialidade_w, null, null);
				end if;				

				exception
				when others then
					PERFORM set_config('nais_interface_pck.ds_error_w', sqlerrm || ' - Error during verification of included prescription data.', false);
				end;
		end if;

		if (ie_tipo_file_p = 'unexecutedOrderMessageCancelSurgery') then
            begin 
				PERFORM set_config('nais_interface_pck.ie_processing_classification_w', '03', false);

                select	coalesce(a.dt_lib_suspensao, f.dt_atualizacao),
                        f.nr_prescricao,
                        coalesce(c.nm_usuario_susp,f.nm_usuario),
                        f.cd_estabelecimento,
						coalesce(a.cd_departamento_med, ''),
						coalesce(a.cd_especialidade_med, '')			
				into STRICT 	current_setting('nais_interface_pck.dt_suspencao_w')::timestamp,
						current_setting('nais_interface_pck.nr_prescricao_w')::prescr_procedimento.nr_prescricao%type,
						current_setting('nais_interface_pck.nm_usuario_w')::varchar(20),
						current_setting('nais_interface_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type,
						cd_department_w,
						cd_especialidade_w
				from 	cpoe_order_unit a,
						cpoe_tipo_pedido b,
						cpoe_procedimento c,
						prescr_procedimento d,              
						prescr_medica f
				where	a.nr_seq_cpoe_tipo_pedido = b.nr_sequencia
						and a.nr_sequencia 		  = c.nr_seq_cpoe_order_unit    
						and c.nr_sequencia 		  = d.nr_seq_proc_cpoe
						and d.nr_prescricao       = f.nr_prescricao
						and (SELECT count(k.nr_seq_interno) from prescr_procedimento k where k.nr_prescricao = d.nr_prescricao and coalesce(k.dt_suspensao::text, '') = '') = 0
						and d.nr_seq_interno      = nr_seq_registro_p;

				if (cd_department_w IS NOT NULL AND cd_department_w::text <> '') then
					cd_dept_affair_w := get_medicalaffair_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', cd_department_w, null, null);		
				elsif (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') then
					cd_dept_affair_w := get_medicalaffair_code('OS', 'ESPECIALIDADE_MEDICA', 'CD_ESPECIALIDADE', cd_especialidade_w, null, null);
				end if;

				exception
				when others then
					PERFORM set_config('nais_interface_pck.ds_error_w', sqlerrm || ' - Error during data verification of canceled prescription item.', false);
				end;
		end if; 			

		nm_maquina_w := nais_interface_pck.get_machine_name(current_setting('nais_interface_pck.nm_usuario_w')::varchar(20));

		for r_c02 in c02 loop
			begin
				PERFORM set_config('nais_interface_pck.ds_line_w', NULL, false);				
				generate_int_serial_number(0,'MLA_ORDER_KK',current_setting('nais_interface_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type, coalesce(current_setting('nais_interface_pck.nm_usuario_w')::varchar(20), ' '), current_setting('nais_interface_pck.nr_serial_w')::bigint,944);

				for r_c01 in c01 loop
					begin
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.serial_number,5,'L','0');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.system_code,1,'R');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.message_type_code,2,'R');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.continuation_flag,1,'R');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.destination_code,1,'R');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.sender_code,1,'R');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(to_char(r_c01.processing_date,'YYYYMMDD'),8,'L','0');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(to_char(r_c01.processing_time,'HH24MISS'),6,'L','0');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.device_name,8,'R', ' ');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.user_number,8,'R');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.processing_classification,2,'R');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.response_class,2,'R', ' ');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.telegram_length,5,'L','0');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.eot,1,'R');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.med_institution_code,2,'R', ' ');
						CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.blank,11,'R');
					end;
				end loop;

				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.processing_classification,2,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.order_class,2,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.order_number,8,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.patient_id,10,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.dt_of_consultation,8,'L');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.department_code,2,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.inpatient_outpatient,1,'L');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.ward_code,3,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.room_number,5,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_dental,1,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.applied_insurance_sel_num,2,'L','0');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_C02.doctor_code,8,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.newborn,1,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.prescription_classification,1,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.requestor,3,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.exclusion_control,1,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_department_number,4,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.blank,1,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.blank_01,1,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.execution_classification,1,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.scheduled_date_of_execution,8,'L');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.schedule_time_of_execution,4,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.executing_operator_code,3,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.execution_update_flag,1,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.weight,6,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.off_hours_flag,1,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.blank_02,8,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.slip_code,3,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.number_of_details,2,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_01,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_02,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_03,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_04,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_05,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_06,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_07,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_08,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_09,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.medical_treatment_detail_10,64,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.blank_03,4,'R',' ');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.eot,1,'R');

				current_setting('nais_interface_pck.json_output_w')::philips_json := nais_interface_pck.add_json_value(current_setting('nais_interface_pck.json_output_w')::philips_json, 'message', current_setting('nais_interface_pck.ds_line_w')::varchar(32767));
				current_setting('nais_interface_pck.json_output_list_w')::philips_json_list.append(current_setting('nais_interface_pck.json_output_w')::philips_json.to_json_value());
            end;
		end loop;

		dbms_lob.createtemporary( ds_file_output_p, true);
		current_setting('nais_interface_pck.json_output_list_w')::philips_json_list.(ds_file_output_p);

        if (current_setting('nais_interface_pck.ds_error_w')::coalesce(varchar(2000)::text, '') = '') then
            record_integration_call_log(current_setting('nais_interface_pck.nm_usuario_w')::varchar(20), 'NAIS', clock_timestamp(), 'nais.unexecutedOrder.message', 'unexecutedOrderMessageRequestSurgery',
            'T', 'E', null, 'MJ', ds_file_output_p,
            null, null, current_setting('nais_interface_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, nr_seq_registro_p, 944, 'S');
        else      
            record_integration_call_log(wheb_usuario_pck.get_nm_usuario, 'NAIS', clock_timestamp(), 'nais.unexecutedOrder.message', 'unexecutedOrderMessageRequestSurgery',
            'E', 'E', null, 'MJ', null,
            substr(current_setting('nais_interface_pck.ds_error_w')::varchar(2000),1,499), null, current_setting('nais_interface_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, nr_seq_registro_p, 944, 'E');
        end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_interface_pck.unexecutedorder_surgery (nr_seq_registro_p bigint, ds_file_output_p INOUT text, ie_tipo_file_p text) FROM PUBLIC;
