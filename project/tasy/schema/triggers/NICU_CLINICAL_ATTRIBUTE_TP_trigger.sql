-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nicu_clinical_attribute_tp ON nicu_clinical_attribute CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nicu_clinical_attribute_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ORDER_BY,1,4000), substr(NEW.NR_ORDER_BY,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ORDER_BY', ie_log_w, ds_w, 'NICU_CLINICAL_ATTRIBUTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DISPLAY_CARD,1,4000), substr(NEW.IE_DISPLAY_CARD,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DISPLAY_CARD', ie_log_w, ds_w, 'NICU_CLINICAL_ATTRIBUTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_LABEL,1,4000), substr(NEW.DS_LABEL,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_LABEL', ie_log_w, ds_w, 'NICU_CLINICAL_ATTRIBUTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SNOMED,1,4000), substr(NEW.CD_SNOMED,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SNOMED', ie_log_w, ds_w, 'NICU_CLINICAL_ATTRIBUTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.ID_RULE,1,4000), substr(NEW.ID_RULE,1,4000), NEW.nm_usuario, nr_seq_w, 'ID_RULE', ie_log_w, ds_w, 'NICU_CLINICAL_ATTRIBUTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nicu_clinical_attribute_tp() FROM PUBLIC;

CREATE TRIGGER nicu_clinical_attribute_tp
	AFTER UPDATE ON nicu_clinical_attribute FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nicu_clinical_attribute_tp();
