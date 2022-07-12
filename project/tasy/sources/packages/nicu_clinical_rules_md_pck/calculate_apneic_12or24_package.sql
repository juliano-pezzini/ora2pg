-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION nicu_clinical_rules_md_pck.calculate_apneic_12or24 (count_p bigint, hours_p bigint ) RETURNS varchar AS $body$
DECLARE

	vl_return_w bigint := null;
	
BEGIN
		vl_return_w := (count_p / hours_p);
		return to_char(vl_return_w);
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nicu_clinical_rules_md_pck.calculate_apneic_12or24 (count_p bigint, hours_p bigint ) FROM PUBLIC;
