-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_db.do_drop_index_of_constraint (table_name_p text, index_name_p text) AS $body$
DECLARE

	
  REC RECORD;

BEGIN
	FOR REC IN (SELECT TABLE_NAME,
					   CONSTRAINT_NAME,
					   INDEX_NAME
				  FROM USER_CONSTRAINTS
				 WHERE TABLE_NAME = table_name_p
				   AND INDEX_NAME = index_name_p)
	LOOP
	  CALL wheb_db.do_drop_constraint(REC.TABLE_NAME, REC.CONSTRAINT_NAME);
	  CALL wheb_db.do_drop_index(REC.TABLE_NAME, REC.INDEX_NAME);
	END LOOP;
	END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_db.do_drop_index_of_constraint (table_name_p text, index_name_p text) FROM PUBLIC;
