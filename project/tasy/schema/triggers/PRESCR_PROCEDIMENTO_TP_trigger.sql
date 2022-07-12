-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_procedimento_tp ON prescr_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_procedimento_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null;  ds_c_w:= 'NR_PRESCRICAO='||to_char(OLD.NR_PRESCRICAO)||'#@#@NR_SEQUENCIA='||to_char(OLD.NR_SEQUENCIA); ds_w:=substr(NEW.NR_DOC_CONVENIO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_DOC_CONVENIO,1,4000), substr(NEW.NR_DOC_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_DOC_CONVENIO', ie_log_w, ds_w, 'PRESCR_PROCEDIMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_PREV_EXECUCAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_PREV_EXECUCAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_PREV_EXECUCAO', ie_log_w, ds_w, 'PRESCR_PROCEDIMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_procedimento_tp() FROM PUBLIC;

CREATE TRIGGER prescr_procedimento_tp
	AFTER UPDATE ON prescr_procedimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_procedimento_tp();
