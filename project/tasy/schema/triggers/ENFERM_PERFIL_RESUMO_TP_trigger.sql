-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS enferm_perfil_resumo_tp ON enferm_perfil_resumo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_enferm_perfil_resumo_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PROM_SAUDE_RESUMO,1,4000), substr(NEW.DS_PROM_SAUDE_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PROM_SAUDE_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONFORTO,1,4000), substr(NEW.IE_CONFORTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONFORTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PROM_SAUDE_TEXTO,1,4000), substr(NEW.DS_PROM_SAUDE_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PROM_SAUDE_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_NUTRICAO_RESUMO,1,4000), substr(NEW.DS_NUTRICAO_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_NUTRICAO_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NUTRICAO,1,4000), substr(NEW.IE_NUTRICAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NUTRICAO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_NUTRICAO_TEXTO,1,4000), substr(NEW.DS_NUTRICAO_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_NUTRICAO_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_EXCRECAO_RESUMO,1,4000), substr(NEW.DS_EXCRECAO_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_EXCRECAO_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXCRECAO,1,4000), substr(NEW.IE_EXCRECAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_EXCRECAO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_EXCRECAO_TEXTO,1,4000), substr(NEW.DS_EXCRECAO_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_EXCRECAO_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ATIV_DESC_RESUMO,1,4000), substr(NEW.DS_ATIV_DESC_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ATIV_DESC_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATIV_DESC,1,4000), substr(NEW.IE_ATIV_DESC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATIV_DESC', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ATIV_DESC_TEXTO,1,4000), substr(NEW.DS_ATIV_DESC_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ATIV_DESC_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PERC_COGN_RESUMO,1,4000), substr(NEW.DS_PERC_COGN_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PERC_COGN_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PERC_COGN,1,4000), substr(NEW.IE_PERC_COGN,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PERC_COGN', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PERC_COGN_TEXTO,1,4000), substr(NEW.DS_PERC_COGN_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PERC_COGN_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PERCEPCAO_RESUMO,1,4000), substr(NEW.DS_PERCEPCAO_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PERCEPCAO_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PERCEPCAO,1,4000), substr(NEW.IE_PERCEPCAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PERCEPCAO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PERCEPCAO_TEXTO,1,4000), substr(NEW.DS_PERCEPCAO_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PERCEPCAO_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_RELAC_FUNCAO_RESUMO,1,4000), substr(NEW.DS_RELAC_FUNCAO_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_RELAC_FUNCAO_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_RELAC_FUNCAO,1,4000), substr(NEW.IE_RELAC_FUNCAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_RELAC_FUNCAO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_RELAC_FUNCAO_TEXTO,1,4000), substr(NEW.DS_RELAC_FUNCAO_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_RELAC_FUNCAO_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SEXUALIDADE_RESUMO,1,4000), substr(NEW.DS_SEXUALIDADE_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SEXUALIDADE_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SEXUALIDADE,1,4000), substr(NEW.IE_SEXUALIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SEXUALIDADE', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SEXUALIDADE_TEXTO,1,4000), substr(NEW.DS_SEXUALIDADE_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SEXUALIDADE_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_STRESS_RESUMO,1,4000), substr(NEW.DS_STRESS_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_STRESS_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STRESS,1,4000), substr(NEW.IE_STRESS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STRESS', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_STRESS_TEXTO,1,4000), substr(NEW.DS_STRESS_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_STRESS_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PRINC_VIDA_RESUMO,1,4000), substr(NEW.DS_PRINC_VIDA_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PRINC_VIDA_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PRINC_VIDA,1,4000), substr(NEW.IE_PRINC_VIDA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PRINC_VIDA', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PRINC_VIDA_TEXTO,1,4000), substr(NEW.DS_PRINC_VIDA_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PRINC_VIDA_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SEG_DEF_RESUMO,1,4000), substr(NEW.DS_SEG_DEF_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SEG_DEF_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SEG_DEF,1,4000), substr(NEW.IE_SEG_DEF,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SEG_DEF', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SEG_DEF_TEXTO,1,4000), substr(NEW.DS_SEG_DEF_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SEG_DEF_TEXTO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CONFORTO_RESUMO,1,4000), substr(NEW.DS_CONFORTO_RESUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CONFORTO_RESUMO', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PROM_SAUDE,1,4000), substr(NEW.IE_PROM_SAUDE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PROM_SAUDE', ie_log_w, ds_w, 'ENFERM_PERFIL_RESUMO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_enferm_perfil_resumo_tp() FROM PUBLIC;

CREATE TRIGGER enferm_perfil_resumo_tp
	AFTER UPDATE ON enferm_perfil_resumo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_enferm_perfil_resumo_tp();
