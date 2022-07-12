-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_creden_prestador_tp ON pls_creden_prestador CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_creden_prestador_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_WSUITE_USUARIO,1,4000), substr(NEW.NR_SEQ_WSUITE_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_WSUITE_USUARIO', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CGC,1,4000), substr(NEW.CD_CGC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CGC', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PAIS,1,4000), substr(NEW.NR_SEQ_PAIS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PAIS', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_TELEFONE,1,4000), substr(NEW.NR_TELEFONE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_TELEFONE', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_EMAIL,1,4000), substr(NEW.DS_EMAIL,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_EMAIL', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_INSCRICAO_ESTADUAL,1,4000), substr(NEW.NR_INSCRICAO_ESTADUAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_INSCRICAO_ESTADUAL', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_INSCRICAO_MUNICIPAL,1,4000), substr(NEW.NR_INSCRICAO_MUNICIPAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_INSCRICAO_MUNICIPAL', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SITE_INTERNET,1,4000), substr(NEW.DS_SITE_INTERNET,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SITE_INTERNET', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CNPJ,1,4000), substr(NEW.NR_CNPJ,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CNPJ', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CNES,1,4000), substr(NEW.CD_CNES,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CNES', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_RAZAO_SOCIAL,1,4000), substr(NEW.DS_RAZAO_SOCIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_RAZAO_SOCIAL', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_FANTASIA,1,4000), substr(NEW.NM_FANTASIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_FANTASIA', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_SECRETARIA,1,4000), substr(NEW.IE_TIPO_SECRETARIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_SECRETARIA', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CEP,1,4000), substr(NEW.CD_CEP,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CEP', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_LOGRADOURO,1,4000), substr(NEW.NR_SEQ_TIPO_LOGRADOURO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_LOGRADOURO', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ENDERECO,1,4000), substr(NEW.DS_ENDERECO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ENDERECO', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ENDERECO,1,4000), substr(NEW.NR_ENDERECO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ENDERECO', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_COMPLEMENTO,1,4000), substr(NEW.DS_COMPLEMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_COMPLEMENTO', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_BAIRRO,1,4000), substr(NEW.DS_BAIRRO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_BAIRRO', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MUNICIPIO_IBGE,1,4000), substr(NEW.CD_MUNICIPIO_IBGE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MUNICIPIO_IBGE', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MUNICIPIO,1,4000), substr(NEW.DS_MUNICIPIO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MUNICIPIO', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.SG_ESTADO,1,4000), substr(NEW.SG_ESTADO,1,4000), NEW.nm_usuario, nr_seq_w, 'SG_ESTADO', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS,1,4000), substr(NEW.IE_STATUS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CREDENCIADO,1,4000), substr(NEW.IE_CREDENCIADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CREDENCIADO', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_SOLICITANTE,1,4000), substr(NEW.IE_TIPO_SOLICITANTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_SOLICITANTE', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PRESTADOR,1,4000), substr(NEW.NR_SEQ_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PRESTADOR', ie_log_w, ds_w, 'PLS_CREDEN_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_creden_prestador_tp() FROM PUBLIC;

CREATE TRIGGER pls_creden_prestador_tp
	AFTER UPDATE ON pls_creden_prestador FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_creden_prestador_tp();

