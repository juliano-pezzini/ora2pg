-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_pflegegrad_atual ON paciente_pflegegrad CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_pflegegrad_atual() RETURNS trigger AS $BODY$
declare
 
BEGIN 
 
null;
	 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_pflegegrad_atual() FROM PUBLIC;

CREATE TRIGGER paciente_pflegegrad_atual
	BEFORE INSERT OR UPDATE ON paciente_pflegegrad FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_pflegegrad_atual();

