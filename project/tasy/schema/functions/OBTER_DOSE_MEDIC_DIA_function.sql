-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dose_medic_dia ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_utiliza_horarios_p text, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
dt_inicio_prescr_w			timestamp;
dt_validade_prescr_w		timestamp;
dt_inicio_prescr_ww			timestamp;
dt_validade_prescr_ww		timestamp;
qt_dose_w					prescr_material.qt_dose%type;
cd_unidade_medida_dose_w	prescr_material.cd_unidade_medida_dose%type;
qt_dose_acumulada_w			prescr_material.qt_dose%type;
ie_dose_max_lib_w			varchar(1);
cd_estabelecimento_w		prescr_medica.cd_estabelecimento%type;

c01 CURSOR FOR
SELECT	coalesce(sum(c.qt_dose),0),
		c.cd_unidade_medida_dose
from	prescr_mat_hor c,
		prescr_material b,
		prescr_medica a
where	a.nr_prescricao		= b.nr_prescricao
and		a.nr_atendimento	= nr_atendimento_w
and		b.cd_material		= cd_material_p
and		b.nr_prescricao		= c.nr_prescricao
and		b.nr_sequencia		= c.nr_seq_material
and		coalesce(a.dt_suspensao::text, '') = ''
and		a.nr_prescricao <> nr_prescricao_p
and		coalesce(b.ie_suspenso,'N')	= 'N'
and		coalesce(c.dt_suspensao::text, '') = ''
and		c.dt_horario between dt_inicio_prescr_w and dt_validade_prescr_w
and		a.dt_inicio_prescr between dt_inicio_prescr_ww and dt_validade_prescr_ww
and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
and		coalesce(ie_dose_max_lib_w,'N') = 'N'
group by c.cd_unidade_medida_dose

union all

select	coalesce(sum(c.qt_dose),0),
		c.cd_unidade_medida_dose
from	prescr_mat_hor c,
		prescr_material b,
		prescr_medica a
where	a.nr_prescricao		= b.nr_prescricao
and		a.nr_atendimento	= nr_atendimento_w
and		b.cd_material		= cd_material_p
and		b.nr_prescricao		= c.nr_prescricao
and		b.nr_sequencia		= c.nr_seq_material
and		coalesce(a.dt_suspensao::text, '') = ''
and		a.nr_prescricao <> nr_prescricao_p
and		coalesce(b.ie_suspenso,'N')	= 'N'
and		coalesce(c.dt_suspensao::text, '') = ''
and		c.dt_horario between dt_inicio_prescr_w and dt_validade_prescr_w
and		a.dt_inicio_prescr between dt_inicio_prescr_ww and dt_validade_prescr_ww
and		coalesce(ie_dose_max_lib_w,'N') = 'S'
group by c.cd_unidade_medida_dose

union all

