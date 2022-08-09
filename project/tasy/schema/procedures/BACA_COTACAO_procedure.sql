-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_cotacao () AS $body$
DECLARE


nr_cot_compra_w		bigint;
cd_cgc_fornecedor_w		varchar(14);
nr_item_cot_compra_w		integer;
cd_tributo_w			integer;
nr_sequencia_w		bigint;
nr_seq_item_w			bigint;
nr_seq_item_tr_w		bigint;

C01 CURSOR FOR
	SELECT	nr_cot_compra,
		cd_cgc_fornecedor
	from	cot_compra_forn
	where	coalesce(nr_sequencia::text, '') = ''
	order by nr_cot_compra;

C02 CURSOR FOR
	SELECT	nr_item_cot_compra
	from	cot_compra_forn_item
	where	nr_cot_compra	= nr_cot_compra_w
	and	cd_cgc_fornecedor = cd_cgc_fornecedor_w
	and	coalesce(nr_sequencia::text, '') = '';

C03 CURSOR FOR
	SELECT	cd_tributo
	from	cot_compra_forn_item_tr
	where	nr_cot_compra = nr_cot_compra_w
	and	cd_cgc_fornecedor = cd_cgc_fornecedor_w
	and	nr_item_cot_compra = nr_item_cot_compra_w
	and	coalesce(nr_sequencia::text, '') = '';

BEGIN

/*
Baca criada por Fabio
Para acertar a sequencia das cotações anteriores a criação dos campos nr_sequencia
OS (9895)
Tabelas :
	cot_compra_forn
	cot_compra_forn_item
	cot_compra_forn_item_tr
*/
OPEN C01;
LOOP
FETCH C01 INTO
	nr_cot_compra_w,
	cd_cgc_fornecedor_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	nextval('cot_compra_forn_seq')
	into STRICT	nr_sequencia_w
	;

	update	cot_compra_forn
	set	nr_sequencia = nr_sequencia_w
	where	nr_cot_compra = nr_cot_compra_w
	and	cd_cgc_fornecedor = cd_cgc_fornecedor_w;

	OPEN C02;
	LOOP
	FETCH C02 INTO
		nr_item_cot_compra_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		select	nextval('cot_compra_forn_item_seq')
		into STRICT	nr_seq_item_w
		;

		update	cot_compra_forn_item
		set	nr_sequencia = nr_seq_item_w,
			nr_seq_cot_forn = nr_sequencia_w
		where	nr_cot_compra = nr_cot_compra_w
		and	cd_cgc_fornecedor = cd_cgc_fornecedor_w
		and	nr_item_cot_compra = nr_item_cot_compra_w;

		OPEN C03;
		LOOP
		FETCH C03 INTO
			cd_tributo_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			select	nextval('cot_compra_forn_item_tr_seq')
			into STRICT	nr_seq_item_tr_w
			;

			update	cot_compra_forn_item_tr
			set	nr_sequencia = nr_seq_item_tr_w,
				nr_seq_cot_item_forn = nr_seq_item_w
			where	nr_cot_compra = nr_cot_compra_w
			and	cd_cgc_fornecedor = cd_cgc_fornecedor_w
			and	nr_item_cot_compra = nr_item_cot_compra_w;
			end;
		END LOOP;
		CLOSE C03;
		end;
	END LOOP;
	CLOSE C02;
	end;

commit;

END LOOP;
CLOSE C01;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_cotacao () FROM PUBLIC;
