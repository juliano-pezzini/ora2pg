-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_db.do_modify_constraint_index (nm_tabela_p text, nm_integridade_referencial_p text, nm_indice_p text) AS $body$
DECLARE

	sql_w 			varchar(255);
	
BEGIN
	IF NOT wheb_db.exists_constraint(nm_tabela_p, nm_integridade_referencial_p) AND wheb_db.exists_index(nm_tabela_p, nm_indice_p) THEN
	  RETURN;
	END IF;

	sql_w := 'ALTER TABLE ' || UPPER(nm_tabela_p) ||
	  ' MODIFY CONSTRAINT ' || UPPER(nm_integridade_referencial_p) ||
			' USING INDEX ' || UPPER(nm_indice_p);

	CALL WHEB_INCONSISTENCIA_LOG.LOG_COMMAND(sql_w || ';');

	IF current_setting('wheb_db.canchangedatabase')::boolean THEN
	  EXECUTE sql_w;
	END IF;
	END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_db.do_modify_constraint_index (nm_tabela_p text, nm_integridade_referencial_p text, nm_indice_p text) FROM PUBLIC;