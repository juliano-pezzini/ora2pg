-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_mascara ( cd_mascara_p bigint, ds_mascara_p text default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(50) := null;
ds_mascara_br_w		dic_mascara.ds_mascara_br%type;
ds_mascara_uk_w		dic_mascara.ds_mascara_uk%type;

BEGIN
if (cd_mascara_p IS NOT NULL AND cd_mascara_p::text <> '') then
	begin
		select	ds_mascara_br,
			ds_mascara_uk
		into STRICT	ds_mascara_br_w,
			ds_mascara_uk_w
		from	dic_mascara
		where	cd_mascara = cd_mascara_p;

		if (philips_param_pck.get_nr_seq_idioma = 6) then -- inglês (UK)
			ds_retorno_w := ds_mascara_uk_w;
		else
			ds_retorno_w := ds_mascara_br_w;
		end if;

	exception
		when others then
			ds_retorno_w := ds_mascara_p;
	end;
end if;
return coalesce(ds_retorno_w, ds_mascara_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_mascara ( cd_mascara_p bigint, ds_mascara_p text default null) FROM PUBLIC;
