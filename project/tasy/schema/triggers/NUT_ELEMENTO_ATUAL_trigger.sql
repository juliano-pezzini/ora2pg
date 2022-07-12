-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nut_elemento_atual ON nut_elemento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nut_elemento_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.qt_min is not null) and (NEW.qt_max is not null) and (NEW.qt_min <> 0) and (NEW.qt_max <> 0) and (NEW.qt_min > NEW.qt_max) then
	BEGIN
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(392333);
	end;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nut_elemento_atual() FROM PUBLIC;

CREATE TRIGGER nut_elemento_atual
	BEFORE INSERT OR UPDATE ON nut_elemento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nut_elemento_atual();

