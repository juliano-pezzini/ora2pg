-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_pos_estabelecido_tp ON pls_regra_pos_estabelecido CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_pos_estabelecido_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.TX_ADMINISTRACAO,1,4000), substr(NEW.TX_ADMINISTRACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_ADMINISTRACAO', ie_log_w, ds_w, 'PLS_REGRA_POS_ESTABELECIDO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_INFORMADO,1,4000), substr(NEW.VL_INFORMADO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_INFORMADO', ie_log_w, ds_w, 'PLS_REGRA_POS_ESTABELECIDO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_VIGENCIA_INICIO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_VIGENCIA_INICIO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_VIGENCIA_INICIO', ie_log_w, ds_w, 'PLS_REGRA_POS_ESTABELECIDO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_SERVICO,1,4000), substr(NEW.NR_SEQ_GRUPO_SERVICO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_SERVICO', ie_log_w, ds_w, 'PLS_REGRA_POS_ESTABELECIDO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_COBRANCA,1,4000), substr(NEW.IE_COBRANCA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_COBRANCA', ie_log_w, ds_w, 'PLS_REGRA_POS_ESTABELECIDO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_MATERIAL,1,4000), substr(NEW.NR_SEQ_GRUPO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_MATERIAL', ie_log_w, ds_w, 'PLS_REGRA_POS_ESTABELECIDO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REPASSA_MEDICO,1,4000), substr(NEW.IE_REPASSA_MEDICO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REPASSA_MEDICO', ie_log_w, ds_w, 'PLS_REGRA_POS_ESTABELECIDO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_VIGENCIA_FIM,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_VIGENCIA_FIM,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_VIGENCIA_FIM', ie_log_w, ds_w, 'PLS_REGRA_POS_ESTABELECIDO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_pos_estabelecido_tp() FROM PUBLIC;

CREATE TRIGGER pls_regra_pos_estabelecido_tp
	AFTER UPDATE ON pls_regra_pos_estabelecido FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_pos_estabelecido_tp();

