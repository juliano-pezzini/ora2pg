-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS log_mensagem_mednet_tp ON log_mensagem_mednet CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_log_mensagem_mednet_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_NASCIMENTO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_NASCIMENTO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_NASCIMENTO', ie_log_w, ds_w, 'LOG_MENSAGEM_MEDNET', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_log_mensagem_mednet_tp() FROM PUBLIC;

CREATE TRIGGER log_mensagem_mednet_tp
	AFTER UPDATE ON log_mensagem_mednet FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_log_mensagem_mednet_tp();

