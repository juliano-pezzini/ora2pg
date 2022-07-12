-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION csan21_verifica_data_venc (dt_vencimento timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(5);

BEGIN
ds_retorno_w	:= 'N';

if (dt_vencimento IS NOT NULL AND dt_vencimento::text <> '') then

	if (dt_vencimento < clock_timestamp()) then
		ds_retorno_w := 'S';
	elsif (dt_vencimento >= clock_timestamp()) then
		ds_retorno_w := 'N';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION csan21_verifica_data_venc (dt_vencimento timestamp) FROM PUBLIC;

