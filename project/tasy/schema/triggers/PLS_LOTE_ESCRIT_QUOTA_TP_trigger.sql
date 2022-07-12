-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_lote_escrit_quota_tp ON pls_lote_escrit_quota CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_lote_escrit_quota_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.CD_CONDICAO_PAGAMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CONDICAO_PAGAMENTO,1,4000), substr(NEW.CD_CONDICAO_PAGAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CONDICAO_PAGAMENTO', ie_log_w, ds_w, 'PLS_LOTE_ESCRIT_QUOTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MOEDA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MOEDA,1,4000), substr(NEW.CD_MOEDA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MOEDA', ie_log_w, ds_w, 'PLS_LOTE_ESCRIT_QUOTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_ENTRADA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_ENTRADA,1,4000), substr(NEW.VL_ENTRADA,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_ENTRADA', ie_log_w, ds_w, 'PLS_LOTE_ESCRIT_QUOTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.QT_QUOTAS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_QUOTAS,1,4000), substr(NEW.QT_QUOTAS,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_QUOTAS', ie_log_w, ds_w, 'PLS_LOTE_ESCRIT_QUOTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_TIPO_ESCRIT_QUOTA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_ESCRIT_QUOTA,1,4000), substr(NEW.NR_SEQ_TIPO_ESCRIT_QUOTA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_ESCRIT_QUOTA', ie_log_w, ds_w, 'PLS_LOTE_ESCRIT_QUOTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_lote_escrit_quota_tp() FROM PUBLIC;

CREATE TRIGGER pls_lote_escrit_quota_tp
	AFTER UPDATE ON pls_lote_escrit_quota FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_lote_escrit_quota_tp();

