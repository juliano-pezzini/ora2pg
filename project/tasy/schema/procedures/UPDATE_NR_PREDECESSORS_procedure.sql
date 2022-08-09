-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_nr_predecessors (nr_seq_cronograma_p bigint) AS $body$
DECLARE


nr_seq_cronograma_w	proj_cron_etapa.nr_seq_cronograma%type := nr_seq_cronograma_p;
nr_seq_etapa_predec_w	proj_cron_predec.nr_seq_etapa_predec%type;
nr_predecessora_w	proj_cron_etapa.nr_predecessora%type;
nr_seq_etapa_w		proj_cron_etapa.nr_sequencia%type;
qt_predecessora_old_w	bigint;
qt_predecessora_new_w	bigint;

c01 CURSOR FOR
	SELECT	pce.nr_sequencia,
		pce.nr_predecessora
	from	proj_cron_etapa pce
	where	nr_seq_cronograma = nr_seq_cronograma_w
	 and	(pce.nr_predecessora IS NOT NULL AND pce.nr_predecessora::text <> '');

c02 CURSOR FOR
	SELECT	pce.nr_sequencia
	from	proj_cron_etapa pce
	where	pce.nr_seq_cronograma = nr_seq_cronograma_w
	 and	(pce.nr_predecessora IS NOT NULL AND pce.nr_predecessora::text <> '')
	 and	not exists (	SELECT	1
				from	proj_cron_predec pcp
				where 	pcp.nr_seq_etapa_atual = pce.nr_sequencia);

c03 CURSOR FOR
	SELECT	nr_seq_etapa_atual,
		nr_seq_etapa_predec
	from	proj_cron_predec pcp
	where	exists (	SELECT	1
				from	proj_cron_etapa pce
				where	pce.nr_seq_cronograma = nr_seq_cronograma_w
				 and	pce.nr_sequencia = pcp.nr_seq_etapa_atual);
BEGIN

if (nr_seq_cronograma_w IS NOT NULL AND nr_seq_cronograma_w::text <> '') then

	select	max(nr_sequencia)
	into STRICT	qt_predecessora_old_w
	from	proj_cron_etapa pce
	where	nr_seq_cronograma = nr_seq_cronograma_w
	 and	(pce.nr_predecessora IS NOT NULL AND pce.nr_predecessora::text <> '');

	select	max(nr_sequencia)
	into STRICT	qt_predecessora_new_w
	from	proj_cron_etapa pce
	where	nr_seq_cronograma = nr_seq_cronograma_w
	 and	(pce.nr_predecessora IS NOT NULL AND pce.nr_predecessora::text <> '')
	 and 	exists (	SELECT	1
				from	proj_cron_predec pcp
				where	pcp.nr_seq_etapa_atual = pce.nr_sequencia);

	if ((qt_predecessora_old_w IS NOT NULL AND qt_predecessora_old_w::text <> '') and coalesce(qt_predecessora_new_w::text, '') = '') then
		begin

		<<c01loop>>
		for reg01 in c01 loop

			nr_seq_etapa_w		:= reg01.nr_sequencia;
			nr_predecessora_w	:= reg01.nr_predecessora;

			select	max(pc2.nr_sequencia)
			into STRICT	nr_seq_etapa_predec_w
			from	proj_cron_etapa pc2
			where	pc2.nr_seq_interno = nr_predecessora_w
			 and	pc2.nr_seq_cronograma = nr_seq_cronograma_w;

			CALL proj_cron_predec_insert(nr_seq_cron_etapa_p		=> nr_seq_etapa_w,
						nr_seq_cron_etapa_predec_p	=> nr_seq_etapa_predec_w,
						nm_usuario_p			=> wheb_usuario_pck.get_nm_usuario);

		end loop c01loop;

		end;

	else
		begin

		<<c02loop>>
		for reg02 in c02 loop

			nr_seq_etapa_w := reg02.nr_sequencia;

			update	proj_cron_etapa pce
			set	pce.nr_predecessora  = NULL
			where	pce.nr_sequencia = nr_seq_etapa_w;

		end loop c02loop;

		<<c03loop>>
		for reg03 in c03 loop

			nr_seq_etapa_w		:= reg03.nr_seq_etapa_atual;
			nr_seq_etapa_predec_w	:= reg03.nr_seq_etapa_predec;

			select	max(nr_seq_interno)
			into STRICT	nr_predecessora_w
			from	proj_cron_etapa pce
			where	pce.nr_sequencia = nr_seq_etapa_predec_w;

			update	proj_cron_etapa pce
			set	pce.nr_predecessora = nr_predecessora_w
			where	pce.nr_sequencia = nr_seq_etapa_w;

		end loop c03loop;

		commit;

		end;

	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_nr_predecessors (nr_seq_cronograma_p bigint) FROM PUBLIC;
