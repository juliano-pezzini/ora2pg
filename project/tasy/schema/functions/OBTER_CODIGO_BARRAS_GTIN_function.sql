-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_barras_gtin ( cd_cgc_emitente_p bigint, cd_material_p bigint, nr_sequencia_p bigint, nr_item_nf_p bigint) RETURNS varchar AS $body$
DECLARE


cd_barras_w	varchar(255);


BEGIN

	select	max(f.cd_gtin)
	into STRICT  	cd_barras_w
	from   	material_fiscal f
	where  	f.cd_material = cd_material_p;
	
	if (coalesce(cd_barras_w::text, '') = '') then
		select	max(r.cd_barra_material)
		into STRICT	cd_barras_w
		from 	material_cod_barra r 
		where 	r.cd_material = cd_material_p 
		and 	r.cd_cgc_fabricante = cd_cgc_emitente_p;
		
		if (coalesce(cd_barras_w::text, '') = '') then
			select	max(r.cd_barra_material)
			into STRICT	cd_barras_w
			from 	material_cod_barra r 
			where 	r.cd_material = cd_material_p 
			and 	coalesce(r.cd_cgc_fabricante::text, '') = '';
			
			if (coalesce(cd_barras_w::text, '') = '') then
				cd_barras_w := 'SEM GTIN';
			end if;
		end if;
	end if;
		
return cd_barras_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_barras_gtin ( cd_cgc_emitente_p bigint, cd_material_p bigint, nr_sequencia_p bigint, nr_item_nf_p bigint) FROM PUBLIC;

