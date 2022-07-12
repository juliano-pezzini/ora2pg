-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proj_cron_excessao_after ON proj_cron_excessao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proj_cron_excessao_after() RETURNS trigger AS $BODY$
declare

ie_operacao_w	proj_cron_log_alt.ie_operacao%type;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'N')  then
	goto Final;
end if;

<<Final>>

if (TG_OP = 'INSERT') then
	ie_operacao_w := 'I';
elsif (TG_OP = 'UPDATE') then
	ie_operacao_w := 'A';
elsif (TG_OP = 'DELETE') then
	ie_operacao_w := 'E';
end if;

CALL proj_log_ultimo_recalc(coalesce(NEW.nr_seq_cronograma, OLD.nr_seq_cronograma),
	'E',
	ie_operacao_w,
	coalesce(NEW.nm_usuario, OLD.nm_usuario));
	
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proj_cron_excessao_after() FROM PUBLIC;

CREATE TRIGGER proj_cron_excessao_after
	AFTER INSERT OR UPDATE OR DELETE ON proj_cron_excessao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proj_cron_excessao_after();
