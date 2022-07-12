-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_ficha_financ_res ( nr_seq_valor_p bigint, ie_restricao_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

if (coalesce(ie_opcao_p::text, '') = '') then
	select	max(a.ds_restricao)
	into STRICT	ds_retorno_w
	from	capa_ficha_financ_campos_res_v a,
		ficha_financ_valor b
	where	a.nm_tabela	= b.nm_tabela
	and	b.nr_sequencia	= nr_seq_valor_p
	and	ie_restricao	= ie_restricao_p;
else
	select	max(a.ds_opcao)
	into STRICT	ds_retorno_w
	from	capa_ficha_financ_campos_res_v a,
		ficha_financ_valor b
	where	a.nm_tabela	= b.nm_tabela
	and	b.nr_sequencia	= nr_seq_valor_p
	and	ie_restricao	= ie_restricao_p
	and	ie_opcao	= ie_opcao_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_ficha_financ_res ( nr_seq_valor_p bigint, ie_restricao_p text, ie_opcao_p text) FROM PUBLIC;
