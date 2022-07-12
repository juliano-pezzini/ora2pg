-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS mdc_episodio_resp_mec_insert ON mdc_episodio_pac_resp_mec CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_mdc_episodio_resp_mec_insert() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.qt_horas_total > 0) then
    NEW.qt_minutos_total := NEW.qt_horas_total * 60;
else
    NEW.qt_minutos_total := 0;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_mdc_episodio_resp_mec_insert() FROM PUBLIC;

CREATE TRIGGER mdc_episodio_resp_mec_insert
	BEFORE INSERT OR UPDATE ON mdc_episodio_pac_resp_mec FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_mdc_episodio_resp_mec_insert();
