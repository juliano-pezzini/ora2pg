-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_regra_terc_item (cd_regra_p bigint, nr_seq_item_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
	'O' - Observação
	'DCC' - Descrição da conta contábil


*/
ds_retorno_w		varchar(255);


BEGIN

ds_retorno_w		:= '';

if (ie_opcao_p = 'O') then
	select	substr(max(ds_observacao),1,255)
	into STRICT	ds_retorno_w
	from	regra_repasse_terc_item
	where	cd_regra	= cd_regra_p
	and	nr_seq_item	= nr_seq_item_p;
elsif (ie_opcao_p = 'DCC') then

	select	max(b.ds_conta_contabil)
	into STRICT	ds_retorno_w
	from	conta_contabil b,
		regra_repasse_terc_item a
	where	a.cd_regra		= cd_regra_p
	and	a.nr_seq_item		= nr_seq_item_p
	and	a.cd_conta_contabil	= b.cd_conta_contabil;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_regra_terc_item (cd_regra_p bigint, nr_seq_item_p bigint, ie_opcao_p text) FROM PUBLIC;
