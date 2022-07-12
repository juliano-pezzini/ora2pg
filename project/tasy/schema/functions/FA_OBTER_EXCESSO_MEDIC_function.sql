-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_excesso_medic (cd_material_p bigint, qt_dose_p bigint, cd_unidade_medida_ori_p text) RETURNS bigint AS $body$
DECLARE


qt_dose_convertida_w	double precision;
cd_unidade_medida_des_w	varchar(10);
vl_conversao_w		double precision;
qt_excesso_w		double precision;


BEGIN

select	max(cd_unidade_medida_consumo)
into STRICT	cd_unidade_medida_des_w
from	material
where	cd_material = cd_material_p;

if (cd_unidade_medida_des_w IS NOT NULL AND cd_unidade_medida_des_w::text <> '') then
	--Raise_application_error(-20011,cd_unidade_medida_ori_p ||' - ' ||cd_unidade_medida_des_w);
	qt_dose_convertida_w := Obter_dose_convertida(cd_material_p,qt_dose_p,cd_unidade_medida_des_w,cd_unidade_medida_ori_p);

	if (qt_dose_convertida_w <> trunc(qt_dose_convertida_w)) then
		qt_dose_convertida_w := trunc(qt_dose_convertida_w) + 1;
	end if;

	select	coalesce(max(qt_conversao),0)
	into STRICT	vl_conversao_w
	from	material_conversao_unidade
	where	cd_material = cd_material_p
	and	cd_unidade_medida = cd_unidade_medida_ori_p;
	--Raise_application_error(-20011,vl_conversao_w || ' - ' || cd_unidade_medida_des_w);
	if (vl_conversao_w <> 0) then
		vl_conversao_w := (qt_dose_convertida_w * (1/vl_conversao_w));
	end if;
	--Raise_application_error(-20011,qt_dose_p || ' - ' || vl_conversao_w);
	qt_excesso_w := vl_conversao_w - qt_dose_p;
else
	qt_excesso_w := 0;
end if;

return	qt_excesso_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_excesso_medic (cd_material_p bigint, qt_dose_p bigint, cd_unidade_medida_ori_p text) FROM PUBLIC;

