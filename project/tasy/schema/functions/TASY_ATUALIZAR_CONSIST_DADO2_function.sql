-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tasy_atualizar_consist_dado2 (nm_owner_origem_p text) RETURNS varchar AS $body$
DECLARE


nm_tabela_w	varchar(50);
qt_rows_tabela	bigint;
qt_rows_tabela_import	bigint;
ds_retorno	varchar(255);
ds_inconsistencias_p varchar(4000);

C01 CURSOR FOR
	SELECT	table_name
	from 	user_tables ut,
		tabela_sistema ts
	where	ts.nm_tabela = ut.table_name
	and	ts.ie_exportar = 'S'
	and	upper(ut.table_name) in (	'INDICE',
						'INDICE_ATRIBUTO',
						'INTEGRIDADE_ATRIBUTO',
						'INTEGRIDADE_REFERENCIAL',
						'OBJETO_SISTEMA_PARAM',
						'DIC_OBJETO',
						'DIC_OBJETO_FILTRO',
						'FUNCAO_PARAMETRO',
						'XML_PROJETO',
						'XML_ATRIBUTO',
						'XML_ELEMENTO');


BEGIN
ds_retorno	:= '';

open C01;
loop
fetch C01 into
	nm_tabela_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		begin
			EXECUTE 'select (select (count(1) + 25) from ' || nm_tabela_w || '), (select count(1) from ' || nm_owner_origem_p || '.' || nm_tabela_w || ') from dual'
			into STRICT qt_rows_tabela, qt_rows_tabela_import;

			if (qt_rows_tabela) < qt_rows_tabela_import then
				ds_retorno := ds_retorno || nm_tabela_w || ': ' || qt_rows_tabela || ', ' || qt_rows_tabela_import || '.'|| chr(13) || chr(10);
			end if;
		exception
			WHEN OTHERS THEN
				null;
		end;
	end;
end loop;

close C01;

return ds_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tasy_atualizar_consist_dado2 (nm_owner_origem_p text) FROM PUBLIC;
