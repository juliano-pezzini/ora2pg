-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_hpc_snap_content (nr_seq_dataset_p bigint, nm_usuario_p text , cd_convenio_p text, returned_value_p INOUT bigint, other_exception_p INOUT text) AS $body$
DECLARE

  ds_segment_w                 varchar(32767);
  ds_segment_clob_w            text := '';
  is_clob_insertion_successful bigint := 0;
  excp_caught_dataset_clob_ins varchar(500 );
  ds_insurer_iden_w            varchar(15);

BEGIN
    BEGIN 
        ds_insurer_iden_w := 
        generate_data_hcp_pkg.Get_insurer_identifier(cd_convenio_p);

        SELECT '    IMI' -- insurer membership identifier 
               ||CASE WHEN coalesce(cd_membership_id::text, '') = '' THEN  '               '  ELSE Rpad(cd_membership_id, 15, ' ') END  
               ||CASE WHEN coalesce(cd_insurer_id::text, '') = '' THEN  '   '  ELSE Rpad(cd_insurer_id, 3, ' ') END  
               ||CASE WHEN coalesce(cd_snap::text, '') = '' THEN  '               '  ELSE Rpad(cd_snap, 15, ' ') END  
               ||CASE WHEN coalesce(nm_last_name::text, '') = '' THEN  '                            '  ELSE Rpad(nm_last_name, 28, ' ') END  
               ||CASE WHEN coalesce(nm_first_name::text, '') = '' THEN  '                    '  ELSE Rpad(nm_first_name, 20, ' ') END  
               ||CASE WHEN coalesce(dt_dob::text, '') = '' THEN  '        '  ELSE To_char(dt_dob, 'yyyymmdd') END  
               ||CASE WHEN coalesce(cd_zip_code::text, '') = '' THEN  '0000'  ELSE Lpad(cd_zip_code, 4, '0') END  
               ||CASE WHEN coalesce(ie_gender::text, '') = '' THEN  ' '  ELSE trim(both ie_gender) END  
               ||CASE WHEN coalesce(dt_admission::text, '') = '' THEN  '        '  ELSE To_char(dt_admission, 'yyyymmdd') END  
               ||CASE WHEN coalesce(dt_separation::text, '') = '' THEN  '        '  ELSE To_char(dt_separation, 'yyyymmdd') END  
               ||CASE WHEN coalesce(ie_episode_type::text, '') = '' THEN  ' '  ELSE trim(both ie_episode_type) END  
               ||CASE WHEN coalesce(nr_dis_fim_score::text, '') = '' THEN  ' '  ELSE trim(both nr_dis_fim_score) END  
               ||CASE WHEN coalesce(cd_primary_impairment::text, '') = '' THEN  '       '  ELSE Rpad(cd_primary_impairment, 7,                                                '0') END  
               ||CASE WHEN coalesce(cd_assesmt_indic::text, '') = '' THEN  ' '  ELSE trim(both cd_assesmt_indic) END  
               ||CASE WHEN coalesce(cd_snap_class::text, '') = '' THEN  '    '  ELSE trim(both cd_snap_class) END  
               ||CASE WHEN coalesce(cd_snap_version::text, '') = '' THEN  '  '  ELSE trim(both cd_snap_version) END  
               ||CASE WHEN coalesce(dt_rehab_plan::text, '') = '' THEN  '        '  ELSE To_char(dt_rehab_plan, 'yyyymmdd') END  
               ||CASE WHEN coalesce(dt_discharge_plan::text, '') = '' THEN  '        '  ELSE To_char(dt_discharge_plan, 'yyyymmdd'                                            ) END  
               ||CASE WHEN coalesce(nr_seq_dataset::text, '') = '' THEN  '        '  ELSE To_char(nr_seq_dataset, 5, '0') END 
	       ||CASE WHEN coalesce(cd_episode_start::text, '') = '' THEN  ' '  ELSE Lpad(trim(both cd_episode_start),1 ,'0' ) END 
               ||CASE WHEN coalesce(cd_episode_end::text, '') = '' THEN  ' '  ELSE Lpad(trim(both cd_episode_end),1 ,'0' ) END 
        INTO STRICT   ds_segment_w 
        FROM   hcp_snap_seg_data 
        WHERE  nr_seq_dataset = nr_seq_dataset_p;
     EXCEPTION 	
        WHEN OTHERS THEN 	
          ds_segment_w := NULL;
    END;

    SELECT Concat(ds_segment_clob_w, ds_segment_w) 
    INTO STRICT   ds_segment_clob_w 
;

    SELECT * FROM Insert_hcp_dataset_content(nm_usuario_p, nr_seq_dataset_p, ds_segment_clob_w, is_clob_insertion_successful, excp_caught_dataset_clob_ins) INTO STRICT is_clob_insertion_successful, excp_caught_dataset_clob_ins;

    IF ( is_clob_insertion_successful = 1 ) THEN 
      returned_value_p := 1;

      other_exception_p := NULL;
    ELSE 
      IF (excp_caught_dataset_clob_ins IS NOT NULL AND excp_caught_dataset_clob_ins::text <> '') THEN 
        returned_value_p := 0;

        other_exception_p := excp_caught_dataset_clob_ins;
      END IF;
    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_hpc_snap_content (nr_seq_dataset_p bigint, nm_usuario_p text , cd_convenio_p text, returned_value_p INOUT bigint, other_exception_p INOUT text) FROM PUBLIC;

