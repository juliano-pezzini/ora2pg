-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cycle_menu_after_update ON cycle_menu CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cycle_menu_after_update() RETURNS trigger AS $BODY$
BEGIN

if (OLD.dt_validity_start <> NEW.dt_validity_start or OLD.dt_validity_end <> NEW.dt_validity_end) then

    update nut_cardapio_dia
    set dt_vigencia_inicial = NEW.dt_validity_start,
    dt_vigencia_final = NEW.dt_validity_end,
    dt_atualizacao = NEW.dt_atualizacao,
    nm_usuario = NEW.nm_usuario
    where nr_seq_cycle = NEW.nr_sequencia;

end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cycle_menu_after_update() FROM PUBLIC;

CREATE TRIGGER cycle_menu_after_update
	AFTER UPDATE ON cycle_menu FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cycle_menu_after_update();
