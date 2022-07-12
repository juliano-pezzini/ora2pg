-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proj_risco_implantacao_atual ON proj_risco_implantacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proj_risco_implantacao_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w	smallint;
BEGIN

if (OLD.DT_LIBERACAO is null) and (NEW.DT_LIBERACAO is not null) and (NEW.DT_FIM_REAL is null) then
	NEW.DT_FIM_REAL	:= NEW.DT_LIBERACAO;
end if;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proj_risco_implantacao_atual() FROM PUBLIC;

CREATE TRIGGER proj_risco_implantacao_atual
	BEFORE INSERT OR UPDATE ON proj_risco_implantacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proj_risco_implantacao_atual();

