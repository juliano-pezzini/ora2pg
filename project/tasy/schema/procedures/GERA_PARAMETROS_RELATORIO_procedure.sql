-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_parametros_relatorio ( ds_comando_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

cursor_p	integer;
col_cnt     	integer;	--Numero de colunas
dtab       	 	dbms_sql.desc_tab2;	--Descricao da Tabela
nr_tipo_w	smallint;
ds_erro_w	varchar(512);
nm_coluna_w	varchar(4000) := '';
nr_repet_coluna_w		bigint	:= 1;
TYPE COLUNAS_W IS TABLE OF varchar(4000) INDEX BY varchar(4000);
colunas_sql_w COLUNAS_W;
BEGIN
	if (ds_comando_p IS NOT NULL AND ds_comando_p::text <> '') and (coalesce(trim(both ds_comando_p)::text, '') = '' ) then
		CALL wheb_mensagem_pck.EXIBIR_MENSAGEM_ABORT(191071);
	end if;
	cursor_p := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(cursor_p, ds_comando_p, dbms_sql.native);
	dbms_sql.describe_columns2(cursor_p,col_cnt,dtab);
	--dbms_sql.desc_rec(cursor_p,col_cnt,dtab);
	/*Registra as colunas*/

	for i in 1 .. col_cnt loop
		nm_coluna_w	:= upper(dtab[i].col_name);
		if (colunas_sql_w.EXISTS(nm_coluna_w)) then
			nm_coluna_w := 	substr(nm_coluna_w || '_' || nr_repet_coluna_w,1,3999);
			nr_repet_coluna_w := nr_repet_coluna_w + 1;
		end if;
		colunas_sql_w(nm_coluna_w) := nm_coluna_w;

		if ( dtab[i].col_type =  12 ) then
			nr_tipo_w := 0; --DATE
		elsif (  dtab[i].col_type in (23,24)) then
			nr_tipo_w := 1; --BYTE
		elsif (  dtab[i].col_type = 8) then
			nr_tipo_w := 2; -- LONG
		elsif (  dtab[i].col_type = 2) then
			if (dtab[i].col_scale > 0) then
				nr_tipo_w := 3;--DOUBLE
			else
				nr_tipo_w := 4;--NUMBER
			end if;
		else
			nr_tipo_w := 5; --VARCHAR2
		end if;
		if (ds_retorno_p IS NOT NULL AND ds_retorno_p::text <> '') then
			ds_retorno_p := ds_retorno_p ||';';
		end if;
		ds_retorno_p := ds_retorno_p || nm_coluna_w  ||'='||nr_tipo_w;
	end loop;
	DBMS_SQL.CLOSE_CURSOR(cursor_p);
exception
when others then
	begin
	DBMS_SQL.CLOSE_CURSOR(cursor_p);
	ds_erro_w	:= SQLERRM(SQLSTATE);
	CALL wheb_mensagem_pck.EXIBIR_MENSAGEM_ABORT(191072,'ERRO='||ds_erro_w);
	end;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_parametros_relatorio ( ds_comando_p text, ds_retorno_p INOUT text) FROM PUBLIC;

