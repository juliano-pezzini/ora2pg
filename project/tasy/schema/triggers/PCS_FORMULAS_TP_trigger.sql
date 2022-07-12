-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pcs_formulas_tp ON pcs_formulas CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pcs_formulas_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MACRO,1,4000), substr(NEW.DS_MACRO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MACRO', ie_log_w, ds_w, 'PCS_FORMULAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_FORMULA,1,4000), substr(NEW.DS_FORMULA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_FORMULA', ie_log_w, ds_w, 'PCS_FORMULAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pcs_formulas_tp() FROM PUBLIC;

CREATE TRIGGER pcs_formulas_tp
	AFTER UPDATE ON pcs_formulas FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pcs_formulas_tp();
