-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lote_validade_item_oc ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



ie_retorno_w		varchar(20);
ds_lote_fornec_w	varchar(20);
dt_validade_w		timestamp;
nr_sequencia_w	bigint;

/*ie_opcao_p
	L = Lote (Retorna o numero do lote fornecedor
	D = Data Validade (Retorna a data de validade do lote*/
BEGIN

select	coalesce(max(nr_seq_lote_fornec), 0)
into STRICT	nr_sequencia_w
from	movimento_estoque
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p;

if (nr_sequencia_w > 0) then
	select	ds_lote_fornec,
		dt_validade
	into STRICT	ds_lote_fornec_w,
		dt_validade_w
	from	material_lote_fornec
	where	nr_sequencia = nr_sequencia_w;

	if (ie_opcao_p = 'L') then
		ie_retorno_w	:= ds_lote_fornec_w;
	elsif (ie_opcao_p = 'D') then
		ie_retorno_w	:= dt_validade_w;
	end if;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lote_validade_item_oc ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ie_opcao_p text) FROM PUBLIC;

