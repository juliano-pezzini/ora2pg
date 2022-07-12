-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_lanc_aut_pac_tp ON regra_lanc_aut_pac CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_lanc_aut_pac_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null;  ds_c_w:= 'NR_SEQ_REGRA='||to_char(OLD.NR_SEQ_REGRA)||'#@#@NR_SEQ_LANC='||to_char(OLD.NR_SEQ_LANC);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONSISTE_ITEM,1,4000), substr(NEW.IE_CONSISTE_ITEM,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONSISTE_ITEM', ie_log_w, ds_w, 'REGRA_LANC_AUT_PAC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PROC_INTERNO,1,4000), substr(NEW.NR_SEQ_PROC_INTERNO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PROC_INTERNO', ie_log_w, ds_w, 'REGRA_LANC_AUT_PAC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDIMENTO,1,4000), substr(NEW.CD_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDIMENTO', ie_log_w, ds_w, 'REGRA_LANC_AUT_PAC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_EXAME,1,4000), substr(NEW.NR_SEQ_EXAME,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_EXAME', ie_log_w, ds_w, 'REGRA_LANC_AUT_PAC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MEDICO_ATENDIMENTO,1,4000), substr(NEW.IE_MEDICO_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_MEDICO_ATENDIMENTO', ie_log_w, ds_w, 'REGRA_LANC_AUT_PAC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_LANC,1,4000), substr(NEW.NR_SEQ_LANC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_LANC', ie_log_w, ds_w, 'REGRA_LANC_AUT_PAC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_LANCAMENTO,1,4000), substr(NEW.QT_LANCAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_LANCAMENTO', ie_log_w, ds_w, 'REGRA_LANC_AUT_PAC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL,1,4000), substr(NEW.CD_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL', ie_log_w, ds_w, 'REGRA_LANC_AUT_PAC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_lanc_aut_pac_tp() FROM PUBLIC;

CREATE TRIGGER regra_lanc_aut_pac_tp
	AFTER UPDATE ON regra_lanc_aut_pac FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_lanc_aut_pac_tp();
