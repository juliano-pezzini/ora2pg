-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proj_ata_pendencia_atual ON proj_ata_pendencia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proj_ata_pendencia_atual() RETURNS trigger AS $BODY$
declare

BEGIN
if (TG_OP = 'UPDATE') and (NEW.dt_repactuada is not null) and (coalesce(OLD.dt_repactuada,OLD.dt_prev_solucao) <> NEW.dt_repactuada) then
	BEGIN
	/*insert into logxxxxx_tasy (
		dt_atualizacao,
		nm_usuario,
		cd_log,
		ds_log)
	values (
		sysdate,
		:new.nm_usuario,
		24680,
		'O usuário ' || :new.nm_usuario || ' alterou a data de conclusão da pendência de ' || to_char(nvl(:old.dt_repactuada,:old.dt_prev_solucao),'dd/mm/yyyy') ||
		' para ' || to_char(:new.dt_repactuada,'dd/mm/yyyy'));*/
	NEW.nr_repactuacoes := coalesce(OLD.nr_repactuacoes,0) + 1;
	end;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proj_ata_pendencia_atual() FROM PUBLIC;

CREATE TRIGGER proj_ata_pendencia_atual
	BEFORE INSERT OR UPDATE ON proj_ata_pendencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proj_ata_pendencia_atual();
