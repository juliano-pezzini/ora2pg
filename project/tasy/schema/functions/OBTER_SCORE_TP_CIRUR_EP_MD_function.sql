-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_tp_cirur_ep_md (ie_tipo_cirurgia_p bigint ) RETURNS bigint AS $body$
DECLARE


   qt_pt_tipo_cirurgia_w	smallint := 0;

BEGIN
	--- Inicio MD15
	-- tipo cirurgia
	if (ie_tipo_cirurgia_p IS NOT NULL AND ie_tipo_cirurgia_p::text <> '') then
		if (ie_tipo_cirurgia_p	=	1) then
			qt_pt_tipo_cirurgia_w	:=	1;
		elsif (ie_tipo_cirurgia_p	in (2,4)) then
			qt_pt_tipo_cirurgia_w	:=	4;
		elsif (ie_tipo_cirurgia_p	=	8) then
			qt_pt_tipo_cirurgia_w	:=	8;
		end if;
	end if;
	--- Fim MD15
    RETURN coalesce(qt_pt_tipo_cirurgia_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_tp_cirur_ep_md (ie_tipo_cirurgia_p bigint ) FROM PUBLIC;
