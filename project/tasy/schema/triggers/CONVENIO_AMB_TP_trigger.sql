-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS convenio_amb_tp ON convenio_amb CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_convenio_amb_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null;  ds_c_w:= 'CD_ESTABELECIMENTO='||to_char(OLD.CD_ESTABELECIMENTO)||'#@#@CD_CONVENIO='||to_char(OLD.CD_CONVENIO)||'#@#@CD_CATEGORIA='||to_char(OLD.CD_CATEGORIA)||'#@#@DT_INICIO_VIGENCIA='||to_char(OLD.DT_INICIO_VIGENCIA)||'#@#@IE_PRIORIDADE='||to_char(OLD.IE_PRIORIDADE);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TISS_TABELA,1,4000), substr(NEW.NR_SEQ_TISS_TABELA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TISS_TABELA', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_FINAL_VIGENCIA,1,4000), substr(NEW.DT_FINAL_VIGENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_FINAL_VIGENCIA', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PRIORIDADE,1,4000), substr(NEW.IE_PRIORIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PRIORIDADE', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_EDICAO_AMB,1,4000), substr(NEW.CD_EDICAO_AMB,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_EDICAO_AMB', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CONVENIO,1,4000), substr(NEW.CD_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CONVENIO', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_CH_CUSTO_OPER,1,4000), substr(NEW.VL_CH_CUSTO_OPER,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_CH_CUSTO_OPER', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CBHPM_EDICAO,1,4000), substr(NEW.NR_SEQ_CBHPM_EDICAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CBHPM_EDICAO', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_FILME,1,4000), substr(NEW.VL_FILME,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_FILME', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_CH_HONORARIOS,1,4000), substr(NEW.VL_CH_HONORARIOS,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_CH_HONORARIOS', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CATEGORIA,1,4000), substr(NEW.CD_CATEGORIA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CATEGORIA', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_INICIO_VIGENCIA,1,4000), substr(NEW.DT_INICIO_VIGENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_INICIO_VIGENCIA', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.TX_AJUSTE_GERAL,1,4000), substr(NEW.TX_AJUSTE_GERAL,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_AJUSTE_GERAL', ie_log_w, ds_w, 'CONVENIO_AMB', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_convenio_amb_tp() FROM PUBLIC;

CREATE TRIGGER convenio_amb_tp
	AFTER UPDATE ON convenio_amb FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_convenio_amb_tp();

