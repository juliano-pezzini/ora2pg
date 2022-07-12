-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ap_lote_item_update ON ap_lote_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ap_lote_item_update() RETURNS trigger AS $BODY$
declare

ds_origem_w		varchar(1800);
BEGIN                                                                           
if (TG_OP = 'UPDATE') then
	if (OLD.qt_dispensar > 0) and (OLD.qt_dispensar <> NEW.qt_dispensar) then                                                   
		
		ds_origem_w := substr(dbms_utility.format_call_stack,1,1800);
		
		insert into log_tasy(
			dt_atualizacao,
			nm_usuario,
			cd_log,
			ds_log)
		values (LOCALTIMESTAMP,
			NEW.nm_usuario,
			88938,
			'Lote=' || NEW.nr_seq_lote || ' Old=' || OLD.qt_dispensar || ' New=' || NEW.qt_dispensar || ' Origem=' ||ds_origem_w);		
	end if;

	if (OLD.qt_dispensar <> NEW.qt_dispensar) then

		ds_origem_w := substr(dbms_utility.format_call_stack,1,2000);

		insert into log_tasy(
			dt_atualizacao,
			nm_usuario,
			cd_log,
			ds_log)
		values (
			LOCALTIMESTAMP,
			NEW.nr_seq_lote,
			88899,
			'Lote=' || NEW.nr_seq_lote || ' old.qt_dispensar=' || OLD.qt_dispensar || ' new.qt_dispensar=' || NEW.qt_dispensar || ' Origem=' || ds_origem_w);

	end if;

end if;

if (TG_OP = 'INSERT') then
	NEW.ds_stack := substr(dbms_utility.format_call_stack,1,2000);
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ap_lote_item_update() FROM PUBLIC;

CREATE TRIGGER ap_lote_item_update
	BEFORE INSERT OR UPDATE ON ap_lote_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ap_lote_item_update();
