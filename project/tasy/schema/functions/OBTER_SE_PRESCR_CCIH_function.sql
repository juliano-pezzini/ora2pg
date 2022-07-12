-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prescr_ccih (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


cd_material_w		bigint;
cd_mat_cih_w		bigint;
ie_prescr_cih_w		varchar(1) := 'N';

C01 CURSOR FOR
	SELECT	cd_material
	from	prescr_material
	where	nr_prescricao = nr_prescricao_p
	group by cd_material;


BEGIN

open C01;
loop
fetch C01 into
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	coalesce(max(cd_material),0)
	into STRICT	cd_mat_cih_w
	from	material
	where	cd_material = cd_material_w
	and	(cd_medicamento IS NOT NULL AND cd_medicamento::text <> '')
	and	coalesce(ie_controle_medico,0) = 2;

	if (cd_mat_cih_w <> 0) then
		ie_prescr_cih_w := 'S';
		exit;
	end if;

	end;
end loop;
close C01;

return	ie_prescr_cih_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prescr_ccih (nr_prescricao_p bigint) FROM PUBLIC;
