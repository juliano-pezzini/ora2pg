-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inf_procedencia (cd_procedencia_p bigint, ie_campo_p text) RETURNS varchar AS $body$
DECLARE


ds_procedencia_w		varchar(40);
nm_curto_w			varchar(5);
ds_retorno_w			varchar(40);


BEGIN

if (cd_procedencia_p IS NOT NULL AND cd_procedencia_p::text <> '') then
	select	ds_procedencia,
		nm_curto
	into STRICT	ds_procedencia_w,
		nm_curto_w
	from	procedencia
	where	cd_procedencia	= cd_procedencia_p;
end if;

if (ie_campo_p	= 'D') then
	ds_retorno_w	:= ds_procedencia_w;
else
	ds_retorno_w	:= nm_curto_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inf_procedencia (cd_procedencia_p bigint, ie_campo_p text) FROM PUBLIC;
