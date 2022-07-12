-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ordem_compra_tie ON ordem_compra CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ordem_compra_tie() RETURNS trigger AS $BODY$
declare

ds_retorno_integracao_w		text;

BEGIN

if (wheb_usuario_pck.get_nm_usuario is not null) then
    if (NEW.dt_aprovacao is not null) and (OLD.dt_aprovacao is null) then
        select bifrost.send_integration(
			'purchase.order.send.request',
			'com.philips.tasy.integration.purchaseorder.outbound.PurchaseOrderCallback',
			''||NEW.nr_ordem_compra||'',
			wheb_usuario_pck.get_nm_usuario)
		into STRICT ds_retorno_integracao_w
;
    end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ordem_compra_tie() FROM PUBLIC;

CREATE TRIGGER ordem_compra_tie
	AFTER UPDATE ON ordem_compra FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ordem_compra_tie();

