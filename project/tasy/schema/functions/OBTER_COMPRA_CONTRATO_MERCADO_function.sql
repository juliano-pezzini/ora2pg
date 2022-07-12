-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_compra_contrato_mercado ( nr_sequencia_p bigint, nr_item_nf_p bigint) RETURNS varchar AS $body$
DECLARE

 
cd_material_w		bigint;
ie_retorno_w		varchar(1) := 'N';
ie_contrato_w		varchar(1);
nr_contrato_w		bigint;
			

BEGIN 
 
select	coalesce(max(cd_material),0), 
	coalesce(max(nr_contrato),0) 
into STRICT	cd_material_w, 
	nr_contrato_w 
from	nota_fiscal_item 
where	nr_sequencia = nr_sequencia_p 
and	nr_item_nf = nr_item_nf_p;
 
if (cd_material_w > 0) then 
	 
	select	obter_se_item_contrato(cd_material_w) 
	into STRICT	ie_contrato_w 
	;
	 
	if (ie_contrato_w = 'S') and (nr_contrato_w > 0) then 
		ie_retorno_w := 'C'; /*O item é de contrato e foi comprador por contrato*/
	end if;
		 
	if (ie_contrato_w = 'S') and (nr_contrato_w = 0) then 
		ie_retorno_w := 'M'; /*O item é de contrato mas não foi comprador por contrato*/
	end if;
end if;
 
 
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_compra_contrato_mercado ( nr_sequencia_p bigint, nr_item_nf_p bigint) FROM PUBLIC;
