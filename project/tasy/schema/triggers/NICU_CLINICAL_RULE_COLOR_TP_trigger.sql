-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nicu_clinical_rule_color_tp ON nicu_clinical_rule_color CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nicu_clinical_rule_color_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SNOMED_IN,1,4000), substr(NEW.CD_SNOMED_IN,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SNOMED_IN', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SNOMED_IN,1,4000), substr(NEW.DS_SNOMED_IN,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SNOMED_IN', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SNOMED_CHILD,1,4000), substr(NEW.CD_SNOMED_CHILD,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SNOMED_CHILD', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SNOMED_CHILD,1,4000), substr(NEW.DS_SNOMED_CHILD,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SNOMED_CHILD', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SNOMED_SOURCE,1,4000), substr(NEW.CD_SNOMED_SOURCE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SNOMED_SOURCE', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SNOMED_SOURCE,1,4000), substr(NEW.DS_SNOMED_SOURCE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SNOMED_SOURCE', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_VALUE_TRIGGER,1,4000), substr(NEW.QT_VALUE_TRIGGER,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_VALUE_TRIGGER', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_YELLOW_LOW,1,4000), substr(NEW.QT_YELLOW_LOW,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_YELLOW_LOW', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_YELLOW_HIGH,1,4000), substr(NEW.QT_YELLOW_HIGH,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_YELLOW_HIGH', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_RED_LOW,1,4000), substr(NEW.QT_RED_LOW,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_RED_LOW', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_RED_HIGH,1,4000), substr(NEW.QT_RED_HIGH,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_RED_HIGH', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_NOTE,1,4000), substr(NEW.DS_NOTE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_NOTE', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SNOMED_COLOR_TRIGGER,1,4000), substr(NEW.CD_SNOMED_COLOR_TRIGGER,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SNOMED_COLOR_TRIGGER', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.ID_RULE,1,4000), substr(NEW.ID_RULE,1,4000), NEW.nm_usuario, nr_seq_w, 'ID_RULE', ie_log_w, ds_w, 'NICU_CLINICAL_RULE_COLOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nicu_clinical_rule_color_tp() FROM PUBLIC;

CREATE TRIGGER nicu_clinical_rule_color_tp
	AFTER UPDATE ON nicu_clinical_rule_color FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nicu_clinical_rule_color_tp();

