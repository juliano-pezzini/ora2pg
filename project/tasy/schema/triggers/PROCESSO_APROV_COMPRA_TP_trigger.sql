-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS processo_aprov_compra_tp ON processo_aprov_compra CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_processo_aprov_compra_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null;  ds_c_w:= 'NR_SEQUENCIA='||to_char(OLD.NR_SEQUENCIA)||'#@#@NR_SEQ_PROC_APROV='||to_char(OLD.NR_SEQ_PROC_APROV);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCESSO_APROV,1,4000), substr(NEW.CD_PROCESSO_APROV,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCESSO_APROV', ie_log_w, ds_w, 'PROCESSO_APROV_COMPRA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_MINIMO_APROVADOR,1,4000), substr(NEW.QT_MINIMO_APROVADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_MINIMO_APROVADOR', ie_log_w, ds_w, 'PROCESSO_APROV_COMPRA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_REGRA,1,4000), substr(NEW.NM_USUARIO_REGRA,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_REGRA', ie_log_w, ds_w, 'PROCESSO_APROV_COMPRA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_MINIMO,1,4000), substr(NEW.VL_MINIMO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_MINIMO', ie_log_w, ds_w, 'PROCESSO_APROV_COMPRA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_RESPONSAVEL,1,4000), substr(NEW.IE_RESPONSAVEL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_RESPONSAVEL', ie_log_w, ds_w, 'PROCESSO_APROV_COMPRA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_MAXIMO,1,4000), substr(NEW.VL_MAXIMO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_MAXIMO', ie_log_w, ds_w, 'PROCESSO_APROV_COMPRA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_processo_aprov_compra_tp() FROM PUBLIC;

CREATE TRIGGER processo_aprov_compra_tp
	AFTER UPDATE ON processo_aprov_compra FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_processo_aprov_compra_tp();

