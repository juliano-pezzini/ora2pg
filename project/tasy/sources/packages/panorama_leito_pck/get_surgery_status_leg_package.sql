-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



	/*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	-----------------------------  54 Surgery status ---------------------------------
	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
CREATE OR REPLACE FUNCTION panorama_leito_pck.get_surgery_status_leg (ie_status_agenda_p text) RETURNS bigint AS $body$
BEGIN
	CASE ie_status_agenda_p
	    WHEN 'AN' THEN return 1274;
	    WHEN 'CH' THEN return 1275;
	    WHEN 'PA' THEN return 1279;
	    WHEN 'AL' THEN return 1280;
	    WHEN 'PI' THEN return 1281;
	    WHEN 'SR' THEN return 1282;
	    WHEN 'CF' THEN return 1283;
	    WHEN 'SC' THEN return 1284;
	    ELSE return 0;
	  END CASE;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION panorama_leito_pck.get_surgery_status_leg (ie_status_agenda_p text) FROM PUBLIC;
