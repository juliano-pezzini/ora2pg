-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION param_recalcular_repasse_pck.get_ie_repasse_item_audit () RETURNS PARAMETRO_REPASSE.IE_REPASSE_ITEM_AUDIT%TYPE AS $body$
BEGIN
		return current_setting('param_recalcular_repasse_pck.ie_repasse_audit_w')::parametro_repasse.ie_repasse_item_audit%type;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION param_recalcular_repasse_pck.get_ie_repasse_item_audit () FROM PUBLIC;
