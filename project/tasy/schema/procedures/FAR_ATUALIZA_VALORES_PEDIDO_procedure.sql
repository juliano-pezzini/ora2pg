-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE far_atualiza_valores_pedido ( nr_seq_pedido_p bigint, vl_desconto_p bigint, vl_total_p bigint, vl_troco_p bigint, vl_entrega_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_pedido_w bigint;


BEGIN

select count(*)
into STRICT	qt_pedido_w
from	far_pedido
where nr_sequencia = nr_seq_pedido_p;


if (qt_pedido_w > 0) then

update far_pedido
	set	vl_desconto = vl_desconto_p,
		vl_entrega = vl_entrega_p,
		vl_total = vl_total_p,
		vl_troco = vl_troco_p,
		dt_emissao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		ie_status_pedido = 'P',
		dt_fechamento  = clock_timestamp()
	where	nr_sequencia = nr_seq_pedido_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE far_atualiza_valores_pedido ( nr_seq_pedido_p bigint, vl_desconto_p bigint, vl_total_p bigint, vl_troco_p bigint, vl_entrega_p bigint, nm_usuario_p text) FROM PUBLIC;
