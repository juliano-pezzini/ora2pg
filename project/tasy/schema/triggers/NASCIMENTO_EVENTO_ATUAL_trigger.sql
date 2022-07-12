-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nascimento_evento_atual ON nascimento_evento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nascimento_evento_atual() RETURNS trigger AS $BODY$
declare


BEGIN
if (coalesce(OLD.DT_ATUALIZACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_ATUALIZACAO) and (NEW.DT_ATUALIZACAO is not null) then
	NEW.ds_utc				:= obter_data_utc(NEW.DT_ATUALIZACAO, 'HV');
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nascimento_evento_atual() FROM PUBLIC;

CREATE TRIGGER nascimento_evento_atual
	BEFORE INSERT OR UPDATE ON nascimento_evento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nascimento_evento_atual();

