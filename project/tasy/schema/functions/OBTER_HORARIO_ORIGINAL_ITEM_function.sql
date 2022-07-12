-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horario_original_item ( nr_seq_horario_p bigint, dt_horario_p timestamp) RETURNS timestamp AS $body$
DECLARE


nr_seq_evento_w		bigint;
cont_w			bigint;
nr_seq_superior_w		bigint;
nr_seq_material_w		bigint;
nr_prescricao_w		bigint;
nr_seq_horario_w		bigint;
dt_horario_w		timestamp;


BEGIN

select	count(*)
into STRICT	cont_w
from	prescr_mat_alteracao
where	nr_seq_horario	= nr_seq_horario_p
and	ie_alteracao	in (10,15);

select	max(dt_horario),
	max(nr_seq_superior),
	max(nr_prescricao)
into STRICT	dt_horario_w,
	nr_seq_superior_w,
	nr_prescricao_w
from	prescr_mat_hor
where	nr_sequencia	= nr_seq_horario_p
and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';

if (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_material_w
	from	prescr_material
	where	nr_prescricao	= nr_prescricao_w
	and	nr_sequencia	= nr_seq_superior_w;

	select	min(y.nr_sequencia)
	into STRICT	nr_seq_horario_w
	from	prescr_mat_hor y
	where	y.nr_prescricao	= nr_prescricao_w
	and	y.nr_seq_material = nr_seq_material_w
	and	trunc(dt_horario, 'mi') = trunc(dt_horario_p,'mi')
	and	Obter_se_horario_liberado(y.dt_lib_horario, y.dt_horario) = 'S';

	select	min(nr_sequencia)
	into STRICT	nr_seq_evento_w
	from	prescr_mat_alteracao
	where	nr_seq_horario	= nr_seq_horario_w
	and	ie_alteracao	in (10,15);

	if (nr_seq_evento_w IS NOT NULL AND nr_seq_evento_w::text <> '') then
		select	min(dt_horario_original)
		into STRICT	dt_horario_w
		from	prescr_mat_alteracao
		where	nr_sequencia	= nr_seq_evento_w;
	else
		select	min(y.dt_horario)
		into STRICT	dt_horario_w
		from	prescr_mat_hor y
		where	y.nr_sequencia = nr_seq_horario_w
		and	Obter_se_horario_liberado(y.dt_lib_horario, y.dt_horario) = 'S';
	end if;

elsif (cont_w > 0) then
	select	min(nr_sequencia)
	into STRICT	nr_seq_evento_w
	from	prescr_mat_alteracao
	where	nr_seq_horario	= nr_seq_horario_p
	and	ie_alteracao	in (10,15);

	select	min(dt_horario_original)
	into STRICT	dt_horario_w
	from	prescr_mat_alteracao
	where	nr_sequencia	= nr_seq_evento_w;
end if;

return	dt_horario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horario_original_item ( nr_seq_horario_p bigint, dt_horario_p timestamp) FROM PUBLIC;
