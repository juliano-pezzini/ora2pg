-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_pf_data ( cd_pessoa_fisica_p text, dt_referencia_p timestamp, ds_atributo_p text) RETURNS varchar AS $body$
DECLARE


ds_valor_new_w          varchar(255);
nm_retorno_w		varchar(255);
ds_comando_w		varchar(256);
retorno_w   		integer;
c010     		integer;
c011     		integer;


BEGIN

ds_comando_w :=
	'select ' || ds_atributo_p ||
	' from  PESSOA_FISICA_ALTERACAO ' ||
	' where cd_pessoa_fisica = :cd_pessoa_fisica_p '||
	' and dt_atualizacao > :dt_referencia_p '||
	' order by dt_atualizacao ';

C010 := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(C010, ds_comando_w, dbms_sql.Native);

-- coloca as coluna
DBMS_SQL.DEFINE_COLUMN(C010,1,nm_retorno_w,50);

-- aqui troca os bind
DBMS_SQL.BIND_VARIABLE(C010, 'cd_pessoa_fisica_p', cd_pessoa_fisica_p,255);

DBMS_SQL.BIND_VARIABLE(C010, 'dt_referencia_p', dt_referencia_p);

retorno_w := DBMS_SQL.execute(c010);

while( DBMS_SQL.FETCH_ROWS(C010) > 0 ) loop

	DBMS_SQL.COLUMN_VALUE(C010, 1, nm_retorno_w);

	exit;
end loop;
DBMS_SQL.CLOSE_CURSOR(C010);

if (coalesce(nm_retorno_w::text, '') = '') then
	ds_comando_w :=  'select ' || ds_atributo_p ||
	' from  PESSOA_FISICA ' ||
	' where cd_pessoa_fisica = :cd_pessoa_fisica_p ';

	C011 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C011, ds_comando_w, dbms_sql.Native);
	-- coloca as coluna
	DBMS_SQL.DEFINE_COLUMN(C011,1,nm_retorno_w,50);
	-- aqui troca os bind
	DBMS_SQL.BIND_VARIABLE(C011, 'cd_pessoa_fisica_p', cd_pessoa_fisica_p,255);

	retorno_w := DBMS_SQL.execute(c011);

	while( DBMS_SQL.FETCH_ROWS(C011) > 0 ) loop

		DBMS_SQL.COLUMN_VALUE(C011, 1, nm_retorno_w);

	exit;

	end loop;
DBMS_SQL.CLOSE_CURSOR(C011);

end if;

return nm_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_pf_data ( cd_pessoa_fisica_p text, dt_referencia_p timestamp, ds_atributo_p text) FROM PUBLIC;
