-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE eis_contas_pend_filtros_pck.set_ie_contas_canceladas ( ie_contas_canceladas_p text) AS $body$
BEGIN
		PERFORM set_config('eis_contas_pend_filtros_pck.ie_contas_canceladas', ie_contas_canceladas_p, false);
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eis_contas_pend_filtros_pck.set_ie_contas_canceladas ( ie_contas_canceladas_p text) FROM PUBLIC;
