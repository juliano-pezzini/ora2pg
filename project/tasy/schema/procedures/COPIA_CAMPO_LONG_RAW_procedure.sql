-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_campo_long_raw ( nm_tabela_p text, nm_coluna_p text, ds_restricao_where_p text, nm_tabela_update_p text, nm_coluna_update_p text, ds_restricao_where_update_p text, ie_commit_p text) AS $body$
DECLARE


	ds_select_w	varchar(4000);
	ds_update_w	varchar(4000);

	C01_ID		integer;
	C02_ID		integer;

	l_long_raw_w	bytea;
	col_cnt_w		integer;
	desctab_w		dbms_sql.desc_tab;

	retorno_w		integer;


BEGIN

	ds_select_w := ' SELECT ' || nm_coluna_p || ' FROM ' || nm_tabela_p || ' WHERE 1 = 1 ' || ds_restricao_where_p;

	C01_ID := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C01_ID, ds_select_w, DBMS_SQL.NATIVE);
	DBMS_SQL.DESCRIBE_COLUMNS(C01_ID,col_cnt_w,desctab_w);

	DBMS_SQL.DEFINE_COLUMN_RAW(C01_ID,1,l_long_raw_w, 32767);

	retorno_w := DBMS_SQL.EXECUTE(C01_ID);
	retorno_w := DBMS_SQL.FETCH_ROWS(C01_ID);

	DBMS_SQL.COLUMN_VALUE_RAW(C01_ID, 1, l_long_raw_w);

	ds_update_w := ' UPDATE ' || nm_tabela_update_p || ' SET ' || nm_coluna_update_p || ' = :CAMPO_LONG_RAW  WHERE 1 = 1 ' || ds_restricao_where_update_p;

	C02_ID := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C02_ID, ds_update_w, DBMS_SQL.NATIVE);

	DBMS_SQL.BIND_VARIABLE_RAW(C02_ID, 'CAMPO_LONG_RAW', l_long_raw_w, 32767);

	retorno_w := DBMS_SQL.EXECUTE(C02_ID);
	DBMS_SQL.CLOSE_CURSOR(C02_ID);
	DBMS_SQL.CLOSE_CURSOR(C01_ID);

	IF (ie_commit_p = 'S') THEN
		COMMIT;
	END IF;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_campo_long_raw ( nm_tabela_p text, nm_coluna_p text, ds_restricao_where_p text, nm_tabela_update_p text, nm_coluna_update_p text, ds_restricao_where_update_p text, ie_commit_p text) FROM PUBLIC;

