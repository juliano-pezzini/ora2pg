-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS protocolo_integrado_evento_tp ON protocolo_integrado_evento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_protocolo_integrado_evento_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.IE_TIPO_ATENDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ATENDIMENTO,1,4000), substr(NEW.IE_TIPO_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ATENDIMENTO', ie_log_w, ds_w, 'PROTOCOLO_INTEGRADO_EVENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CLINICA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CLINICA,1,4000), substr(NEW.IE_CLINICA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CLINICA', ie_log_w, ds_w, 'PROTOCOLO_INTEGRADO_EVENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_CLASSIF_SETOR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CLASSIF_SETOR,1,4000), substr(NEW.CD_CLASSIF_SETOR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CLASSIF_SETOR', ie_log_w, ds_w, 'PROTOCOLO_INTEGRADO_EVENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_EVENTO,1,4000), substr(NEW.DS_EVENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_EVENTO', ie_log_w, ds_w, 'PROTOCOLO_INTEGRADO_EVENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_EVENTO,1,4000), substr(NEW.IE_TIPO_EVENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_EVENTO', ie_log_w, ds_w, 'PROTOCOLO_INTEGRADO_EVENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CLASSIF,1,4000), substr(NEW.NR_SEQ_CLASSIF,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CLASSIF', ie_log_w, ds_w, 'PROTOCOLO_INTEGRADO_EVENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_EVENTO,1,4000), substr(NEW.NR_SEQ_EVENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_EVENTO', ie_log_w, ds_w, 'PROTOCOLO_INTEGRADO_EVENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_protocolo_integrado_evento_tp() FROM PUBLIC;

CREATE TRIGGER protocolo_integrado_evento_tp
	AFTER UPDATE ON protocolo_integrado_evento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_protocolo_integrado_evento_tp();

