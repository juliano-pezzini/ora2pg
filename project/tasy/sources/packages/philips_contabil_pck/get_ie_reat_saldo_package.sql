-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_contabil_pck.get_ie_reat_saldo () RETURNS varchar AS $body$
BEGIN
	PERFORM set_config('philips_contabil_pck.ie_reat_saldo_w', coalesce(current_setting('philips_contabil_pck.ie_reat_saldo_w')::varchar(1),'N'), false);
		return current_setting('philips_contabil_pck.ie_reat_saldo_w')::varchar(1);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION philips_contabil_pck.get_ie_reat_saldo () FROM PUBLIC;
