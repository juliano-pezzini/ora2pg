-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_uk_cotacao () AS $body$
DECLARE


ds_retorno_w	varchar(100);


BEGIN

/* DROPA 1 UK*/

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE COT_COMPRA_FORN_ITEM_TR DROP CONSTRAINT COCOFOT_UK', ds_retorno_w);
delete	from INDICE_ATRIBUTO
where	nm_tabela = 'COT_COMPRA_FORN_ITEM_TR'
and	nm_indice = 'COCOFOT_UK';
delete	from indice
where	nm_tabela = 'COT_COMPRA_FORN_ITEM_TR'
and	nm_indice = 'COCOFOT_UK';

/* DROPA 2 UK*/

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE COT_COMPRA_FORN DROP CONSTRAINT COCOFOR_UK', ds_retorno_w);
delete	from INDICE_ATRIBUTO
where	nm_tabela = 'COT_COMPRA_FORN'
and	nm_indice = 'COCOFOR_UK';
delete	from indice
where	nm_tabela = 'COT_COMPRA_FORN'
and	nm_indice = 'COCOFOR_UK';

/* DROPA 3 UK E AS REFERENCIAS A ESTA UK*/

ds_retorno_w := Executar_SQL_Dinamico('  ALTER TABLE COT_COMPRA_ITEM DROP CONSTRAINT COCOITE_COCOFOA_FK', ds_retorno_w);
delete	from INTEGRIDADE_ATRIBUTO
where	nm_tabela = 'COT_COMPRA_FORN_ITEM'
and	nm_INTEGRIDADE_REFERENCIAL =  'COCOITE_COCOFOA_FK';
delete 	from INTEGRIDADE_REFERENCIAL
where	nm_tabela = 'COT_COMPRA_FORN_ITEM'
and	nm_INTEGRIDADE_REFERENCIAL =  'COCOITE_COCOFOA_FK';

ds_retorno_w := Executar_SQL_Dinamico('  ALTER TABLE COT_COMPRA_ITEM DROP CONSTRAINT COCOITE_COCOFOS_FK', ds_retorno_w);
delete	from INTEGRIDADE_ATRIBUTO
where	nm_tabela = 'COT_COMPRA_ITEM'
and	nm_INTEGRIDADE_REFERENCIAL =  'COCOITE_COCOFOS_FK';
delete 	from INTEGRIDADE_REFERENCIAL
where	nm_tabela = 'COT_COMPRA_ITEM'
and	nm_INTEGRIDADE_REFERENCIAL =  'COCOITE_COCOFOS_FK';

ds_retorno_w := Executar_SQL_Dinamico('  ALTER TABLE COT_COMPRA_ITEM DROP CONSTRAINT COCOITE_COCOFOA_FK', ds_retorno_w);
delete	from INTEGRIDADE_ATRIBUTO
where	nm_tabela = 'COT_COMPRA_ITEM'
and	nm_INTEGRIDADE_REFERENCIAL =  'COCOITE_COCOFOA_FK';
delete 	from INTEGRIDADE_REFERENCIAL
where	nm_tabela = 'COT_COMPRA_ITEM'
and	nm_INTEGRIDADE_REFERENCIAL =  'COCOITE_COCOFOA_FK';

ds_retorno_w := Executar_SQL_Dinamico('  ALTER TABLE COT_COMPRA_FORN_ITEM DROP CONSTRAINT COCOFOI_UK', ds_retorno_w);
delete	from INDICE_ATRIBUTO
where	nm_tabela = 'COT_COMPRA_FORN_ITEM'
and	nm_indice = 'COCOFOI_UK';
delete	from indice
where	nm_tabela = 'COT_COMPRA_FORN_ITEM'
and	nm_indice = 'COCOFOI_UK';

/* AJUSTA OS INDICES*/

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE COT_COMPRA_ITEM DROP CONSTRAINT COCOITE_COCOFOI_I', ds_retorno_w);
	delete	from INDICE_ATRIBUTO
	where	nm_tabela = 'COT_COMPRA_ITEM'
	and	nm_indice = 'COCOITE_COCOFOI_I';
	delete	from indice
	where	nm_tabela = 'COT_COMPRA_ITEM'
	and	nm_indice = 'COCOITE_COCOFOI_I';

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE COT_COMPRA_ITEM DROP CONSTRAINT COCOITE_COCOFOA_I', ds_retorno_w);
	delete	from INDICE_ATRIBUTO
	where	nm_tabela = 'COT_COMPRA_ITEM'
	and	nm_indice = 'COCOITE_COCOFOA_I';
	delete	from indice
	where	nm_tabela = 'COT_COMPRA_ITEM'
	and	nm_indice = 'COCOITE_COCOFOA_I';

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_uk_cotacao () FROM PUBLIC;

