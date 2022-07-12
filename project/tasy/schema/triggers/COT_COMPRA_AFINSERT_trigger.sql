-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cot_compra_afinsert ON cot_compra CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cot_compra_afinsert() RETURNS trigger AS $BODY$
declare
ds_retorno_integracao_w text;

BEGIN

if (OLD.dt_aprovacao is null and NEW.dt_aprovacao is not null) then

    select bifrost.send_integration(
        'purchase.quotation.send.request',
        'com.philips.tasy.integration.purchasequotation.outbound.PurchaseQuotationCallback',
        ''||NEW.nr_cot_compra||'',
        NEW.nm_usuario)
    into STRICT ds_retorno_integracao_w
;

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cot_compra_afinsert() FROM PUBLIC;

CREATE TRIGGER cot_compra_afinsert
	AFTER INSERT OR UPDATE ON cot_compra FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cot_compra_afinsert();

