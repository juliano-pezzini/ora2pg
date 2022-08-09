-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_horas_cronograma (nr_seq_etapa_p bigint) AS $body$
DECLARE


qt_total_ativ_w		bigint;
nr_seq_cron_param_w	bigint;
ie_possui_inferior_w	varchar(1);
qt_hora_ativ_inf_w	bigint;


BEGIN

if (nr_seq_etapa_p IS NOT NULL AND nr_seq_etapa_p::text <> '') then
	select	coalesce(sum(coalesce(qt_min_ativ,0)),0)
	into STRICT	qt_total_ativ_w
	from	proj_rat_ativ
	where	nr_seq_etapa_cron = nr_seq_etapa_p;

	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_possui_inferior_w
	from	proj_cron_etapa
	where	nr_seq_superior = nr_seq_etapa_p;

	if (ie_possui_inferior_w = 'S') then
		select	coalesce(sum(coalesce(qt_hora_real, 0) * 60), 0)
		into STRICT	qt_hora_ativ_inf_w
		from	proj_cron_etapa
		where	nr_seq_superior = nr_seq_etapa_p;

		qt_total_ativ_w := qt_total_ativ_w + qt_hora_ativ_inf_w;
	end if;

	update	proj_cron_etapa
	set	qt_hora_real = coalesce(dividir(qt_total_ativ_w,60),0)
	where	nr_sequencia = nr_seq_etapa_p;

	commit;

	select	c.nr_seq_cronograma
	into STRICT	nr_seq_cron_param_w
	from	proj_cron_etapa c
	where	c.nr_sequencia = nr_seq_etapa_p;

	CALL Atualizar_Total_Horas_Cron(nr_seq_cron_param_w);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_horas_cronograma (nr_seq_etapa_p bigint) FROM PUBLIC;
