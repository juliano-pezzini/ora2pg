-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_altera_dt_inicio_medic ( nr_sequencia_p bigint, dt_inicio_p timestamp, nr_dias_p bigint default 0) AS $body$
DECLARE

dt_validade_w		timestamp;
nr_dias_receita_w	integer;
nr_seq_receita_w	bigint;
nr_dias_w		integer;


BEGIN
dt_validade_w := null;
if (dt_inicio_p IS NOT NULL AND dt_inicio_p::text <> '') then

	select	max(nr_seq_receita)
	into STRICT	nr_seq_receita_w
	from	fa_receita_farmacia_item
	where	nr_sequencia = nr_sequencia_p;

	if (nr_seq_receita_w IS NOT NULL AND nr_seq_receita_w::text <> '') then
		select	max(nr_dias_receita)
		into STRICT	nr_dias_receita_w
		from	fa_receita_farmacia
		where	nr_sequencia = nr_seq_receita_w;
	end if;

	nr_dias_w := nr_dias_p;
	if (nr_dias_receita_w IS NOT NULL AND nr_dias_receita_w::text <> '') and (nr_dias_w = 0) then
		nr_dias_w := nr_dias_receita_w;
	end if;

	if (nr_dias_w > 0) then
		dt_validade_w := dt_inicio_p + trunc(nr_dias_w)-1;
	end if;
	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
		update	fa_receita_farmacia_item
		set	dt_validade_receita = dt_validade_w,
			nr_dias_receita = nr_dias_w,
			dt_inicio_receita = dt_inicio_p
		where	nr_sequencia = nr_sequencia_p;
	end if;

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_altera_dt_inicio_medic ( nr_sequencia_p bigint, dt_inicio_p timestamp, nr_dias_p bigint default 0) FROM PUBLIC;
