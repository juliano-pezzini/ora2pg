-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pertence_paciente_atual ON pertence_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pertence_paciente_atual() RETURNS trigger AS $BODY$
DECLARE

BEGIN

if (NEW.dt_entrega is null) then
	update	armario_pertence
	set	ie_livre = 'N'
	where	nr_sequencia = NEW.nr_seq_armario;
elsif (NEW.dt_entrega is not null) then
	update	armario_pertence
	set	ie_livre = 'S'
	where	nr_sequencia = NEW.nr_seq_armario;
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pertence_paciente_atual() FROM PUBLIC;

CREATE TRIGGER pertence_paciente_atual
	BEFORE INSERT OR UPDATE ON pertence_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pertence_paciente_atual();
