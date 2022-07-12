-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_hl7_pck.validate_order (nr_order_id_p bigint, nm_patient_id_p text, ds_result_p INOUT text) AS $body$
BEGIN

        ds_result_p := wheb_hl7_pck.validate_order_id(nr_order_id_p, ds_result_p);
        if ((ds_result_p IS NOT NULL AND ds_result_p::text <> '') or ds_result_p != '') then
            return;
        end if;

        ds_result_p := '';
    end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_hl7_pck.validate_order (nr_order_id_p bigint, nm_patient_id_p text, ds_result_p INOUT text) FROM PUBLIC;
