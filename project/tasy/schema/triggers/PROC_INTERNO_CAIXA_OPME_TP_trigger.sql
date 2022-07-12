-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proc_interno_caixa_opme_tp ON proc_interno_caixa_opme CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proc_interno_caixa_opme_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO,1,4000), substr(NEW.CD_MEDICO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO', ie_log_w, ds_w, 'PROC_INTERNO_CAIXA_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PROC_INTERNO,1,4000), substr(NEW.NR_SEQ_PROC_INTERNO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PROC_INTERNO', ie_log_w, ds_w, 'PROC_INTERNO_CAIXA_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_MATERIAL,1,4000), substr(NEW.QT_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_MATERIAL', ie_log_w, ds_w, 'PROC_INTERNO_CAIXA_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_CAIXA_OPME,1,4000), substr(NEW.NR_SEQ_TIPO_CAIXA_OPME,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_CAIXA_OPME', ie_log_w, ds_w, 'PROC_INTERNO_CAIXA_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PADRAO,1,4000), substr(NEW.IE_PADRAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PADRAO', ie_log_w, ds_w, 'PROC_INTERNO_CAIXA_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_APRES,1,4000), substr(NEW.NR_SEQ_APRES,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_APRES', ie_log_w, ds_w, 'PROC_INTERNO_CAIXA_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_AUTORIZACAO,1,4000), substr(NEW.IE_AUTORIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_AUTORIZACAO', ie_log_w, ds_w, 'PROC_INTERNO_CAIXA_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proc_interno_caixa_opme_tp() FROM PUBLIC;

CREATE TRIGGER proc_interno_caixa_opme_tp
	AFTER UPDATE ON proc_interno_caixa_opme FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proc_interno_caixa_opme_tp();

