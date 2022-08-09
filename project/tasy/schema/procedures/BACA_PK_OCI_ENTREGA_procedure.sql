-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pk_oci_entrega () AS $body$
DECLARE


qt_registro_w			bigint;
nr_sequencia_w		bigint;
nr_ordem_compra_w		bigint;
nr_item_oci_w			integer;
dt_prevista_entrega_w	timestamp;
ds_retorno_w			varchar(100);



/*-------------------- Primeira parte ----------------------------------- */

/* Carrega o campo NR_SEQUENCIA da tabela ORDEM_COMPRA_ITEM_ENTREGA */

c01 CURSOR FOR

SELECT	nr_ordem_compra,
	nr_item_oci,
	dt_prevista_entrega
from	ordem_compra_item_entrega
where	coalesce(nr_sequencia::text, '') = '';


BEGIN

open c01;
loop
	fetch c01 into
		nr_ordem_compra_w,
		nr_item_oci_w,
		dt_prevista_entrega_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	nextval('ordem_compra_item_entrega_seq')
	into STRICT	nr_sequencia_w
	;

	update	ordem_compra_item_entrega
	set	nr_sequencia = nr_sequencia_w
	where	nr_ordem_compra = nr_ordem_compra_w
	and	nr_item_oci = nr_item_oci_w
	and	dt_prevista_entrega = dt_prevista_entrega_w;

	end;
end loop;
close c01;

commit;


/* ------------------- Segunda parte -------------------------------- */

/* Dropa o indice (ORCOIEE_PK) e as PK's dos campos NR_ORDEM_COMPRA, NR_ITEM_OCI, DT_PREVISTA_ENTREGA */

ds_retorno_w := Executar_SQL_Dinamico(' DROP INDEX ORCOIEE_PK', ds_retorno_w);
ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE ORDEM_COMPRA_ITEM_ENTREGA DROP CONSTRAINT ORCOIEE_PK', ds_retorno_w);

delete	from INDICE_ATRIBUTO
where	nm_tabela = 'ORDEM_COMPRA_ITEM_ENTREGA'
and	nm_indice = 'ORCOIEE_PK';

delete	from INDICE
where	nm_tabela = 'ORDEM_COMPRA_ITEM_ENTREGA'
and	nm_indice = 'ORCOIEE_PK';




/* Dropa o indice (ORDCOIE_PK) e a PK do campo NR_SEQUENCIA */

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE ORDEM_COMPRA_ITEM_ENTREGA DROP CONSTRAINT ORDCOIE_PK', ds_retorno_w);
ds_retorno_w := Executar_SQL_Dinamico(' DROP INDEX ORDCOIE_PK', ds_retorno_w);

delete	from INDICE_ATRIBUTO
where	nm_tabela = 'ORDEM_COMPRA_ITEM_ENTREGA'
and	nm_indice = 'ORDCOIE_PK';

delete	from INDICE
where	nm_tabela = 'ORDEM_COMPRA_ITEM_ENTREGA'
and	nm_indice = 'ORDCOIE_PK';



/*Cria o indice (ORDCOIE_PK) e a PK para o campo NR_SEQUENCIA */

ds_retorno_w := Executar_SQL_Dinamico(' 	ALTER TABLE ORDEM_COMPRA_ITEM_ENTREGA ADD
			(	CONSTRAINT ORDCOIE_PK   Primary Key  (NR_SEQUENCIA)) ', ds_retorno_w);
	insert into INDICE(
		nm_tabela,
		nm_indice,
		ie_tipo,
		dt_atualizacao,
		nm_usuario,
		ds_indice,
		ie_criar_alterar,
		ie_situacao,
		dt_criacao)
	values ('ORDEM_COMPRA_ITEM_ENTREGA',
		'ORDCOIE_PK',
		'PK',
		clock_timestamp(),
		'Tasy',
		'',
		'I',
		'A',
		clock_timestamp());

	insert	into INDICE_ATRIBUTO(
		nm_tabela,
		nm_indice,
		nr_sequencia,
		nm_atributo,
		dt_atualizacao,
		nm_usuario)
	values ('ORDEM_COMPRA_ITEM_ENTREGA',
		'ORDCOIE_PK',
		1,
		'NR_SEQUENCIA',
		clock_timestamp(),
		'Tasy');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pk_oci_entrega () FROM PUBLIC;
