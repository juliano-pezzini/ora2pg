-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_consiste_inf_evo_tp ON regra_consiste_inf_evo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_consiste_inf_evo_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_EVENTO,1,4000), substr(NEW.NR_SEQ_EVENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_EVENTO', ie_log_w, ds_w, 'REGRA_CONSISTE_INF_EVO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_consiste_inf_evo_tp() FROM PUBLIC;

CREATE TRIGGER regra_consiste_inf_evo_tp
	AFTER UPDATE ON regra_consiste_inf_evo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_consiste_inf_evo_tp();

