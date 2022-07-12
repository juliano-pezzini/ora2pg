-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS oft_consulta_medica_atual ON oft_consulta_medica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_oft_consulta_medica_atual() RETURNS trigger AS $BODY$
declare


BEGIN
if (coalesce(OLD.DT_CONSULTA,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_CONSULTA) and (NEW.DT_CONSULTA is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_CONSULTA, 'HV');
end if;

if (coalesce(OLD.DT_LIBERACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIBERACAO) and (NEW.DT_LIBERACAO is not null) then
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIBERACAO,'HV');
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_oft_consulta_medica_atual() FROM PUBLIC;

CREATE TRIGGER oft_consulta_medica_atual
	BEFORE INSERT OR UPDATE ON oft_consulta_medica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_oft_consulta_medica_atual();
