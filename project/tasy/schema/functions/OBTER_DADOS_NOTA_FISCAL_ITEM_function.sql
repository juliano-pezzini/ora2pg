-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_nota_fiscal_item (nr_seq_nota_p bigint, nr_item_nf_p bigint, ie_retorno_w text) RETURNS varchar AS $body$
DECLARE


/*
ie_retorno_w
SC = Nº Solicitação de compra
LE = Código do Local de estoque
DV = Data de validade
*/
nr_solic_compra_w	bigint;
cd_local_estoque_w	smallint;
dt_validade_w		timestamp;
vl_retorno_w		varchar(255);


BEGIN
if (ie_retorno_w = 'SC') then
	begin
	select 	max(a.nr_solic_compra)
	into STRICT	nr_solic_compra_w
	from	nota_fiscal_item a,
		ordem_compra_item b
	where	a.nr_ordem_compra = b.nr_ordem_compra
	and	a.nr_item_oci = b.nr_item_oci
	and	a.nr_item_nf = nr_item_nf_p
	and	a.nr_sequencia = nr_seq_nota_p;
	vl_retorno_w := to_char(nr_solic_compra_w);
	end;
end if;

if (ie_retorno_w = 'LE') then
	begin
	select 	max(a.cd_local_estoque)
	into STRICT	cd_local_estoque_w
	from	nota_fiscal_item a
	where	a.nr_item_nf = nr_item_nf_p
	and	a.nr_sequencia = nr_seq_nota_p;
	vl_retorno_w := to_char(cd_local_estoque_w);
	end;
end if;

if (ie_retorno_w = 'DV') then
	begin
	select 	max(a.dt_validade)
	into STRICT	dt_validade_w
	from	nota_fiscal_item a
	where	a.nr_item_nf = nr_item_nf_p
	and	a.nr_sequencia = nr_seq_nota_p;
	vl_retorno_w := to_char(dt_validade_w);
	end;

end if;

return	vl_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_nota_fiscal_item (nr_seq_nota_p bigint, nr_item_nf_p bigint, ie_retorno_w text) FROM PUBLIC;
