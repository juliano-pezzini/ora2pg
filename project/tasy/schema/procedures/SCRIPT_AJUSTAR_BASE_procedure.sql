-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE script_ajustar_base () AS $body$
DECLARE


/* Os comando serao gerados na tabela SCRIPT_AJUSTAR_BASE_LOG
  Apos executar os comandos, executar a procedure TASY_SINCRONIZAR_BASE*/
nm_tabela_w 	  varchar(30);
nm_index_w  	  varchar(30);
nm_constraint_w   varchar(30);
ds_comando_w	  varchar(255);
varSql		  varchar(255) := chr(39);
qt_registro_p bigint;
-- Retorna as tabelas com problemas
c01 CURSOR FOR
	SELECT distinct nm_tabela
	from consiste_base_v;
-- Retorna as FK que estão na base e não estão no dicionario
c02 CURSOR FOR
	SELECT  distinct a.constraint_name
	from  	user_cons_columns a,
      		user_constraints c
	where	c.constraint_type not in ('P','U')
	and     a.table_name = c.table_name
	and     a.constraint_name = c.constraint_name
	and     a.table_name = nm_tabela_w
	and     substr(a.constraint_name,0,3) <> 'SYS'
	and     not exists ( SELECT  1
           		     from    integridade_referencial b
			     where   a.constraint_name = b.nm_integridade_referencial
			     and     a.table_name = b.nm_tabela);
-- Retorna as PK E UK que estão na base e não estão no dicionario
c03 CURSOR FOR
	SELECT  distinct a.constraint_name
	from  	user_cons_columns a,
      		user_constraints c
	where	c.constraint_type in ('P','U')
	and     a.table_name = c.table_name
	and     a.constraint_name = c.constraint_name
	and     a.table_name = nm_tabela_w
	and     substr(a.constraint_name,0,3) <> 'SYS'
	and     not exists ( SELECT  1
           		     from    indice b
			     where   a.constraint_name  = b.nm_indice
			     and     a.table_name 	= b.nm_tabela);
-- Retorna os indices que estao no banco e não estão no dicionario
c04 CURSOR FOR
	SELECT 	distinct index_name
	from 	user_ind_columns a
	where 	a.table_name = nm_tabela_w
		and	substr(index_name,0,3) <> 'SYS'
	and not exists (SELECT 	1
           		from    indice b
           		where   a.index_name = b.nm_indice
           		and     a.table_name = b.nm_tabela);
-- Retorna os indices que estao no banco mas não possui CONSTRAINT criada
c05 CURSOR FOR
	SELECT  a.index_name
	from    user_indexes a
	where 	a.table_name = nm_tabela_w
	and (a.index_name like '%_PK' or
		a.index_name like '%_UK')
	and     not exists (SELECT 1
			   from   user_constraints b
		  	   where  a.table_name = b.table_name
			   and 	  a.index_name = b.constraint_name);
-- Habilitar CONSTRAINTS
c06 CURSOR FOR
	SELECT	a.constraint_name
	from	user_constraints a
	where	a.table_name = nm_tabela_w
	and	a.status = 'DISABLED';
-- Retorna indice criado no banco com colunas diferente do dicionario
c07 CURSOR FOR
SELECT	distinct b.nm_indice
from	indice_atributo b
where	b.nm_tabela = nm_tabela_w
and 	not exists (	select 	1
			from	user_ind_columns a
           		where   a.table_name = b.nm_tabela
           		and     substr(index_name,0,3) <> 'SYS'
           		and     b.nm_indice     = a.index_name
           		and     b.nm_Atributo   = a.column_name);

BEGIN
	select 		coalesce(max(table_name),'N')
	into STRICT		nm_tabela_w
	from 		user_tables
	where		upper(table_name) = 'SCRIPT_AJUSTAR_BASE_LOG';
	if ( nm_tabela_w = 'N') then
		CALL EXEC_SQL_DINAMICO('TASY','create table script_ajustar_base_log (ds_comando varchar2(255))');
	else
		CALL EXEC_SQL_DINAMICO('TASY','delete from script_ajustar_base_log');
		commit;
	end if;
