-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_ocorrencia_exige_valor_tp ON pls_ocorrencia_exige_valor CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_ocorrencia_exige_valor_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.DS_REGRA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REGRA,1,4000), substr(NEW.DS_REGRA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REGRA', ie_log_w, ds_w, 'PLS_OCORRENCIA_EXIGE_VALOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_OCORRENCIA,1,4000), substr(NEW.NR_SEQ_OCORRENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_OCORRENCIA', ie_log_w, ds_w, 'PLS_OCORRENCIA_EXIGE_VALOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESTABELECIMENTO,1,4000), substr(NEW.CD_ESTABELECIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESTABELECIMENTO', ie_log_w, ds_w, 'PLS_OCORRENCIA_EXIGE_VALOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_MATERIAL,1,4000), substr(NEW.NR_SEQ_GRUPO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_MATERIAL', ie_log_w, ds_w, 'PLS_OCORRENCIA_EXIGE_VALOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_DESPESA_MAT,1,4000), substr(NEW.IE_TIPO_DESPESA_MAT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_DESPESA_MAT', ie_log_w, ds_w, 'PLS_OCORRENCIA_EXIGE_VALOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'PLS_OCORRENCIA_EXIGE_VALOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_SERVICO,1,4000), substr(NEW.NR_SEQ_GRUPO_SERVICO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_SERVICO', ie_log_w, ds_w, 'PLS_OCORRENCIA_EXIGE_VALOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_ocorrencia_exige_valor_tp() FROM PUBLIC;

CREATE TRIGGER pls_ocorrencia_exige_valor_tp
	AFTER UPDATE ON pls_ocorrencia_exige_valor FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_ocorrencia_exige_valor_tp();
