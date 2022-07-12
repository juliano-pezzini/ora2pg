-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION param_recalculo_conta_pck.get_recalcular_conta () RETURNS varchar AS $body$
BEGIN
		return current_setting('param_recalculo_conta_pck.ie_recalcular_w')::varchar(1);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION param_recalculo_conta_pck.get_recalcular_conta () FROM PUBLIC;