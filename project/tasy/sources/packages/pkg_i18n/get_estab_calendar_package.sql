-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_i18n.get_estab_calendar () RETURNS varchar AS $body$
BEGIN
return coalesce(current_setting('pkg_i18n.estab_calendar_w')::varchar(32), current_setting('pkg_i18n.default_calendar')::user_locale.ds_calendar%type);
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pkg_i18n.get_estab_calendar () FROM PUBLIC;
