-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_dose_onco ( cd_material_p bigint, qt_dose_p bigint, ie_via_aplicacao_p text, ie_dispensacao_p text default 'N', cd_intervalo_p text default null) RETURNS bigint AS $body$
DECLARE



ie_via_aplicacao_w	varchar(10);
qt_retorno_w		double precision;
ie_regra_w		varchar(2);
qt_multiplo_w		double precision;
nr_multiplo_w		double precision	:= 0;
qt_casas_decimais_w	bigint;
qt_resto_w			double precision;
cd_grupo_w			smallint	:= 0;
cd_subgrupo_w			smallint	:= 0;
cd_classe_w			integer	:= 0;
cd_intervalo_w		varchar(10)	:= coalesce(cd_intervalo_p,'XPTO');
cd_estabelecimento_w 	bigint := wheb_usuario_pck.get_cd_estabelecimento;


C01 CURSOR FOR
	SELECT	ie_regra,
		coalesce(qt_multiplo,1),
		coalesce(QT_CASAS_DECIMAIS,0)
	from	regra_disp_oncologia
	where	1=1
	and		coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	and 	(((coalesce(ie_utiliza_disp,'S')=  'N') and (ie_dispensacao_p = 'N')) or (coalesce(ie_utiliza_disp,'S') in ('S','E')))
	and	coalesce(cd_material,cd_material_p)			= cd_material_p
	and 	coalesce(cd_classe_material, cd_classe_w)		= cd_classe_w
	and 	coalesce(cd_subgrupo_material, cd_subgrupo_w) 		= cd_subgrupo_w
	and 	coalesce(cd_grupo_material, cd_grupo_w) 	 	= cd_grupo_w
	and	coalesce(ie_via_aplicacao,ie_via_aplicacao_w)	= ie_via_aplicacao_w
	and	coalesce(cd_intervalo,cd_intervalo_w)	= cd_intervalo_w
	order by coalesce(ie_via_aplicacao,'0'),
			coalesce(cd_intervalo,'0'),
	coalesce(cd_material,0),
	coalesce(cd_classe_material,0),
	coalesce(cd_subgrupo_material,0),
	coalesce(cd_grupo_material,0);



BEGIN
ie_via_aplicacao_w	:= coalesce(ie_via_aplicacao_p,'0');

select	coalesce(max(a.cd_classe_material),0),
	coalesce(max(b.cd_subgrupo_material),0),
	coalesce(max(c.cd_grupo_material),0)
into STRICT	cd_classe_w,
	cd_subgrupo_w,
	cd_grupo_w
from	material a,
	classe_material b,
	subgrupo_material c
where	a.cd_material          = cd_material_p
and a.cd_classe_material   = b.cd_classe_material
and b.cd_subgrupo_material = c.cd_subgrupo_material;


open C01;
loop
fetch C01 into
	ie_regra_w,
	qt_multiplo_w,
	QT_CASAS_DECIMAIS_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

if (ie_regra_w	= 'P') then
	qt_retorno_w	:= round(qt_dose_p,QT_CASAS_DECIMAIS_w);
elsif (ie_regra_w	= 'S') then

	if	((trunc(qt_dose_p / qt_multiplo_w) * qt_multiplo_w) = qt_dose_p) then
		nr_multiplo_w	:= (qt_dose_p / qt_multiplo_w);
	else
		nr_multiplo_w   := trunc(qt_dose_p / qt_multiplo_w) + 1;
	end if;
	qt_retorno_w	:= qt_multiplo_w * nr_multiplo_w;

elsif (ie_regra_w	= 'I') then

	if	((trunc(qt_dose_p / qt_multiplo_w) * qt_multiplo_w) = qt_dose_p) then
		nr_multiplo_w	:= (qt_dose_p / qt_multiplo_w);
	else
		nr_multiplo_w   := trunc(qt_dose_p / qt_multiplo_w);
	end if;
	qt_retorno_w	:= qt_multiplo_w * nr_multiplo_w;
elsif (ie_regra_w	= 'A') then
	qt_resto_w	:= mod(qt_dose_p,qt_multiplo_w);

	if	((qt_resto_w/qt_multiplo_w ) >= 0.5) then
		nr_multiplo_w   := trunc(qt_dose_p / qt_multiplo_w) + 1;
	else
		nr_multiplo_w   := trunc(qt_dose_p / qt_multiplo_w);
	end if;
	qt_retorno_w	:= qt_multiplo_w * nr_multiplo_w;
else
	qt_retorno_w	:= qt_dose_p;

end if;


return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_dose_onco ( cd_material_p bigint, qt_dose_p bigint, ie_via_aplicacao_p text, ie_dispensacao_p text default 'N', cd_intervalo_p text default null) FROM PUBLIC;

