-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE executar_sql_dinamico ( ds_comando_p text, ds_Retorno_P INOUT bigint) AS $body$
DECLARE


c001		integer;
retorno_w	integer;
ds_erro_w	varchar(512);


BEGIN
	begin
	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_comando_p, dbms_sql.native);
	retorno_w := DBMS_SQL.execute(c001);
	DBMS_SQL.CLOSE_CURSOR(C001);
	exception
	when others then
		ds_erro_w	:= SQLERRM(SQLSTATE);
		CALL tratar_erro_banco(ds_erro_w);
		DBMS_SQL.CLOSE_CURSOR(C001);
	end;
	ds_retorno_p	:= retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE executar_sql_dinamico ( ds_comando_p text, ds_Retorno_P INOUT bigint) FROM PUBLIC;
