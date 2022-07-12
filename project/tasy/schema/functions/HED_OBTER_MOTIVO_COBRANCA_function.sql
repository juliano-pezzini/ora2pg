-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hed_obter_motivo_cobranca ( cd_motivo_alta_p bigint) RETURNS bigint AS $body$
DECLARE

ds_retorno_w 	smallint;


BEGIN

if (cd_motivo_alta_p in (14,16,69,71,65,66,67,68,64,61,62,63,13,12)) then
	ds_retorno_w := 1;
elsif (cd_motivo_alta_p in (116,115,41,43,44,45,46,54,51,53)) then
	ds_retorno_w := 2;
elsif (cd_motivo_alta_p in (34,33,10,19,38,35,39,37,32,31,21,24,18,17,22)) then
	ds_retorno_w := 3;
elsif (cd_motivo_alta_p in (117)) then
	ds_retorno_w := 4;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hed_obter_motivo_cobranca ( cd_motivo_alta_p bigint) FROM PUBLIC;
