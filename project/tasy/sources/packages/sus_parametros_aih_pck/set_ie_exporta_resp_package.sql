-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sus_parametros_aih_pck.set_ie_exporta_resp (ie_exporta_resp_p sus_parametros_aih.ie_exporta_resp%type) AS $body$
BEGIN
	PERFORM set_config('sus_parametros_aih_pck.ie_exporta_resp', ie_exporta_resp_p, false);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_parametros_aih_pck.set_ie_exporta_resp (ie_exporta_resp_p sus_parametros_aih.ie_exporta_resp%type) FROM PUBLIC;
