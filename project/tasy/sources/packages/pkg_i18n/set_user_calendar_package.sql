-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pkg_i18n.set_user_calendar (calendar text) AS $body$
BEGIN
PERFORM set_config('pkg_i18n.user_calendar_w', calendar, false);
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pkg_i18n.set_user_calendar (calendar text) FROM PUBLIC;
