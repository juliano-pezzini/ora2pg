-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cot_compra_forn_item_tie ON cot_compra_forn_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cot_compra_forn_item_tie() RETURNS trigger AS $BODY$
declare
  ds_retorno_integracao_w    text;
  json_w                     philips_json;
  json_data_w                text;
BEGIN
  if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S') then
    if (wheb_usuario_pck.get_nm_usuario is not null) then
      json_w := philips_json();

      json_w.put('id', NEW.NR_SEQUENCIA);
      json_w.put('quotationSupplier', NEW.NR_SEQ_COT_FORN);
      json_w.put('quotation', NEW.NR_COT_COMPRA);
      json_w.put('quotationItem', NEW.NR_ITEM_COT_COMPRA);
      json_w.put('supplier', NEW.CD_CGC_FORNECEDOR);
      json_w.put('status', NEW.IE_SITUACAO);
      json_w.put('brandDescription', NEW.DS_MARCA);
      json_w.put('supplierBrandDescription', NEW.DS_MARCA_FORNEC);
      json_w.put('material', NEW.CD_MATERIAL);
      json_w.put('materialAmount', NEW.QT_MATERIAL);
      json_w.put('unitValue', NEW.VL_UNITARIO_MATERIAL);
      json_w.put('netValue', NEW.VL_PRECO_LIQUIDO);
      json_w.put('netItemValue', NEW.VL_TOTAL_LIQUIDO_ITEM);
      json_w.put('lastUpdatedBy', NEW.NM_USUARIO);
      json_w.put('lastUpdate', NEW.DT_ATUALIZACAO);

      dbms_lob.createtemporary(json_data_w, true);
      json_w.(json_data_w);

      ds_retorno_integracao_w := bifrost.send_integration_content('supplieritempurchasequotation.send', json_data_w, wheb_usuario_pck.get_nm_usuario);

    end if;
  end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cot_compra_forn_item_tie() FROM PUBLIC;

CREATE TRIGGER cot_compra_forn_item_tie
	AFTER INSERT ON cot_compra_forn_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cot_compra_forn_item_tie();

