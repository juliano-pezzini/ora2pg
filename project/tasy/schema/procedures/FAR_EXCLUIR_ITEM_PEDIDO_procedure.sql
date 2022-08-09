-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE far_excluir_item_pedido ( nr_seq_pedido_p bigint, nr_seq_item_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


qt_pedido_w bigint;


BEGIN

select	count(*)
into STRICT	qt_pedido_w
from	far_pedido
where	cd_estabelecimento = cd_estabelecimento_p
and	nr_sequencia = nr_seq_pedido_p;

if (qt_pedido_w > 0) then

	delete from far_pedido_item
	where nr_seq_pedido = nr_seq_pedido_p
	and	nr_seq_item = nr_seq_item_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE far_excluir_item_pedido ( nr_seq_pedido_p bigint, nr_seq_item_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
