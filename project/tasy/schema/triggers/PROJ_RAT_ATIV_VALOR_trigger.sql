-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proj_rat_ativ_valor ON proj_rat_ativ CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proj_rat_ativ_valor() RETURNS trigger AS $BODY$
declare
qt_hora_w 		double precision := 0;
qt_hora_adic_w		double precision := 0;
qt_hora_old_w		double precision := 0;
qt_hora_adic_old_w	double precision := 0;

BEGIN
if (NEW.nr_seq_etapa_cron is not null) then
	BEGIN
	if (TG_OP = 'UPDATE') and (OLD.qt_min_ativ <> NEW.qt_min_ativ) then
		BEGIN
		select	coalesce(qt_hora_real,0),
			coalesce(qt_horas_etapa_adic,0)
		into STRICT	qt_hora_old_w,
			qt_hora_adic_old_w
		from	proj_cron_etapa
		where	nr_sequencia = OLD.nr_seq_etapa_cron;
		
		select	coalesce((coalesce(qt_hora_real,0) - dividir(coalesce(NEW.qt_min_ativ,0) - coalesce(OLD.qt_min_ativ,0),60)),0)
		into STRICT	qt_hora_w
		from	proj_cron_etapa
		where	nr_sequencia = OLD.nr_seq_etapa_cron;
		
		if (NEW.ie_atividade_extra = 'S') then
			qt_hora_adic_w := coalesce(round((dividir(NEW.qt_min_ativ,60))::numeric,2),0);
		end if;
		
		update	proj_cron_etapa
		set	qt_hora_real = (qt_hora_old_w - coalesce(qt_hora_w,0)) + qt_hora_old_w,
			qt_horas_etapa_adic = qt_hora_adic_w - coalesce(qt_hora_adic_w,0)
		where	nr_sequencia = NEW.nr_seq_etapa_cron;
		end;
	elsif (TG_OP = 'INSERT') then
		BEGIN
		select	coalesce((coalesce(qt_hora_real,0) + dividir(coalesce(NEW.qt_min_ativ,0),60)),0)
		into STRICT	qt_hora_w
		from	proj_cron_etapa
		where	nr_sequencia = NEW.nr_seq_etapa_cron;

		if (NEW.ie_atividade_extra = 'S') then
			qt_hora_adic_w := coalesce(round((dividir(NEW.qt_min_ativ,60))::numeric,2),0);
		end if;
		
		update	proj_cron_etapa
		set	qt_hora_real = qt_hora_w,
			qt_horas_etapa_adic = coalesce(qt_hora_adic_w,0)
		where	nr_sequencia = NEW.nr_seq_etapa_cron;
		end;
	end if;
	end;

        -- Palliative solution to zero the activities seconds

        NEW.dt_fim_ativ := NEW.dt_fim_ativ + NUMTODSINTERVAL(0 - EXTRACT(SECOND FROM CAST(NEW.dt_fim_ativ AS TIMESTAMP)),'SECOND');
        NEW.dt_inicio_ativ := NEW.dt_inicio_ativ + NUMTODSINTERVAL(0 - EXTRACT(SECOND FROM CAST(NEW.dt_inicio_ativ AS TIMESTAMP)),'SECOND');

end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proj_rat_ativ_valor() FROM PUBLIC;

CREATE TRIGGER proj_rat_ativ_valor
	BEFORE INSERT OR UPDATE ON proj_rat_ativ FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proj_rat_ativ_valor();

