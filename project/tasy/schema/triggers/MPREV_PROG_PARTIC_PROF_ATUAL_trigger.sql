-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS mprev_prog_partic_prof_atual ON mprev_prog_partic_prof CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_mprev_prog_partic_prof_atual() RETURNS trigger AS $BODY$
DECLARE

BEGIN

if (trunc(NEW.dt_fim_acomp) < trunc(NEW.dt_inicio_acomp)) then
	CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(832205);
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_mprev_prog_partic_prof_atual() FROM PUBLIC;

CREATE TRIGGER mprev_prog_partic_prof_atual
	BEFORE INSERT OR UPDATE ON mprev_prog_partic_prof FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_mprev_prog_partic_prof_atual();
