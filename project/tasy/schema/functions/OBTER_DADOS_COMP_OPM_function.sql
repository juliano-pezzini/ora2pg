-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_comp_opm ( nr_sequencia_p bigint, nr_seq_origem_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
/*
ie_opcao_p
SC - Solicitação de compra
RM - Requisição de material
ST - Solicitação de transferência
*/
BEGIN

if (ie_opcao_p	= 'SC') then
	select 	substr(max(nr_solic_compra),1,255)
	into STRICT		ds_retorno_w
	from   	solic_compra_item
	where  	((nr_seq_op_comp_opm = nr_sequencia_p) or (nr_seq_op_comp_opm = nr_seq_origem_p));
elsif (ie_opcao_p	= 'RM') then
	select 	substr(max(nr_requisicao),1,255)
	into STRICT		ds_retorno_w
	from   	item_requisicao_material
	where  	((nr_seq_op_comp_opm = nr_sequencia_p) or (nr_seq_op_comp_opm = nr_seq_origem_p));
elsif (ie_opcao_p	= 'ST') then
	select 	substr(max(nr_ordem_compra),1,255)
	into STRICT		ds_retorno_w
	from   	ordem_compra_item
	where  	((nr_seq_op_comp_opm = nr_sequencia_p) or (nr_seq_op_comp_opm = nr_seq_origem_p))
	and		coalesce(ie_situacao,'A') = 'A';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_comp_opm ( nr_sequencia_p bigint, nr_seq_origem_p bigint, ie_opcao_p text) FROM PUBLIC;

