-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_number (string_p text) RETURNS integer AS $body$
DECLARE

v_new_num bigint;

BEGIN

v_new_num := (string_p)::numeric;
return 1;

exception

when data_exception then
return 0;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_number (string_p text) FROM PUBLIC;
