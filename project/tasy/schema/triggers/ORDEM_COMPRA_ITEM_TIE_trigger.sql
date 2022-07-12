-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ordem_compra_item_tie ON ordem_compra_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ordem_compra_item_tie() RETURNS trigger AS $BODY$
declare
  ds_retorno_integracao_w    text;
  json_w                     philips_json;
  json_data_w                text;
BEGIN
  if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S') then
    if (wheb_usuario_pck.get_nm_usuario is not null) then
      json_w := philips_json();

      json_w.put('order', NEW.NR_ORDEM_COMPRA);
      json_w.put('item', NEW.NR_ITEM_OCI);
      json_w.put('material', NEW.CD_MATERIAL);
      json_w.put('amount', NEW.QT_MATERIAL);
      json_w.put('measurementUnit', NEW.CD_UNIDADE_MEDIDA_COMPRA);
      json_w.put('costCenter', NEW.CD_CENTRO_CUSTO);
      json_w.put('generalLedgerAccount', NEW.CD_CONTA_CONTABIL);
      json_w.put('stockLocation', NEW.CD_LOCAL_ESTOQUE);
      json_w.put('approvalDate', NEW.DT_APROVACAO);
      json_w.put('expirationDate', NEW.DT_VALIDADE);
      json_w.put('quotation', NEW.NR_COT_COMPRA);
      json_w.put('request', NEW.NR_SOLIC_COMPRA);
      json_w.put('requestItem', NEW.NR_ITEM_SOLIC_COMPRA);
      json_w.put('deliveredAmount', NEW.QT_MATERIAL_ENTREGUE);
      json_w.put('originalAmount', NEW.QT_ORIGINAL);
      json_w.put('liquidValue', NEW.VL_ITEM_LIQUIDO);
      json_w.put('unitValue', NEW.VL_UNITARIO_MATERIAL);
      json_w.put('totalValue', NEW.VL_TOTAL_ITEM);
      json_w.put('discount', NEW.PR_DESCONTOS);
      json_w.put('supplierBatch', NEW.NR_SEQ_LOTE_FORNEC);
      json_w.put('disapprovalDate', NEW.DT_REPROVACAO);
      json_w.put('status', NEW.IE_SITUACAO);
      json_w.put('lastUpdate', NEW.DT_ATUALIZACAO);
      json_w.put('lastUpdateBy', NEW.NM_USUARIO);

      dbms_lob.createtemporary(json_data_w, true);
      json_w.(json_data_w);

      ds_retorno_integracao_w := bifrost.send_integration_content('purchaseorderitem.send', json_data_w, wheb_usuario_pck.get_nm_usuario);

    end if;
  end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ordem_compra_item_tie() FROM PUBLIC;

CREATE TRIGGER ordem_compra_item_tie
	AFTER INSERT ON ordem_compra_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ordem_compra_item_tie();
