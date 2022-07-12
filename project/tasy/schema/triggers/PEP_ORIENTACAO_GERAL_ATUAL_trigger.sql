-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pep_orientacao_geral_atual ON pep_orientacao_geral CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pep_orientacao_geral_atual() RETURNS trigger AS $BODY$
declare


BEGIN
if (coalesce(OLD.DT_REGISTRO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_REGISTRO) and (NEW.DT_REGISTRO is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_REGISTRO, 'HV');	
end if;

if (coalesce(OLD.DT_LIBERACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIBERACAO) and (NEW.DT_LIBERACAO is not null) then
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIBERACAO,'HV');
end if;

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	if (OLD.dt_inativacao is null and NEW.dt_inativacao is not null and NEW.cd_evolucao is not null) then
	delete from clinical_note_soap_data
        where cd_evolucao = NEW.cd_evolucao
        and ie_med_rec_type = 'GNRL_INSTRCT'
        and ie_stage = 1
        and ie_soap_type = 'P'
        and nr_seq_med_item = NEW.nr_sequencia;
	end if;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pep_orientacao_geral_atual() FROM PUBLIC;

CREATE TRIGGER pep_orientacao_geral_atual
	BEFORE INSERT OR UPDATE ON pep_orientacao_geral FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pep_orientacao_geral_atual();
