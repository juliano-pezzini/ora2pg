-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS fa_entrega_medicacao_tp ON fa_entrega_medicacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_fa_entrega_medicacao_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_RECEITA_AMB,1,4000), substr(NEW.NR_SEQ_RECEITA_AMB,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_RECEITA_AMB', ie_log_w, ds_w, 'FA_ENTREGA_MEDICACAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_FISICA,1,4000), substr(NEW.CD_PESSOA_FISICA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_FISICA', ie_log_w, ds_w, 'FA_ENTREGA_MEDICACAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_PERIODO_INICIAL,1,4000), substr(NEW.DT_PERIODO_INICIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_PERIODO_INICIAL', ie_log_w, ds_w, 'FA_ENTREGA_MEDICACAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_PREVISTA_RETORNO,1,4000), substr(NEW.DT_PREVISTA_RETORNO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_PREVISTA_RETORNO', ie_log_w, ds_w, 'FA_ENTREGA_MEDICACAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PACIENTE_ENTREGA,1,4000), substr(NEW.NR_SEQ_PACIENTE_ENTREGA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PACIENTE_ENTREGA', ie_log_w, ds_w, 'FA_ENTREGA_MEDICACAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_MEDICACAO,1,4000), substr(NEW.IE_STATUS_MEDICACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_MEDICACAO', ie_log_w, ds_w, 'FA_ENTREGA_MEDICACAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_PERIODO_FINAL,1,4000), substr(NEW.DT_PERIODO_FINAL,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_PERIODO_FINAL', ie_log_w, ds_w, 'FA_ENTREGA_MEDICACAO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_fa_entrega_medicacao_tp() FROM PUBLIC;

CREATE TRIGGER fa_entrega_medicacao_tp
	AFTER UPDATE ON fa_entrega_medicacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_fa_entrega_medicacao_tp();

