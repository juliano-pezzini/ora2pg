-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_hor_assoc_item ( nr_seq_item_cpoe_p bigint, cd_item_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE


c01 CURSOR FOR
SELECT	a.ds_horario,
		a.dt_horario
from	prescr_mat_hor a,
		prescr_material b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_seq_material = b.nr_sequencia
and		b.nr_seq_mat_cpoe = nr_seq_item_cpoe_p
and		b.cd_material = cd_item_p
and		a.dt_horario between dt_inicial_p and dt_final_p
and		ie_tipo_item_p = 'L'

union

select	a.ds_horario,
		a.dt_horario
from	prescr_mat_hor a,
		prescr_material b,
		prescr_procedimento c
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = c.nr_prescricao
and		a.nr_seq_material = b.nr_sequencia
and		b.nr_sequencia_proc = c.nr_sequencia
and		c.nr_seq_proc_cpoe = nr_seq_item_cpoe_p
and		b.cd_material = cd_item_p
and		a.dt_horario between dt_inicial_p and dt_final_p
and		ie_tipo_item_p = 'P'
order by dt_horario;


ds_horario_w		varchar(15);
ds_horarios_w		varchar(2000);
dt_hor_aux			timestamp;


BEGIN

ds_horarios_w := null;
open c01;
loop
fetch c01 into	ds_horario_w,
				dt_hor_aux;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
		ds_horarios_w := ds_horarios_w || ' ' || ds_horario_w;
	else
		ds_horarios_w := ds_horario_w;
	end if;
	end;
end loop;
close c01;

return ds_horarios_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_hor_assoc_item ( nr_seq_item_cpoe_p bigint, cd_item_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_tipo_item_p text) FROM PUBLIC;
