-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horario_medic_turno_ago ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_turno_p bigint, qt_min_agora_p bigint) RETURNS varchar AS $body$
DECLARE


ds_horario_w		varchar(15);
ds_resultado_w		varchar(2000);

C01 CURSOR FOR
SELECT	b.ds_horario
from	prescr_mat_hor b,
	prescr_medica a
where	a.nr_prescricao		= b.nr_prescricao
and	a.nr_prescricao		= nr_prescricao_p
and	b.nr_seq_material	= nr_sequencia_p
and	b.nr_seq_turno		= nr_seq_turno_p
and	((b.ie_urgente		= 'S') or (b.dt_horario <= coalesce(a.dt_liberacao,a.dt_liberacao_medico) + qt_min_agora_p / 1440))
and	coalesce(b.dt_suspensao::text, '') = ''
and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S'
order by b.dt_horario;


BEGIN

OPEN C01;
LOOP
FETCH C01 into
	ds_horario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_resultado_w	:= ds_resultado_w ||' '||ds_horario_w;
	end;
END LOOP;
CLOSE C01;

return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horario_medic_turno_ago ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_turno_p bigint, qt_min_agora_p bigint) FROM PUBLIC;
