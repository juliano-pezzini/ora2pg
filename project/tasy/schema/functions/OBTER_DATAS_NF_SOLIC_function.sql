-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_datas_nf_solic ( nr_solic_compra_p bigint, ie_opcao_p bigint) RETURNS timestamp AS $body$
DECLARE


/* ie_opcao_p
0 - dt_entrada_saida*/
dt_entrada_saida_w		timestamp;
nr_sequencia_w			bigint;
ds_retorno_w			timestamp;


BEGIN

select	coalesce(max(a.nr_sequencia),0)
into STRICT	nr_sequencia_w
from	nota_fiscal_item a
where	a.nr_solic_compra = nr_solic_compra_p;

if (nr_sequencia_w > 0) then
	select	dt_entrada_saida
	into STRICT	dt_entrada_saida_w
	from	nota_fiscal
	where	nr_sequencia = nr_Sequencia_w;

else
	nr_sequencia_w := null;
end if;

if (ie_opcao_p = 0) then
	ds_retorno_w	:= dt_entrada_saida_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_datas_nf_solic ( nr_solic_compra_p bigint, ie_opcao_p bigint) FROM PUBLIC;

