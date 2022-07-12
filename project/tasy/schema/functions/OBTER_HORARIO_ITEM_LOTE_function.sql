-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horario_item_lote ( nr_seq_lote_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_horario_w			varchar(15);
ds_horarios_w			varchar(2000);
ie_se_horario_lib_w		varchar(1) := 'N';

C01 CURSOR FOR
SELECT	to_char(c.dt_horario, 'hh24:mi'),
	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario)
from	prescr_mat_hor c,
	ap_lote_item b,
	ap_lote a
where	a.nr_sequencia 	= b.nr_seq_lote
and	b.nr_seq_mat_hor = c.nr_sequencia
and	a.nr_prescricao	= c.nr_prescricao
and	coalesce(c.dt_suspensao::text, '') = ''
and	b.cd_material	= cd_material_p
and	a.nr_sequencia	= nr_seq_lote_p
/*and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'  OS701823(problema de lentidão) */

order by c.nr_sequencia;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	open C01;
	loop
	fetch C01 into
		ds_horario_w,
		ie_se_horario_lib_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (ie_se_horario_lib_w = 'S') then
			ds_horarios_w	:= ds_horarios_w || ' ' || ds_horario_w;
		end if;

		end;
	end loop;
	close C01;
end if;

return	ds_horarios_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horario_item_lote ( nr_seq_lote_p bigint, cd_material_p bigint) FROM PUBLIC;

