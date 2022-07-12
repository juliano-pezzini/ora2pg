-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS especialidade_medica_atual ON especialidade_medica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_especialidade_medica_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.ds_espec_sem_acento is null) or (NEW.ds_especialidade <> OLD.ds_especialidade) then
	NEW.ds_espec_sem_acento := elimina_acentuacao(NEW.ds_especialidade);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_especialidade_medica_atual() FROM PUBLIC;

CREATE TRIGGER especialidade_medica_atual
	BEFORE INSERT OR UPDATE ON especialidade_medica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_especialidade_medica_atual();

