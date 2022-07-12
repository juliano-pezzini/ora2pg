-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mat_comercial ( cd_material_p bigint, ie_cod_desc_p text) RETURNS varchar AS $body$
DECLARE


cd_material_w		varchar(06);
ds_material_w		varchar(255);
ds_retorno_w		varchar(255);

/*
Ordem da busca:
a) Primeiro Ativo, se não encontrar, o Inativo.
b) Com a Maior prioridade no cadastro
c) Padronizado, se não encontrar o não padronizado
*/
C01 CURSOR FOR
	SELECT	cd_material,
		substr(ds_material,1,255)
	from	material
	where	cd_material_generico	= cd_material_p
	  and	cd_material 		<> cd_material_p
	order by ie_situacao desc,
		coalesce(qt_prioridade_coml,0),
		coalesce(ie_padronizado,'N');


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	open c01;
	loop
	fetch c01 into
		cd_material_w,
		ds_material_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		cd_material_w	:= cd_material_w;
	end loop;
	close c01;

	if (coalesce(cd_material_w::text, '') = '') then
		cd_material_w	:= cd_material_p;
	end if;

	if (substr(ie_cod_desc_p,1,1) = 'C') then
		ds_retorno_w := cd_material_w;
	else
		if (coalesce(ds_material_w::text, '') = '') then
			select	substr(max(ds_material),1,255)
			into STRICT	ds_material_w
			from	material
			where	cd_material	= cd_material_p;
		end if;
		ds_retorno_w := ds_material_w;
	end if;
end if;

RETURN substr(ds_retorno_w,1,255);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mat_comercial ( cd_material_p bigint, ie_cod_desc_p text) FROM PUBLIC;
