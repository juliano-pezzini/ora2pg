-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ptu_nota_cobranca_atual ON ptu_nota_cobranca CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ptu_nota_cobranca_atual() RETURNS trigger AS $BODY$
declare

BEGIN

NEW.nr_nota_numerico := somente_numero(coalesce(NEW.nr_nota,OLD.nr_nota));
NEW.nr_guia_principal_numerico := somente_numero(coalesce(NEW.nr_guia_principal,OLD.nr_guia_principal));

if (TG_OP = 'INSERT') then
	NEW.ds_stack := substr(dbms_utility.format_call_stack,1,2000);
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ptu_nota_cobranca_atual() FROM PUBLIC;

CREATE TRIGGER ptu_nota_cobranca_atual
	BEFORE INSERT OR UPDATE ON ptu_nota_cobranca FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ptu_nota_cobranca_atual();
