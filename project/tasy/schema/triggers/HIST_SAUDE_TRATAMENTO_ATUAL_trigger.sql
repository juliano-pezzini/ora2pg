-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS hist_saude_tratamento_atual ON historico_saude_tratamento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_hist_saude_tratamento_atual() RETURNS trigger AS $BODY$
declare


BEGIN
if (coalesce(OLD.DT_REGISTRO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_REGISTRO) and (NEW.DT_REGISTRO is not null) then
	NEW.ds_utc				:= obter_data_utc(NEW.DT_REGISTRO, 'HV');
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_hist_saude_tratamento_atual() FROM PUBLIC;

CREATE TRIGGER hist_saude_tratamento_atual
	BEFORE INSERT OR UPDATE ON historico_saude_tratamento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_hist_saude_tratamento_atual();

