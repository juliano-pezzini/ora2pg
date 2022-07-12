-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS parametro_agenda_atual ON parametro_agenda CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_parametro_agenda_atual() RETURNS trigger AS $BODY$
DECLARE
dt_atualizacao 	timestamp	:= LOCALTIMESTAMP;
BEGIN
  BEGIN
BEGIN

if (OLD.ie_forma_excluir_servico	<> NEW.ie_forma_excluir_servico) and (NEW.ie_forma_excluir_servico	= 'N') then
	delete from agenda_controle_horario a
	where exists (SELECT 1 from agenda b where a.cd_agenda = b.cd_agenda and b.cd_tipo_agenda = 5);
end if;

if (OLD.ie_forma_excluir_exame	<> NEW.ie_forma_excluir_exame) and (NEW.ie_forma_excluir_exame	= 'N') then
	delete from agenda_controle_horario a
	where exists (SELECT 1 from agenda b where a.cd_agenda = b.cd_agenda and b.cd_tipo_agenda = 2);
end if;

if (OLD.ie_forma_excluir_consulta	<> NEW.ie_forma_excluir_consulta) and (NEW.ie_forma_excluir_consulta	= 'N') then
	delete from agenda_controle_horario a
	where exists (SELECT 1 from agenda b where a.cd_agenda = b.cd_agenda and b.cd_tipo_agenda in (3,4));
end if;

exception
	when others then
      	dt_atualizacao := LOCALTIMESTAMP;
end;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_parametro_agenda_atual() FROM PUBLIC;

CREATE TRIGGER parametro_agenda_atual
	BEFORE INSERT OR UPDATE ON parametro_agenda FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_parametro_agenda_atual();
