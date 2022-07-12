-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proc_interno_kit_tp ON proc_interno_kit CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proc_interno_kit_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SETOR_ATENDIMENTO,1,4000), substr(NEW.CD_SETOR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SETOR_ATENDIMENTO', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_KIT_MATERIAL,1,4000), substr(NEW.CD_KIT_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_KIT_MATERIAL', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESTABELECIMENTO,1,4000), substr(NEW.CD_ESTABELECIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESTABELECIMENTO', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PROC_INTERNO,1,4000), substr(NEW.NR_SEQ_PROC_INTERNO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PROC_INTERNO', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO,1,4000), substr(NEW.CD_MEDICO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_MIN,1,4000), substr(NEW.QT_IDADE_MIN,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_MIN', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CONVENIO,1,4000), substr(NEW.CD_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CONVENIO', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_MIN_DIA,1,4000), substr(NEW.QT_IDADE_MIN_DIA,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_MIN_DIA', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_MAX,1,4000), substr(NEW.QT_IDADE_MAX,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_MAX', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_MAX_MES,1,4000), substr(NEW.QT_IDADE_MAX_MES,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_MAX_MES', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_MAX_DIA,1,4000), substr(NEW.QT_IDADE_MAX_DIA,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_MAX_DIA', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SOMENTE_EXCLUSIVO,1,4000), substr(NEW.IE_SOMENTE_EXCLUSIVO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SOMENTE_EXCLUSIVO', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_MIN_MES,1,4000), substr(NEW.QT_IDADE_MIN_MES,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_MIN_MES', ie_log_w, ds_w, 'PROC_INTERNO_KIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proc_interno_kit_tp() FROM PUBLIC;

CREATE TRIGGER proc_interno_kit_tp
	AFTER UPDATE ON proc_interno_kit FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proc_interno_kit_tp();
