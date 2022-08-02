-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_inserir_cron_etapa ( nr_seq_etapa_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_interno_w	bigint;
nr_seq_superior_w	bigint;
nr_seq_cronograma_w	bigint;
nr_predecessora_w	bigint;



BEGIN

select	max(nr_seq_interno),
	max(nr_seq_cronograma),
	max(nr_seq_superior),
	max(nr_predecessora)
into STRICT	nr_seq_interno_w,
	nr_seq_cronograma_w,
	nr_seq_superior_w,
	nr_predecessora_w
from	proj_cron_etapa
where	nr_sequencia = nr_seq_etapa_p;

update	proj_cron_etapa
set	nr_seq_interno = nr_seq_interno + 1,
	nr_predecessora = nr_predecessora + 1
where	nr_seq_interno >= nr_seq_interno_w
and 	nr_seq_cronograma = nr_seq_cronograma_w;

commit;

/*
update	proj_cron_etapa
set	nr_predecessora = nr_predecessora + 1
where	nr_seq_interno > nr_seq_interno_w +1;
*/
commit;

insert 	into proj_cron_etapa(	nr_sequencia,
				nr_seq_cronograma,
				dt_atualizacao,
				nm_usuario,
				nr_seq_apres,
				ie_fase,
				qt_hora_prev,
				pr_etapa,
				ie_modulo,
				nr_seq_superior,
				nr_seq_interno,
				nr_predecessora,
				pr_consultoria)
			values (nextval('proj_cron_etapa_seq'),
				nr_seq_cronograma_w,
				clock_timestamp(),
				nm_usuario_p,
				0,
				'N',
				0,
				0,
				'N',
				nr_seq_superior_w,
				nr_seq_interno_w,
				nr_predecessora_w,
				0);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_inserir_cron_etapa ( nr_seq_etapa_p bigint, nm_usuario_p text) FROM PUBLIC;

