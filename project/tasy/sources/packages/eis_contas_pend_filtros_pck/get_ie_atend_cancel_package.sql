-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION eis_contas_pend_filtros_pck.get_ie_atend_cancel () RETURNS varchar AS $body$
BEGIN
		return current_setting('eis_contas_pend_filtros_pck.ie_atend_cancel')::varchar(4000);
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_contas_pend_filtros_pck.get_ie_atend_cancel () FROM PUBLIC;
