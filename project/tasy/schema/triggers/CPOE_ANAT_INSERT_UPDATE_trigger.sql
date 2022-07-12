-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_anat_insert_update ON cpoe_anatomia_patologica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_anat_insert_update() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN
	if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
		BEGIN
			if (NEW.dt_liberacao is not null and ((OLD.dt_liberacao_enf is null and  NEW.dt_liberacao_enf is not null) or (OLD.dt_liberacao_farm is null and NEW.dt_liberacao_farm is not null))) then
				CALL cpoe_atualizar_inf_adic(NEW.nr_atendimento, NEW.nr_sequencia, 'A', NEW.dt_liberacao_enf, NEW.dt_liberacao_farm, null, null, null, null, null, NEW.nr_seq_cpoe_order_unit);
			end if;
		exception
		when others then
			CALL gravar_log_cpoe('CPOE_ANAT_INSERT_UPDATE - CPOE_ATUALIZAR_INF_ADIC - Erro: ' || substr(sqlerrm(SQLSTATE),1,1500) || ' :new.nr_sequencia '|| NEW.nr_sequencia, NEW.nr_atendimento);
		end;
	end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_anat_insert_update() FROM PUBLIC;

CREATE TRIGGER cpoe_anat_insert_update
	AFTER INSERT OR UPDATE ON cpoe_anatomia_patologica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_anat_insert_update();
