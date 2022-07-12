-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_values_decrypted (ds_value_p text, ds_type text) RETURNS varchar AS $body$
BEGIN

    return  WHEB_SEGURANCA.DECRYPT(ds_value_p, ds_type);

exception 
when others then
    return ds_value_p;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_values_decrypted (ds_value_p text, ds_type text) FROM PUBLIC;
