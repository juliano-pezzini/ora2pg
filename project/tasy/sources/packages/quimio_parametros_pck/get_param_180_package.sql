-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION quimio_parametros_pck.get_param_180 () RETURNS varchar AS $body$
BEGIN
		return current_setting('quimio_parametros_pck.param_180_w')::varchar(1);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION quimio_parametros_pck.get_param_180 () FROM PUBLIC;
