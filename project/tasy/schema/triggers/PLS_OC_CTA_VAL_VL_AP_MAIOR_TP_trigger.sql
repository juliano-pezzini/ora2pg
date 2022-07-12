-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_oc_cta_val_vl_ap_maior_tp ON pls_oc_cta_val_vl_ap_maior CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_oc_cta_val_vl_ap_maior_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_OC_CTA_COMB,1,4000), substr(NEW.NR_SEQ_OC_CTA_COMB,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_OC_CTA_COMB', ie_log_w, ds_w, 'PLS_OC_CTA_VAL_VL_AP_MAIOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.PR_TOLERANCIA,1,4000), substr(NEW.PR_TOLERANCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'PR_TOLERANCIA', ie_log_w, ds_w, 'PLS_OC_CTA_VAL_VL_AP_MAIOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_TOLERANCIA,1,4000), substr(NEW.VL_TOLERANCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_TOLERANCIA', ie_log_w, ds_w, 'PLS_OC_CTA_VAL_VL_AP_MAIOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VAL_VL_APRES_A_MAIOR,1,4000), substr(NEW.IE_VAL_VL_APRES_A_MAIOR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_VAL_VL_APRES_A_MAIOR', ie_log_w, ds_w, 'PLS_OC_CTA_VAL_VL_AP_MAIOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_oc_cta_val_vl_ap_maior_tp() FROM PUBLIC;

CREATE TRIGGER pls_oc_cta_val_vl_ap_maior_tp
	AFTER UPDATE ON pls_oc_cta_val_vl_ap_maior FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_oc_cta_val_vl_ap_maior_tp();

