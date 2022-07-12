-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_interface_pck.physician_change ( parameter_id_p bigint, ds_file_output_p INOUT text) AS $body$
DECLARE


        cd_establishment    bigint;
        nm_maquina_w        varchar(255);
        cd_department_w     varchar(255);
        cd_dept_affair_w    nais_conversion_master%rowtype;

		C01 CURSOR FOR
		SELECT	current_setting('nais_interface_pck.nr_serial_w')::bigint serial_number,
				'H' SYSTEM_CODE,
				'NI' MESSAGE_TYPE_CODE,
				'E' CONTINUATION_FLAG,
				'M' DESTINATION_CODE,
				'D' SENDER_CODE,
				clock_timestamp() PROCESSING_DATE,
				clock_timestamp() PROCESSING_TIME,
				coalesce(nm_maquina_w, 'TASY') TERMINAL_NAME,
				current_setting('nais_interface_pck.nm_usuario_ww')::varchar(20) USER_NUMBER,
				'01' PROCESSING_CLASSIFICATION,
				' ' RESPONSE_CLASS,
				162  TELEGRAM_LENGTH,
				' ' EOT,
				' ' MED_INSTITUTION_CODE,
				' ' BLANK
		;

		C02 CURSOR FOR
		SELECT 	01 update_class,
				02 processing_class,
				coalesce(c.medical_record_id,0) patient_id,
				12 transfer_instruction,
				to_char(a.dt_troca,'YYYYMMDD') move_start_date,
				to_char(a.dt_troca,'hh24mi') move_start_time,
				00000000 move_end_date,
				00000000 move_end_time,
				coalesce(cd_dept_affair_w.cd_medical_affair, ' ') move_department_code,
				c.department_id move_ward_code,
				c.room_id move_room_number,
				coalesce(c.bed_id,' ') move_bed_code,
				0 serious_case_classification,
				' ' blank_one,
				0 room_charge_difference,
				0 bedding_use_classification,
				0 transfer_icu_classification,
				00 insurance_selection_no,
				a.cd_medico_atual attending_doctor,
				0 outcome_classification,
                ' ' ds_finish, 
				to_char(c.encouter_admit_date,'YYYYMMDD') date_of_admission,
				to_char(c.encouter_admit_date,'HH24MI') time_of_admission,
				'01' admission_type,
                ' ' ds_spare,
				chr(13) eot_two		
		from atendimento_troca_medico a,
			bft_encounter_v c
		where a.nr_atendimento = c.nr_atendimento 
		and		a.nr_sequencia 		= parameter_id_p;	

		
BEGIN

		PERFORM set_config('nais_interface_pck.ds_line_w', null, false);


        begin
        --for setting up the current user 
        select coalesce(max(a.nm_usuario), 'NAIS')
                into STRICT current_setting('nais_interface_pck.nm_usuario_ww')::varchar(20)
            from atendimento_troca_medico a
            where a.nr_sequencia = parameter_id_p;
        end;

        select coalesce(max(c.establishment_id), 1)
        into STRICT    cd_establishment
        from    atendimento_troca_medico a,
                bft_encounter_v c
        where   a.nr_atendimento = c.nr_atendimento
        and     a.nr_sequencia 		= parameter_id_p;


        generate_int_serial_number(0,'NAIS_MOV_NI', cd_establishment, current_setting('nais_interface_pck.nm_usuario_ww')::varchar(20), current_setting('nais_interface_pck.nr_serial_w')::bigint,978);

        --Fectching user PC name. in case of null it will by default take 'TASY'
        nm_maquina_w := nais_interface_pck.get_machine_name(current_setting('nais_interface_pck.nm_usuario_ww')::varchar(20));

        
        
        --  Fectching department code from nais_convertion_master
            select  coalesce(c.medical_department_id,0)
            into STRICT    cd_department_w
            from    atendimento_troca_medico a,
                    bft_encounter_v c
            where   a.nr_atendimento = c.nr_atendimento 
            and		a.nr_sequencia 		= parameter_id_p;

            cd_dept_affair_w := get_medicalaffair_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', cd_department_w, null, null);


		for r_c01 in C01 loop
			begin
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.serial_number,5,'L','0');   									
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.system_code,1,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.message_type_code,2,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.continuation_flag,1,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.destination_code,1,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.sender_code,1,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(to_char(r_c01.processing_date,'YYYYMMDD'),8,'L','0'); 					
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(to_char(r_c01.processing_time,'HH24MISS'),6,'L','0');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.terminal_name,8,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.user_number,8,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.processing_classification,2,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.response_class,2,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.telegram_length,5,'L','0');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.eot,1,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.med_institution_code,2,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c01.blank,11,'R');
			end;
		end loop;

		for r_c02 in C02 loop
			begin
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.update_class,2,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.processing_class,2,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.patient_id,10,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.transfer_instruction,2,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.move_start_date,8,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.move_start_time,4,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.move_end_date,8,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.move_end_time,4,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.move_department_code,2,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.move_ward_code,3,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.move_room_number,5,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.move_bed_code,2,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.serious_case_classification,1,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.blank_one,1,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.room_charge_difference,1,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.bedding_use_classification,1,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.transfer_icu_classification,1,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.insurance_selection_no,2,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.attending_doctor,8,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.outcome_classification,1,'L','0');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.ds_finish,1,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.date_of_admission,8,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.time_of_admission,4,'L','0');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.admission_type,2,'R');
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.ds_spare,14,'R');
				CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_interface_pck.append_text(r_c02.eot_two,1,'L'); 		
			end;
		end loop;

		RAISE NOTICE '%', current_setting('nais_interface_pck.ds_line_w')::varchar(32767);
		ds_file_output_p	:= current_setting('nais_interface_pck.ds_line_w')::varchar(32767);

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_interface_pck.physician_change ( parameter_id_p bigint, ds_file_output_p INOUT text) FROM PUBLIC;