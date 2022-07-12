-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ordem_compra_venc_after_delete ON ordem_compra_venc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ordem_compra_venc_after_delete() RETURNS trigger AS $BODY$
declare

ds_retorno_w	bigint;

pragma autonomous_transaction;
BEGIN

/* Grava o agendamento da informação para atualização do fluxo de caixa. */

CALL gravar_agend_fluxo_caixa(OLD.nr_ordem_compra,OLD.NR_ITEM_OC_VENC,'OC', OLD.dt_vencimento,'E',OLD.nm_usuario);


SELECT COUNT(*)
into STRICT ds_retorno_w
FROM ORDEM_COMPRA_VENC
where nr_ordem_compra = OLD.nr_ordem_compra;


if (ds_retorno_w - 1 = 0) then
CALL reagendar_item_oc_fluxo(OLD.nr_ordem_compra, 'OC', 'A', OLD.nm_usuario);
end if;

commit;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ordem_compra_venc_after_delete() FROM PUBLIC;

CREATE TRIGGER ordem_compra_venc_after_delete
	AFTER DELETE ON ordem_compra_venc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ordem_compra_venc_after_delete();

