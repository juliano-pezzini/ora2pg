-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE itech_pck.send_urine_info ( nr_prescricao_p bigint, nr_seq_int_prescr_p bigint, nm_usuario_p text, log_sequence_number_p text default 0, file_name_p text default null, cd_establishment_p bigint default 1) AS $body$
DECLARE

    filename_w  varchar(255);
    nr_atendimento_w bigint;
    nr_order_w bigint;
    nr_height_w bigint;
    nr_weight_w bigint;
    qt_atual_volume_w double precision;
    ds_comments_w varchar(4000);
    sender_system_code_w  varchar(2) := 'AB';
    receiver_system_code_w  varchar(2) := 'BI';
    number_of_items_w varchar(10) := '00000001';
    c02 CURSOR FOR
      SELECT nr_order_w order_number,
        nr_height_w height,
        nr_weight_w weight,
        qt_atual_volume_w urine_output,
        ds_comments_w free_comment
;
    c04 CURSOR FOR
    SELECT '1' processing_classification,
      coalesce(c.dt_liberacao, clock_timestamp()) date_of_processing,
      coalesce(c.dt_liberacao, clock_timestamp()) time_of_processing,
      ' ' pt_id,
      ' ' date_of_occurence,
      ' ' seq_number,
      ' ' ws_number,
      ' ' index_classification,
      ' ' xx_classification,
      ' ' xx_type,
      ' ' xx_seq,
      c.nr_prescricao nr_prescricao,
      current_setting('itech_pck.filename_sequence_w')::int_serial_number.nr_serial%type nr_sequencia,
      a.type_encounter_id patient_classification,
      coalesce(a.medical_department_id,0) consult_department_code,
      coalesce(a.medical_department_name,' ') consult_department_name,
      a.department_id ward_code,
      a.department_name ward_name,
      a.encounter_doctor_id doctor_id,
      a.encounter_doctor_given_name doctor_name_in_kana,
      a.encounter_doctor_given_name doctor_name,
      a.department_admit_date request_date,
      clock_timestamp() cancellation_date,
      '0' cancellation_reason,
      d.medical_record_id,
      d.patient_name,
      d.patient_given_name,
      d.patient_sex,
      d.date_of_birth,
      a.type_encounter_id,
      coalesce(a.external_dep_code, 0) external_dep_code,
      coalesce(a.room_name, 0) room_name
    from bft_encounter_v a,
      prescr_medica c,
      bft_patient_v d
    where d.patient_id   = a.patient_id
    and a.encounter_id   = nr_atendimento_w
    and c.nr_prescricao  = nr_prescricao_p  LIMIT 1;

BEGIN
      filename_w := null;
      PERFORM set_config('itech_pck.ds_line_w', null, false);
      PERFORM set_config('itech_pck.log_sequence_number_w', log_sequence_number_p, false);

      CALL generate_itech_lab_external_id(nr_prescricao_p, nm_usuario_p, cd_establishment_p);

      select nr_atendimento
      into STRICT   nr_atendimento_w
      from   prescr_medica
      where  nr_prescricao = nr_prescricao_p;

      select obter_sinal_vital(nr_atendimento_w, 'ALTURA')
      into STRICT   nr_height_w
;

      select obter_sinal_vital(nr_atendimento_w, 'PESO')
      into STRICT   nr_weight_w
;

      select coalesce(qt_volume_enf, qt_volume),
             coalesce(ds_condicao, ' ')
      into STRICT   qt_atual_volume_w,
             ds_comments_w
      from   prescr_proc_material
      where  nr_prescricao = nr_prescricao_p
      and    nr_seq_int_prescr = nr_seq_int_prescr_p;

      select  itech_pck.get_directory_event_code('1F')
      into STRICT  current_setting('itech_pck.cd_integartion_event_w')::philips_json
