-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ordem_compra_adiant_pago_tp ON ordem_compra_adiant_pago CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ordem_compra_adiant_pago_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO_NREC,1,4000), substr(NEW.DT_ATUALIZACAO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'ORDEM_COMPRA_ADIANT_PAGO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_NREC,1,4000), substr(NEW.NM_USUARIO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_NREC', ie_log_w, ds_w, 'ORDEM_COMPRA_ADIANT_PAGO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO,1,4000), substr(NEW.DT_ATUALIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'ORDEM_COMPRA_ADIANT_PAGO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_VINCULADO,1,4000), substr(NEW.VL_VINCULADO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_VINCULADO', ie_log_w, ds_w, 'ORDEM_COMPRA_ADIANT_PAGO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQUENCIA,1,4000), substr(NEW.NR_SEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQUENCIA', ie_log_w, ds_w, 'ORDEM_COMPRA_ADIANT_PAGO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ORDEM_COMPRA,1,4000), substr(NEW.NR_ORDEM_COMPRA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ORDEM_COMPRA', ie_log_w, ds_w, 'ORDEM_COMPRA_ADIANT_PAGO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ADIANTAMENTO,1,4000), substr(NEW.NR_ADIANTAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ADIANTAMENTO', ie_log_w, ds_w, 'ORDEM_COMPRA_ADIANT_PAGO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO,1,4000), substr(NEW.NM_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO', ie_log_w, ds_w, 'ORDEM_COMPRA_ADIANT_PAGO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ordem_compra_adiant_pago_tp() FROM PUBLIC;

CREATE TRIGGER ordem_compra_adiant_pago_tp
	AFTER UPDATE ON ordem_compra_adiant_pago FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ordem_compra_adiant_pago_tp();

