-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS far_venda_item_atual ON far_venda_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_far_venda_item_atual() RETURNS trigger AS $BODY$
declare

BEGIN
if (NEW.cd_procedimento is not null) and (NEW.cd_material is not null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(511223);
elsif (NEW.cd_material is null) and (NEW.cd_procedimento is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(275704);
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_far_venda_item_atual() FROM PUBLIC;

CREATE TRIGGER far_venda_item_atual
	BEFORE INSERT OR UPDATE ON far_venda_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_far_venda_item_atual();
