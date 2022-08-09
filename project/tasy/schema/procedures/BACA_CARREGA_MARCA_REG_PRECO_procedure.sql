-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_carrega_marca_reg_preco ( nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w				bigint;
nr_seq_lic_item_fornec_w			bigint;
ds_marca_w				varchar(255);

c01 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_lic_item_fornec
from	reg_compra_item
where	coalesce(dt_cancelamento::text, '') = '';


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	nr_seq_lic_item_fornec_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(ds_marca)
	into STRICT	ds_marca_w
	from	reg_lic_item_fornec
	where	nr_sequencia = nr_seq_lic_item_fornec_w;

	update	reg_compra_item
	set	ds_marca		= ds_marca_w,
		ds_marca_original	= ds_marca_w
	where	nr_sequencia		= nr_sequencia_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_carrega_marca_reg_preco ( nm_usuario_p text) FROM PUBLIC;
