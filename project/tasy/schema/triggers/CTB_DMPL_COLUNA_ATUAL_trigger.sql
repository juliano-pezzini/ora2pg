-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_dmpl_coluna_atual ON ctb_dmpl_coluna CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_dmpl_coluna_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (coalesce(NEW.cd_aglutinacao_sped,'X') = 'X') then
	NEW.cd_aglutinacao_sped	:= 'DMPL' || NEW.nr_sequencia;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_dmpl_coluna_atual() FROM PUBLIC;

CREATE TRIGGER ctb_dmpl_coluna_atual
	BEFORE INSERT OR UPDATE ON ctb_dmpl_coluna FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_dmpl_coluna_atual();
