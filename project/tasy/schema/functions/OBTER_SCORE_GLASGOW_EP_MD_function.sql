-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_glasgow_ep_md (qt_glasgow_p bigint ) RETURNS bigint AS $body$
DECLARE


   qt_pt_glasgow_w bigint := 0;

BEGIN
	--- Inicio MD2
	-- glasgow
	if (qt_glasgow_p IS NOT NULL AND qt_glasgow_p::text <> '') then
		if (qt_glasgow_p	<=	8) then
			qt_pt_glasgow_w	:=	8;
		elsif (qt_glasgow_p	<=	11) then
			qt_pt_glasgow_w	:=	4;
		elsif (qt_glasgow_p	<=	14) then
			qt_pt_glasgow_w	:=	2;
		else
			qt_pt_glasgow_w	:=	1;
		end if;
	end if;
	--- Fim MD2
    RETURN coalesce(qt_pt_glasgow_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_glasgow_ep_md (qt_glasgow_p bigint ) FROM PUBLIC;

