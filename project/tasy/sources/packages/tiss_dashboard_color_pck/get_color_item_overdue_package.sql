-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_dashboard_color_pck.get_color_item_overdue (vl_item_p bigint, vl_tgt_med_p bigint, vl_tgt_max_p bigint) RETURNS varchar AS $body$
DECLARE


vl_tgt_med_w	bigint := coalesce(vl_tgt_med_p, 900);
vl_tgt_max_w	bigint := coalesce(vl_tgt_max_p, 1000);


BEGIN
	
	return tiss_dashboard_color_pck.get_color_min(vl_item_p, vl_tgt_med_w, vl_tgt_max_w);

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_dashboard_color_pck.get_color_item_overdue (vl_item_p bigint, vl_tgt_med_p bigint, vl_tgt_max_p bigint) FROM PUBLIC;
