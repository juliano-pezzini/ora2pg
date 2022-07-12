-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_patrimonio_pck.get_ie_gravar_movimento () RETURNS boolean AS $body$
BEGIN

return current_setting('philips_patrimonio_pck.ie_gravar_movimento_w')::boolean;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION philips_patrimonio_pck.get_ie_gravar_movimento () FROM PUBLIC;
