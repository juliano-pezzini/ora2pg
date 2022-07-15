-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE lista AS (
	nm varchar(50),
	vl text );


CREATE OR REPLACE PROCEDURE obter_valor_dinamico_4000_bv ( ds_comando_p text, ds_parametros_p text, ds_Retorno_P INOUT text) AS $body$
DECLARE



/*
Executa o SQL passado como parametro (ds_comando_p) passando os parametros (ds_parametros_p) como bind_variable

Ex: obter_valor_dinamico_bv('select nm_pessoa_fisica from pessoa_fisica where cd_pessoa_fisica = :cd','cd=71626;');

*/
c001		integer;
retorno_w	integer;
ds_retorno_w	varchar(4000);
ds_erro_w	varchar(512);
type myArray is table of lista index by integer;

/*Contem os parametros do SQL*/

ar_parametros_w myArray;

ds_param_atual_w 	varchar(50);
ds_parametros_w 	varchar(2000);
nr_pos_separador_w	bigint;
qt_parametros_w		bigint;
qt_contador_w		bigint;


ds_sep_bv_w		varchar(10);
qt_tam_seq_w		smallint;


BEGIN
	ds_sep_bv_w := obter_separador_bv;
	if (position(ds_sep_bv_w in ds_parametros_p) = 0 ) then
		ds_sep_bv_w := ';';
	end if;
	qt_tam_seq_w := length(ds_sep_bv_w);
	ds_parametros_w    := ds_parametros_p;
	nr_pos_separador_w := position(ds_sep_bv_w in ds_parametros_w);
	qt_parametros_w	   := 0;
	while(nr_pos_separador_w > 0 ) loop
		begin
		qt_parametros_w := qt_parametros_w + 1;
		ds_param_atual_w  := substr(ds_parametros_w,1,nr_pos_separador_w-1);
		ds_parametros_w   := substr(ds_parametros_w,nr_pos_separador_w+qt_tam_seq_w,length(ds_parametros_w));
		nr_pos_separador_w := position('=' in ds_param_atual_w);
		ar_parametros_w[qt_parametros_w].nm := upper(substr(ds_param_atual_w,1,nr_pos_separador_w-1));
		ar_parametros_w[qt_parametros_w].vl := substr(ds_param_atual_w,nr_pos_separador_w+1,length(ds_param_atual_w));
		nr_pos_separador_w := position(ds_sep_bv_w in ds_parametros_w);
		if (qt_parametros_w > 1000) then
			nr_pos_separador_w := 0;
		end if;
		end;
	end loop;
	nr_pos_separador_w := position('=' in ds_parametros_w);
	if ( nr_pos_separador_w > 0 ) then
		qt_parametros_w := qt_parametros_w +1;
		ds_param_atual_w := ds_parametros_w;
		ar_parametros_w[qt_parametros_w].nm := upper(substr(ds_param_atual_w,1,nr_pos_separador_w-1));
		ar_parametros_w[qt_parametros_w].vl := substr(ds_param_atual_w,nr_pos_separador_w+1,length(ds_param_atual_w));
	end if;

	begin
	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_comando_p, dbms_sql.Native);
	if (upper(substr(ds_comando_p,1,6)) = 'SELECT') then
		DBMS_SQL.DEFINE_COLUMN(C001, 1, ds_retorno_w,4000);
		for contador_w in 1..ar_parametros_w.count loop
			DBMS_SQL.BIND_VARIABLE(C001, ar_parametros_w[contador_w].nm, ar_parametros_w[contador_w].vl,255);
		end loop;
	end if;
	retorno_w := DBMS_SQL.execute(c001);
	if (upper(substr(ds_comando_p,1,6)) = 'SELECT') then
		begin
		retorno_w := DBMS_SQL.fetch_rows(c001);
		DBMS_SQL.COLUMN_VALUE(C001, 1, ds_retorno_w );
		end;
	end if;
	DBMS_SQL.CLOSE_CURSOR(C001);
	exception
	when others then
		ds_erro_w	:= SQLERRM(SQLSTATE);
		CALL tratar_erro_banco(ds_erro_w);
		DBMS_SQL.CLOSE_CURSOR(C001);
	end;
if  coalesce(ds_retorno_w::text, '') = '' then
	ds_retorno_p	:= '';
else
	ds_retorno_p	:= ds_retorno_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_valor_dinamico_4000_bv ( ds_comando_p text, ds_parametros_p text, ds_Retorno_P INOUT text) FROM PUBLIC;

