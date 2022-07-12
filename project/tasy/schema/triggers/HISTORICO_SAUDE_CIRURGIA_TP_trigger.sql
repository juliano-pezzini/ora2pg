-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS historico_saude_cirurgia_tp ON historico_saude_cirurgia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_historico_saude_cirurgia_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.DS_OBSERVACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO_NREC,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_PROCEDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDIMENTO,1,4000), substr(NEW.CD_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDIMENTO', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_NEGA_CIRURGIAS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NEGA_CIRURGIAS,1,4000), substr(NEW.IE_NEGA_CIRURGIAS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NEGA_CIRURGIAS', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_TIPO_ANESTESIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ANESTESIA,1,4000), substr(NEW.IE_TIPO_ANESTESIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ANESTESIA', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_COMPLICACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_COMPLICACAO,1,4000), substr(NEW.DS_COMPLICACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_COMPLICACAO', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_LIBERACAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_LIBERACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_LIBERACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_LIBERACAO', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_USUARIO_LIBERACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_LIBERACAO,1,4000), substr(NEW.NM_USUARIO_LIBERACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_LIBERACAO', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_PROCEDIMENTO_INF,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PROCEDIMENTO_INF,1,4000), substr(NEW.DS_PROCEDIMENTO_INF,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PROCEDIMENTO_INF', ie_log_w, ds_w, 'HISTORICO_SAUDE_CIRURGIA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_historico_saude_cirurgia_tp() FROM PUBLIC;

CREATE TRIGGER historico_saude_cirurgia_tp
	AFTER UPDATE ON historico_saude_cirurgia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_historico_saude_cirurgia_tp();

