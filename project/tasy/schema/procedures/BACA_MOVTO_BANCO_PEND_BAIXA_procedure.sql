-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_movto_banco_pend_baixa () AS $body$
DECLARE


qt_registros_w		bigint;


BEGIN

select 	count(*)
into STRICT	qt_registros_w
from 	MOVTO_BANCO_PEND_BAIXA a
where 	not exists (SELECT	1
	from	TITULO_RECEBER_LIQ b
	where 	a.NR_TITULO 	= b.NR_TITULO
	and 	a.NR_SEQ_BAIXA 	= b.NR_SEQUENCIA)
and 	(a.NR_TITULO IS NOT NULL AND a.NR_TITULO::text <> '')
and 	(a.NR_SEQ_BAIXA IS NOT NULL AND a.NR_SEQ_BAIXA::text <> '');

if (qt_registros_w > 0) then

	CALL Exec_Sql_Dinamico('MOVBCOPBAI_TIRELIQ_FK',	' update MOVTO_BANCO_PEND_BAIXA a set a.NR_TITULO = null, a.NR_SEQ_BAIXA = null '||
							' where not exists (select 1 from TITULO_RECEBER_LIQ b where a.NR_TITULO = b.NR_TITULO and a.NR_SEQ_BAIXA = b.NR_SEQUENCIA) '||
							' and a.NR_TITULO is not null and a.NR_SEQ_BAIXA is not null ');

	CALL Exec_Sql_Dinamico('MOVBCOPBAI_TIRELIQ_FK', 	' Alter Table MOVTO_BANCO_PEND_BAIXA drop Constraint MOVBCOPBAI_TIRELIQ_FK ');

	CALL Exec_Sql_Dinamico('MOVBCOPBAI_TIRELIQ_FK', 	' Alter Table MOVTO_BANCO_PEND_BAIXA add ( Constraint MOVBCOPBAI_TIRELIQ_FK Foreign Key ( NR_TITULO,NR_SEQ_BAIXA) '||
							' References TITULO_RECEBER_LIQ (NR_TITULO,NR_SEQUENCIA)) ');
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_movto_banco_pend_baixa () FROM PUBLIC;
