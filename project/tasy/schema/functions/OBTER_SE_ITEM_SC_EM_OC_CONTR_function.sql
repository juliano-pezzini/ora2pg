-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_sc_em_oc_contr ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) RETURNS varchar AS $body$
DECLARE

 
nr_ordem_compra_w	bigint;
nr_contrato_w		bigint;
ie_contrato_w		varchar(1) := 'N';


BEGIN 
 
select	coalesce(obter_ordem_solic_compra(nr_solic_compra_p, nr_item_solic_compra_p),0) 
into STRICT	nr_ordem_compra_w
;
 
if (nr_ordem_compra_w > 0) then 
	select	coalesce(max(nr_contrato),0) 
	into STRICT	nr_contrato_w 
	from	ordem_compra_item 
	where	nr_solic_compra = nr_solic_compra_p 
	and	nr_item_solic_compra = nr_item_solic_compra_p;
	 
	if (nr_contrato_w > 0) then 
		ie_contrato_w := 'S';
	end if;
end if;
 
return	ie_contrato_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_sc_em_oc_contr ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) FROM PUBLIC;

