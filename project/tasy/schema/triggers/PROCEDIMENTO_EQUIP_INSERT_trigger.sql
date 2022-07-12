-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS procedimento_equip_insert ON procedimento_equip CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_procedimento_equip_insert() RETURNS trigger AS $BODY$
BEGIN

if (NEW.ie_tipo_equipamento is null) and (NEW.cd_equipamento is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(455494);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_procedimento_equip_insert() FROM PUBLIC;

CREATE TRIGGER procedimento_equip_insert
	BEFORE INSERT ON procedimento_equip FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_procedimento_equip_insert();

