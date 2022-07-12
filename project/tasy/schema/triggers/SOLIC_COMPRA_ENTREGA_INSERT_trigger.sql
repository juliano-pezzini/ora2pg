-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS solic_compra_entrega_insert ON solic_compra_item_entrega CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_solic_compra_entrega_insert() RETURNS trigger AS $BODY$
declare

BEGIN
NEW.nm_usuario_nrec	:=	coalesce(NEW.nm_usuario_nrec, NEW.nm_usuario);
NEW.dt_atualizacao_nrec	:=	coalesce(NEW.dt_atualizacao_nrec, NEW.dt_atualizacao);

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_solic_compra_entrega_insert() FROM PUBLIC;

CREATE TRIGGER solic_compra_entrega_insert
	BEFORE INSERT ON solic_compra_item_entrega FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_solic_compra_entrega_insert();
