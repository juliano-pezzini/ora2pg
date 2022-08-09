-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_vl_nota_qualidade () AS $body$
DECLARE


qt_existe_w	bigint;


BEGIN
select	count(*)
into STRICT	qt_existe_w
from	user_tab_columns
where	table_name	= 'QUA_DOC_TREIN_PESSOA'
and	column_name	= 'VL_NOTA'
and	data_precision	= 10;

if (qt_existe_w > 0) then
	begin
	qt_existe_w := obter_valor_dinamico('select count(*) from user_tables where table_name = ' || chr(39) || 'BKP_QUA_DOC_TREIN_PESSOA' || chr(39), qt_existe_w);

	if (qt_existe_w = 0) then
		begin
		CALL exec_sql_dinamico('Anderson','create table BKP_QUA_DOC_TREIN_PESSOA as (select * from QUA_DOC_TREIN_PESSOA)');

		CALL exec_sql_dinamico('Anderson','alter table QUA_DOC_TREIN_PESSOA add vl_nota2 number(10,0)');

		CALL exec_sql_dinamico('Anderson','update QUA_DOC_TREIN_PESSOA set vl_nota2 = vl_nota ');

		CALL exec_sql_dinamico('Anderson','update QUA_DOC_TREIN_PESSOA set vl_nota = null');

		CALL exec_sql_dinamico('Anderson','alter table QUA_DOC_TREIN_PESSOA modify vl_nota number(05,2)');

		CALL exec_sql_dinamico('Anderson','update QUA_DOC_TREIN_PESSOA set vl_nota = substr(vl_nota2,1,3) ');

		CALL exec_sql_dinamico('Anderson','alter table QUA_DOC_TREIN_PESSOA drop column vl_nota2');
		end;
	end if;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_vl_nota_qualidade () FROM PUBLIC;
