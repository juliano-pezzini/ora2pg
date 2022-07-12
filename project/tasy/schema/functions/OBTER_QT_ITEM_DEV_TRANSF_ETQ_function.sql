-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_item_dev_transf_etq ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, nr_seq_nf_entrada_p bigint, nr_item_nf_entrada_p bigint) RETURNS bigint AS $body$
DECLARE

qt_devolucao_w	double precision;

BEGIN
select	coalesce(sum(qt_material),0)
into STRICT	qt_devolucao_w
from	w_ordem_compra_item_dev
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p
and	nr_seq_nf_entrada = nr_seq_nf_entrada_p
and	nr_item_nf_entrada = nr_item_nf_entrada_p;

return	qt_devolucao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_item_dev_transf_etq ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, nr_seq_nf_entrada_p bigint, nr_item_nf_entrada_p bigint) FROM PUBLIC;
