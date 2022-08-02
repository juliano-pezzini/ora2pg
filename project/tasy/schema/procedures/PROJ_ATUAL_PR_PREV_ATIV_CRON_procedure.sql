-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_atual_pr_prev_ativ_cron ( nr_seq_cronograma_p bigint, nm_usuario_p text ) AS $body$
DECLARE


c01 CURSOR FOR
SELECT	a.nr_sequencia
from	proj_cron_etapa a
where	a.nr_seq_cronograma = nr_seq_cronograma_p
and	not exists (	select	1
			from	proj_cron_etapa b
			where	b.nr_seq_superior = a.nr_sequencia
		)
order by	a.nr_sequencia;

BEGIN

if (nr_seq_cronograma_p IS NOT NULL AND nr_seq_cronograma_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	for r_c01 in c01 loop
		CALL proj_atual_perc_prev_etapa(r_c01.nr_sequencia, nm_usuario_p);
	end loop;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_atual_pr_prev_ativ_cron ( nr_seq_cronograma_p bigint, nm_usuario_p text ) FROM PUBLIC;