select	sum(coalesce(c.qt_dose,c.qt_volume)),
		substr(coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml')),1,30)
from	nut_pac a,
		nut_pac_elemento b,
		nut_pac_elem_mat c,
		nut_elem_material d,
		prescr_medica e
where	a.nr_sequencia = b.nr_seq_nut_pac
and		b.nr_sequencia = c.nr_seq_pac_elem
and		b.nr_seq_elemento = d.nr_seq_elemento
and		d.nr_sequencia = c.nr_seq_elem_mat
and		a.nr_prescricao = e.nr_prescricao
and		a.nr_prescricao <> nr_prescricao_p
and		d.cd_material = cd_material_p
and		coalesce(a.dt_suspensao::text, '') = ''
and		coalesce(e.dt_suspensao::text, '') = ''
and		e.dt_inicio_prescr between dt_inicio_prescr_ww and dt_validade_prescr_ww
and 	e.nr_atendimento = nr_atendimento_w
group by coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml'))

union all

select	sum(coalesce(c.qt_dose,c.qt_volume)),
		substr(coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml')),1,30)
from	nut_pac a,
		nut_pac_elem_mat c,
		prescr_medica d
where	a.nr_sequencia = c.nr_seq_nut_pac
and		a.nr_prescricao = d.nr_prescricao
and		coalesce(a.ie_npt_adulta,'S') = 'S'
and		a.nr_prescricao <> nr_prescricao_p
and		c.cd_material = cd_material_p
and		coalesce(a.dt_suspensao::text, '') = ''
and		coalesce(d.dt_suspensao::text, '') = ''
and		d.dt_inicio_prescr between dt_inicio_prescr_ww and dt_validade_prescr_ww
and 	d.nr_atendimento = nr_atendimento_w
group by coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml'))

union all

select	sum(coalesce(c.qt_dose,c.qt_volume)),
		substr(coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml')),1,30)
from	nut_paciente a,
		nut_paciente_elemento b,
		nut_pac_elem_mat c,
		prescr_medica d
where	a.nr_sequencia = b.nr_seq_nut_pac
and		b.nr_sequencia = c.nr_seq_nut_pac_ele
and		a.nr_prescricao = d.nr_prescricao
and		a.nr_prescricao <> nr_prescricao_p
and		cd_material = cd_material_p
and		coalesce(a.dt_suspensao::text, '') = ''
and		coalesce(d.dt_suspensao::text, '') = ''
and		d.dt_inicio_prescr between dt_inicio_prescr_ww and dt_validade_prescr_ww
and 	d.nr_atendimento = nr_atendimento_w
group by coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml'));

c02 CURSOR FOR
SELECT	coalesce(sum(b.qt_dose),0) + sum(coalesce(b.qt_dose_especial,0)),
		b.cd_unidade_medida_dose
from	prescr_material b,
		prescr_medica a
where	a.nr_prescricao		= b.nr_prescricao
and		a.nr_atendimento	= nr_atendimento_w
and		b.cd_material		= cd_material_p
and		a.nr_prescricao		<> nr_prescricao_p
and		coalesce(a.dt_suspensao::text, '') = ''
and		coalesce(b.ie_suspenso,'N')	= 'N'
and		a.dt_inicio_prescr between dt_inicio_prescr_ww and dt_validade_prescr_ww
group by b.cd_unidade_medida_dose

union all

select	sum(coalesce(c.qt_dose,c.qt_volume)),
		substr(coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml')),1,30)
from	nut_pac a,
		nut_pac_elemento b,
		nut_pac_elem_mat c,
		nut_elem_material d,
		prescr_medica e
where	a.nr_sequencia = b.nr_seq_nut_pac
and		b.nr_sequencia = c.nr_seq_pac_elem
and		b.nr_seq_elemento = d.nr_seq_elemento
and		d.nr_sequencia = c.nr_seq_elem_mat
and		a.nr_prescricao = e.nr_prescricao
and		a.nr_prescricao <> nr_prescricao_p
and		d.cd_material = cd_material_p
and		coalesce(a.dt_suspensao::text, '') = ''
and		coalesce(e.dt_suspensao::text, '') = ''
and		e.dt_inicio_prescr between dt_inicio_prescr_ww and dt_validade_prescr_ww
and 	e.nr_atendimento = nr_atendimento_w
group by coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml'))

union all

select	sum(coalesce(c.qt_dose,c.qt_volume)),
		substr(coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml')),1,30)
from	nut_pac a,
		nut_pac_elem_mat c,
		prescr_medica d
where	a.nr_sequencia = c.nr_seq_nut_pac
and		a.nr_prescricao = d.nr_prescricao
and		coalesce(a.ie_npt_adulta,'S') = 'S'
and		a.nr_prescricao <> nr_prescricao_p
and		c.cd_material = cd_material_p
and		coalesce(a.dt_suspensao::text, '') = ''
and		coalesce(d.dt_suspensao::text, '') = ''
and		d.dt_inicio_prescr between dt_inicio_prescr_ww and dt_validade_prescr_ww
and 	d.nr_atendimento = nr_atendimento_w
group by coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml'))

union all

select	sum(coalesce(c.qt_dose,c.qt_volume)),
		substr(coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml')),1,30)
from	nut_paciente a,
		nut_paciente_elemento b,
		nut_pac_elem_mat c,
		prescr_medica d
where	a.nr_sequencia = b.nr_seq_nut_pac
and		b.nr_sequencia = c.nr_seq_nut_pac_ele
and		a.nr_prescricao = d.nr_prescricao
and		a.nr_prescricao <> nr_prescricao_p
and		cd_material = cd_material_p
and		coalesce(a.dt_suspensao::text, '') = ''
and		coalesce(d.dt_suspensao::text, '') = ''
and		d.dt_inicio_prescr between dt_inicio_prescr_ww and dt_validade_prescr_ww
and 	d.nr_atendimento = nr_atendimento_w
group by coalesce(c.cd_unidade_medida, obter_unid_med_usua('ml'));


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	select	max(a.nr_atendimento),
			max(a.dt_inicio_prescr),
			max(a.dt_validade_prescr),
			max(cd_estabelecimento)
	into STRICT	nr_atendimento_w,
			dt_inicio_prescr_w,
			dt_validade_prescr_w,
			cd_estabelecimento_w
	from	prescr_medica a
	where	a.nr_prescricao	= nr_prescricao_p;

	select max(ie_dose_max_lib)
	into STRICT	ie_dose_max_lib_w
	from	parametro_medico
	where	cd_estabelecimento = cd_estabelecimento_w;

	dt_inicio_prescr_ww		:= dt_inicio_prescr_w - 2;
	dt_validade_prescr_ww	:= dt_validade_prescr_w + 2;

	qt_dose_acumulada_w	:= 0;
	if (ie_utiliza_horarios_p	= 'S') then

		open C01;
		loop
		fetch C01 into
			qt_dose_w,
			cd_unidade_medida_dose_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			qt_dose_acumulada_w	:= qt_dose_acumulada_w + obter_conversao_unid_med_cons(cd_material_p,cd_unidade_medida_dose_w,qt_dose_w);
			end;
		end loop;
		close C01;
	else
		open C02;
		loop
		fetch C02 into
			qt_dose_w,
			cd_unidade_medida_dose_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			qt_dose_acumulada_w	:= qt_dose_acumulada_w + obter_conversao_unid_med_cons(cd_material_p,cd_unidade_medida_dose_w,qt_dose_w);
			end;
		end loop;
		close C02;
	end if;
end if;

return qt_dose_acumulada_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dose_medic_dia ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_utiliza_horarios_p text, cd_material_p bigint) FROM PUBLIC;
