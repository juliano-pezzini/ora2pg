-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_um_dosagem_prescr2 ( nr_prescricao_p bigint, nr_sequencia_p bigint ) RETURNS varchar AS $body$
DECLARE


qt_dose_w			varchar(15);
qt_solucao_w			double precision;
cd_unidade_medida_dose_w	varchar(30);
ds_prescr_w			varchar(15);
ds_prescricao_w			varchar(60);
ds_dose_diferenciada_w		varchar(50);
ds_retorno_w			varchar(80);
nr_agrupamento_w		double precision;
qt_reg_w			integer;
nr_seq_w			integer;
ie_via_w			varchar(05);
ie_agrupador_w			smallint;
qt_dose_especial_w		double precision;
hr_dose_especial_w		varchar(5);


BEGIN

select	converte_fracao_dose(a.cd_unidade_medida_dose, b.qt_dose)  qt_dose,
	a.cd_unidade_medida_dose,
	c.ds_prescricao,
	a.ie_via_aplicacao,
	a.nr_agrupamento,
	a.ie_agrupador
into STRICT	qt_dose_w,
	cd_unidade_medida_dose_w,
	ds_prescr_w,
	ie_via_w,
	nr_agrupamento_w,
	ie_agrupador_w
from  	prescr_mat_hor b,
	intervalo_prescricao c,
	prescr_material a
where 	a.cd_intervalo 		= c.cd_intervalo
and	a.nr_prescricao 	= b.nr_prescricao
and	a.nr_sequencia		= b.nr_seq_material
and 	a.nr_prescricao  	= nr_prescricao_p
and	b.nr_sequencia		= nr_sequencia_p
and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S';

if (substr(qt_dose_w,1,1) = ',') then
	qt_dose_w	:= '0' || qt_dose_w;
end if;
qt_dose_w	:= replace(qt_dose_w,'.',',');

select	count(*),
	min(nr_sequencia)
into STRICT	qt_reg_w,
	nr_seq_w
from	prescr_material
where	nr_prescricao		= nr_prescricao_p
  and	ie_agrupador		= 1
  and	nr_agrupamento		= nr_agrupamento_w;

if (qt_reg_w > 1) and (nr_sequencia_p <> nr_seq_w) then
	ds_prescricao_w	:= '';
	ie_via_w		:= '';
else
	ds_prescricao_w	:= ds_prescr_w;
end if;

if 	((ie_agrupador_w <> 1) or (ie_agrupador_w = 1) and (coalesce(qt_solucao_w::text, '') = '')) then
	ds_retorno_w	:= qt_dose_w || ' ' || cd_unidade_medida_dose_w ||
			'   ' ||ds_prescricao_w || '   ' || ie_via_w;
else
	ds_retorno_w	:= ds_prescricao_w || '   ' || ie_via_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_um_dosagem_prescr2 ( nr_prescricao_p bigint, nr_sequencia_p bigint ) FROM PUBLIC;
