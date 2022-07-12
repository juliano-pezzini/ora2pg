-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_prescr_citopatologico_tp ON cpoe_prescr_citopatologico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_prescr_citopatologico_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_FISICA,1,4000), substr(NEW.CD_PESSOA_FISICA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_FISICA', ie_log_w, ds_w, 'CPOE_PRESCR_CITOPATOLOGICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ATENDIMENTO,1,4000), substr(NEW.NR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ATENDIMENTO', ie_log_w, ds_w, 'CPOE_PRESCR_CITOPATOLOGICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_INICIO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_INICIO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_INICIO', ie_log_w, ds_w, 'CPOE_PRESCR_CITOPATOLOGICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_FIM,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_FIM,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_FIM', ie_log_w, ds_w, 'CPOE_PRESCR_CITOPATOLOGICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_prescr_citopatologico_tp() FROM PUBLIC;

CREATE TRIGGER cpoe_prescr_citopatologico_tp
	AFTER UPDATE ON cpoe_prescr_citopatologico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_prescr_citopatologico_tp();

