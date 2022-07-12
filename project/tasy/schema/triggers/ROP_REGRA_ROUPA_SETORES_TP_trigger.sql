-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS rop_regra_roupa_setores_tp ON rop_regra_roupa_setores CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_rop_regra_roupa_setores_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_REGRA,1,4000), substr(NEW.NR_SEQ_REGRA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_REGRA', ie_log_w, ds_w, 'ROP_REGRA_ROUPA_SETORES', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_MAXIMO,1,4000), substr(NEW.QT_MAXIMO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_MAXIMO', ie_log_w, ds_w, 'ROP_REGRA_ROUPA_SETORES', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_MINIMO,1,4000), substr(NEW.QT_MINIMO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_MINIMO', ie_log_w, ds_w, 'ROP_REGRA_ROUPA_SETORES', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SETOR_ATENDIMENTO,1,4000), substr(NEW.CD_SETOR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SETOR_ATENDIMENTO', ie_log_w, ds_w, 'ROP_REGRA_ROUPA_SETORES', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_rop_regra_roupa_setores_tp() FROM PUBLIC;

CREATE TRIGGER rop_regra_roupa_setores_tp
	AFTER UPDATE ON rop_regra_roupa_setores FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_rop_regra_roupa_setores_tp();
