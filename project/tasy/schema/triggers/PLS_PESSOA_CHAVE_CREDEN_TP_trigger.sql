-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_pessoa_chave_creden_tp ON pls_pessoa_chave_creden CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_pessoa_chave_creden_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_VINCULO,1,4000), substr(NEW.NR_SEQ_TIPO_VINCULO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_VINCULO', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_FORMULARIO,1,4000), substr(NEW.NR_SEQ_FORMULARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_FORMULARIO', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_TELEFONE,1,4000), substr(NEW.NR_TELEFONE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_TELEFONE', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CARGO,1,4000), substr(NEW.CD_CARGO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CARGO', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CARGO,1,4000), substr(NEW.DS_CARGO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CARGO', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_EMAIL,1,4000), substr(NEW.DS_EMAIL,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_EMAIL', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_DDD_TELEFONE,1,4000), substr(NEW.NR_DDD_TELEFONE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_DDD_TELEFONE', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_NASCIMENTO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_NASCIMENTO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_NASCIMENTO', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CPF,1,4000), substr(NEW.NR_CPF,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CPF', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_IDENTIDADE,1,4000), substr(NEW.NR_IDENTIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_IDENTIDADE', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_DDD_CELULAR,1,4000), substr(NEW.NR_DDD_CELULAR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_DDD_CELULAR', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_TELEFONE_CELULAR,1,4000), substr(NEW.NR_TELEFONE_CELULAR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_TELEFONE_CELULAR', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_PESSOA,1,4000), substr(NEW.NM_PESSOA,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_PESSOA', ie_log_w, ds_w, 'PLS_PESSOA_CHAVE_CREDEN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_pessoa_chave_creden_tp() FROM PUBLIC;

CREATE TRIGGER pls_pessoa_chave_creden_tp
	AFTER UPDATE ON pls_pessoa_chave_creden FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_pessoa_chave_creden_tp();

