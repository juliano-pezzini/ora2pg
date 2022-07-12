-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_diluente_baixa_auto ( cd_material_p bigint, cd_diluente_p bigint) RETURNS varchar AS $body$
DECLARE


cd_motivo_w		smallint;
ie_baixa_w		varchar(1) := 'N';


BEGIN

select	coalesce(max(cd_motivo_baixa),0)
into STRICT	cd_motivo_w
from	material_diluicao
where	cd_material = cd_material_p
and	cd_diluente = cd_diluente_p;

if (cd_motivo_w <> 0) then
	ie_baixa_w := 'S';
end if;

return	ie_baixa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_diluente_baixa_auto ( cd_material_p bigint, cd_diluente_p bigint) FROM PUBLIC;
