-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nut_producao_lactario_item_tp ON nut_producao_lactario_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nut_producao_lactario_item_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.NR_ATENDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ATENDIMENTO,1,2000), substr(NEW.NR_ATENDIMENTO,1,2000), NEW.nm_usuario, nr_seq_w, 'NR_ATENDIMENTO', ie_log_w, ds_w, 'NUT_PRODUCAO_LACTARIO_ITEM', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nut_producao_lactario_item_tp() FROM PUBLIC;

CREATE TRIGGER nut_producao_lactario_item_tp
	AFTER UPDATE ON nut_producao_lactario_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nut_producao_lactario_item_tp();

