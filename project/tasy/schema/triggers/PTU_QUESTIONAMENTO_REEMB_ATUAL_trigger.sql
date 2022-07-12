-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ptu_questionamento_reemb_atual ON ptu_questionamento_reemb CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ptu_questionamento_reemb_atual() RETURNS trigger AS $BODY$
declare

BEGIN
NEW.nr_nota_numerico := somente_numero(coalesce(NEW.nr_nota,OLD.nr_nota));

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ptu_questionamento_reemb_atual() FROM PUBLIC;

CREATE TRIGGER ptu_questionamento_reemb_atual
	BEFORE INSERT OR UPDATE ON ptu_questionamento_reemb FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ptu_questionamento_reemb_atual();

