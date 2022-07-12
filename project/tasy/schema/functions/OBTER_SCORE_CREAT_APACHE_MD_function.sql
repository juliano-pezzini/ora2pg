-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_creat_apache_md (ie_renal_p text, qt_diurese_p bigint, qt_creatinina_p bigint, qt_creatinina_p_max_p bigint ) RETURNS bigint AS $body$
DECLARE


	qt_pt_creatinina_min_w	   smallint;
	qt_pt_creatinina_max_w	   smallint;
	qt_pt_creatinina_w	       smallint;

BEGIN
	--- Inicio MD10
	-- Creatinina COM Acute Renal Failure 
	if	((ie_renal_p = 'N') or (coalesce(ie_renal_p::text, '') = '')) and (qt_diurese_p	<	410) and (qt_creatinina_p	>=	1.5) then
		qt_pt_creatinina_w	:=	10;
	else
	-- Creatinina SEM Acute Renal Failure
		if (qt_creatinina_p	<=	0.4) then
			qt_pt_creatinina_min_w	:=	3;
		elsif (qt_creatinina_p	<=	1.4) then
			qt_pt_creatinina_min_w	:=	0;
		elsif (qt_creatinina_p	<=	1.94) then	
			qt_pt_creatinina_min_w	:=	4;
		else
			qt_pt_creatinina_min_w	:=	7;
		end if;

		if (qt_creatinina_p_max_p	<=	0.4) then
			qt_pt_creatinina_max_w	:=	3;
		elsif (qt_creatinina_p_max_p	<=	1.4) then
			qt_pt_creatinina_max_w	:=	0;
		elsif (qt_creatinina_p_max_p	<=	1.94) then	
			qt_pt_creatinina_max_w	:=	4;
		else
			qt_pt_creatinina_max_w	:=	7;
		end if;

		if (qt_pt_creatinina_max_w > qt_pt_creatinina_min_w) then
			qt_pt_creatinina_w	:=	qt_pt_creatinina_max_w;
		else
			qt_pt_creatinina_w	:=	qt_pt_creatinina_min_w;
		end if;
	end if;
	--- Fim MD10
	return qt_pt_creatinina_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_creat_apache_md (ie_renal_p text, qt_diurese_p bigint, qt_creatinina_p bigint, qt_creatinina_p_max_p bigint ) FROM PUBLIC;

