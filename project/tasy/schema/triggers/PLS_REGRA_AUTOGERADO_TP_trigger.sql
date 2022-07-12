-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_autogerado_tp ON pls_regra_autogerado CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_autogerado_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_AREA_PROCEDIMENTO,1,4000), substr(NEW.CD_AREA_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_AREA_PROCEDIMENTO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VINC_INTERNACAO,1,4000), substr(NEW.IE_VINC_INTERNACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_VINC_INTERNACAO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GRUPO_PROC,1,4000), substr(NEW.CD_GRUPO_PROC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GRUPO_PROC', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDIMENTO,1,4000), substr(NEW.CD_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDIMENTO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PRESTADOR,1,4000), substr(NEW.NR_SEQ_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PRESTADOR', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_ACOMODACAO,1,4000), substr(NEW.NR_SEQ_TIPO_ACOMODACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_ACOMODACAO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_SEGURADO,1,4000), substr(NEW.IE_TIPO_SEGURADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_SEGURADO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_ATENDIMENTO,1,4000), substr(NEW.NR_SEQ_TIPO_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_ATENDIMENTO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CLASSIFICACAO,1,4000), substr(NEW.NR_SEQ_CLASSIFICACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CLASSIFICACAO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PLANO,1,4000), substr(NEW.NR_SEQ_PLANO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PLANO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_GUIA,1,4000), substr(NEW.IE_TIPO_GUIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_GUIA', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_PREST_EXEC,1,4000), substr(NEW.NR_SEQ_GRUPO_PREST_EXEC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_PREST_EXEC', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_PREST_SOLIC,1,4000), substr(NEW.NR_SEQ_GRUPO_PREST_SOLIC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_PREST_SOLIC', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_MED_EXEC,1,4000), substr(NEW.NR_SEQ_GRUPO_MED_EXEC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_MED_EXEC', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_MED_SOLIC,1,4000), substr(NEW.NR_SEQ_GRUPO_MED_SOLIC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_MED_SOLIC', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ORIGEM_MEDICO_SOLIC,1,4000), substr(NEW.IE_ORIGEM_MEDICO_SOLIC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ORIGEM_MEDICO_SOLIC', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PRIMEIRA_CONDICAO,1,4000), substr(NEW.IE_PRIMEIRA_CONDICAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PRIMEIRA_CONDICAO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SEGUNDA_CONDICAO,1,4000), substr(NEW.IE_SEGUNDA_CONDICAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SEGUNDA_CONDICAO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PRESTADOR,1,4000), substr(NEW.CD_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PRESTADOR', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_REC,1,4000), substr(NEW.NR_SEQ_GRUPO_REC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_REC', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_SERVICO,1,4000), substr(NEW.NR_SEQ_GRUPO_SERVICO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_SERVICO', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_PRESTADOR,1,4000), substr(NEW.NR_SEQ_TIPO_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_PRESTADOR', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_PREST_SOLIC,1,4000), substr(NEW.NR_SEQ_TIPO_PREST_SOLIC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_PREST_SOLIC', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_PREST_PROT,1,4000), substr(NEW.NR_SEQ_TIPO_PREST_PROT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_PREST_PROT', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CLASSIF_SOLIC,1,4000), substr(NEW.NR_SEQ_CLASSIF_SOLIC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CLASSIF_SOLIC', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CLASSIF_PROT,1,4000), substr(NEW.NR_SEQ_CLASSIF_PROT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CLASSIF_PROT', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONSIDERAR_PREST_SOLIC_REQ,1,4000), substr(NEW.IE_CONSIDERAR_PREST_SOLIC_REQ,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONSIDERAR_PREST_SOLIC_REQ', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESPECIALIDADE,1,4000), substr(NEW.CD_ESPECIALIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESPECIALIDADE', ie_log_w, ds_w, 'PLS_REGRA_AUTOGERADO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_autogerado_tp() FROM PUBLIC;

CREATE TRIGGER pls_regra_autogerado_tp
	AFTER UPDATE ON pls_regra_autogerado FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_autogerado_tp();

