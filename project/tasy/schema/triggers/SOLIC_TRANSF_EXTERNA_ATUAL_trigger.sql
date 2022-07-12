-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS solic_transf_externa_atual ON solic_transf_externa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_solic_transf_externa_atual() RETURNS trigger AS $BODY$
declare


BEGIN
if (coalesce(OLD.DT_SOLICITACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_SOLICITACAO) and (NEW.DT_SOLICITACAO is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_SOLICITACAO, 'HV');
end if;

if (coalesce(OLD.DT_LIBERACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIBERACAO) and (NEW.DT_LIBERACAO is not null) then
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIBERACAO,'HV');
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_solic_transf_externa_atual() FROM PUBLIC;

CREATE TRIGGER solic_transf_externa_atual
	BEFORE INSERT OR UPDATE ON solic_transf_externa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_solic_transf_externa_atual();

