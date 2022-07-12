-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_param_lote_contas_rec_tp ON ctb_param_lote_contas_rec CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_param_lote_contas_rec_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CC_GLOSA,1,4000), substr(NEW.IE_CC_GLOSA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CC_GLOSA', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_CARTAO_CR,1,4000), substr(NEW.IE_CONTAB_CARTAO_CR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_CARTAO_CR', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_CLASSIF_TIT_REC,1,4000), substr(NEW.IE_CONTAB_CLASSIF_TIT_REC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_CLASSIF_TIT_REC', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_VL_ESTORNO,1,4000), substr(NEW.IE_CONTAB_VL_ESTORNO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_VL_ESTORNO', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_TIT_DESDOB,1,4000), substr(NEW.IE_CONTAB_TIT_DESDOB,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_TIT_DESDOB', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PROD_CLASSIF_BAIXA,1,4000), substr(NEW.IE_PROD_CLASSIF_BAIXA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PROD_CLASSIF_BAIXA', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DT_CONTAB_GLOSA,1,4000), substr(NEW.IE_DT_CONTAB_GLOSA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DT_CONTAB_GLOSA', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_CURTO_PRAZO,1,4000), substr(NEW.IE_CONTAB_CURTO_PRAZO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_CURTO_PRAZO', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_PROV_CONTRATO,1,4000), substr(NEW.IE_CONTAB_PROV_CONTRATO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_PROV_CONTRATO', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_REC_CLASSIF,1,4000), substr(NEW.IE_CONTAB_REC_CLASSIF,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_REC_CLASSIF', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_TIT_CANCELADO,1,4000), substr(NEW.IE_CONTAB_TIT_CANCELADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_TIT_CANCELADO', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DT_CONTAB_CR,1,4000), substr(NEW.IE_DT_CONTAB_CR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DT_CONTAB_CR', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERAR_CONTAB_REG_TIT,1,4000), substr(NEW.IE_GERAR_CONTAB_REG_TIT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GERAR_CONTAB_REG_TIT', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MOVTO_CARTAO_ESTAB,1,4000), substr(NEW.IE_MOVTO_CARTAO_ESTAB,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_MOVTO_CARTAO_ESTAB', ie_log_w, ds_w, 'CTB_PARAM_LOTE_CONTAS_REC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_param_lote_contas_rec_tp() FROM PUBLIC;

CREATE TRIGGER ctb_param_lote_contas_rec_tp
	AFTER UPDATE ON ctb_param_lote_contas_rec FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_param_lote_contas_rec_tp();

