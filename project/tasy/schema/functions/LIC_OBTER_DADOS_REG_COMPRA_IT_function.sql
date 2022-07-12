-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_dados_reg_compra_it ( nr_seq_reg_compra_p bigint, nr_seq_lic_item_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* 
ie_opcao_p 
F - Nome do fornecedor */
 
 
 
ds_fornecedor_w			varchar(100);
ds_resultado_w			varchar(100);

			 

BEGIN 
 
select	max(obter_fornec_reg_lic_fornec(nr_seq_fornec)) 
into STRICT	ds_fornecedor_w 
from	reg_compra_item 
where	nr_seq_reg_compra	= nr_seq_reg_compra_p 
and	nr_seq_lic_item	= nr_seq_lic_item_p;
 
if (ie_opcao_p = 'F') then 
	ds_resultado_w	:= ds_fornecedor_w;
end if;
 
return	ds_resultado_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_dados_reg_compra_it ( nr_seq_reg_compra_p bigint, nr_seq_lic_item_p bigint, ie_opcao_p text) FROM PUBLIC;
