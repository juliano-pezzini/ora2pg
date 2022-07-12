-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atendimento_paciente_tp ON atendimento_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atendimento_paciente_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_ATENDIMENTO);  ds_c_w:=null; ds_w:=substr(NEW.IE_TIPO_ATENDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ATENDIMENTO,1,4000), substr(NEW.IE_TIPO_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ATENDIMENTO', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CLINICA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CLINICA,1,4000), substr(NEW.IE_CLINICA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CLINICA', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_ATENDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ATENDIMENTO,1,4000), substr(NEW.NR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ATENDIMENTO', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CARATER_INTER_SUS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CARATER_INTER_SUS,1,4000), substr(NEW.IE_CARATER_INTER_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CARATER_INTER_SUS', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO_RESP,1,4000), substr(NEW.CD_MEDICO_RESP,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO_RESP', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_FISICA,1,4000), substr(NEW.CD_PESSOA_FISICA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_FISICA', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDENCIA,1,4000), substr(NEW.CD_PROCEDENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDENCIA', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ENTRADA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ENTRADA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ENTRADA', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_PREVISTO_ALTA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_PREVISTO_ALTA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_PREVISTO_ALTA', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PROBABILIDADE_ALTA,1,4000), substr(NEW.IE_PROBABILIDADE_ALTA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PROBABILIDADE_ALTA', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBS_PREV_ALTA,1,4000), substr(NEW.DS_OBS_PREV_ALTA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBS_PREV_ALTA', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_RESPONSAVEL,1,4000), substr(NEW.CD_PESSOA_RESPONSAVEL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_RESPONSAVEL', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CLASSIF_MEDICO,1,4000), substr(NEW.NR_SEQ_CLASSIF_MEDICO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CLASSIF_MEDICO', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO_INFECT,1,4000), substr(NEW.CD_MEDICO_INFECT,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO_INFECT', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MOTIVO_ALTA_MEDICA,1,4000), substr(NEW.CD_MOTIVO_ALTA_MEDICA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MOTIVO_ALTA_MEDICA', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ALTA_MEDICO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ALTA_MEDICO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ALTA_MEDICO', ie_log_w, ds_w, 'ATENDIMENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atendimento_paciente_tp() FROM PUBLIC;

CREATE TRIGGER atendimento_paciente_tp
	AFTER UPDATE ON atendimento_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atendimento_paciente_tp();
