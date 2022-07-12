-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cot_compra_forn_item_tp ON cot_compra_forn_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cot_compra_forn_item_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CGC_FORNECEDOR,1,4000), substr(NEW.CD_CGC_FORNECEDOR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CGC_FORNECEDOR', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_JUSTIFICATIVA_LIB,1,4000), substr(NEW.DS_JUSTIFICATIVA_LIB,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_JUSTIFICATIVA_LIB', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_UNITARIO_MATERIAL,1,4000), substr(NEW.VL_UNITARIO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_UNITARIO_MATERIAL', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO,1,4000), substr(NEW.NM_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.PR_DESCONTO,1,4000), substr(NEW.PR_DESCONTO,1,4000), NEW.nm_usuario, nr_seq_w, 'PR_DESCONTO', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_COT_COMPRA,1,4000), substr(NEW.NR_COT_COMPRA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_COT_COMPRA', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MARCA,1,4000), substr(NEW.DS_MARCA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MARCA', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ITEM_COT_COMPRA,1,4000), substr(NEW.NR_ITEM_COT_COMPRA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ITEM_COT_COMPRA', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MATERIAL_DIRETO,1,4000), substr(NEW.DS_MATERIAL_DIRETO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MATERIAL_DIRETO', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_VALIDADE,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_VALIDADE,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_VALIDADE', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL,1,4000), substr(NEW.CD_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQUENCIA,1,4000), substr(NEW.NR_SEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQUENCIA', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_COT_FORN,1,4000), substr(NEW.NR_SEQ_COT_FORN,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_COT_FORN', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MARCA_FORNEC,1,4000), substr(NEW.DS_MARCA_FORNEC,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MARCA_FORNEC', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_LIB,1,4000), substr(NEW.NM_USUARIO_LIB,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_LIB', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_MATERIAL,1,4000), substr(NEW.QT_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_MATERIAL', ie_log_w, ds_w, 'COT_COMPRA_FORN_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cot_compra_forn_item_tp() FROM PUBLIC;

CREATE TRIGGER cot_compra_forn_item_tp
	AFTER UPDATE ON cot_compra_forn_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cot_compra_forn_item_tp();
