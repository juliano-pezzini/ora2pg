-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clinical_panorama_md_pck.get_risk_of_death_category (ie_categoria_rod_p text) RETURNS varchar AS $body$
BEGIN
	return ie_categoria_rod_p;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION clinical_panorama_md_pck.get_risk_of_death_category (ie_categoria_rod_p text) FROM PUBLIC;