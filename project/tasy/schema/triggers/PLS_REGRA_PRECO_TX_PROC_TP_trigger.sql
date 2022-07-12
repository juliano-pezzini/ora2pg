-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_preco_tx_proc_tp ON pls_regra_preco_tx_proc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_preco_tx_proc_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_EXEC_MIN,1,4000), substr(NEW.QT_EXEC_MIN,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_EXEC_MIN', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_EXEC_MAX,1,4000), substr(NEW.QT_EXEC_MAX,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_EXEC_MAX', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.TX_PROCEDIMENTO,1,4000), substr(NEW.TX_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_PROCEDIMENTO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.TX_MATERIAL,1,4000), substr(NEW.TX_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_MATERIAL', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.TX_CUSTO_OPERACIONAL,1,4000), substr(NEW.TX_CUSTO_OPERACIONAL,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_CUSTO_OPERACIONAL', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TAXA_ITEM,1,4000), substr(NEW.NR_SEQ_TAXA_ITEM,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TAXA_ITEM', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.TX_ANESTESISTA,1,4000), substr(NEW.TX_ANESTESISTA,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_ANESTESISTA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.TX_AUXILIARES,1,4000), substr(NEW.TX_AUXILIARES,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_AUXILIARES', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.TX_MEDICO,1,4000), substr(NEW.TX_MEDICO,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_MEDICO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_TX_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_preco_tx_proc_tp() FROM PUBLIC;

CREATE TRIGGER pls_regra_preco_tx_proc_tp
	AFTER UPDATE ON pls_regra_preco_tx_proc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_preco_tx_proc_tp();

