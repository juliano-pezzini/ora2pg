-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agrupa_acm_sn_medic (nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_agrupar_acm_sn_p text, dt_inicio_valid_p timestamp default null, dt_fim_valid_p timestamp default null) RETURNS varchar AS $body$
DECLARE


ie_agrupar_acm_sn_w		varchar(1);
cd_material_w			bigint;
cd_intervalo_w			varchar(10);
qt_dose_w			double precision;
dt_inicio_prescr_w		timestamp;
dt_validade_prescr_w		timestamp;
dt_inicio_w			timestamp;
dt_validade_w			timestamp;
nr_atendimento_w		bigint;
ie_existe_w			varchar(1);


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') and (ie_agrupar_acm_sn_p = 'S') then

	select	max(a.cd_material),
		max(a.cd_intervalo),
		max(a.qt_dose),
		max(b.dt_inicio_prescr - 1),
		max(b.dt_validade_prescr + 1),
		max(b.nr_atendimento)
	into STRICT	cd_material_w,
		cd_intervalo_w,
		qt_dose_w,
		dt_inicio_prescr_w,
		dt_validade_prescr_w,
		nr_atendimento_w
	from	prescr_medica b,
		prescr_material a
	where	a.nr_prescricao	= b.nr_prescricao
	and	a.nr_prescricao	= nr_prescricao_p
	and	a.nr_sequencia	= nr_seq_prescr_p
	and	b.nr_prescricao	= nr_prescricao_p;

	dt_inicio_w	:= dt_inicio_prescr_w - 2;
	dt_validade_w	:= dt_validade_prescr_w + 2;

	select	CASE WHEN count(a.nr_sequencia)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_existe_w
	from	prescr_medica b,
		prescr_material a
	where	a.nr_prescricao		= b.nr_prescricao
	and	((a.nr_prescricao	<> nr_prescricao_p) or (a.nr_sequencia	<> nr_seq_prescr_p))
	and	b.nr_atendimento	= nr_atendimento_w
	and (b.dt_validade_prescr	between dt_inicio_w and dt_validade_w)
	and	a.cd_material		= cd_material_w
	and	a.cd_intervalo		= cd_intervalo_w
	and	a.qt_dose		= qt_dose_w
	and	((b.dt_inicio_prescr	between dt_inicio_prescr_w and dt_validade_prescr_w) or (b.dt_validade_prescr	between dt_inicio_prescr_w and dt_validade_prescr_w) or
		 (b.dt_validade_prescr	> dt_validade_prescr_w AND b.dt_inicio_prescr	< dt_inicio_prescr_w));

	if (ie_existe_w	= 'S') then
		ie_agrupar_acm_sn_w	:= 'S';
	else
		ie_agrupar_acm_sn_w	:= 'N';
	end if;

else

	ie_agrupar_acm_sn_w	:= 'N';

end if;

return ie_agrupar_acm_sn_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agrupa_acm_sn_medic (nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_agrupar_acm_sn_p text, dt_inicio_valid_p timestamp default null, dt_fim_valid_p timestamp default null) FROM PUBLIC;
