-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_oc_reg_compra ( nr_seq_licitacao_p bigint, nr_seq_reg_lic_item_p bigint, nr_seq_reg_compra_p bigint) RETURNS bigint AS $body$
DECLARE

 
nr_ordem_compra_w			bigint;


BEGIN 
 
select	max(a.nr_ordem_compra) 
into STRICT	nr_ordem_compra_w 
from	ordem_compra a, 
	ordem_compra_item b 
where	a.nr_ordem_compra		= b.nr_ordem_compra 
and	a.nr_seq_licitacao		= nr_seq_licitacao_p 
and	a.nr_seq_reg_lic_compra	= nr_seq_reg_compra_p 
and	b.nr_seq_reg_lic_item	= nr_seq_reg_lic_item_p;
 
return	nr_ordem_compra_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_oc_reg_compra ( nr_seq_licitacao_p bigint, nr_seq_reg_lic_item_p bigint, nr_seq_reg_compra_p bigint) FROM PUBLIC;