OPEN c01;
LOOP
FETCH c01 INTO 	nm_tabela_w;
 BEGIN
 	EXIT WHEN NOT FOUND; /* apply on c01 */
	-- Verifica quantida de registro da tabela
	qt_registro_p := obter_valor_dinamico('select nvl(count(*),0) from ' || nm_tabela_w, qt_registro_p);
	if ( qt_registro_p = 0 ) then
		ds_comando_w := 'insert into script_ajustar_base_log values( ' || varSql || ' DROP TABLE ' || nm_tabela_w || ' cascade constraints;' || varSql ||')';
		CALL EXEC_SQL_DINAMICO('TASY',ds_comando_w);
		commit;
	else
		OPEN c02;
		LOOP
		FETCH c02 INTO nm_constraint_w;
		  BEGIN
			EXIT WHEN NOT FOUND; /* apply on c02 */
				if ( nm_tabela_w <> 'Procedure' and nm_tabela_w <> 'Function' and nm_tabela_w  <> 'Trigger') then
					ds_comando_w := 'insert into script_ajustar_base_log values('|| varSql || 'ALTER TABLE ' || nm_tabela_w || ' DROP CONSTRAINT '|| nm_constraint_w || ';' || varSql || ')';
					CALL EXEC_SQL_DINAMICO('TASY',ds_comando_w);
					commit;
				end if;
		  END;
		END LOOP;
		CLOSE c02;
		OPEN c03;
		LOOP
		FETCH c03 INTO nm_constraint_w;
		  BEGIN
			EXIT WHEN NOT FOUND; /* apply on c03 */
				ds_comando_w := 'insert into script_ajustar_base_log values(' || varSql || 'ALTER TABLE ' || nm_tabela_w || ' DROP CONSTRAINT '|| nm_constraint_w || ';' || varSql || ')';
				CALL EXEC_SQL_DINAMICO('TASY',ds_comando_w);
				commit;
		  END;
		END LOOP;
		CLOSE c03;
		OPEN c04;
		LOOP
		FETCH c04 INTO nm_index_w;
		  BEGIN
			EXIT WHEN NOT FOUND; /* apply on c04 */
				ds_comando_w := 'insert into script_ajustar_base_log values(' || varSql || 'DROP INDEX ' || nm_index_w || ';' || varSql || ')';
				CALL EXEC_SQL_DINAMICO('TASY',ds_comando_w);
				commit;
		  END;
		END LOOP;
		CLOSE c04;
		OPEN c05;
		LOOP
		FETCH c05 INTO nm_index_w;
		  BEGIN
			EXIT WHEN NOT FOUND; /* apply on c05 */
				ds_comando_w := 'insert into script_ajustar_base_log values(' || varSql || 'DROP INDEX ' || nm_index_w || ';' || varSql || ')';
				CALL EXEC_SQL_DINAMICO('TASY',ds_comando_w);
				commit;
		  END;
		END LOOP;
		CLOSE c05;
		OPEN c06;
		LOOP
		FETCH c06 INTO nm_constraint_w;
		  BEGIN
			EXIT WHEN NOT FOUND; /* apply on c06 */
				ds_comando_w := 'insert into script_ajustar_base_log values(' || varSql || 'ALTER TABLE '|| nm_tabela_w || ' ENABLE CONSTRAINT ' || nm_constraint_w || ';' || varSql || ')';
				CALL EXEC_SQL_DINAMICO('TASY',ds_comando_w);
				commit;
		  END;
		END LOOP;
		CLOSE c06;
		OPEN c07;
		LOOP
		FETCH c07 INTO nm_index_w;
		  BEGIN
			EXIT WHEN NOT FOUND; /* apply on c07 */
				if ( nm_index_w like '%_I') then
					ds_comando_w := 'insert into script_ajustar_base_log values('|| varSql || 'ALTER TABLE ' || nm_tabela_w || ' DROP CONSTRAINT ' || substr(nm_index_w,0,length(nm_index_w)-2) || ';' || varSql || ')';
				else
					ds_comando_w := 'insert into script_ajustar_base_log values('|| varSql || 'ALTER TABLE ' || nm_tabela_w || ' DROP CONSTRAINT ' || nm_index_w || ';' || varSql ||')';
				end if;
				CALL EXEC_SQL_DINAMICO('TASY',ds_comando_w);
				ds_comando_w := 'insert into script_ajustar_base_log values('|| varSql || 'DROP INDEX ' || nm_index_w || ';' || varSql || ')';
				CALL EXEC_SQL_DINAMICO('TASY',ds_comando_w);
				commit;
		  END;
		END LOOP;
		CLOSE c07;
	end if;
 END;
 END LOOP;
CLOSE c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE script_ajustar_base () FROM PUBLIC;
