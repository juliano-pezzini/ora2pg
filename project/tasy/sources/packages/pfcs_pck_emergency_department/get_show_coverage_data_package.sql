-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_emergency_department.get_show_coverage_data () RETURNS varchar AS $body$
DECLARE

		ie_show_coverage_network_w	pfcs_general_rule.ie_show_coverage_network%type;

	
BEGIN
		select ie_show_coverage_network
		  into STRICT ie_show_coverage_network_w
		  from pfcs_general_rule LIMIT 1;

		return ie_show_coverage_network_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_emergency_department.get_show_coverage_data () FROM PUBLIC;