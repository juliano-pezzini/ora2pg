-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_criar_objeto_banco ( nm_objeto_p text, nm_owner_origem_p text) AS $body$
DECLARE


type invalid_status_type is  table of varchar(50) index by integer;
type text_type is table of varchar(4000) index by integer;

c001	integer;
i	integer;
ds_sql_w			varchar(32760)	:= '';
ie_tipo_objeto_w		varchar(15);
seq_w				integer := 0;

vl_retorno_w			double precision	:= 0;
ds_linha_w			varchar(256);
qt_tam_linha_w			bigint;

ds_script_criacao_w		text;
ds_resto_linha_w		varchar(256);
qt_linhas_w			bigint;
qt_registro_w			bigint;
qt_caracteres_w			integer;
qt_loops_w			bigint;
qt_pos_barra_w			bigint;

nm_owner_origem_w		varchar(30);
nm_owner_atual_w		varchar(30);
nm_tablespace_w			varchar(50);

j		integer:=0;

v_text_rec text_type;

invalid_rec	invalid_status_type;
v_text		dbms_sql.varchar2s;
i             bigint := 1;
n             bigint := 1;
cursor1       integer;
ret_val       integer;
lb            integer := 1;
ub            integer := 0;
init          integer :=1;
column_length integer :=1;



BEGIN

select	user
into STRICT	nm_owner_atual_w
;

if ( coalesce(nm_owner_origem_p::text, '') = '' ) or ( nm_owner_origem_p = '' ) or ( nm_owner_atual_w = nm_owner_origem_w ) then
	nm_owner_origem_w := 'TASY_VERSAO';
end if;

select	' TABLESPACE ' || obter_tablespace_tab_temp('W_OBJETO_SISTEMA')
into STRICT	nm_tablespace_w
;

select 	count(*)
into STRICT	qt_registro_w
from	user_tables
where	table_name = 'W_OBJETO_SISTEMA';

if ( qt_registro_w = 0 ) then
	CALL exec_sql_dinamico('','create TABLE w_objeto_sistema( ds_script_criacao clob,ie_tipo_objeto varchar2(15)) '|| nm_tablespace_w);
else
	CALL exec_sql_dinamico('','truncate table w_objeto_sistema');
end if;

if (nm_owner_origem_p = 'WHEB') then
	EXECUTE 'insert into w_objeto_sistema select TO_LOB(ds_script_criacao),ie_tipo_objeto from objeto_sistema where nm_objeto = upper(' || chr(39) || nm_objeto_p || chr(39) ||')';
else
	EXECUTE 'insert into w_objeto_sistema select TO_LOB(ds_script_criacao),ie_tipo_objeto from '|| nm_owner_origem_w ||'.objeto_sistema where nm_objeto = upper(' || chr(39) || nm_objeto_p || chr(39) ||')';
end if;

commit;

ds_sql_w := ' '||
	' select 	ds_script_criacao, ' ||
	'		ie_tipo_objeto ' ||
	' from 		w_objeto_sistema';

c001 := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(c001, ds_sql_w, dbms_sql.native);

dbms_sql.define_column(c001,1,ds_script_criacao_w);
dbms_sql.define_column(c001,2,ie_tipo_objeto_w,15);

vl_retorno_w := DBMS_SQL.EXECUTE(c001);
vl_retorno_w := DBMS_SQL.fetch_rows(c001);

DBMS_SQL.COLUMN_VALUE(c001, 1, ds_script_criacao_w);
DBMS_SQL.COLUMN_VALUE(c001, 2, ie_tipo_objeto_w);
DBMS_SQL.CLOSE_CURSOR(c001);

qt_caracteres_w := octet_length(ds_script_criacao_w);
qt_loops_w	:= round(qt_caracteres_w / 256) + 1;

--delete from almir;
if (qt_caracteres_w > 0) then

	for j in 1..qt_loops_w loop
		begin
		ds_linha_w := replace(substr(ds_script_criacao_w,256,((j*256)-255)),chr(13),'');

		if (length(trim(both ds_linha_w)) > 0) then
			ub := ub+1;
			v_text(ub) := ds_linha_w;

			--insert into almir values (ub, v_text(ub), sysdate);
			qt_pos_barra_w := position(chr(10)||'/'||chr(10) in ds_linha_w);
			if (qt_pos_barra_w > 0) and
				(j < (qt_loops_w - 3))  then

				ds_resto_linha_w := substr(v_text(ub),qt_pos_barra_w + 2,256);

				v_text(ub) := substr(v_text(ub),1,(qt_pos_barra_w - 1));

				cursor1 := dbms_sql.open_cursor;
				dbms_sql.parse(cursor1, v_text, lb, ub, null, dbms_sql.native);
				ret_val := dbms_sql.execute(cursor1);
				dbms_sql.close_cursor(cursor1);

				--insert into almir values (ub, 'Segunda parte....',sysdate);
				ub := 1;
				v_text(ub) := ds_resto_linha_w;
			end if;

		end if;
		end;
	end loop;


	if (position('/' in v_text(ub)) > 0) then
		v_text(ub) := substr(v_text(ub),1,instr(v_text(ub),'/',-1)-1);
	end if;

	if (ie_tipo_objeto_w = 'View') then
		v_text(ub) := replace(v_text(ub),';','');
	end if;

	--insert into almir values (ub, v_text(ub), sysdate);
	--commit;
	cursor1 := dbms_sql.open_cursor;
	dbms_sql.parse(cursor1, v_text, lb, ub, null, dbms_sql.native);
	ret_val := dbms_sql.execute(cursor1);
	dbms_sql.close_cursor(cursor1);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_criar_objeto_banco ( nm_objeto_p text, nm_owner_origem_p text) FROM PUBLIC;
