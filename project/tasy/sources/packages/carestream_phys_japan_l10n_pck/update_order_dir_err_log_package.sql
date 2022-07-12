-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




      /** 
   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    Procedure used to resend the file from order directory, if the file moved to error folder
    Integration messages - Patient Order Information  
    Control code - 
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   **/
CREATE OR REPLACE PROCEDURE carestream_phys_japan_l10n_pck.update_order_dir_err_log () AS $body$
DECLARE

    cd_event_w integer;
    file_name_like_w varchar(8);

BEGIN
        select carestream_japan_l10n_pck.get_directory_event_code(null, 'CARE_PHY_ORDER')
        into STRICT   current_setting('carestream_phys_japan_l10n_pck.cd_integartion_event_w')::philips_json
;

        cd_event_w := current_setting('carestream_phys_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_index_error'].value_of();

        select ds_dir_oracle
        into STRICT current_setting('carestream_phys_japan_l10n_pck.directory_path_w')::varchar(255)
        from evento_tasy_utl_file
        where cd_evento = cd_event_w;

        file_name_like_w := 'H'||current_setting('carestream_phys_japan_l10n_pck.his_system_code')::varchar(2) || current_setting('carestream_phys_japan_l10n_pck.physiology_dept_code_w')::varchar(2) ||  current_setting('carestream_phys_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['control_code'].value_of();

        for r_cfile in current_setting('carestream_phys_japan_l10n_pck.cfile')::loop CURSOR
            carestream_japan_l10n_pck.update_tasy_error_log(r_cfile.cd_registro, file_name_like_w, current_setting('carestream_phys_japan_l10n_pck.cd_integartion_event_w')::philips_json.get['cd_event_data'].value_of());
        end loop;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_phys_japan_l10n_pck.update_order_dir_err_log () FROM PUBLIC;
