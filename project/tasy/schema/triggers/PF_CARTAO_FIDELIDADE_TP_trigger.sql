-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pf_cartao_fidelidade_tp ON pf_cartao_fidelidade CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pf_cartao_fidelidade_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CARTAO_FIDELIDADE,1,4000), substr(NEW.NR_CARTAO_FIDELIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CARTAO_FIDELIDADE', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_EMISSAO_CARTAO,1,4000), substr(NEW.DT_EMISSAO_CARTAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_EMISSAO_CARTAO', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_TITULAR,1,4000), substr(NEW.CD_PESSOA_TITULAR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_TITULAR', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_PONTUACAO_CM,1,4000), substr(NEW.QT_PONTUACAO_CM,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_PONTUACAO_CM', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_FIM_VALIDADE,1,4000), substr(NEW.DT_FIM_VALIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_FIM_VALIDADE', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_FISICA,1,4000), substr(NEW.CD_PESSOA_FISICA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_FISICA', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CARTAO,1,4000), substr(NEW.NR_SEQ_CARTAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CARTAO', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_INICIO_VALIDADE,1,4000), substr(NEW.DT_INICIO_VALIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_INICIO_VALIDADE', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_VENDEDOR,1,4000), substr(NEW.CD_PESSOA_VENDEDOR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_VENDEDOR', ie_log_w, ds_w, 'PF_CARTAO_FIDELIDADE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pf_cartao_fidelidade_tp() FROM PUBLIC;

CREATE TRIGGER pf_cartao_fidelidade_tp
	AFTER UPDATE ON pf_cartao_fidelidade FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pf_cartao_fidelidade_tp();

