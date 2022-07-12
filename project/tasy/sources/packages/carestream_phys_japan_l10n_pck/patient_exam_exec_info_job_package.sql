-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



    /** 
   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Recieve_accounting_info
	message type:- 2F  
    In this message 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    **/
CREATE OR REPLACE PROCEDURE carestream_phys_japan_l10n_pck.patient_exam_exec_info_job () AS $body$
DECLARE

       file_name_like_w         varchar(8);
       jobno        bigint;
       ds_comando_w varchar(255);
       cd_event_w integer;

BEGIN

    select carestream_japan_l10n_pck.get_directory_event_code('2F',  'CARE_PHY_COST')
    into STRICT   current_setting('carestream_phys_japan_l10n_pck.cd_integartion_event_w')::philips_json                       
;

    cd_event_w := current_setting('carestream_phys_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_index'].value_of();

    select ds_dir_oracle
    into STRICT current_setting('carestream_phys_japan_l10n_pck.inbound_index_path_w')::varchar(255)
    from evento_tasy_utl_file
    where cd_evento = cd_event_w;

    file_name_like_w := 'H'||current_setting('carestream_phys_japan_l10n_pck.physiology_dept_code_w')::varchar(2)||current_setting('carestream_phys_japan_l10n_pck.his_system_code')::varchar(2)||current_setting('carestream_phys_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['control_code'].value_of();

    for r_c04 in current_setting('carestream_phys_japan_l10n_pck.c04')::loop CURSOR
      begin
          ds_comando_w := 'carestream_phys_japan_l10n_pck.patient_exam_execution_info(''' ||r_c04.cd_registro ||''');';
          if (r_c04.cd_registro like file_name_like_w||'%') then
            dbms_job.submit(jobno, ds_comando_w);
            commit;
          end if;
      end;
    end loop;

   END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_phys_japan_l10n_pck.patient_exam_exec_info_job () FROM PUBLIC;
