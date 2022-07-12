-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS indice_tp ON indice CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_indice_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null;  ds_c_w:= 'NM_TABELA='||to_char(OLD.NM_TABELA)||'#@#@NM_INDICE='||to_char(OLD.NM_INDICE);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_INDICE,1,4000), substr(NEW.DS_INDICE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_INDICE', ie_log_w, ds_w, 'INDICE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO,1,4000), substr(NEW.IE_TIPO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO', ie_log_w, ds_w, 'INDICE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'INDICE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CRIAR_ALTERAR,1,4000), substr(NEW.IE_CRIAR_ALTERAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CRIAR_ALTERAR', ie_log_w, ds_w, 'INDICE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_CRIACAO,1,4000), substr(NEW.DT_CRIACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_CRIACAO', ie_log_w, ds_w, 'INDICE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_INDICE,1,4000), substr(NEW.NM_INDICE,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_INDICE', ie_log_w, ds_w, 'INDICE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_indice_tp() FROM PUBLIC;

CREATE TRIGGER indice_tp
	AFTER UPDATE ON indice FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_indice_tp();
