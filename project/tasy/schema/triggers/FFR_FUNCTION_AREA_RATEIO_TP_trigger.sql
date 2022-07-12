-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ffr_function_area_rateio_tp ON ffr_function_area_rateio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ffr_function_area_rateio_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DT_FIM_VIGENCIA,1,4000), substr(NEW.DT_FIM_VIGENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_FIM_VIGENCIA', ie_log_w, ds_w, 'FFR_FUNCTION_AREA_RATEIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_INICIO_VIGENCIA,1,4000), substr(NEW.DT_INICIO_VIGENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_INICIO_VIGENCIA', ie_log_w, ds_w, 'FFR_FUNCTION_AREA_RATEIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ffr_function_area_rateio_tp() FROM PUBLIC;

CREATE TRIGGER ffr_function_area_rateio_tp
	AFTER UPDATE ON ffr_function_area_rateio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ffr_function_area_rateio_tp();

