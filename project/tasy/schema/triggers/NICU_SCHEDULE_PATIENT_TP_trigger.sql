-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nicu_schedule_patient_tp ON nicu_schedule_patient CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nicu_schedule_patient_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PATIENT,1,4000), substr(NEW.NR_SEQ_PATIENT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PATIENT', ie_log_w, ds_w, 'NICU_SCHEDULE_PATIENT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TASK,1,4000), substr(NEW.NR_SEQ_TASK,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TASK', ie_log_w, ds_w, 'NICU_SCHEDULE_PATIENT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_SCHEDULE,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_SCHEDULE,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_SCHEDULE', ie_log_w, ds_w, 'NICU_SCHEDULE_PATIENT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.ID_STATUS,1,4000), substr(NEW.ID_STATUS,1,4000), NEW.nm_usuario, nr_seq_w, 'ID_STATUS', ie_log_w, ds_w, 'NICU_SCHEDULE_PATIENT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USER_COMPLETE,1,4000), substr(NEW.NM_USER_COMPLETE,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USER_COMPLETE', ie_log_w, ds_w, 'NICU_SCHEDULE_PATIENT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_SCHEDULE_SUP,1,4000), substr(NEW.NR_SEQ_SCHEDULE_SUP,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_SCHEDULE_SUP', ie_log_w, ds_w, 'NICU_SCHEDULE_PATIENT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_COMPLETE,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_COMPLETE,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_COMPLETE', ie_log_w, ds_w, 'NICU_SCHEDULE_PATIENT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nicu_schedule_patient_tp() FROM PUBLIC;

CREATE TRIGGER nicu_schedule_patient_tp
	AFTER UPDATE ON nicu_schedule_patient FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nicu_schedule_patient_tp();

