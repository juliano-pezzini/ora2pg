-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_data_entrega_nf_oci ( nr_seq_oci_entrega_p ordem_compra_item_entrega.nr_sequencia%type, dt_prevista_entrega_orig_p timestamp, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


dt_prevista_entrega_w	ordem_compra_item_entrega.dt_prevista_entrega%type;
nr_item_oci_w		ordem_compra_item_entrega.nr_item_oci%type;
nr_ordem_compra_w	ordem_compra_item_entrega.nr_ordem_compra%type;


BEGIN

select	b.dt_prevista_entrega,
	b.nr_item_oci,
	b.nr_ordem_compra
into STRICT	dt_prevista_entrega_w,
	nr_item_oci_w,
	nr_ordem_compra_w
from	ordem_compra_item_entrega b
where	b.nr_sequencia = nr_seq_oci_entrega_p;

if (dt_prevista_entrega_orig_p <> dt_prevista_entrega_w) then

	update	nota_fiscal_item
	set	dt_entrega_ordem = dt_prevista_entrega_w
	where	nr_ordem_compra = nr_ordem_compra_w
	and	nr_item_oci = nr_item_oci_w
	and	dt_entrega_ordem = dt_prevista_entrega_orig_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_data_entrega_nf_oci ( nr_seq_oci_entrega_p ordem_compra_item_entrega.nr_sequencia%type, dt_prevista_entrega_orig_p timestamp, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
