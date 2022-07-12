-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_capurro_neuro_befinsup ON escala_capurro_neuro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_capurro_neuro_befinsup() RETURNS trigger AS $BODY$
declare


BEGIN
if (coalesce(OLD.DT_AVALIACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_AVALIACAO) and (NEW.DT_AVALIACAO is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_AVALIACAO, 'HV');
end if;

if (coalesce(OLD.DT_LIBERACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIBERACAO) and (NEW.DT_LIBERACAO is not null) then
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIBERACAO,'HV');
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_capurro_neuro_befinsup() FROM PUBLIC;

CREATE TRIGGER escala_capurro_neuro_befinsup
	BEFORE INSERT OR UPDATE ON escala_capurro_neuro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_capurro_neuro_befinsup();

