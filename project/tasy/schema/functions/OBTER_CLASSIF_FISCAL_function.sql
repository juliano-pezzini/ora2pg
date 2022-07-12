-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_fiscal (cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


cd_classif_fiscal_w   material.cd_classif_fiscal%type;


BEGIN

select max(cd_classif_fiscal)
into STRICT   cd_classif_fiscal_w
from   material
where  cd_material = cd_material_p;

return	cd_classif_fiscal_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_fiscal (cd_material_p bigint) FROM PUBLIC;

