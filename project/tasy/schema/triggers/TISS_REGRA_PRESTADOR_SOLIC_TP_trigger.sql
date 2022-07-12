-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tiss_regra_prestador_solic_tp ON tiss_regra_prestador_solic CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tiss_regra_prestador_solic_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.IE_TIPO_ATENDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ATENDIMENTO,1,4000), substr(NEW.IE_TIPO_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ATENDIMENTO', ie_log_w, ds_w, 'TISS_REGRA_PRESTADOR_SOLIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CLINICA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CLINICA,1,4000), substr(NEW.IE_CLINICA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CLINICA', ie_log_w, ds_w, 'TISS_REGRA_PRESTADOR_SOLIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_SETOR_ENTRADA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SETOR_ENTRADA,1,4000), substr(NEW.CD_SETOR_ENTRADA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SETOR_ENTRADA', ie_log_w, ds_w, 'TISS_REGRA_PRESTADOR_SOLIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_SOLICITANTE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SOLICITANTE,1,4000), substr(NEW.IE_SOLICITANTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SOLICITANTE', ie_log_w, ds_w, 'TISS_REGRA_PRESTADOR_SOLIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MEDICO_PREST,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO_PREST,1,4000), substr(NEW.CD_MEDICO_PREST,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO_PREST', ie_log_w, ds_w, 'TISS_REGRA_PRESTADOR_SOLIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_AUTORIZACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_AUTORIZACAO,1,4000), substr(NEW.IE_AUTORIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_AUTORIZACAO', ie_log_w, ds_w, 'TISS_REGRA_PRESTADOR_SOLIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_PROCEDENCIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDENCIA,1,4000), substr(NEW.CD_PROCEDENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDENCIA', ie_log_w, ds_w, 'TISS_REGRA_PRESTADOR_SOLIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MEDICO_ATENDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO_ATENDIMENTO,1,4000), substr(NEW.CD_MEDICO_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO_ATENDIMENTO', ie_log_w, ds_w, 'TISS_REGRA_PRESTADOR_SOLIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_CGC_PRESTADOR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CGC_PRESTADOR,1,4000), substr(NEW.CD_CGC_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CGC_PRESTADOR', ie_log_w, ds_w, 'TISS_REGRA_PRESTADOR_SOLIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tiss_regra_prestador_solic_tp() FROM PUBLIC;

CREATE TRIGGER tiss_regra_prestador_solic_tp
	AFTER UPDATE ON tiss_regra_prestador_solic FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tiss_regra_prestador_solic_tp();

