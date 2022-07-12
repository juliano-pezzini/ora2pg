-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_ureia_ep_md (qt_ureia_p bigint ) RETURNS bigint AS $body$
DECLARE


   qt_pt_ureia_w   smallint := 0;
   qt_ureia_mmol_w double precision := 0;

BEGIN
	--- Inicio MD3
	-- ureia 
	if (qt_ureia_p IS NOT NULL AND qt_ureia_p::text <> '') then
		qt_ureia_mmol_w	:=	(qt_ureia_p * 0.357); -- converte de mg para mmol
		if (qt_ureia_mmol_w	<=	7.5) then
			qt_pt_ureia_w	:=	1;
		elsif (qt_ureia_mmol_w	<=	10) then
			qt_pt_ureia_w	:=	2;
		elsif (qt_ureia_mmol_w	<=	15) then
			qt_pt_ureia_w	:=	4;
		else
			qt_pt_ureia_w	:=	8;
		end if;
	end if;
	--- Fim MD3
    RETURN coalesce(qt_pt_ureia_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_ureia_ep_md (qt_ureia_p bigint ) FROM PUBLIC;
