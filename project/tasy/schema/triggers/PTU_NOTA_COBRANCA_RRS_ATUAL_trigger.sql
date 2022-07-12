-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ptu_nota_cobranca_rrs_atual ON ptu_nota_cobranca_rrs CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ptu_nota_cobranca_rrs_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (TG_OP = 'INSERT') then
	NEW.ds_stack := substr(dbms_utility.format_call_stack,1,2000);
end if;

NEW.nr_nota_numerico := somente_numero(coalesce(NEW.nr_nota,OLD.nr_nota));

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ptu_nota_cobranca_rrs_atual() FROM PUBLIC;

CREATE TRIGGER ptu_nota_cobranca_rrs_atual
	BEFORE INSERT OR UPDATE ON ptu_nota_cobranca_rrs FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ptu_nota_cobranca_rrs_atual();
