-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tiss_campo_esp_compl_tp ON tiss_campo_esp_compl CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tiss_campo_esp_compl_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.DS_CAMPO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CAMPO,1,4000), substr(NEW.DS_CAMPO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CAMPO', ie_log_w, ds_w, 'TISS_CAMPO_ESP_COMPL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_ANTERIOR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ANTERIOR,1,4000), substr(NEW.DS_ANTERIOR,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ANTERIOR', ie_log_w, ds_w, 'TISS_CAMPO_ESP_COMPL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_PADRAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_PADRAO,1,4000), substr(NEW.VL_PADRAO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_PADRAO', ie_log_w, ds_w, 'TISS_CAMPO_ESP_COMPL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_APRESENTACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_APRESENTACAO,1,4000), substr(NEW.NR_SEQ_APRESENTACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_APRESENTACAO', ie_log_w, ds_w, 'TISS_CAMPO_ESP_COMPL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_POSTERIOR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_POSTERIOR,1,4000), substr(NEW.DS_POSTERIOR,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_POSTERIOR', ie_log_w, ds_w, 'TISS_CAMPO_ESP_COMPL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tiss_campo_esp_compl_tp() FROM PUBLIC;

CREATE TRIGGER tiss_campo_esp_compl_tp
	AFTER UPDATE ON tiss_campo_esp_compl FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tiss_campo_esp_compl_tp();
