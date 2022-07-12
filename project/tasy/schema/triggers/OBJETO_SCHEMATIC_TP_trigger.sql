-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS objeto_schematic_tp ON objeto_schematic CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_objeto_schematic_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO,1,4000), substr(NEW.DT_ATUALIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_OBJ_SUP_ATIV,1,4000), substr(NEW.NR_SEQ_OBJ_SUP_ATIV,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_OBJ_SUP_ATIV', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO,1,4000), substr(NEW.NM_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO_NREC,1,4000), substr(NEW.DT_ATUALIZACAO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_NREC,1,4000), substr(NEW.NM_USUARIO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_NREC', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBJETO,1,4000), substr(NEW.DS_OBJETO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBJETO', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_OBJETO,1,4000), substr(NEW.IE_TIPO_OBJETO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_OBJETO', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_OBJ_PAINEL,1,4000), substr(NEW.IE_TIPO_OBJ_PAINEL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_OBJ_PAINEL', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_OBJ_SUP,1,4000), substr(NEW.NR_SEQ_OBJ_SUP,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_OBJ_SUP', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_OBJ_NAVEGADOR,1,4000), substr(NEW.IE_TIPO_OBJ_NAVEGADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_OBJ_NAVEGADOR', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_OBJ_MASTER_REGIAO,1,4000), substr(NEW.IE_TIPO_OBJ_MASTER_REGIAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_OBJ_MASTER_REGIAO', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_FUNCAO,1,4000), substr(NEW.CD_FUNCAO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_FUNCAO', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_SCHEMATIC,1,4000), substr(NEW.NR_SEQ_TIPO_SCHEMATIC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_SCHEMATIC', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_FUNCAO_SCHEMATIC,1,4000), substr(NEW.NR_SEQ_FUNCAO_SCHEMATIC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_FUNCAO_SCHEMATIC', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_DIC_OBJETO,1,4000), substr(NEW.NR_SEQ_DIC_OBJETO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_DIC_OBJETO', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_APRES,1,4000), substr(NEW.NR_SEQ_APRES,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_APRES', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_COMPONENTE,1,4000), substr(NEW.IE_TIPO_COMPONENTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_COMPONENTE', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_VISAO,1,4000), substr(NEW.NR_SEQ_VISAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_VISAO', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_TABELA,1,4000), substr(NEW.NM_TABELA,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_TABELA', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQUENCIA,1,4000), substr(NEW.NR_SEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQUENCIA', ie_log_w, ds_w, 'OBJETO_SCHEMATIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_objeto_schematic_tp() FROM PUBLIC;

CREATE TRIGGER objeto_schematic_tp
	AFTER UPDATE ON objeto_schematic FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_objeto_schematic_tp();
