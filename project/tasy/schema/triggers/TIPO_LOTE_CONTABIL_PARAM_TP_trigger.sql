-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tipo_lote_contabil_param_tp ON tipo_lote_contabil_param CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tipo_lote_contabil_param_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null;  ds_c_w:= 'CD_TIPO_LOTE_CONTABIL='||to_char(OLD.CD_TIPO_LOTE_CONTABIL)||'#@#@NR_SEQ_PARAMETRO='||to_char(OLD.NR_SEQ_PARAMETRO);SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO_NREC,1,4000), substr(NEW.DT_ATUALIZACAO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_DIC_OBJ,1,4000), substr(NEW.NR_SEQ_DIC_OBJ,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_DIC_OBJ', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_TIPO_LOTE_CONTABIL,1,4000), substr(NEW.CD_TIPO_LOTE_CONTABIL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_TIPO_LOTE_CONTABIL', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO,1,4000), substr(NEW.NM_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_DOMINIO,1,4000), substr(NEW.CD_DOMINIO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_DOMINIO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PARAMETRO_FIXO,1,4000), substr(NEW.IE_PARAMETRO_FIXO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PARAMETRO_FIXO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PARAMETRO,1,4000), substr(NEW.NR_SEQ_PARAMETRO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PARAMETRO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_PARAMETRO,1,4000), substr(NEW.IE_TIPO_PARAMETRO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_PARAMETRO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_PARAMETRO,1,4000), substr(NEW.DT_PARAMETRO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_PARAMETRO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_PARAMETRO,1,4000), substr(NEW.VL_PARAMETRO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_PARAMETRO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PARAMETRO,1,4000), substr(NEW.DS_PARAMETRO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PARAMETRO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_ATUALIZACAO,1,4000), substr(NEW.DT_ATUALIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_VALOR_PARAMETRO,1,4000), substr(NEW.DS_VALOR_PARAMETRO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_VALOR_PARAMETRO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_EXP_PARAMETRO,1,4000), substr(NEW.CD_EXP_PARAMETRO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_EXP_PARAMETRO', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_NREC,1,4000), substr(NEW.NM_USUARIO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_NREC', ie_log_w, ds_w, 'TIPO_LOTE_CONTABIL_PARAM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tipo_lote_contabil_param_tp() FROM PUBLIC;

CREATE TRIGGER tipo_lote_contabil_param_tp
	AFTER UPDATE ON tipo_lote_contabil_param FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tipo_lote_contabil_param_tp();
