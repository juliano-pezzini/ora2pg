-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_pac_dispositivo_atual ON atend_pac_dispositivo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_pac_dispositivo_atual() RETURNS trigger AS $BODY$
declare


BEGIN
if (coalesce(OLD.DT_INSTALACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_INSTALACAO) and (NEW.DT_INSTALACAO is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_INSTALACAO, 'HV');	
end if;

if (OLD.dt_retirada is null) and (NEW.dt_retirada is not null) then
	CALL wl_gerar_finalizar_tarefa('TL','F',NEW.nr_atendimento,null,NEW.nm_usuario,null,'N',null,NEW.nr_sequencia);
end if;

if (OLD.dt_instalacao is null) and (NEW.dt_instalacao is not null) then
	CALL send_device_integration(NEW.nr_sequencia, NEW.nr_atendimento, NEW.nr_seq_dispositivo, NEW.ie_lado,
							NEW.nr_seq_topografia, NEW.dt_instalacao, NEW.dt_retirada, NEW.dt_atualizacao);
end if;

if (OLD.dt_retirada is null) and (NEW.dt_retirada is not null) then
	CALL send_device_integration(NEW.nr_sequencia, NEW.nr_atendimento, NEW.nr_seq_dispositivo, NEW.ie_lado,
							NEW.nr_seq_topografia, NEW.dt_instalacao, NEW.dt_retirada, NEW.dt_atualizacao);
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_pac_dispositivo_atual() FROM PUBLIC;

CREATE TRIGGER atend_pac_dispositivo_atual
	BEFORE INSERT OR UPDATE ON atend_pac_dispositivo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_pac_dispositivo_atual();

