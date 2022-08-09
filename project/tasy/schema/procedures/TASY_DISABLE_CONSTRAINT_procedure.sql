-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_disable_constraint () AS $body$
DECLARE


ds_comando_w			varchar(2000);
nm_tabela_w			varchar(50);
nm_constraint_w		varchar(50);

sofar_w bigint := 0;
n_cleanupdb_pck_w bigint := 0;
nm_fase_atualizacao_w varchar(20) := 'DATABASE_CLEANUP';
b_cleanupdb smallint := 0;
l_sql_chk_cleanupdb_table varchar(1000) := 'select count(1) from user_tables where table_name = ''CLEANUPDB_TABLE'' and status = ''VALID''';


C010 CURSOR FOR
	SELECT constraint_name,
		table_name
	from user_constraints
	where status = 'ENABLED'
	and	constraint_type = 'R';


BEGIN
    
SELECT COUNT(1)
INTO STRICT n_cleanupdb_pck_w
FROM USER_OBJECTS
WHERE OBJECT_NAME = 'CLEANUPDB_PCK'
AND STATUS = 'VALID';

OPEN C010;
LOOP
	FETCH C010 INTO 	nm_constraint_w,
				nm_tabela_w;
	EXIT WHEN NOT FOUND; /* apply on C010 */

	ds_comando_w	:= 'Alter table ' || nm_tabela_w || ' Disable constraint ' || nm_constraint_w;
	CALL Exec_Sql_Dinamico(nm_tabela_w || ' Disable constraint', ds_comando_w);
    if (n_cleanupdb_pck_w > 1) then
      EXECUTE l_sql_chk_cleanupdb_table into STRICT b_cleanupdb;
      if (b_cleanupdb > 0) then
        EXECUTE 'begin cleanupdb_pck.add_progress(:nm_fase_atualizacao_w, 1); end;' using nm_fase_atualizacao_w;
      end if;
    end if;
end loop;

CLOSE C010;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_disable_constraint () FROM PUBLIC;
