-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS dispositivo_tp ON dispositivo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_dispositivo_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DS_COR_HTML,1,4000), substr(NEW.DS_COR_HTML,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_COR_HTML', ie_log_w, ds_w, 'DISPOSITIVO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_dispositivo_tp() FROM PUBLIC;

CREATE TRIGGER dispositivo_tp
	AFTER UPDATE ON dispositivo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_dispositivo_tp();