;

      select nr_controle_lab
      into STRICT   nr_order_w
      from   prescr_medica
      where  nr_prescricao = nr_prescricao_p;

      if (file_name_p IS NOT NULL AND file_name_p::text <> '') then
        filename_w := file_name_p;
      else
        generate_int_serial_number(nr_prescricao_p, current_setting('itech_pck.control_code_w')::varchar(5), cd_establishment_p, nm_usuario_p, current_setting('itech_pck.filename_sequence_w')::int_serial_number.nr_serial%type, current_setting('itech_pck.nr_seq_evento_int_w')::integration_call_log.nr_seq_evento_int%type);
        filename_w := 'HABBI'||current_setting('itech_pck.control_code_w')::varchar(5)||to_char(clock_timestamp(),'YYYYMMDD')||to_char(clock_timestamp(),'HH24MISS')||lpad(to_char(current_setting('itech_pck.filename_sequence_w')::int_serial_number.nr_serial%type), 4, '0')||'.dat';
      end if;

      PERFORM set_config('itech_pck.control_code_w', current_setting('itech_pck.cd_integartion_event_w')::philips_json.get['control_code'].value_of(), false);
      PERFORM set_config('itech_pck.log_code_w', current_setting('itech_pck.cd_integartion_event_w')::philips_json.get['cd_event_log'].value_of(), false);
      PERFORM set_config('itech_pck.nr_seq_evento_int_w', current_setting('itech_pck.cd_integartion_event_w')::philips_json.get['integration_event_code'].value_of(), false);
      PERFORM set_config('itech_pck.event_index_error_code_w', current_setting('itech_pck.cd_integartion_event_w')::philips_json.get['cd_event_index_error'].value_of(), false);
      if (log_sequence_number_p > 0) then
        begin
          CALL CALL itech_pck.delete_error_file( file_name_p, current_setting('itech_pck.cd_integartion_event_w')::philips_json.get['cd_event_data_error'].value_of(), current_setting('itech_pck.cd_integartion_event_w')::philips_json.get['cd_event_index_error'].value_of(), current_setting('itech_pck.log_code_w')::varchar(5));
        exception
        when others then
          PERFORM set_config('itech_pck.ds_log_message_w', 'Error occured while deleting the file from error folder  for'
                              || 'Urine Output Information'
                              || '.'
                              || current_setting('itech_pck.ds_line_w')::varchar(32767)
                              || 'Integration name - Urine Output Information'
                              || current_setting('itech_pck.ds_line_w')::varchar(32767)
                              || 'Time of faliure : '
                              || clock_timestamp()
                              || current_setting('itech_pck.ds_line_w')::varchar(32767)
                              || 'Encounter Id'
                              || nr_atendimento_w
                              || current_setting('itech_pck.ds_line_w')::varchar(32767)
                              || 'file Name'
                              || file_name_p, false);

            record_integration_call_log(nm_usuario_p, nm_usuario_p, clock_timestamp(), 'Urine Output Information', 'Urine Output Information',
            'E', 'E', null, current_setting('itech_pck.ds_log_message_w')::varchar(32767), null,
            current_setting('itech_pck.ds_log_message_w')::varchar(32767), file_name_p, current_setting('itech_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, nr_atendimento_w, current_setting('itech_pck.nr_seq_evento_int_w')::integration_call_log.nr_seq_evento_int%type);
        end;
    end if;
    begin
    PERFORM set_config('itech_pck.ds_line_w', null, false);
    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text('1F',2,'L');
    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(to_char(clock_timestamp(),'YYYYMMDD'),8,'L');
    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(to_char(clock_timestamp(),'HH24MISS'),6,'L');
    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(sender_system_code_w,2,'L');
    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(receiver_system_code_w,2,'L');
    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(number_of_items_w,8,'L');
  --Append intersystem common header result
  for r_c04 in c04
  loop
    begin
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.processing_classification,1,'L');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(to_char(r_c04.date_of_processing,'YYYYMMDD'),8,'L');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(to_char(r_c04.time_of_processing,'HH24MISS'),6,'L');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.pt_id,10,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.date_of_occurence,8,'L',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.seq_number,6,'L',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.ws_number,4,'L',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.index_classification,1,'L',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.xx_classification,2,'L',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.xx_type,3,'L',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.xx_seq,5,'L',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.nr_prescricao,14,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.nr_sequencia,10,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.patient_classification,1,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.consult_department_code,3,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.consult_department_name,20,'R',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.ward_code,3,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.ward_name,20,'R', ' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.doctor_id,10,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.doctor_name_in_kana,20,'R', ' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.doctor_name,20,'R', ' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(to_char(r_c04.request_date,'YYYYMMDD'),8,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(to_char(r_c04.cancellation_date,'YYYYMMDD'),8,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.cancellation_reason,1,'R', ' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.medical_record_id,10,'L', '0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.patient_name,23,'R',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.patient_given_name,20,'R',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.patient_sex,1,'L',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(to_char(r_c04.date_of_birth,'YYYYMMDD'),8,'L');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.type_encounter_id,1,'L');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.external_dep_code,4,'L','0');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c04.room_name,20,'R',' ');
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(number_of_items_w,8,'L');
    end;
  end loop;

      for r_c02 in c02
      loop
        begin
          CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c02.order_number,15,'L','0');
          CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c02.height,8,'R',' ');
          CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c02.weight,8,'R',' ');
          CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c02.urine_output,8,'R',' ');
          CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(r_c02.free_comment,40,'R',' ');
		  CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(chr(10),2,'R');
        end;
      end loop;

      CALL CALL CALL itech_pck.generate_file(current_setting('itech_pck.cd_integartion_event_w')::philips_json.get['cd_event_data'].value_of(), filename_w, current_setting('itech_pck.ds_line_w')::varchar(32767)); --create a data file
      PERFORM set_config('itech_pck.ds_line_w', null, false);
      CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL itech_pck.append_text(filename_w,length(filename_w),'L');
      CALL CALL CALL itech_pck.generate_file(current_setting('itech_pck.cd_integartion_event_w')::philips_json.get['cd_event_index'].value_of(), filename_w, current_setting('itech_pck.ds_line_w')::varchar(32767)); --create an index file
      PERFORM set_config('itech_pck.ds_log_message_w', itech_pck.get_log_message(filename_w, current_setting('itech_pck.control_code_w')::varchar(5), 'BI'), false);
    exception
    when others then
      PERFORM set_config('itech_pck.ds_log_message_w', 'File generation failed for data and index folder for '
                            || 'Urine Output Information'
                            || '.'
                            || current_setting('itech_pck.ds_line_w')::varchar(32767)
                            || 'Integration name - Urine Output Information'
                            || current_setting('itech_pck.ds_line_w')::varchar(32767)
                            || 'Time of faliure : '
                            || clock_timestamp()
                            || current_setting('itech_pck.ds_line_w')::varchar(32767)
                            || 'Encounter Id'
                            || nr_atendimento_w
                            || current_setting('itech_pck.ds_line_w')::varchar(32767)
                            || 'file Name'
                            || file_name_p, false);

          record_integration_call_log(nm_usuario_p, nm_usuario_p, clock_timestamp(), 'Urine Output Information', 'Urine Output Information',
          'E', 'E', null, current_setting('itech_pck.ds_log_message_w')::varchar(32767), null,
          current_setting('itech_pck.ds_log_message_w')::varchar(32767), file_name_p, current_setting('itech_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, nr_atendimento_w, current_setting('itech_pck.nr_seq_evento_int_w')::integration_call_log.nr_seq_evento_int%type);
          CALL CALL itech_pck.save_log(current_setting('itech_pck.log_code_w')::varchar(5), current_setting('itech_pck.log_file_name_w')::varchar(255), current_setting('itech_pck.ds_log_message_w')::varchar(32767));
    end;
	-- Updating Tasy and third party Log 
    CALL CALL itech_pck.save_log(current_setting('itech_pck.log_code_w')::varchar(5), current_setting('itech_pck.log_file_name_w')::varchar(255), current_setting('itech_pck.ds_log_message_w')::varchar(32767));
    PERFORM set_config('itech_pck.ds_script_w', 'itech_pck.send_urine_info ('
                      || nr_prescricao_p ||','
                      || nr_seq_int_prescr_p || ',' 
                      || current_setting('itech_pck.ds_guampa_w')::varchar(10)||':nm_exec_user' ||current_setting('itech_pck.ds_guampa_w')::varchar(10) ||',' 
                      || ':nr_seq_int_call_log'||',' 
                      || current_setting('itech_pck.ds_guampa_w')::varchar(10)||filename_w||current_setting('itech_pck.ds_guampa_w')::varchar(10)||','
                      || cd_establishment_p
                      || ');', false);
    record_integration_call_log(nm_usuario_p, nm_usuario_p, clock_timestamp(), 'Urine Output Information', 'Urine Output Information' , 'T', 'E', current_setting('itech_pck.ds_script_w')::integration_call_log.ds_resend_script%type, current_setting('itech_pck.ds_log_message_w')::varchar(32767), current_setting('itech_pck.ds_log_message_w')::varchar(32767), null, filename_w, current_setting('itech_pck.log_sequence_number_w')::integration_message_log.nr_seq_int_call_log%type, nr_atendimento_w, current_setting('itech_pck.nr_seq_evento_int_w')::integration_call_log.nr_seq_evento_int%type);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE itech_pck.send_urine_info ( nr_prescricao_p bigint, nr_seq_int_prescr_p bigint, nm_usuario_p text, log_sequence_number_p text default 0, file_name_p text default null, cd_establishment_p bigint default 1) FROM PUBLIC;
