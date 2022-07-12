-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_consulta_tp ON agenda_consulta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_consulta_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.NR_SEQ_STATUS_PAC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_STATUS_PAC,1,4000), substr(NEW.NR_SEQ_STATUS_PAC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_STATUS_PAC', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ATENDIMENTO,1,4000), substr(NEW.NR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ATENDIMENTO', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_PACIENTE,1,4000), substr(NEW.IE_STATUS_PACIENTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_PACIENTE', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SESSAO_COPIAR_PROCED_ADIC,1,4000), substr(NEW.IE_SESSAO_COPIAR_PROCED_ADIC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SESSAO_COPIAR_PROCED_ADIC', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SESSAO_FINAL_SEMANA,1,4000), substr(NEW.IE_SESSAO_FINAL_SEMANA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SESSAO_FINAL_SEMANA', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_SESSAO_INTERVALO,1,4000), substr(NEW.QT_SESSAO_INTERVALO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_SESSAO_INTERVALO', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SESSAO_DIAS_SEMANA,1,4000), substr(NEW.DS_SESSAO_DIAS_SEMANA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SESSAO_DIAS_SEMANA', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SESSAO_COPIAR_PROCED,1,4000), substr(NEW.IE_SESSAO_COPIAR_PROCED,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SESSAO_COPIAR_PROCED', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CLASSIF_AGENDA,1,4000), substr(NEW.IE_CLASSIF_AGENDA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CLASSIF_AGENDA', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SESSAO_DIARIAMENTE,1,4000), substr(NEW.IE_SESSAO_DIARIAMENTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SESSAO_DIARIAMENTE', ie_log_w, ds_w, 'AGENDA_CONSULTA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_consulta_tp() FROM PUBLIC;

CREATE TRIGGER agenda_consulta_tp
	AFTER UPDATE ON agenda_consulta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_consulta_tp();

