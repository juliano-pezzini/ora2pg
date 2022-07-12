-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_nr_solic_compra_item (nr_ordem_compra_p bigint, nr_item_oci_p bigint) RETURNS bigint AS $body$
DECLARE

 
ds_retorno_w	solic_compra_item.nr_solic_compra%type;


BEGIN 
 
select	max(a.nr_solic_compra) 
into STRICT	ds_retorno_w 
from	solic_compra a, 
	solic_compra_item b 
where	a.nr_solic_compra = b.nr_solic_compra 
and	coalesce(a.nr_seq_motivo_cancel::text, '') = '' 
and	coalesce(b.nr_seq_motivo_cancel::text, '') = '' 
and	b.nr_ordem_compra_orig = nr_ordem_compra_p 
and	b.nr_item_oci_orig = nr_item_oci_p;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_nr_solic_compra_item (nr_ordem_compra_p bigint, nr_item_oci_p bigint) FROM PUBLIC;

