-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS enferm_perfil_relac_funcao_tp ON enferm_perfil_relac_funcao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_enferm_perfil_relac_funcao_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_COMB2_TRABALHANDO,1,4000), substr(NEW.IE_COMB2_TRABALHANDO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_COMB2_TRABALHANDO', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REL_OUTROS_RELACAO,1,4000), substr(NEW.IE_REL_OUTROS_RELACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REL_OUTROS_RELACAO', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TRABALHANDO_PASSADO,1,4000), substr(NEW.IE_TRABALHANDO_PASSADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TRABALHANDO_PASSADO', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PLANO_TRABALHO,1,4000), substr(NEW.IE_PLANO_TRABALHO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PLANO_TRABALHO', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_COMB1_TRABALHANDO,1,4000), substr(NEW.IE_COMB1_TRABALHANDO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_COMB1_TRABALHANDO', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REL_OUTROS,1,4000), substr(NEW.DS_REL_OUTROS,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REL_OUTROS', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REL_OUTROS_OBS,1,4000), substr(NEW.DS_REL_OUTROS_OBS,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REL_OUTROS_OBS', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REL_FAMILIAR,1,4000), substr(NEW.IE_REL_FAMILIAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REL_FAMILIAR', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REL_FAMILIAR,1,4000), substr(NEW.DS_REL_FAMILIAR,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REL_FAMILIAR', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PAPEL_CASA,1,4000), substr(NEW.DS_PAPEL_CASA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PAPEL_CASA', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TRABALHANDO,1,4000), substr(NEW.IE_TRABALHANDO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TRABALHANDO', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CUIDADO_ENF,1,4000), substr(NEW.IE_CUIDADO_ENF,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CUIDADO_ENF', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_COMB_CUIDADO_ENF,1,4000), substr(NEW.IE_COMB_CUIDADO_ENF,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_COMB_CUIDADO_ENF', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CUIDADOR_NOME,1,4000), substr(NEW.DS_CUIDADOR_NOME,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CUIDADOR_NOME', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CUIDADOR_IDADE,1,4000), substr(NEW.DS_CUIDADOR_IDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CUIDADOR_IDADE', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PESO_FAMILIA_CASA,1,4000), substr(NEW.DS_PESO_FAMILIA_CASA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PESO_FAMILIA_CASA', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CUIDADOR_RELACAO,1,4000), substr(NEW.IE_CUIDADOR_RELACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CUIDADOR_RELACAO', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CUIDADOR_SAUDE,1,4000), substr(NEW.IE_CUIDADOR_SAUDE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CUIDADOR_SAUDE', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PESO_FAMILIA_CASA,1,4000), substr(NEW.IE_PESO_FAMILIA_CASA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PESO_FAMILIA_CASA', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_DESEJO_CUIDADO_PESSOA,1,4000), substr(NEW.DS_DESEJO_CUIDADO_PESSOA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_DESEJO_CUIDADO_PESSOA', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_FAMILIA_CARINHO,1,4000), substr(NEW.DS_FAMILIA_CARINHO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_FAMILIA_CARINHO', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PESSOA_CHAVE_NOME,1,4000), substr(NEW.DS_PESSOA_CHAVE_NOME,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PESSOA_CHAVE_NOME', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PESSOA_CHAVE_IDADE,1,4000), substr(NEW.DS_PESSOA_CHAVE_IDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PESSOA_CHAVE_IDADE', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PESSOA_CHAVE_RELACAO,1,4000), substr(NEW.IE_PESSOA_CHAVE_RELACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PESSOA_CHAVE_RELACAO', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PESSOA_CHAVE_SAUDE,1,4000), substr(NEW.IE_PESSOA_CHAVE_SAUDE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PESSOA_CHAVE_SAUDE', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REL_OUTROS_PESSOA,1,4000), substr(NEW.DS_REL_OUTROS_PESSOA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REL_OUTROS_PESSOA', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REL_OUTROS_NOME,1,4000), substr(NEW.DS_REL_OUTROS_NOME,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REL_OUTROS_NOME', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REL_OUTROS_IDADE,1,4000), substr(NEW.DS_REL_OUTROS_IDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REL_OUTROS_IDADE', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TRABALHANDO_ATUAL,1,4000), substr(NEW.IE_TRABALHANDO_ATUAL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TRABALHANDO_ATUAL', ie_log_w, ds_w, 'ENFERM_PERFIL_RELAC_FUNCAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_enferm_perfil_relac_funcao_tp() FROM PUBLIC;

CREATE TRIGGER enferm_perfil_relac_funcao_tp
	AFTER UPDATE ON enferm_perfil_relac_funcao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_enferm_perfil_relac_funcao_tp();
