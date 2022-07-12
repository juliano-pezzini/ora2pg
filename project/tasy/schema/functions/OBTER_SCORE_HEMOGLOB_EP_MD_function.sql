-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_hemoglob_ep_md (qt_hemoglobina_p bigint ) RETURNS bigint AS $body$
DECLARE


   qt_pt_hemoglobina_w	smallint := 0;

BEGIN
	--- Inicio MD5
	-- hemoglobina
	if (qt_hemoglobina_p IS NOT NULL AND qt_hemoglobina_p::text <> '') then
		if (qt_hemoglobina_p	<=	9.9) then
			qt_pt_hemoglobina_w	:=	8;
		elsif (qt_hemoglobina_p	<=	11.4) then
			qt_pt_hemoglobina_w	:=	4;
		elsif (qt_hemoglobina_p	<=	12.9) then
			qt_pt_hemoglobina_w	:=	2;
		elsif (qt_hemoglobina_p	<=	16) then
			qt_pt_hemoglobina_w	:=	1;
		elsif (qt_hemoglobina_p	<=	17) then
			qt_pt_hemoglobina_w	:=	2;
		elsif (qt_hemoglobina_p	<=	18) then
			qt_pt_hemoglobina_w	:=	4;
		else
			qt_pt_hemoglobina_w	:=	8;
		end if;
	end if;
	--- Fim MD5
    RETURN coalesce(qt_pt_hemoglobina_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_hemoglob_ep_md (qt_hemoglobina_p bigint ) FROM PUBLIC;

