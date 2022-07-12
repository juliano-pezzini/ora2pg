-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mat_inconsistente (cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ie_inconsistente_w		varchar(01)	:= 'N';
qt_componente_kit_w		bigint	:= 0;
qt_protocolo_w		bigint	:= 0;
qt_ajuste_mat_w		bigint	:= 0;
cd_estabelecimento_w	smallint;


BEGIN
select 	wheb_usuario_pck.get_cd_estabelecimento
into STRICT	cd_estabelecimento_w
;

select	count(*)
into STRICT	qt_componente_kit_w
from	componente_kit
where	cd_material	= cd_material_p
and	((coalesce(cd_estab_regra::text, '') = '') or (cd_estab_regra = cd_estabelecimento_w));

select	count(*)
into STRICT	qt_protocolo_w
from	protocolo_medic_material
where	cd_material	= cd_material_p;

select	count(*)
into STRICT	qt_ajuste_mat_w
from	regra_ajuste_material
where	cd_material	= cd_material_p;

if (qt_componente_kit_w > 0) or (qt_protocolo_w > 0) or (qt_ajuste_mat_w > 0) then
	ie_inconsistente_w	:= 'S';
end if;

return	ie_inconsistente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mat_inconsistente (cd_material_p bigint) FROM PUBLIC;
