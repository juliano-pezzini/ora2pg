-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sus_obter_inco_ativa_pck.set_ie_bpa_con (ie_bpa_con_p text) AS $body$
BEGIN
		PERFORM set_config('sus_obter_inco_ativa_pck.ie_bpa_con_w', ie_bpa_con_p, false);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_obter_inco_ativa_pck.set_ie_bpa_con (ie_bpa_con_p text) FROM PUBLIC;
