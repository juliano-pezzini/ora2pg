-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS opdm_trade_item_tp ON opdm_trade_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_opdm_trade_item_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SOFTWARE_PRODUCT,1,4000), substr(NEW.IE_SOFTWARE_PRODUCT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SOFTWARE_PRODUCT', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GREEN_PRODUCT,1,4000), substr(NEW.IE_GREEN_PRODUCT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GREEN_PRODUCT', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_ENGINEERING_RESP_ORG,1,4000), substr(NEW.NM_ENGINEERING_RESP_ORG,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_ENGINEERING_RESP_ORG', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_TYPE_DEVICE,1,4000), substr(NEW.DS_TYPE_DEVICE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_TYPE_DEVICE', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_BASE_MODEL,1,4000), substr(NEW.NM_BASE_MODEL,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_BASE_MODEL', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_OPDM_TASY,1,4000), substr(NEW.NR_SEQ_OPDM_TASY,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_OPDM_TASY', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_TRADE_ITEM_ID,1,4000), substr(NEW.CD_TRADE_ITEM_ID,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_TRADE_ITEM_ID', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_TRADE_ITEM_TYPE_ID,1,4000), substr(NEW.CD_TRADE_ITEM_TYPE_ID,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_TRADE_ITEM_TYPE_ID', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_TRADE_ITEM,1,4000), substr(NEW.NM_TRADE_ITEM,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_TRADE_ITEM', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTERNAL_DEVICE_IDENT,1,4000), substr(NEW.CD_INTERNAL_DEVICE_IDENT,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_INTERNAL_DEVICE_IDENT', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTERNAL_DEVICE_IDENT_TYPE,1,4000), substr(NEW.CD_INTERNAL_DEVICE_IDENT_TYPE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_INTERNAL_DEVICE_IDENT_TYPE', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GTIN,1,4000), substr(NEW.CD_GTIN,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GTIN', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_GTIN_TYPE,1,4000), substr(NEW.DS_GTIN_TYPE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_GTIN_TYPE', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_UNIT_DESCRIPTOR,1,4000), substr(NEW.DS_UNIT_DESCRIPTOR,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_UNIT_DESCRIPTOR', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_REFERENCE_NUMBER,1,4000), substr(NEW.CD_REFERENCE_NUMBER,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_REFERENCE_NUMBER', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REF_NUMBER_ACCORD_OPDM,1,4000), substr(NEW.IE_REF_NUMBER_ACCORD_OPDM,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REF_NUMBER_ACCORD_OPDM', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_MODEL,1,4000), substr(NEW.NM_MODEL,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_MODEL', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MODEL_ACCORD_OPDM,1,4000), substr(NEW.IE_MODEL_ACCORD_OPDM,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_MODEL_ACCORD_OPDM', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MATURITY,1,4000), substr(NEW.DS_MATURITY,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MATURITY', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_DEVICE_COUNT,1,4000), substr(NEW.NR_DEVICE_COUNT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_DEVICE_COUNT', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_INSTRUCTION_USE,1,4000), substr(NEW.DS_INSTRUCTION_USE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_INSTRUCTION_USE', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GLOBAL_PROD_CLASS_CODE,1,4000), substr(NEW.CD_GLOBAL_PROD_CLASS_CODE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GLOBAL_PROD_CLASS_CODE', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTROL_LOT,1,4000), substr(NEW.IE_CONTROL_LOT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTROL_LOT', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTROL_DOM,1,4000), substr(NEW.IE_CONTROL_DOM,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTROL_DOM', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTROL_DOB,1,4000), substr(NEW.IE_CONTROL_DOB,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTROL_DOB', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MED_DEV_DATA_BLOCK_FILE,1,4000), substr(NEW.DS_MED_DEV_DATA_BLOCK_FILE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MED_DEV_DATA_BLOCK_FILE', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MDRD_EU_FILENAME,1,4000), substr(NEW.DS_MDRD_EU_FILENAME,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MDRD_EU_FILENAME', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_CATALOG_ITEM,1,4000), substr(NEW.NM_CATALOG_ITEM,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_CATALOG_ITEM', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_LEGAL_MANUFACTURER,1,4000), substr(NEW.DS_LEGAL_MANUFACTURER,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_LEGAL_MANUFACTURER', ie_log_w, ds_w, 'OPDM_TRADE_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_opdm_trade_item_tp() FROM PUBLIC;

CREATE TRIGGER opdm_trade_item_tp
	AFTER UPDATE ON opdm_trade_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_opdm_trade_item_tp();

