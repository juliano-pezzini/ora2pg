-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_interface_pck.add_json_value ( json_p INOUT philips_json, name_p text, value_p text ) AS $body$
BEGIN
        if (value_p IS NOT NULL AND value_p::text <> '') then
            json_p.put(name_p, value_p);
        end if;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_interface_pck.add_json_value ( json_p INOUT philips_json, name_p text, value_p text ) FROM PUBLIC;
