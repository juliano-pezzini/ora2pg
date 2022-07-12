-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_transfusao_tp ON paciente_transfusao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_transfusao_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.DT_ATUALIZACAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO_NREC,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_USUARIO_LIBERACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_LIBERACAO,1,4000), substr(NEW.NM_USUARIO_LIBERACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_LIBERACAO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_LIBERACAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_LIBERACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_LIBERACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_LIBERACAO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_AFERESE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_AFERESE,1,4000), substr(NEW.IE_AFERESE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_AFERESE', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_ALIQUOTADO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ALIQUOTADO,1,4000), substr(NEW.IE_ALIQUOTADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ALIQUOTADO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_ORIENTACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ORIENTACAO,1,4000), substr(NEW.DS_ORIENTACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ORIENTACAO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_IRRADIADO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_IRRADIADO,1,4000), substr(NEW.IE_IRRADIADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_IRRADIADO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_LAVADO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_LAVADO,1,4000), substr(NEW.IE_LAVADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_LAVADO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_DERIVADO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_DERIVADO,1,4000), substr(NEW.NR_SEQ_DERIVADO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_DERIVADO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_TRANSFUSAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_TRANSFUSAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_TRANSFUSAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_TRANSFUSAO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_NEGA_TRANSFUSAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NEGA_TRANSFUSAO,1,4000), substr(NEW.IE_NEGA_TRANSFUSAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NEGA_TRANSFUSAO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_FILTRADO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FILTRADO,1,4000), substr(NEW.IE_FILTRADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FILTRADO', ie_log_w, ds_w, 'PACIENTE_TRANSFUSAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_transfusao_tp() FROM PUBLIC;

CREATE TRIGGER paciente_transfusao_tp
	AFTER UPDATE ON paciente_transfusao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_transfusao_tp();
