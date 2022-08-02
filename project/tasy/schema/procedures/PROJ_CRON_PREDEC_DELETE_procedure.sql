-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_cron_predec_delete (nr_seq_cronograma_p bigint) AS $body$
BEGIN
if (nr_seq_cronograma_p IS NOT NULL AND nr_seq_cronograma_p::text <> '') then
	begin
		delete from proj_cron_predec a
		where a.nr_seq_etapa_atual in (SELECT b.nr_sequencia
								  from proj_cron_etapa b
								  where b.nr_seq_cronograma = nr_seq_cronograma_p);
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_cron_predec_delete (nr_seq_cronograma_p bigint) FROM PUBLIC;

