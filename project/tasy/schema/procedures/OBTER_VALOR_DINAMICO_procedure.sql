-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_valor_dinamico ( ds_comando_p text, ds_Retorno_P INOUT bigint) AS $body$
DECLARE


c001		integer;		
retorno_w	integer;
vl_retorno_w	double precision;
ds_erro_w	varchar(512);


BEGIN
	begin
	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_comando_p, dbms_sql.Native);
	if (upper(substr(ds_comando_p,1,6)) = 'SELECT') then
		DBMS_SQL.DEFINE_COLUMN(C001, 1, vl_retorno_w);
	end if;
	retorno_w := DBMS_SQL.execute(c001);
	if (upper(substr(ds_comando_p,1,6)) = 'SELECT') then
		begin
		retorno_w := DBMS_SQL.fetch_rows(c001);
		DBMS_SQL.COLUMN_VALUE(C001, 1, vl_retorno_w );
		end;
	end if;
	DBMS_SQL.CLOSE_CURSOR(C001);
	exception
	when others then
		ds_erro_w	:= SQLERRM(SQLSTATE);
		CALL tratar_erro_banco(ds_erro_w);
		DBMS_SQL.CLOSE_CURSOR(C001);
	end;
if  coalesce(vl_retorno_w::text, '') = '' then
	ds_retorno_p	:= 0;
else
	ds_retorno_p	:= vl_retorno_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_valor_dinamico ( ds_comando_p text, ds_Retorno_P INOUT bigint) FROM PUBLIC;

