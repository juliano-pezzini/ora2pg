-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_portab_email_anexo_atual ON pls_portab_email_anexo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_portab_email_anexo_atual() RETURNS trigger AS $BODY$
declare
BEGIN

if (NEW.nr_seq_relatorio is not null) then
	select	cd_classif_relat,
		cd_relatorio
	into STRICT	NEW.cd_classif_relat,
		NEW.cd_relatorio
	from	relatorio
	where	nr_sequencia	= NEW.nr_seq_relatorio;
else
	NEW.cd_classif_relat	:= null;
	NEW.cd_relatorio	:= null;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_portab_email_anexo_atual() FROM PUBLIC;

CREATE TRIGGER pls_portab_email_anexo_atual
	BEFORE INSERT OR UPDATE ON pls_portab_email_anexo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_portab_email_anexo_atual();

