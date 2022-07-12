-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION converte_pck.string_to_integer (ds_string_p text) RETURNS integer AS $body$
BEGIN
begin
return	(ds_string_p)::numeric;
exception
	when others then
	return null;
end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_pck.string_to_integer (ds_string_p text) FROM PUBLIC;
