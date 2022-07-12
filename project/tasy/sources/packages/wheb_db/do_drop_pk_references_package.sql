-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_db.do_drop_pk_references (primary_key_name_p text) AS $body$
DECLARE

	
  REC RECORD;

BEGIN
	FOR REC IN (SELECT TABLE_NAME,
					   CONSTRAINT_NAME
				  FROM USER_CONSTRAINTS
				 WHERE CONSTRAINT_TYPE   = 'R'
				   AND R_CONSTRAINT_NAME = primary_key_name_p)
	LOOP
	  CALL wheb_db.do_drop_constraint(REC.TABLE_NAME, REC.CONSTRAINT_NAME);
	END LOOP;
	END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_db.do_drop_pk_references (primary_key_name_p text) FROM PUBLIC;