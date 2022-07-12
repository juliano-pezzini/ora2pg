-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_dpc_pck.send_dpcinformation ( parameter_id_p bigint, ds_file_output_p INOUT text ) AS $body$
DECLARE

        ie_situacao_w varchar(10);
        nr_seq_int_call_log_w   bigint := 0;

BEGIN
    PERFORM set_config('nais_dpc_pck.ds_line_w', null, false);
		select CASE WHEN ie_situacao='I' THEN '3'  ELSE '1' END
		into STRICT ie_situacao_w
		from patient_dpc
		where nr_sequencia = parameter_id_p;
		CALL CALL CALL CALL CALL CALL CALL nais_dpc_pck.nais_common_header('D2', parameter_id_p, ie_situacao_w, 'E', '01',03310);
		CALL CALL nais_dpc_pck.nais_common_body(parameter_id_p);
		ds_file_output_p := current_setting('nais_dpc_pck.ds_line_w')::text;
            if current_setting('nais_dpc_pck.ds_error_w')::(varchar(4000) IS NOT NULL AND (varchar(4000))::text <> '') then
                record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), '259', 'nais.dpc.info' , 
                'E', 'E', null, 'KK', ds_file_output_p,substr(current_setting('nais_dpc_pck.ds_error_w')::varchar(4000),1,499), 'nais.dpc.info',nr_seq_int_call_log_w, parameter_id_p, 944,'E', ie_interface_type_p => '251',ie_tipo_error_p => 'MB');
            end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_dpc_pck.send_dpcinformation ( parameter_id_p bigint, ds_file_output_p INOUT text ) FROM PUBLIC;
