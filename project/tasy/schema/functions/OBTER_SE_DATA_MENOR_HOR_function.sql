-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_data_menor_hor (dt_ref_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE

ds_retorno_w varchar(1);

BEGIN

ds_retorno_w := 'N';

if (dt_ref_p <= dt_final_p) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_data_menor_hor (dt_ref_p timestamp, dt_final_p timestamp) FROM PUBLIC;

