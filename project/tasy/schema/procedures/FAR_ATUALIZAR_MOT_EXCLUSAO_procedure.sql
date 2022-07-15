-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE far_atualizar_mot_exclusao ( nr_seq_motivo_p bigint, nr_seq_pedido_p bigint, nr_seq_item_p bigint, cd_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_rateado_w double precision;


BEGIN

select	vl_rateado
into STRICT	vl_rateado_w
from	far_pedido_item
where	nr_seq_pedido = nr_seq_pedido_p
and		nr_seq_item = nr_seq_item_p;

update	far_pedido_item
set	nr_seq_motivo_exclusao = nr_seq_motivo_p,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where	nr_seq_pedido = nr_seq_pedido_p
and	nr_seq_item = nr_seq_item_p
and	cd_material = cd_material_p;

update	far_pedido
set		vl_desconto = (vl_desconto - vl_rateado_w)
where	nr_sequencia = nr_seq_pedido_p;

commit;
CALL far_atualizar_vl_total_ped(nr_seq_pedido_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE far_atualizar_mot_exclusao ( nr_seq_motivo_p bigint, nr_seq_pedido_p bigint, nr_seq_item_p bigint, cd_material_p bigint, nm_usuario_p text) FROM PUBLIC;

