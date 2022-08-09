-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE FUNCTION pkg_name_utils.get_formatted_person_name ( given_name text, family_name text, component_name_1 text, component_name_2 text, component_name_3 text, title_name text, format text) RETURNS varchar AS $body$
DECLARE
	bindings		varchar(2000);
	result			varchar(2000);
	format_w 		person_name_format.ds_format%type := format;
BEGIN
	bindings	:= bindings || current_setting('pkg_name_utils.key_given')::varchar(30) || '=' || given_name || ';';
	bindings	:= bindings || current_setting('pkg_name_utils.key_family')::varchar(30) || '=' || family_name || ';';
	bindings	:= bindings || current_setting('pkg_name_utils.key_component_1')::varchar(30) || '=' || component_name_1 || ';';
	bindings	:= bindings || current_setting('pkg_name_utils.key_component_2')::varchar(30) || '=' || component_name_2 || ';';
	bindings	:= bindings || current_setting('pkg_name_utils.key_component_3')::varchar(30) || '=' || component_name_3 || ';';
	bindings	:= bindings || current_setting('pkg_name_utils.key_title')::varchar(30) || '=' || title_name || ';';

	if (bindings IS NOT NULL AND bindings::text <> '') then
		result := regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(pkg_name_utils.evaluate_name_template(format_w, bindings),'\${.*}',''),' +', ' '),'(, )\1+','\1'),'^, ',''),', $', '');
	end if;

	return result;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_name_utils.get_formatted_person_name ( given_name text, family_name text, component_name_1 text, component_name_2 text, component_name_3 text, title_name text, format text) FROM PUBLIC;
