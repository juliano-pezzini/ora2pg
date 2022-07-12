-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_full_desc_topografia (cd_topografia_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(4000);
ds_category_w			cido_categoria.ds_categoria%TYPE;
ds_topografy_w			cido_topografia.ds_topografia%TYPE;
ds_category_anatomica_w	cido_categoria_anatomica.ds_categoria_anatomica%TYPE;
cd_category_w			cido_categoria.cd_categoria%TYPE;
cd_category_anatomica_w	cido_categoria_anatomica.cd_categoria_anatomica%TYPE;


BEGIN

if (cd_topografia_p IS NOT NULL AND cd_topografia_p::text <> '') then
	select	substr(ds_topografia,1,100),
		cd_categoria
	into STRICT	ds_topografy_w,
		cd_category_w
	from	cido_topografia
	where	cd_topografia = cd_topografia_p;
end if;

if (cd_category_w IS NOT NULL AND cd_category_w::text <> '') then
	select	substr(ds_categoria,1,100),
		cd_categoria_anatomica
	into STRICT	ds_category_w,
		cd_category_anatomica_w
	from	cido_categoria
	where	cd_categoria	= cd_category_w;
end if;

if (cd_category_anatomica_w IS NOT NULL AND cd_category_anatomica_w::text <> '') then
	select	substr(ds_categoria_anatomica,1,80)
	into STRICT	ds_category_anatomica_w
	from	cido_categoria_anatomica
	where	cd_categoria_anatomica	= cd_category_anatomica_w;
end if;

if (coalesce(ds_category_w::text, '') = '') and (coalesce(ds_category_anatomica_w::text, '') = '') then
	ds_retorno_w	:= ds_topografy_w;
elsif (coalesce(ds_category_w::text, '') = '') or (coalesce(ds_category_anatomica_w::text, '') = '') then
	ds_retorno_w	:= coalesce(ds_category_w, ds_category_anatomica_w) || ' (' || ds_topografy_w || ')';
else
	ds_retorno_w	:= ds_category_w || ', ' || ds_category_anatomica_w || ' (' || ds_topografy_w || ')';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_full_desc_topografia (cd_topografia_p text) FROM PUBLIC;

