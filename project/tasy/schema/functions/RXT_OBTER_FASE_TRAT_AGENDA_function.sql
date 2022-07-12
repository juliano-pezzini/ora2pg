-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_fase_trat_agenda (nr_seq_tratamento_p bigint, dt_agenda_p timestamp) RETURNS bigint AS $body$
DECLARE


dt_inicio_trat_w	timestamp;
nr_seq_fase_w	bigint;
qt_dia_fase_w	integer;
qt_dia_fase_ww	integer := 0;
qt_dia_trat_w	integer;
nr_seq_fase_trat_w	bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	qt_duracao_trat
from	rxt_fase_tratamento
where	nr_seq_tratamento = nr_seq_tratamento_p
order by
	nr_sequencia;


BEGIN
if (nr_seq_tratamento_p IS NOT NULL AND nr_seq_tratamento_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') then

	select	max(dt_inicio_trat)
	into STRICT	dt_inicio_trat_w
	from	rxt_tratamento
	where	nr_sequencia = nr_seq_tratamento_p;

	if (dt_inicio_trat_w IS NOT NULL AND dt_inicio_trat_w::text <> '') then

		open c01;
		loop
		fetch c01 into	nr_seq_fase_w,
				qt_dia_fase_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			qt_dia_fase_ww	:= qt_dia_fase_ww + qt_dia_fase_w;

			qt_dia_trat_w	:= obter_dias_entre_datas(dt_inicio_trat_w, dt_agenda_p);

			if (coalesce(nr_seq_fase_trat_w::text, '') = '') and (qt_dia_trat_w <= qt_dia_fase_ww) then

				nr_seq_fase_trat_w := nr_seq_fase_w;


			end if;

			end;
		end loop;
		close c01;

	end if;

end if;

return nr_seq_fase_trat_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_fase_trat_agenda (nr_seq_tratamento_p bigint, dt_agenda_p timestamp) FROM PUBLIC;

