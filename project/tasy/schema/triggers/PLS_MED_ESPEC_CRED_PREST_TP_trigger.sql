-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_med_espec_cred_prest_tp ON pls_med_espec_cred_prest CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_med_espec_cred_prest_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESPECIALIDADE,1,4000), substr(NEW.CD_ESPECIALIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESPECIALIDADE', ie_log_w, ds_w, 'PLS_MED_ESPEC_CRED_PREST', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CGC,1,4000), substr(NEW.CD_CGC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CGC', ie_log_w, ds_w, 'PLS_MED_ESPEC_CRED_PREST', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ESPECIALIDADE_PRINC,1,4000), substr(NEW.IE_ESPECIALIDADE_PRINC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ESPECIALIDADE_PRINC', ie_log_w, ds_w, 'PLS_MED_ESPEC_CRED_PREST', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_AREA_ATUACAO,1,4000), substr(NEW.NR_SEQ_AREA_ATUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_AREA_ATUACAO', ie_log_w, ds_w, 'PLS_MED_ESPEC_CRED_PREST', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_FORMULARIO,1,4000), substr(NEW.NR_SEQ_FORMULARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_FORMULARIO', ie_log_w, ds_w, 'PLS_MED_ESPEC_CRED_PREST', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_med_espec_cred_prest_tp() FROM PUBLIC;

CREATE TRIGGER pls_med_espec_cred_prest_tp
	AFTER UPDATE ON pls_med_espec_cred_prest FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_med_espec_cred_prest_tp();

