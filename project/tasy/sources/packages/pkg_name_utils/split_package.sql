-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE FUNCTION pkg_name_utils.split ( list text, delimiter text default ',') RETURNS text[] AS $body$
BEGIN
	return string_to_array(list, delimiter);
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_name_utils.split ( list text, delimiter text default ',') FROM PUBLIC;
