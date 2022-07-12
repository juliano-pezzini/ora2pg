-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_material_higienizacao (cd_material_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(100) := '';


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	begin
	select a.ds_material ds
	into STRICT ds_retorno_w
	from material a, cih_material_hig b
	where a.cd_material = b.cd_material
	AND b.nr_sequencia = cd_material_p;

	exception
		when others then
			ds_retorno_w	:= '';
	end;

end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_material_higienizacao (cd_material_p bigint ) FROM PUBLIC;
