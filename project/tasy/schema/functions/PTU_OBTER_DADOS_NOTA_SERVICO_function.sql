-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_dados_nota_servico ( nr_seq_nota_servico_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*	VTP -  Valor total dos procedimentos com taxas
	VTT - Valor Total das taxas
	VST - Valor total dos procedimentos sem taxas
*/
ds_retorno_w		varchar(255);


BEGIN
if (ie_opcao_p = 'VTP') then
	select	coalesce(vl_procedimento,0) + coalesce(vl_custo_operacional,0) + coalesce(vl_filme,0) + coalesce(vl_adic_procedimento,0) + coalesce(vl_adic_co,0) + coalesce(vl_adic_filme,0)
	into STRICT	ds_retorno_w
	from	ptu_nota_servico
	where	nr_sequencia	= nr_seq_nota_servico_p;
elsif (ie_opcao_p = 'VTT') then
	select	coalesce(vl_adic_procedimento,0) + coalesce(vl_adic_co,0) + coalesce(vl_adic_filme,0)
	into STRICT	ds_retorno_w
	from	ptu_nota_servico
	where	nr_sequencia	= nr_seq_nota_servico_p;
elsif (ie_opcao_p = 'VST') then
	select	coalesce(vl_procedimento,0) + coalesce(vl_custo_operacional,0) + coalesce(vl_filme,0)
	into STRICT	ds_retorno_w
	from	ptu_nota_servico
	where	nr_sequencia	= nr_seq_nota_servico_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_dados_nota_servico ( nr_seq_nota_servico_p bigint, ie_opcao_p text) FROM PUBLIC;
