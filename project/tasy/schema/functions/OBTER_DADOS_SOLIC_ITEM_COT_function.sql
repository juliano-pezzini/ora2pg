-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_solic_item_cot ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
ie_opcao
U - ie_urgente
C - cd_centro_custo
L - cd_local_estoque
S - nr_solic_compra
CC - Conta Contabil
*/
			
cd_local_estoque_w			solic_compra.cd_local_estoque%type;
cd_centro_custo_w			solic_compra.cd_centro_custo%type;
nr_solic_compra_w			cot_compra_item.nr_solic_compra%type;
nr_item_solic_compra_w		cot_compra_item.nr_item_solic_compra%type;
ds_retorno_w				varchar(20);
ie_urgente_w				solic_compra.ie_urgente%type;
cd_conta_contabil_w			solic_compra.cd_conta_contabil%type;
cd_conta_contabil_ww		solic_compra.cd_conta_contabil%type;

c01 CURSOR FOR
SELECT a.nr_solic_compra,
       a.nr_item_solic_compra
from	cot_compra_item a
where	a.nr_cot_compra		= nr_cot_compra_p
and	a.nr_item_cot_compra	= nr_item_cot_compra_p
and	(a.nr_solic_compra IS NOT NULL AND a.nr_solic_compra::text <> '')

union

SELECT b.nr_solic_compra,
       b.nr_item_solic_compra
from   cot_compra_item a,
       cot_compra_solic_agrup b
where	a.nr_cot_compra		= b.nr_cot_compra
and	a.nr_item_cot_compra	= b.nr_item_cot_compra
and	a.nr_cot_compra		= nr_cot_compra_p
and	a.nr_item_cot_compra	= nr_item_cot_compra_p
and	(b.nr_solic_compra IS NOT NULL AND b.nr_solic_compra::text <> '');

BEGIN

for register_c01 in c01 loop
    nr_solic_compra_w := register_c01.nr_solic_compra;
    nr_item_solic_compra_w := register_c01.nr_item_solic_compra;
end loop;

if (ie_opcao_p = 'S') then
		ds_retorno_w := nr_solic_compra_w;
else
	select	cd_local_estoque,
		cd_centro_custo,
		coalesce(ie_urgente,'N'),
		cd_conta_contabil
	into STRICT	cd_local_estoque_w,
		cd_centro_custo_w,
		ie_urgente_w,
		cd_conta_contabil_ww
	from	solic_compra
	where	nr_solic_compra = nr_solic_compra_w;
	
	if (ie_opcao_p = 'L') then
		ds_retorno_w := cd_local_estoque_w;
	elsif (ie_opcao_p = 'C') then
		ds_retorno_w := cd_centro_custo_w;
	elsif (ie_opcao_p = 'U') then
		ds_retorno_w := ie_urgente_w;
	elsif (ie_opcao_p = 'CC') then
    	select	coalesce(cd_conta_contabil,cd_conta_contabil_ww)
        into STRICT	cd_conta_contabil_w
        from	solic_compra_item
        where	nr_solic_compra = nr_solic_compra_w
        and	nr_item_solic_compra = nr_item_solic_compra_w;

		ds_retorno_w := cd_conta_contabil_w;
	end if;
	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_solic_item_cot ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, ie_opcao_p text) FROM PUBLIC;
