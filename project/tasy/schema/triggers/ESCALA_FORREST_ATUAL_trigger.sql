-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_forrest_atual ON escala_forrest CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_forrest_atual() RETURNS trigger AS $BODY$
declare

BEGIN
if (NEW.ie_forrest = '1A') then
	NEW.pr_reavaliacao	:= 55;
	NEW.pr_mortalidade	:= 11;
elsif (NEW.ie_forrest = '1B') then
	NEW.pr_reavaliacao	:= 55;
	NEW.pr_mortalidade	:= 11;
elsif (NEW.ie_forrest = '2A') then
	NEW.pr_reavaliacao	:= 43;
	NEW.pr_mortalidade	:= 11;
elsif (NEW.ie_forrest = '2B') then
	NEW.pr_reavaliacao	:= 22;
	NEW.pr_mortalidade	:= 7;
elsif (NEW.ie_forrest = '2C') then
	NEW.pr_reavaliacao	:= 10;
	NEW.pr_mortalidade	:= 3;
elsif (NEW.ie_forrest = '3') then
	NEW.pr_reavaliacao	:= 5;
	NEW.pr_mortalidade	:= 2;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_forrest_atual() FROM PUBLIC;

CREATE TRIGGER escala_forrest_atual
	BEFORE INSERT OR UPDATE ON escala_forrest FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_forrest_atual();

