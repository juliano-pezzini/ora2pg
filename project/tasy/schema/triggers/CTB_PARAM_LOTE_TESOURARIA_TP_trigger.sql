-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_param_lote_tesouraria_tp ON ctb_param_lote_tesouraria CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_param_lote_tesouraria_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_HISTORICO_CRED,1,4000), substr(NEW.CD_HISTORICO_CRED,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_HISTORICO_CRED', ie_log_w, ds_w, 'CTB_PARAM_LOTE_TESOURARIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_MONET_DOCTO,1,4000), substr(NEW.IE_CONTAB_MONET_DOCTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_MONET_DOCTO', ie_log_w, ds_w, 'CTB_PARAM_LOTE_TESOURARIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_TRANSF_CAIXA,1,4000), substr(NEW.IE_CONTAB_TRANSF_CAIXA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_TRANSF_CAIXA', ie_log_w, ds_w, 'CTB_PARAM_LOTE_TESOURARIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_TRANS_FIN_BAIXA,1,4000), substr(NEW.IE_CONTAB_TRANS_FIN_BAIXA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_TRANS_FIN_BAIXA', ie_log_w, ds_w, 'CTB_PARAM_LOTE_TESOURARIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_CR,1,4000), substr(NEW.IE_CONTAB_CR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_CR', ie_log_w, ds_w, 'CTB_PARAM_LOTE_TESOURARIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_MONET_REGRA,1,4000), substr(NEW.IE_CONTAB_MONET_REGRA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_MONET_REGRA', ie_log_w, ds_w, 'CTB_PARAM_LOTE_TESOURARIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTAB_CP,1,4000), substr(NEW.IE_CONTAB_CP,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTAB_CP', ie_log_w, ds_w, 'CTB_PARAM_LOTE_TESOURARIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_param_lote_tesouraria_tp() FROM PUBLIC;

CREATE TRIGGER ctb_param_lote_tesouraria_tp
	AFTER UPDATE ON ctb_param_lote_tesouraria FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_param_lote_tesouraria_tp();
