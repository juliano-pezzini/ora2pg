-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nota_fiscal_lote_nfe_tp ON nota_fiscal_lote_nfe CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nota_fiscal_lote_nfe_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ENVIO,1,4000), substr(NEW.DT_ENVIO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ENVIO', ie_log_w, ds_w, 'NOTA_FISCAL_LOTE_NFE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_PROTOCOLO,1,4000), substr(NEW.NR_PROTOCOLO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_PROTOCOLO', ie_log_w, ds_w, 'NOTA_FISCAL_LOTE_NFE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MENSAGEM_RETORNO,1,4000), substr(NEW.DS_MENSAGEM_RETORNO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MENSAGEM_RETORNO', ie_log_w, ds_w, 'NOTA_FISCAL_LOTE_NFE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_GERACAO,1,4000), substr(NEW.DT_GERACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_GERACAO', ie_log_w, ds_w, 'NOTA_FISCAL_LOTE_NFE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nota_fiscal_lote_nfe_tp() FROM PUBLIC;

CREATE TRIGGER nota_fiscal_lote_nfe_tp
	AFTER UPDATE ON nota_fiscal_lote_nfe FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nota_fiscal_lote_nfe_tp();

