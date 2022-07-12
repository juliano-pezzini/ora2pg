-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS w_suep_tp ON w_suep CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_w_suep_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.NM_PESSOA_FISICA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_PESSOA_FISICA,1,4000), substr(NEW.NM_PESSOA_FISICA,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_PESSOA_FISICA', ie_log_w, ds_w, 'W_SUEP', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CATEGORIA,1,4000), substr(NEW.CD_CATEGORIA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CATEGORIA', ie_log_w, ds_w, 'W_SUEP', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ENTRADA,1,4000), substr(NEW.DT_ENTRADA,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ENTRADA', ie_log_w, ds_w, 'W_SUEP', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_SANGUE,1,4000), substr(NEW.IE_TIPO_SANGUE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_SANGUE', ie_log_w, ds_w, 'W_SUEP', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_PRONTUARIO,1,4000), substr(NEW.NR_PRONTUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_PRONTUARIO', ie_log_w, ds_w, 'W_SUEP', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FATOR_RH,1,4000), substr(NEW.IE_FATOR_RH,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FATOR_RH', ie_log_w, ds_w, 'W_SUEP', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CONVENIO,1,4000), substr(NEW.DS_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CONVENIO', ie_log_w, ds_w, 'W_SUEP', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_w_suep_tp() FROM PUBLIC;

CREATE TRIGGER w_suep_tp
	AFTER UPDATE ON w_suep FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_w_suep_tp();
