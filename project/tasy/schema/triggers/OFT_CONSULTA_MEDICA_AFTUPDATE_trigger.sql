-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS oft_consulta_medica_aftupdate ON oft_consulta_medica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_oft_consulta_medica_aftupdate() RETURNS trigger AS $BODY$
declare
 
BEGIN 
 
if (NEW.dt_liberacao	is not null) and (OLD.dt_liberacao is null) and (NEW.nr_atendimento is not null)then 
	CALL executar_evento_agenda_atend(NEW.nr_atendimento,'OFT',obter_estab_atend(NEW.nr_atendimento),NEW.nm_usuario);
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_oft_consulta_medica_aftupdate() FROM PUBLIC;

CREATE TRIGGER oft_consulta_medica_aftupdate
	BEFORE UPDATE ON oft_consulta_medica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_oft_consulta_medica_aftupdate();

