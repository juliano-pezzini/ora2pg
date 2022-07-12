-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_name_utils.get_person_name ( given_name text, family_name text, component_name_1 text, component_name_2 text, component_name_3 text, title_name text, format text) RETURNS varchar AS $body$
BEGIN
	return pkg_name_utils.get_formatted_person_name(given_name, family_name, component_name_1, component_name_2, component_name_3, title_name, format);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_name_utils.get_person_name ( given_name text, family_name text, component_name_1 text, component_name_2 text, component_name_3 text, title_name text, format text) FROM PUBLIC;
