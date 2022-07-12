-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pe_procedimento_atual ON pe_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pe_procedimento_atual() RETURNS trigger AS $BODY$
declare

BEGIN
if (NEW.ds_procedimento_pesquisa is null) or (NEW.ds_procedimento <> OLD.ds_procedimento ) then
	NEW.ds_procedimento_pesquisa	:= upper(elimina_acentuacao(NEW.ds_procedimento));
end if;


RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pe_procedimento_atual() FROM PUBLIC;

CREATE TRIGGER pe_procedimento_atual
	BEFORE INSERT OR UPDATE ON pe_procedimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pe_procedimento_atual();

