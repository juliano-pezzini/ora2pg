-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_preco_ordem_tp ON pls_regra_preco_ordem CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_preco_ordem_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQUENCIA,1,4000), substr(NEW.NR_SEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQUENCIA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_ORDEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_PRECO,1,4000), substr(NEW.IE_TIPO_PRECO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_PRECO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_ORDEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ORDEM_CLASSIFICACAO,1,4000), substr(NEW.IE_ORDEM_CLASSIFICACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ORDEM_CLASSIFICACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_ORDEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_ATRIBUTO,1,4000), substr(NEW.NM_ATRIBUTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_ATRIBUTO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_ORDEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_APRESENTACAO,1,4000), substr(NEW.NR_SEQ_APRESENTACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_APRESENTACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_ORDEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_preco_ordem_tp() FROM PUBLIC;

CREATE TRIGGER pls_regra_preco_ordem_tp
	AFTER UPDATE ON pls_regra_preco_ordem FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_preco_ordem_tp();

