-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS hc_pad_controle_prof_tp ON hc_pad_controle_prof CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_hc_pad_controle_prof_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO,1,4000), substr(NEW.DT_ATUALIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'HC_PAD_CONTROLE_PROF', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO,1,4000), substr(NEW.NM_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO', ie_log_w, ds_w, 'HC_PAD_CONTROLE_PROF', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_PROFISSIONAL,1,4000), substr(NEW.QT_PROFISSIONAL,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_PROFISSIONAL', ie_log_w, ds_w, 'HC_PAD_CONTROLE_PROF', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_INTERVALO,1,4000), substr(NEW.NR_SEQ_INTERVALO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_INTERVALO', ie_log_w, ds_w, 'HC_PAD_CONTROLE_PROF', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PROFISSIONAL,1,4000), substr(NEW.NR_SEQ_PROFISSIONAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PROFISSIONAL', ie_log_w, ds_w, 'HC_PAD_CONTROLE_PROF', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CONTROLE,1,4000), substr(NEW.NR_SEQ_CONTROLE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CONTROLE', ie_log_w, ds_w, 'HC_PAD_CONTROLE_PROF', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_hc_pad_controle_prof_tp() FROM PUBLIC;

CREATE TRIGGER hc_pad_controle_prof_tp
	AFTER UPDATE ON hc_pad_controle_prof FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_hc_pad_controle_prof_tp();

