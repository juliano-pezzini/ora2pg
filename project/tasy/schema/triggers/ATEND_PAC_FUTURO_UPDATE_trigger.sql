-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_pac_futuro_update ON atend_pac_futuro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_pac_futuro_update() RETURNS trigger AS $BODY$
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then

	if (OLD.nr_seq_status is not null) and (NEW.nr_seq_status is not null) and (NEW.nr_seq_status <> OLD.nr_seq_status) then

		CALL gerar_atend_futuro_status_hist(NEW.nr_sequencia,NEW.nr_seq_status,NEW.nm_usuario);
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_pac_futuro_update() FROM PUBLIC;

CREATE TRIGGER atend_pac_futuro_update
	BEFORE UPDATE ON atend_pac_futuro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_pac_futuro_update();
