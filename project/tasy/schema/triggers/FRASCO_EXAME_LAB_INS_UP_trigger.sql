-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS frasco_exame_lab_ins_up ON frasco_exame_lab CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_frasco_exame_lab_ins_up() RETURNS trigger AS $BODY$
BEGIN

if (NEW.QT_VOLUME < 1 AND NEW.QT_VOLUME is not null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(791040);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_frasco_exame_lab_ins_up() FROM PUBLIC;

CREATE TRIGGER frasco_exame_lab_ins_up
	BEFORE INSERT OR UPDATE ON frasco_exame_lab FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_frasco_exame_lab_ins_up();

