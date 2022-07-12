-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS indice_reajuste_anual_fin_tp ON indice_reajuste_anual_fin CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_indice_reajuste_anual_fin_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.NR_DIAS_BASE_ANUAL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_DIAS_BASE_ANUAL,1,4000), substr(NEW.NR_DIAS_BASE_ANUAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_DIAS_BASE_ANUAL', ie_log_w, ds_w, 'INDICE_REAJUSTE_ANUAL_FIN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_DIAS_CONSIDERADOS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DIAS_CONSIDERADOS,1,4000), substr(NEW.IE_DIAS_CONSIDERADOS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DIAS_CONSIDERADOS', ie_log_w, ds_w, 'INDICE_REAJUSTE_ANUAL_FIN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_INICIO_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_INICIO_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_INICIO_VIGENCIA', ie_log_w, ds_w, 'INDICE_REAJUSTE_ANUAL_FIN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_FINAL_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_FINAL_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_FINAL_VIGENCIA', ie_log_w, ds_w, 'INDICE_REAJUSTE_ANUAL_FIN', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_indice_reajuste_anual_fin_tp() FROM PUBLIC;

CREATE TRIGGER indice_reajuste_anual_fin_tp
	AFTER UPDATE ON indice_reajuste_anual_fin FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_indice_reajuste_anual_fin_tp();

