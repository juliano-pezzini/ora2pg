-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_seq_entrega_oci ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, dt_entrega_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w		ordem_compra_item_entrega.nr_sequencia%type;


BEGIN

select	min(b.nr_sequencia)
into STRICT	nr_sequencia_w
from	ordem_compra_item_entrega b,
	ordem_compra_item a
where	a.nr_ordem_compra	= nr_ordem_compra_p
and	a.nr_item_oci		= nr_item_oci_p
and	a.nr_ordem_compra	= b.nr_ordem_compra
and	a.nr_item_oci		= b.nr_item_oci
and	coalesce(b.dt_cancelamento::text, '') = ''
and	trunc(b.dt_prevista_entrega,'dd') = trunc(dt_entrega_p,'dd');

return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_seq_entrega_oci ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, dt_entrega_p timestamp) FROM PUBLIC;

