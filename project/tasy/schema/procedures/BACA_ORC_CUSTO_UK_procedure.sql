-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_orc_custo_uk () AS $body$
DECLARE


ds_comando_w	varchar(255);
qt_registro_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	user_cons_columns
where	constraint_name	= 'ORCCUST_UK'
and	column_name	= 'NR_SEQ_NG';

if (qt_registro_w = 0) then
	CALL exec_sql_dinamico('Matheus','alter table orcamento_custo drop constraint ORCCUST_UK');

	select	count(*)
	into STRICT	qt_registro_w
	from	user_indexes
	where	index_name	= 'ORCCUST_UK';

	if (qt_registro_w > 0) then
		CALL exec_sql_dinamico('Matheus','drop index ORCCUST_UK');
	end if;
	/* Atualiza os registros */

	CALL baca_ng_pk();
	/*Cria nova UK*/

	ds_comando_w	:= 'Alter Table ORCAMENTO_CUSTO add ( Constraint ORCCUST_UK Unique ( ' ||
             'CD_ESTABELECIMENTO, CD_TABELA_CUSTO, CD_CENTRO_CONTROLE, NR_SEQ_NG, IE_TIPO_GASTO) Using Index Tablespace TASY_INDEX);';
	CALL exec_sql_dinamico('Matheus',ds_comando_w);
end if;
CALL valida_objetos_sistema();
commit;

select	count(*)
into STRICT	qt_registro_w
from	user_cons_columns
where	constraint_name	= 'ORCCUST_UK'
and	column_name	= 'NR_SEQ_NG';

if (qt_registro_w = 0) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(277976);
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_orc_custo_uk () FROM PUBLIC;

