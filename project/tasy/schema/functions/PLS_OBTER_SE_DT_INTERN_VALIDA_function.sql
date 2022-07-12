-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_dt_intern_valida (dt_internacao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2) := 'S';


BEGIN

	if (to_date(dt_internacao_p, 'dd/mm/yyyy hh24:mi:ss') > clock_timestamp()) then
		ds_retorno_w := 'N';
	end if;

return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_dt_intern_valida (dt_internacao_p text) FROM PUBLIC;

