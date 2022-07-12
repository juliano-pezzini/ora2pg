-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS xml_elemento_tp ON xml_elemento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_xml_elemento_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.NR_SEQ_PROJETO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PROJETO,1,4000), substr(NEW.NR_SEQ_PROJETO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PROJETO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_SQL_2,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SQL_2,1,4000), substr(NEW.DS_SQL_2,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SQL_2', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_TIPO_COMPLEXO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_COMPLEXO,1,4000), substr(NEW.IE_TIPO_COMPLEXO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_COMPLEXO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_ELEMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ELEMENTO,1,4000), substr(NEW.DS_ELEMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ELEMENTO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_CABECALHO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CABECALHO,1,4000), substr(NEW.DS_CABECALHO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CABECALHO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_TIPO_ELEMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ELEMENTO,1,4000), substr(NEW.IE_TIPO_ELEMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ELEMENTO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_APRESENTACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_APRESENTACAO,1,4000), substr(NEW.NR_SEQ_APRESENTACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_APRESENTACAO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CRIAR_ELEMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CRIAR_ELEMENTO,1,4000), substr(NEW.IE_CRIAR_ELEMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CRIAR_ELEMENTO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQUENCIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQUENCIA,1,4000), substr(NEW.NR_SEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQUENCIA', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO,1,4000), substr(NEW.DT_ATUALIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_USUARIO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO,1,4000), substr(NEW.NM_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_ELEMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_ELEMENTO,1,4000), substr(NEW.NM_ELEMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_ELEMENTO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO_NREC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO_NREC,1,4000), substr(NEW.DT_ATUALIZACAO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_USUARIO_NREC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_NREC,1,4000), substr(NEW.NM_USUARIO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_NREC', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_SQL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SQL,1,4000), substr(NEW.DS_SQL,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SQL', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CRIAR_NULO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CRIAR_NULO,1,4000), substr(NEW.IE_CRIAR_NULO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CRIAR_NULO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_GRUPO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_GRUPO,1,4000), substr(NEW.DS_GRUPO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_GRUPO', ie_log_w, ds_w, 'XML_ELEMENTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_xml_elemento_tp() FROM PUBLIC;

CREATE TRIGGER xml_elemento_tp
	AFTER UPDATE ON xml_elemento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_xml_elemento_tp();

