-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ph_eapache_iv_md (qt_ph_p bigint ) RETURNS bigint AS $body$
DECLARE


   result_w	double precision := null;

BEGIN
	--- Inicio MD1
	if (coalesce(qt_ph_p::text, '') = '') or (qt_ph_p = 0) then
		result_w	:=	7.4; -- apacheIV.js: alert("You left PH field empty, if no ABG's is available a normal value will be assigned automatically");
	end if;

    RETURN result_w;
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ph_eapache_iv_md (qt_ph_p bigint ) FROM PUBLIC;
