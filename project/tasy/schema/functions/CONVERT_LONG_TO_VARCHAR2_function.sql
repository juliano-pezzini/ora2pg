-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION convert_long_to_varchar2 ( ds_nome_campo_p text, ds_nome_tabela_p text, ds_condicao_p text ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w  varchar(4000);
qt_lenght_w  bigint;
cursor_w integer := dbms_sql.open_cursor;
fetch_w  integer;


BEGIN

dbms_sql.parse(cursor_w,'select '||ds_nome_campo_p||' from '||ds_nome_tabela_p||' where '||ds_condicao_p, dbms_sql.native);
dbms_sql.define_column_long(cursor_w,1);

fetch_w := dbms_sql.execute_and_fetch(cursor_w);

dbms_sql.column_value_long(cursor_w,1,4000,0, ds_retorno_w, qt_lenght_w );
dbms_sql.close_cursor(cursor_w);

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION convert_long_to_varchar2 ( ds_nome_campo_p text, ds_nome_tabela_p text, ds_condicao_p text ) FROM PUBLIC;

