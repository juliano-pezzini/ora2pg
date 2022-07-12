-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS fa_paciente_entrega_tp ON fa_paciente_entrega CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_fa_paciente_entrega_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ENTREGA,1,4000), substr(NEW.DT_ENTREGA,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ENTREGA', ie_log_w, ds_w, 'FA_PACIENTE_ENTREGA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PACIENTE_PMC,1,4000), substr(NEW.NR_SEQ_PACIENTE_PMC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PACIENTE_PMC', ie_log_w, ds_w, 'FA_PACIENTE_ENTREGA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ATENDIMENTO,1,4000), substr(NEW.NR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ATENDIMENTO', ie_log_w, ds_w, 'FA_PACIENTE_ENTREGA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ENTRADA,1,4000), substr(NEW.DT_ENTRADA,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ENTRADA', ie_log_w, ds_w, 'FA_PACIENTE_ENTREGA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SENHA,1,4000), substr(NEW.DS_SENHA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SENHA', ie_log_w, ds_w, 'FA_PACIENTE_ENTREGA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_FISICA,1,4000), substr(NEW.CD_PESSOA_FISICA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_FISICA', ie_log_w, ds_w, 'FA_PACIENTE_ENTREGA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_PACIENTE,1,4000), substr(NEW.IE_STATUS_PACIENTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_PACIENTE', ie_log_w, ds_w, 'FA_PACIENTE_ENTREGA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_fa_paciente_entrega_tp() FROM PUBLIC;

CREATE TRIGGER fa_paciente_entrega_tp
	AFTER UPDATE ON fa_paciente_entrega FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_fa_paciente_entrega_tp();
