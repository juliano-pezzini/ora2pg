-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS perfil_item_pepo_tp ON perfil_item_pepo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_perfil_item_pepo_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PASTA_INICIAL,1,4000), substr(NEW.NR_SEQ_PASTA_INICIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PASTA_INICIAL', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_QUEST_TEXTO_PADRAO,1,4000), substr(NEW.IE_QUEST_TEXTO_PADRAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_QUEST_TEXTO_PADRAO', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQUENCIA,1,4000), substr(NEW.NR_SEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQUENCIA', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO,1,4000), substr(NEW.DT_ATUALIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PERFIL,1,4000), substr(NEW.CD_PERFIL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PERFIL', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_ITEM_PEPO,1,4000), substr(NEW.NR_SEQ_ITEM_PEPO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_ITEM_PEPO', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATUALIZAR,1,4000), substr(NEW.IE_ATUALIZAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATUALIZAR', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO,1,4000), substr(NEW.NM_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO_NREC,1,4000), substr(NEW.DT_ATUALIZACAO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_NREC,1,4000), substr(NEW.NM_USUARIO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_NREC', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_APRESENTACAO,1,4000), substr(NEW.NR_SEQ_APRESENTACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_APRESENTACAO', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ITEM,1,4000), substr(NEW.IE_TIPO_ITEM,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ITEM', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SOMENTE_TEMPLATE,1,4000), substr(NEW.IE_SOMENTE_TEMPLATE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SOMENTE_TEMPLATE', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ITEM_INSTITUICAO,1,4000), substr(NEW.DS_ITEM_INSTITUICAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ITEM_INSTITUICAO', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PASTA_TEMPLATE,1,4000), substr(NEW.DS_PASTA_TEMPLATE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PASTA_TEMPLATE', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_INATIVAR,1,4000), substr(NEW.IE_INATIVAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_INATIVAR', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SENHA_LIBERACAO,1,4000), substr(NEW.IE_SENHA_LIBERACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SENHA_LIBERACAO', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VISUALIZA_INATIVO,1,4000), substr(NEW.IE_VISUALIZA_INATIVO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_VISUALIZA_INATIVO', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_IMPRIMIR_LIBERAR,1,4000), substr(NEW.IE_IMPRIMIR_LIBERAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_IMPRIMIR_LIBERAR', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FORMA_LIBERAR,1,4000), substr(NEW.IE_FORMA_LIBERAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FORMA_LIBERAR', ie_log_w, ds_w, 'PERFIL_ITEM_PEPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_perfil_item_pepo_tp() FROM PUBLIC;

CREATE TRIGGER perfil_item_pepo_tp
	AFTER UPDATE ON perfil_item_pepo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_perfil_item_pepo_tp();

