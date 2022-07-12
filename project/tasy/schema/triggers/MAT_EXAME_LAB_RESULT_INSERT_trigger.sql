-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS mat_exame_lab_result_insert ON mat_exame_lab_result CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_mat_exame_lab_result_insert() RETURNS trigger AS $BODY$
BEGIN
 
if (NEW.ie_formato_resultado = 'D') and 
	((NEW.ds_resultado is null) or 
	 ((NEW.qt_minima is not null) or (NEW.qt_maxima is not null)) or 
	 ((NEW.qt_percent_min is not null) or (NEW.qt_percent_max is not null))) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(713206);
elsif (NEW.ie_formato_resultado = 'V') and 
	 (((NEW.qt_minima is null) or (NEW.qt_maxima is null)) or (NEW.ds_resultado is not null) or 
	  ((NEW.qt_percent_min is not null) or (NEW.qt_percent_max is not null))) then 
	  CALL wheb_mensagem_pck.exibir_mensagem_abort(713211);
elsif (NEW.ie_formato_resultado = 'P') and 
	 (((NEW.qt_percent_min is null) or (NEW.qt_percent_max is null)) or (NEW.ds_resultado is not null) or 
	  ((NEW.qt_minima is not null) or (NEW.qt_maxima is not null))) then 
	  CALL wheb_mensagem_pck.exibir_mensagem_abort(713217);
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_mat_exame_lab_result_insert() FROM PUBLIC;

CREATE TRIGGER mat_exame_lab_result_insert
	BEFORE INSERT OR UPDATE ON mat_exame_lab_result FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_mat_exame_lab_result_insert();

