-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tiss_partic_adic_tp ON tiss_partic_adic CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tiss_partic_adic_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.CD_INTERNO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTERNO,1,4000), substr(NEW.CD_INTERNO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_INTERNO', ie_log_w, ds_w, 'TISS_PARTIC_ADIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_FUNCAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FUNCAO,1,4000), substr(NEW.IE_FUNCAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FUNCAO', ie_log_w, ds_w, 'TISS_PARTIC_ADIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_PARTICIPANTE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_PARTICIPANTE,1,4000), substr(NEW.NM_PARTICIPANTE,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_PARTICIPANTE', ie_log_w, ds_w, 'TISS_PARTIC_ADIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_CBOS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CBOS,1,4000), substr(NEW.CD_CBOS,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CBOS', ie_log_w, ds_w, 'TISS_PARTIC_ADIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_CRM,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CRM,1,4000), substr(NEW.NR_CRM,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CRM', ie_log_w, ds_w, 'TISS_PARTIC_ADIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.UF_CRM,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.UF_CRM,1,4000), substr(NEW.UF_CRM,1,4000), NEW.nm_usuario, nr_seq_w, 'UF_CRM', ie_log_w, ds_w, 'TISS_PARTIC_ADIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_CPF,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CPF,1,4000), substr(NEW.NR_CPF,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CPF', ie_log_w, ds_w, 'TISS_PARTIC_ADIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.SG_CONSELHO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.SG_CONSELHO,1,4000), substr(NEW.SG_CONSELHO,1,4000), NEW.nm_usuario, nr_seq_w, 'SG_CONSELHO', ie_log_w, ds_w, 'TISS_PARTIC_ADIC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tiss_partic_adic_tp() FROM PUBLIC;

CREATE TRIGGER tiss_partic_adic_tp
	AFTER UPDATE ON tiss_partic_adic FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tiss_partic_adic_tp();

