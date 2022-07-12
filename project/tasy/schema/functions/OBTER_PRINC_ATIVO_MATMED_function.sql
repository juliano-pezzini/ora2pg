-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_princ_ativo_matmed (cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_ficha_tecnica_w	varchar(80);


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select	max(obter_desc_ficha_tecnica(coalesce(nr_seq_ficha_tecnica,0)))
	into STRICT	ds_ficha_tecnica_w
	from	material
	where	cd_material = cd_material_p;

end if;

return ds_ficha_tecnica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_princ_ativo_matmed (cd_material_p bigint) FROM PUBLIC;
