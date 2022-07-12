-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_transfusao_atual ON paciente_transfusao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_transfusao_atual() RETURNS trigger AS $BODY$
declare


BEGIN
if (coalesce(OLD.DT_REGISTRO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_REGISTRO) and (NEW.DT_REGISTRO is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_REGISTRO, 'HV');
end if;

if (coalesce(OLD.DT_LIBERACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIBERACAO) and (NEW.DT_LIBERACAO is not null) then
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIBERACAO,'HV');
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_transfusao_atual() FROM PUBLIC;

CREATE TRIGGER paciente_transfusao_atual
	BEFORE INSERT OR UPDATE ON paciente_transfusao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_transfusao_atual();

