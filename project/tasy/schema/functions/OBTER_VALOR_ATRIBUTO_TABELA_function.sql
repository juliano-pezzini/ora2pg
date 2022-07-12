-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_atributo_tabela ( nm_tabela_p text, nm_atributo_p text, ds_sql_where_p text, ds_parametros_p text) RETURNS varchar AS $body$
DECLARE


vl_atributo_w	varchar(2000);
ds_comando_w	varchar(2000);


BEGIN
if (nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '') and (nm_atributo_p IS NOT NULL AND nm_atributo_p::text <> '') then
	begin
	ds_comando_w :=	'select ' || nm_atributo_p ||
			' from ' || nm_tabela_p ||
			' where 1=1 ' || ds_sql_where_p;

	CALL exec_sql_dinamico_bv('Tasy', ds_comando_w, ds_parametros_p);
	end;
end if;
return vl_atributo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_atributo_tabela ( nm_tabela_p text, nm_atributo_p text, ds_sql_where_p text, ds_parametros_p text) FROM PUBLIC;
