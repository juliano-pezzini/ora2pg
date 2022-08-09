-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_brasindice_preco_pk3 () AS $body$
DECLARE


qt_col_w	bigint;
nr_sequencia_W	bigint;
ie_w		varchar(1);
qt_existe_w	bigint;


BEGIN

select 	count(*)
into STRICT	qt_col_w
from 	user_cons_columns
where 	constraint_name = 'BRAPREC_PK'
and	column_name	= 'NR_SEQUENCIA';

if (qt_col_w	= 0) then
	begin

	select	count(*)
	into STRICT	qt_existe_w
	from	user_tab_columns
	where	table_name	= 'BRASINDICE_PRECO'
	and	column_name	= 'NR_SEQUENCIA'
	and	nullable	= 'Y';

	if (qt_existe_w > 0) then

		begin
		CALL Exec_Sql_Dinamico('BRAPREC_PK',   ' alter table BRASINDICE_PRECO modify (nr_sequencia number(10,0) not null) ');
		exception
			when others then
			ie_w:= 'S';
		end;
	end if;

	select	count(*)
	into STRICT	qt_existe_w
	from	user_constraints
	where	CONSTRAINT_NAME = 'BRAPREC_PK';

	if (qt_existe_w > 0) then
		begin
		CALL Exec_Sql_Dinamico('BRAPREC_PK',   ' alter table BRASINDICE_PRECO drop constraint BRAPREC_PK ');
		exception
			when others then
			ie_w:= 'S';
		end;
	end if;

	select	count(*)
	into STRICT	qt_existe_w
	from	user_indexes
	where	INDEX_NAME = 'BRAPREC_PK';

	if (qt_existe_w > 0) then

		begin
		CALL Exec_Sql_Dinamico('BRAPREC_PK',   ' drop index BRAPREC_PK ');
		exception
			when others then
			ie_w:= 'S';
		end;

	end if;

	select	count(*)
	into STRICT	qt_existe_w
	from	user_constraints
	where	CONSTRAINT_NAME = 'BRAPREC_PK';


	if (qt_existe_w = 0) THEN
		begin
		CALL Exec_Sql_Dinamico('BRAPREC_PK',   ' alter table BRASINDICE_PRECO add ( CONSTRAINT BRAPREC_PK Primary Key (nr_sequencia)) ');
		exception
			when others then
			ie_w:= 'S';
		end;
	END IF;

	select	count(*)
	into STRICT	qt_existe_w
	from	user_tab_columns
	where	table_name	= 'BRASINDICE_PRECO'
	and	column_name	= 'NR_SEQUENCIA'
	and	nullable	= 'Y';

	if (qt_existe_w = 0) then

		UPDATE 	tabela_atributo
		SET	IE_OBRIGATORIO = 'S'
		where  nm_tabela 	= 'BRASINDICE_PRECO'
		and    nm_atributo 	= 'NR_SEQUENCIA';

	end if;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_brasindice_preco_pk3 () FROM PUBLIC;
