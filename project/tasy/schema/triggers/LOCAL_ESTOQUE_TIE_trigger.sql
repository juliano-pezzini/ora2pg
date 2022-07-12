-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS local_estoque_tie ON local_estoque CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_local_estoque_tie() RETURNS trigger AS $BODY$
declare
  ds_retorno_integracao_w    text;
  json_w                     philips_json;
  json_data_w                text;
BEGIN
  if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S') then
    if (wheb_usuario_pck.get_nm_usuario is not null) then
      json_w := philips_json();

      json_w.put('id', NEW.CD_LOCAL_ESTOQUE);
      json_w.put('description', NEW.DS_LOCAL_ESTOQUE);
      json_w.put('status', NEW.IE_SITUACAO);
      json_w.put('lastUpdate', NEW.DT_ATUALIZACAO);
      json_w.put('establishment', NEW.CD_ESTABELECIMENTO);
      json_w.put('allowScanning', NEW.IE_PERMITE_DIGITACAO);
      json_w.put('nameUser', NEW.NM_USUARIO);
      json_w.put('own', NEW.IE_PROPRIO);
      json_w.put('stockMaterialRequirement', NEW.IE_REQ_MAT_ESTOQUE);
      json_w.put('inventoryCenter', NEW.IE_CENTRO_INVENTARIO);
      json_w.put('lowMood', NEW.IE_BAIXA_DISP);
      json_w.put('allowsNegativeStock', NEW.IE_PERMITE_ESTOQUE_NEGATIVO);
      json_w.put('orderCostCenter', NEW.IE_CENTRO_CUSTO_ORDEM);
      json_w.put('deliveryLocationOC', NEW.IE_LOCAL_ENTREGA_OC);
      json_w.put('external', NEW.IE_EXTERNO);
      json_w.put('costCenterNF', NEW.IE_CENTRO_CUSTO_NF);
      json_w.put('stoneCenter', NEW.IE_CENTRO_PERDA);
      json_w.put('costCenter', NEW.CD_CENTRO_CUSTO);
      json_w.put('localType', NEW.IE_TIPO_LOCAL);
      json_w.put('requestedPoint', NEW.IE_PONTO_PEDIDO);
      json_w.put('automaticRequest', NEW.IE_REQ_AUTOMATICA);
      json_w.put('buyerConsig', NEW.CD_COMPRADOR_CONSIG);
      json_w.put('consignedApplicationPerson', NEW.CD_PESSOA_SOLIC_CONSIG);
      json_w.put('minimumAdjustmentDay', NEW.QT_DIA_AJUSTE_MINIMO);
      json_w.put('maximumAdjustmentDay', NEW.QT_DIA_AJUSTE_MAXIMO);
      json_w.put('consumptionDay', NEW.QT_DIA_CONSUMO);
      json_w.put('generateBatch', NEW.IE_GERA_LOTE);
      json_w.put('considerStandardTransfer', NEW.IE_CONSIDERA_TRANSF_PADRAO);
      json_w.put('allowLoan', NEW.IE_PERMITE_EMPRESTIMO);
      json_w.put('complement', NEW.DS_COMPLEMENTO);
      json_w.put('clearRequisition', NEW.IE_LIMPA_REQUISICAO);
      json_w.put('consistsBalance', NEW.IE_CONSISTE_SALDO_REP);
      json_w.put('allowsOC', NEW.IE_PERMITE_OC);
      json_w.put('localTypeExt', NEW.IE_TIPO_LOCAL_EXT);
      json_w.put('cns', NEW.CD_CNS);

      dbms_lob.createtemporary(json_data_w, true);
      json_w.(json_data_w);

      ds_retorno_integracao_w := bifrost.send_integration_content('stocklocation.send', json_data_w, wheb_usuario_pck.get_nm_usuario);

    end if;
  end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_local_estoque_tie() FROM PUBLIC;

CREATE TRIGGER local_estoque_tie
	AFTER INSERT ON local_estoque FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_local_estoque_tie();
