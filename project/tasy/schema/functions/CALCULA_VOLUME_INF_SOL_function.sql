-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcula_volume_inf_sol (nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_duracao_w		double precision := 0;
qt_dosagem_ant_w	double precision := 0;
dt_evento_ant_w		timestamp;
qt_total_w			double precision := 0;
qt_volume_w			double precision := 0;
qt_dosagem_w		double precision := 0;
dt_alteracao_w		timestamp;
qt_volume_adep_w	prescr_solucao.qt_volume_adep%type;

c01 CURSOR FOR
SELECT	converte_vel_infusao(ie_tipo_dosagem,'mlh',qt_dosagem),
		dt_alteracao
from	prescr_solucao_evento
where	nr_prescricao = nr_prescricao_p
and 	nr_seq_solucao = nr_seq_solucao_p
and		obter_status_etapa_sol(nr_prescricao,nr_seq_solucao,nr_etapa_evento) = 'I'
and		ie_evento_valido = 'S'
and		ie_alteracao in (1,3,5,35)
and		(qt_dosagem IS NOT NULL AND qt_dosagem::text <> '')
order by
		nr_sequencia;

BEGIN
dt_evento_ant_w := null;

select	coalesce(max(a.qt_volume_adep),0)
into STRICT	qt_volume_adep_w
from	prescr_solucao	a
where	a.nr_prescricao	= nr_prescricao_p
and		a.nr_seq_solucao = nr_seq_solucao_p;

open c01;
loop
fetch c01 into	qt_dosagem_w,
				dt_alteracao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
		if (dt_evento_ant_w IS NOT NULL AND dt_evento_ant_w::text <> '') then
			select to_number(round((dt_alteracao_w - dt_evento_ant_w) * 24,2))
			into STRICT qt_duracao_w
			;
			qt_volume_w := (qt_duracao_w * qt_dosagem_ant_w);
			qt_total_w:= qt_total_w + qt_volume_w;
		end if;
		dt_evento_ant_w  := dt_alteracao_w;
		qt_dosagem_ant_w := qt_dosagem_w;
	end;
end loop;
if (dt_evento_ant_w IS NOT NULL AND dt_evento_ant_w::text <> '') then
	select to_number(round((clock_timestamp() - dt_evento_ant_w) * 24,2))
	into STRICT qt_duracao_w
	;
	qt_volume_w := (qt_duracao_w * qt_dosagem_ant_w);
	qt_total_w:= qt_total_w + qt_volume_w;
end if;

if (qt_total_w > qt_volume_adep_w) then
	qt_total_w	:= qt_volume_adep_w;
end if;

return coalesce(qt_total_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcula_volume_inf_sol (nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
