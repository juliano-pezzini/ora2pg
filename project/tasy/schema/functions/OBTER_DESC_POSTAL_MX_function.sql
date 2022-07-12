-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_postal_mx (nr_sequencia_p bigint, ie_tipo_cat_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(200);


BEGIN

if (ie_tipo_cat_p = 'L') then

	select 	ds_cat_localidade
	into STRICT	ds_retorno_w
	from 	cat_localidade a,
			cat_codigo_postal b
	where 	a.cd_cat_municipio = b.cve_mun
	and 	a.cd_efe = b.cve_ent
	and		a.cd_cat_localidade = b.cve_loc
	and		b.nr_sequencia = nr_sequencia_p;

elsif (ie_tipo_cat_p = 'M') then

	select 	ds_cat_municipio
	into STRICT	ds_retorno_w
	from 	cat_municipio a,
			cat_codigo_postal b
	where 	cd_cat_entidades = b.cve_ent
	and		a.cd_cat_municipio = b.cve_mun
	and		b.nr_sequencia = nr_sequencia_p;

elsif (ie_tipo_cat_p = 'A') then

	select 	nm_assentamento
	into STRICT	ds_retorno_w
	from 	cat_assentamento a,
			cat_codigo_postal b
	where 	a.cd_entidade = b.cve_ent
	and 	a.cd_localidade = b.cve_loc
	and 	a.cd_municipio = b.cve_mun
	and		a.cd_assentamento = b.cve_asen
	and		b.nr_sequencia = nr_sequencia_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_postal_mx (nr_sequencia_p bigint, ie_tipo_cat_p text) FROM PUBLIC;

