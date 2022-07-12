-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ptu_fatura_imp_update ON ptu_fatura CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ptu_fatura_imp_update() RETURNS trigger AS $BODY$
declare

BEGIN

if (OLD.ie_status <> 'I') and (NEW.ie_status = 'I') then
	CALL pls_grava_log_proces_imp_a500('ptu_fatura_imp_update', NEW.nr_sequencia, coalesce(NEW.nm_usuario, OLD.nm_usuario));
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ptu_fatura_imp_update() FROM PUBLIC;

CREATE TRIGGER ptu_fatura_imp_update
	BEFORE INSERT OR UPDATE ON ptu_fatura FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ptu_fatura_imp_update();
