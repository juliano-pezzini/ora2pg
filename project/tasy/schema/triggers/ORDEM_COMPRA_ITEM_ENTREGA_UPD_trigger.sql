-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ordem_compra_item_entrega_upd ON ordem_compra_item_entrega CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ordem_compra_item_entrega_upd() RETURNS trigger AS $BODY$
DECLARE

ds_log_w	varchar(2000);
dt_liberacao_w	timestamp;

BEGIN

select	max(dt_liberacao)
into STRICT	dt_liberacao_w
from	ordem_compra
where	nr_ordem_compra = NEW.nr_ordem_compra;

if (dt_liberacao_w is not null) and (OLD.qt_prevista_entrega <> NEW.qt_prevista_entrega) then
	CALL gravar_log_tasy(27, substr(dbms_utility.format_call_stack,1,2000), NEW.nm_usuario);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ordem_compra_item_entrega_upd() FROM PUBLIC;

CREATE TRIGGER ordem_compra_item_entrega_upd
	BEFORE UPDATE ON ordem_compra_item_entrega FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ordem_compra_item_entrega_upd();

