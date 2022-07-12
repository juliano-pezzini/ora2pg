-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_sumario_alta_atual ON atend_sumario_alta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_sumario_alta_atual() RETURNS trigger AS $BODY$
declare

nr_seq_mhr_doc_w			mhr_doc_meta.nr_sequencia%TYPE;
patient_code_w			mhr_doc_meta.cd_pessoa_fisica%TYPE;



BEGIN
if (coalesce(OLD.DT_ALTA,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_ALTA) and (NEW.DT_ALTA is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_ALTA, 'HV');	
end if;

if (coalesce(OLD.DT_LIBERACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIBERACAO) and (NEW.DT_LIBERACAO is not null) then
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIBERACAO,'HV');
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_sumario_alta_atual() FROM PUBLIC;

CREATE TRIGGER atend_sumario_alta_atual
	BEFORE INSERT OR UPDATE ON atend_sumario_alta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_sumario_alta_atual();

