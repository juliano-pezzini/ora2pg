-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conversao_mat_tp ON pls_conversao_mat CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conversao_mat_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.NR_SEQ_TIPO_PRESTADOR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_PRESTADOR,1,4000), substr(NEW.NR_SEQ_TIPO_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_PRESTADOR', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_XML,1,4000), substr(NEW.IE_XML,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_XML', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_DESPESA_MAT,1,4000), substr(NEW.IE_TIPO_DESPESA_MAT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_DESPESA_MAT', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL_ORIG_INICIAL,1,4000), substr(NEW.CD_MATERIAL_ORIG_INICIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL_ORIG_INICIAL', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL_ORIG_FINAL,1,4000), substr(NEW.CD_MATERIAL_ORIG_FINAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL_ORIG_FINAL', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ENVIO_RECEB,1,4000), substr(NEW.IE_ENVIO_RECEB,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ENVIO_RECEB', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_MATERIAL,1,4000), substr(NEW.NR_SEQ_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_MATERIAL', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PRESTADOR,1,4000), substr(NEW.NR_SEQ_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PRESTADOR', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_OPS_CONGENERE,1,4000), substr(NEW.NR_SEQ_OPS_CONGENERE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_OPS_CONGENERE', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CONTRATO,1,4000), substr(NEW.NR_SEQ_CONTRATO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CONTRATO', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL_ENVIO,1,4000), substr(NEW.CD_MATERIAL_ENVIO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL_ENVIO', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MATERIAL_ENVIO,1,4000), substr(NEW.DS_MATERIAL_ENVIO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MATERIAL_ENVIO', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_TABELA,1,4000), substr(NEW.IE_TIPO_TABELA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_TABELA', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_MATERIAL_ORIG,1,4000), substr(NEW.NR_SEQ_MATERIAL_ORIG,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_MATERIAL_ORIG', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_REGRA_MAT,1,4000), substr(NEW.IE_TIPO_REGRA_MAT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_REGRA_MAT', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_PRESTADOR,1,4000), substr(NEW.NR_SEQ_GRUPO_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_PRESTADOR', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_REGRA,1,4000), substr(NEW.NM_REGRA,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_REGRA', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ORDEM_EXEC_REGRA,1,4000), substr(NEW.NR_ORDEM_EXEC_REGRA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ORDEM_EXEC_REGRA', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_COMPLEMENTO,1,4000), substr(NEW.IE_COMPLEMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_COMPLEMENTO', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DIGITACAO_PORTAL,1,4000), substr(NEW.IE_DIGITACAO_PORTAL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DIGITACAO_PORTAL', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_INICIO_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_INICIO_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_INICIO_VIGENCIA', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_FIM_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_FIM_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_FIM_VIGENCIA', ie_log_w, ds_w, 'PLS_CONVERSAO_MAT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conversao_mat_tp() FROM PUBLIC;

CREATE TRIGGER pls_conversao_mat_tp
	AFTER UPDATE ON pls_conversao_mat FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conversao_mat_tp();
