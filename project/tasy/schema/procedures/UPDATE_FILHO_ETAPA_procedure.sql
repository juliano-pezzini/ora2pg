-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_filho_etapa ( nr_sequencia_p bigint, nr_seq_identificador_p bigint, nm_usuario_p text ) AS $body$
WITH RECURSIVE cte AS (
DECLARE


c01 CURSOR FOR
	SELECT 1 as level,nr_sequencia
	from proj_cron_etapa
	 WHERE nr_sequencia = nr_sequencia_p
  UNION ALL
DECLARE
 

c01 CURSOR FOR
	SELECT (c.level+1),nr_sequencia
	from proj_cron_etapa
	 JOIN cte c ON (c.prior nr_sequencia = nr_seq_superior)

) SELECT * FROM cte;
;


BEGIN
	for c01_w in c01
				loop
		update	proj_cron_etapa
		set	dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p,
			nr_seq_identificador		= nr_seq_identificador_p
		where	nr_sequencia = c01_w.nr_sequencia;

	end loop;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_filho_etapa ( nr_sequencia_p bigint, nr_seq_identificador_p bigint, nm_usuario_p text ) FROM PUBLIC;
