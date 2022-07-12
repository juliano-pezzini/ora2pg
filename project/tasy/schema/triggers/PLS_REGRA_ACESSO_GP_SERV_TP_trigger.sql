-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_acesso_gp_serv_tp ON pls_regra_acesso_gp_serv CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_acesso_gp_serv_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'PLS_REGRA_ACESSO_GP_SERV', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REGRA_PRESTADOR,1,4000), substr(NEW.IE_REGRA_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REGRA_PRESTADOR', ie_log_w, ds_w, 'PLS_REGRA_ACESSO_GP_SERV', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REGRA_REEMBOLSO,1,4000), substr(NEW.IE_REGRA_REEMBOLSO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REGRA_REEMBOLSO', ie_log_w, ds_w, 'PLS_REGRA_ACESSO_GP_SERV', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REGRA_FATURA,1,4000), substr(NEW.IE_REGRA_FATURA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REGRA_FATURA', ie_log_w, ds_w, 'PLS_REGRA_ACESSO_GP_SERV', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REGRA,1,4000), substr(NEW.DS_REGRA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REGRA', ie_log_w, ds_w, 'PLS_REGRA_ACESSO_GP_SERV', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REGRA_INTERCAMBIO,1,4000), substr(NEW.IE_REGRA_INTERCAMBIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REGRA_INTERCAMBIO', ie_log_w, ds_w, 'PLS_REGRA_ACESSO_GP_SERV', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REGRA_AUTORIZACAO,1,4000), substr(NEW.IE_REGRA_AUTORIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REGRA_AUTORIZACAO', ie_log_w, ds_w, 'PLS_REGRA_ACESSO_GP_SERV', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REGRA_FRANQUIA,1,4000), substr(NEW.IE_REGRA_FRANQUIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REGRA_FRANQUIA', ie_log_w, ds_w, 'PLS_REGRA_ACESSO_GP_SERV', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REGRA_COPARTICIPACAO,1,4000), substr(NEW.IE_REGRA_COPARTICIPACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REGRA_COPARTICIPACAO', ie_log_w, ds_w, 'PLS_REGRA_ACESSO_GP_SERV', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_acesso_gp_serv_tp() FROM PUBLIC;

CREATE TRIGGER pls_regra_acesso_gp_serv_tp
	AFTER UPDATE ON pls_regra_acesso_gp_serv FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_acesso_gp_serv_tp();

