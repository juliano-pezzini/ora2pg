-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_loc_tp_baixa_prescr_tp ON regra_loc_tp_baixa_prescr CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_loc_tp_baixa_prescr_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL,1,4000), substr(NEW.CD_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GRUPO_MATERIAL,1,4000), substr(NEW.CD_GRUPO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GRUPO_MATERIAL', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SUBGRUPO_MATERIAL,1,4000), substr(NEW.CD_SUBGRUPO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SUBGRUPO_MATERIAL', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CLASSE_MATERIAL,1,4000), substr(NEW.CD_CLASSE_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CLASSE_MATERIAL', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PERFIL,1,4000), substr(NEW.CD_PERFIL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PERFIL', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_FAMILIA,1,4000), substr(NEW.NR_SEQ_FAMILIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_FAMILIA', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_LOCAL_ESTOQUE,1,4000), substr(NEW.CD_LOCAL_ESTOQUE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_LOCAL_ESTOQUE', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_BAIXA,1,4000), substr(NEW.NR_SEQ_TIPO_BAIXA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_BAIXA', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_LOCAL_BARRAS,1,4000), substr(NEW.IE_LOCAL_BARRAS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_LOCAL_BARRAS', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SETOR_ATENDIMENTO,1,4000), substr(NEW.CD_SETOR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SETOR_ATENDIMENTO', ie_log_w, ds_w, 'REGRA_LOC_TP_BAIXA_PRESCR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_loc_tp_baixa_prescr_tp() FROM PUBLIC;

CREATE TRIGGER regra_loc_tp_baixa_prescr_tp
	AFTER UPDATE ON regra_loc_tp_baixa_prescr FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_loc_tp_baixa_prescr_tp();
