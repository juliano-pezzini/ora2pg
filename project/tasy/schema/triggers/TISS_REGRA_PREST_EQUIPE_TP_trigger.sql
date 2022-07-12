-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tiss_regra_prest_equipe_tp ON tiss_regra_prest_equipe CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tiss_regra_prest_equipe_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.IE_TISS_TIPO_GUIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TISS_TIPO_GUIA,1,4000), substr(NEW.IE_TISS_TIPO_GUIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TISS_TIPO_GUIA', ie_log_w, ds_w, 'TISS_REGRA_PREST_EQUIPE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_CGC_PRESTADOR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CGC_PRESTADOR,1,4000), substr(NEW.CD_CGC_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CGC_PRESTADOR', ie_log_w, ds_w, 'TISS_REGRA_PREST_EQUIPE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_SETOR_ATENDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SETOR_ATENDIMENTO,1,4000), substr(NEW.CD_SETOR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SETOR_ATENDIMENTO', ie_log_w, ds_w, 'TISS_REGRA_PREST_EQUIPE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_RESPONSAVEL_CREDITO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_RESPONSAVEL_CREDITO,1,4000), substr(NEW.IE_RESPONSAVEL_CREDITO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_RESPONSAVEL_CREDITO', ie_log_w, ds_w, 'TISS_REGRA_PREST_EQUIPE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_CONSELHO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CONSELHO,1,4000), substr(NEW.NR_CONSELHO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CONSELHO', ie_log_w, ds_w, 'TISS_REGRA_PREST_EQUIPE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.UF_CONSELHO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.UF_CONSELHO,1,4000), substr(NEW.UF_CONSELHO,1,4000), NEW.nm_usuario, nr_seq_w, 'UF_CONSELHO', ie_log_w, ds_w, 'TISS_REGRA_PREST_EQUIPE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_GRAU_PARTIC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GRAU_PARTIC,1,4000), substr(NEW.IE_GRAU_PARTIC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GRAU_PARTIC', ie_log_w, ds_w, 'TISS_REGRA_PREST_EQUIPE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.SG_CONSELHO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.SG_CONSELHO,1,4000), substr(NEW.SG_CONSELHO,1,4000), NEW.nm_usuario, nr_seq_w, 'SG_CONSELHO', ie_log_w, ds_w, 'TISS_REGRA_PREST_EQUIPE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tiss_regra_prest_equipe_tp() FROM PUBLIC;

CREATE TRIGGER tiss_regra_prest_equipe_tp
	AFTER UPDATE ON tiss_regra_prest_equipe FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tiss_regra_prest_equipe_tp();
