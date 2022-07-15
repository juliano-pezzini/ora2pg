-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_integridade_tasymed () AS $body$
DECLARE



nm_tabela_w		varchar(100);
nm_integridade_w	varchar(100);
nm_indice_w		varchar(100);
ds_comando_w		varchar(255);
DS_SHORTNAME_w		varchar(100);

c01 CURSOR FOR
	SELECT	a.table_name,
		a.CONSTRAINT_NAME,
		b.ds_shortname
	from  	tabela_sistema b, user_constraints a
	where 	a.TABLE_NAME like 'MED_%'
	and b.ds_aplicacao = 'TasyMed'
	and 	a.R_CONSTRAINT_NAME = 'MEDICO_PK'
	and	a.TABLE_NAME 	= b.nm_tabela
	order by 1;

c02 CURSOR FOR
	SELECT	a.table_name,
		a.index_NAME
	from   	tabela_sistema b, user_indexes a
	where  	a.TABLE_NAME like 'MED_%'
	and 	b.ds_aplicacao = 'TasyMed'
	and	a.TABLE_NAME 	= b.nm_tabela
 	and  	a.index_NAME like '%MEDICO_FK%';


BEGIN

open	c01;
loop
fetch	c01 into
	nm_tabela_w,
	nm_integridade_w,
	DS_SHORTNAME_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ds_comando_w	:= 'alter table ' || nm_tabela_w || ' drop ' ||
			' constraint ' || nm_integridade_w;
	CALL Exec_sql_Dinamico(nm_tabela_w || '=' || nm_integridade_w, ds_comando_w);

	end;
end loop;
close c01;

open	c02;
loop
fetch	c02 into
	nm_tabela_w,
	nm_indice_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin

	ds_comando_w	:= 'drop index ' || nm_indice_w;
	CALL Exec_sql_Dinamico(nm_tabela_w || '=' || nm_indice_w, ds_comando_w);

	end;
end loop;
close c02;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_integridade_tasymed () FROM PUBLIC;

