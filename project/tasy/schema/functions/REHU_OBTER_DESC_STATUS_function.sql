-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rehu_obter_desc_status ( ie_status_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

if (ie_status_p = 1) then
	ds_retorno_w 	:= 	obter_desc_expressao(289110);
elsif (ie_status_p = 2) then
	ds_retorno_w 	:= 	obter_desc_expressao(290157);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rehu_obter_desc_status ( ie_status_p bigint) FROM PUBLIC;

