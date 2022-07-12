-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_suplementacao_dietetica ( nr_atendimento_p bigint, nr_agrupador_p bigint, qt_horas_p bigint) RETURNS varchar AS $body$
DECLARE



/*
12 - suplemento oral
8  - suporte nutricional enteral
*/
ds_material_w	varchar(255);
qt_dose_w	double precision;
ds_unid_med_w	varchar(40);
ds_horarios_w	varchar(2000);
nr_prescricao_w	bigint;
nr_sequencia_w	bigint;
ds_retorno_w	varchar(1000);


BEGIN



if (qt_horas_p	= 0) then
	select	max(x.nr_prescricao),
		max(x.nr_sequencia)
	into STRICT	nr_prescricao_w,
		nr_sequencia_w
	from	prescr_material x,
		prescr_medica p
	where	x.nr_prescricao =	p.nr_prescricao
	and	nr_atendimento	=	nr_atendimento_p
	and	ie_agrupador	=	nr_agrupador_p
	and ((coalesce(dt_validade_prescr::text, '') = '') or (clock_timestamp() between p.dt_inicio_prescr and p.dt_validade_prescr));
else
	select	max(x.nr_prescricao),
		max(x.nr_sequencia)
	into STRICT	nr_prescricao_w,
		nr_sequencia_w
	from	prescr_material x,
		prescr_medica p
	where	x.nr_prescricao =	p.nr_prescricao
	and	nr_atendimento	=	nr_atendimento_p
	and	ie_agrupador	=	nr_agrupador_p
	and	p.dt_prescricao between clock_timestamp() - (qt_horas_p/24) and clock_timestamp() + interval '3 days'
	and ((coalesce(dt_validade_prescr::text, '') = '') or (clock_timestamp() between p.dt_inicio_prescr and p.dt_validade_prescr));
end if;


if (nr_prescricao_w > 0) then

	select	max(substr(obter_desc_material(cd_material),1,150)),
		max(coalesce(qt_dose,0)),
		max(obter_unidade_medida(cd_unidade_medida_dose)),
		max(ds_horarios)
	into STRICT	ds_material_w,
		qt_dose_w,
		ds_unid_med_w,
		ds_horarios_w
	from	prescr_material
	where	nr_prescricao = nr_prescricao_w
	and	nr_sequencia	= nr_sequencia_w;

	ds_retorno_w := (ds_material_w || ' / ' || qt_dose_w || ' ' || ds_unid_med_w ||  ' / ' || ds_horarios_w);
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_suplementacao_dietetica ( nr_atendimento_p bigint, nr_agrupador_p bigint, qt_horas_p bigint) FROM PUBLIC;
