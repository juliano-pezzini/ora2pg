-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acerto_nf_trib () AS $body$
DECLARE


qt_existe_w		bigint;

/*

dsantos em 15/01/2011 baca desenvolvido para alterar a PK da tabela nota_fiscal_trib, e a tabela titulo_receber_trib

1. DROPAR FK DA TITULO_RECEBER_TRIB
2. DROPAR INDICE DA TITULO_RECEBER_TRIB TITRETR_NOTFITR_FK_I
3. DROPAR PK DA NOTA_FISCAL_TRIB
4. CARREGAR NOVA SEQUENCE NO CAMPO NOTA_FISCAL_TRIB.NR_SEQ_INTERNO
5. ALTERAR CAMPO NOTA_FISCAL_TRIB.NR_SEQ_INTERNO PARA NOT NULL
6. CRIAR PK NOVA DA NOTA_FISCAL_TRIB
7. CARREGAR TITULO_RECEBER_TRIB.NR_SEQ_NF_TRIB com a NR_SEQ_INTERNO CORRETO
8. CRIAR INTEGRIDADE DA TITULO_RECEBER_TRIB.NR_SEQ_NF_TRIB COM NOTA_FISCAL_TRIB
9. CRIAR INDICE DA TITULO_RECEBER_TRIB.NR_SEQ_NF_TRIB

*/
cont_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	user_indexes
where	index_name = 'TITRETR_NOTFITR_FK_I';

if (qt_existe_w > 0) then
	CALL Exec_Sql_Dinamico('TASY', 'drop index TITRETR_NOTFITR_FK_I');								-- 1
end if;

select	count(*)
into STRICT	qt_existe_w
from	user_constraints
where	table_name = 'TITULO_RECEBER_TRIB'
and	constraint_name = 'TITRETR_NOTFITR_FK';

if (qt_existe_w > 0) then
	CALL Exec_Sql_Dinamico('TASY', 'alter table	TITULO_RECEBER_TRIB drop constraint TITRETR_NOTFITR_FK');				-- 2
end if;

select	count(*)
into STRICT	qt_existe_w
from	user_constraints
where	table_name = 'NOTA_FISCAL_TRIB'
and	constraint_name = 'NOTFITR_PK';

if (qt_existe_w > 0) then
	CALL Exec_Sql_Dinamico('TASY', 'alter table	NOTA_FISCAL_TRIB drop constraint NOTFITR_PK');					-- 3
end if;

select	count(*)
into STRICT	qt_existe_w
from	user_indexes
where	index_name = 'NOTFITR_PK';

if (qt_existe_w > 0) then
	CALL Exec_Sql_Dinamico('TASY', 'drop index NOTFITR_PK');								-- 1
end	if;

select	count(*)
into STRICT	cont_w
from	nota_fiscal_trib a
where	coalesce(a.nr_seq_interno::text, '') = '';

while	cont_w > 0 loop

	update	nota_fiscal_trib a
	set	a.nr_seq_interno		= nextval('nota_fiscal_trib_seq')
	where	coalesce(a.nr_seq_interno::text, '') = ''  LIMIT 2000;

	commit;

	cont_w	:= cont_w - 1999;
end loop;														-- 4
CALL Exec_Sql_Dinamico('TASY',' alter table NOTA_FISCAL_TRIB modify NR_SEQ_INTERNO NOT NULL ');				-- 5
CALL Exec_Sql_Dinamico('TASY',' ALTER TABLE NOTA_FISCAL_TRIB ADD ( ' ||
 	' CONSTRAINT NOTFITR_PK Primary Key  (NR_SEQ_INTERNO)) ' );			-- 6
select	count(*)
into STRICT	cont_w
from	titulo_receber_trib a
where	coalesce(a.nr_seq_nf_trib::text, '') = '';

while	cont_w > 0 loop

	update	titulo_receber_trib a
	set	a.nr_seq_nf_trib 		=	(
						SELECT	b.nr_seq_interno
						from	nota_fiscal_trib b
						where	b.nr_sequencia	= a.nr_seq_nota_fiscal
						and	b.cd_tributo	= a.cd_tributo
						)
	where	coalesce(a.nr_seq_nf_trib::text, '') = ''  LIMIT 2000;

	commit;

	cont_w	:= cont_w - 1999;
end loop;														-- 7
CALL Exec_Sql_Dinamico('TASY',' ALTER TABLE TITULO_RECEBER_TRIB ADD ' ||
			 ' (CONSTRAINT TITRETR_NOTFITR_FK FOREIGN KEY (NR_SEQ_NF_TRIB) ' ||
			 ' REFERENCES NOTA_FISCAL_TRIB (NR_SEQ_INTERNO)) ' );					-- 8
CALL Exec_Sql_Dinamico('TASY',' CREATE INDEX TITRETR_NOTFITR_FK_I ON TITULO_RECEBER_TRIB(NR_SEQ_NF_TRIB)');		-- 9
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acerto_nf_trib () FROM PUBLIC;

