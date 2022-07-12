-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_aviso_exec_mat_tp ON regra_aviso_exec_mat CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_aviso_exec_mat_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_INATIVA_CADASTRO,1,4000), substr(NEW.IE_INATIVA_CADASTRO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_INATIVA_CADASTRO', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NOVA_ESTRUT,1,4000), substr(NEW.IE_NOVA_ESTRUT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NOVA_ESTRUT', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CI_LIDA,1,4000), substr(NEW.IE_CI_LIDA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CI_LIDA', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXECUCAO_MATERIAL,1,4000), substr(NEW.IE_EXECUCAO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_EXECUCAO_MATERIAL', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GRUPO_MATERIAL,1,4000), substr(NEW.CD_GRUPO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GRUPO_MATERIAL', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SUBGRUPO_MATERIAL,1,4000), substr(NEW.CD_SUBGRUPO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SUBGRUPO_MATERIAL', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CLASSE_MATERIAL,1,4000), substr(NEW.CD_CLASSE_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CLASSE_MATERIAL', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL,1,4000), substr(NEW.CD_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SETOR_ATENDIMENTO,1,4000), substr(NEW.CD_SETOR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SETOR_ATENDIMENTO', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_USUARIO_DESTINO,1,4000), substr(NEW.DS_USUARIO_DESTINO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_USUARIO_DESTINO', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ALTO_CUSTO_CONTA,1,4000), substr(NEW.IE_ALTO_CUSTO_CONTA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ALTO_CUSTO_CONTA', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NOVO_CADASTRO,1,4000), substr(NEW.IE_NOVO_CADASTRO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NOVO_CADASTRO', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ALTERACAO_CADASTRO,1,4000), substr(NEW.IE_ALTERACAO_CADASTRO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ALTERACAO_CADASTRO', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESTABELECIMENTO,1,4000), substr(NEW.CD_ESTABELECIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESTABELECIMENTO', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PERFIL,1,4000), substr(NEW.CD_PERFIL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PERFIL', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXCLUSAO_MAT,1,4000), substr(NEW.IE_EXCLUSAO_MAT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_EXCLUSAO_MAT', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_FUNCAO,1,4000), substr(NEW.CD_FUNCAO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_FUNCAO', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ALTERACAO_ESTRUT,1,4000), substr(NEW.IE_ALTERACAO_ESTRUT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ALTERACAO_ESTRUT', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATIVA_CADASTRO,1,4000), substr(NEW.IE_ATIVA_CADASTRO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATIVA_CADASTRO', ie_log_w, ds_w, 'REGRA_AVISO_EXEC_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_aviso_exec_mat_tp() FROM PUBLIC;

CREATE TRIGGER regra_aviso_exec_mat_tp
	AFTER UPDATE ON regra_aviso_exec_mat FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_aviso_exec_mat_tp();

