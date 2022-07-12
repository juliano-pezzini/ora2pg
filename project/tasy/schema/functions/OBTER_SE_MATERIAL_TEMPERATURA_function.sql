-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_material_temperatura ( cd_estabelecimento_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
qt_existe_w	integer;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	inspecao_regra_material
where	cd_material = cd_material_p
and	cd_estabelecimento = cd_estabelecimento_p
and	coalesce(ie_temperatura, 'N') = 'S'
and	(qt_temperatura_min IS NOT NULL AND qt_temperatura_min::text <> '')
and	(qt_temperatura_max IS NOT NULL AND qt_temperatura_max::text <> '');

ds_retorno_w	:= 'N';
if (qt_existe_w > 0) then
	ds_retorno_w	:= 'S';
end if;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_material_temperatura ( cd_estabelecimento_p bigint, cd_material_p bigint) FROM PUBLIC;

