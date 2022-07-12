-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dose_util_manip_quimio ( nr_seq_ordem_p bigint, cd_material_p bigint, cd_unid_prescr_p text) RETURNS bigint AS $body$
DECLARE


qt_material_prescr_w	double precision;
qt_quantidade_w		double precision;
cd_material_w		bigint;
cd_unidade_medida_w	varchar(30);
C01 CURSOR FOR
	SELECT 	sum(qt_material),
		cd_material,
		cd_unidade_medida
	from 	w_preparo_quimio_lote a
	where 	nr_seq_ordem = nr_seq_ordem_p
	and	obter_ficha_tecnica_medic(cd_material) = obter_ficha_tecnica_medic(cd_material_p)
	group by cd_material,
		 cd_unidade_medida;


BEGIN

qt_quantidade_w := 0;

open C01;
loop
fetch C01 into
	qt_material_prescr_w,
	cd_material_w,
	cd_unidade_medida_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_quantidade_w := qt_quantidade_w + Obter_dose_convertida_quimio(cd_material_w,qt_material_prescr_w,cd_unidade_medida_w,cd_unid_prescr_p);
	end;
end loop;
close C01;

return	qt_quantidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dose_util_manip_quimio ( nr_seq_ordem_p bigint, cd_material_p bigint, cd_unid_prescr_p text) FROM PUBLIC;
