-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_diverg_solic_ordem_tp ON regra_diverg_solic_ordem CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_diverg_solic_ordem_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'REGRA_DIVERG_SOLIC_ORDEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESTABELECIMENTO,1,4000), substr(NEW.CD_ESTABELECIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESTABELECIMENTO', ie_log_w, ds_w, 'REGRA_DIVERG_SOLIC_ORDEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DIVERGENCIA,1,4000), substr(NEW.IE_DIVERGENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DIVERGENCIA', ie_log_w, ds_w, 'REGRA_DIVERG_SOLIC_ORDEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_diverg_solic_ordem_tp() FROM PUBLIC;

CREATE TRIGGER regra_diverg_solic_ordem_tp
	AFTER UPDATE ON regra_diverg_solic_ordem FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_diverg_solic_ordem_tp();
