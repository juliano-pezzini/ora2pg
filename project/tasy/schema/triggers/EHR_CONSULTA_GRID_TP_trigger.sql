-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ehr_consulta_grid_tp ON ehr_consulta_grid CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ehr_consulta_grid_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NM_CAMPO_BASE,1,4000), substr(NEW.NM_CAMPO_BASE,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_CAMPO_BASE', ie_log_w, ds_w, 'EHR_CONSULTA_GRID', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_EDICAO,1,4000), substr(NEW.IE_TIPO_EDICAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_EDICAO', ie_log_w, ds_w, 'EHR_CONSULTA_GRID', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_INFORMACAO,1,4000), substr(NEW.DS_INFORMACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_INFORMACAO', ie_log_w, ds_w, 'EHR_CONSULTA_GRID', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MASCARA,1,4000), substr(NEW.DS_MASCARA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MASCARA', ie_log_w, ds_w, 'EHR_CONSULTA_GRID', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_APRES,1,4000), substr(NEW.NR_SEQ_APRES,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_APRES', ie_log_w, ds_w, 'EHR_CONSULTA_GRID', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_LARGURA,1,4000), substr(NEW.QT_LARGURA,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_LARGURA', ie_log_w, ds_w, 'EHR_CONSULTA_GRID', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ehr_consulta_grid_tp() FROM PUBLIC;

CREATE TRIGGER ehr_consulta_grid_tp
	AFTER UPDATE ON ehr_consulta_grid FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ehr_consulta_grid_tp();

