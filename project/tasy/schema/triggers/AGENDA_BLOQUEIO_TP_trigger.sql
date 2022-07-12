-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_bloqueio_tp ON agenda_bloqueio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_bloqueio_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DT_FINAL,1,4000), substr(NEW.DT_FINAL,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_FINAL', ie_log_w, ds_w, 'AGENDA_BLOQUEIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_INICIAL,1,4000), substr(NEW.DT_INICIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_INICIAL', ie_log_w, ds_w, 'AGENDA_BLOQUEIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DIA_SEMANA,1,4000), substr(NEW.IE_DIA_SEMANA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DIA_SEMANA', ie_log_w, ds_w, 'AGENDA_BLOQUEIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.HR_FINAL_BLOQUEIO,1,4000), substr(NEW.HR_FINAL_BLOQUEIO,1,4000), NEW.nm_usuario, nr_seq_w, 'HR_FINAL_BLOQUEIO', ie_log_w, ds_w, 'AGENDA_BLOQUEIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.HR_INICIO_BLOQUEIO,1,4000), substr(NEW.HR_INICIO_BLOQUEIO,1,4000), NEW.nm_usuario, nr_seq_w, 'HR_INICIO_BLOQUEIO', ie_log_w, ds_w, 'AGENDA_BLOQUEIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_bloqueio_tp() FROM PUBLIC;

CREATE TRIGGER agenda_bloqueio_tp
	AFTER UPDATE ON agenda_bloqueio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_bloqueio_tp();
