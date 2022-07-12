-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_dacon (nr_sequencia_p integer, ie_opcao text) RETURNS bigint AS $body$
DECLARE


retorno_w	double precision;
pr_pis_w	double precision;
pr_cofins_w	double precision;


BEGIN
/*
	opções
TPR : Total PIS retido.
TCR: Total COFINS retido.
TNPR: Total das notas com PIS retido.
TNCR: Total das notas com COFINS retido.
TNSPR: Total das notas sem PIS retido.
TNSCR:Total das notas sem COFINS retido.
AP: Alíquota do PIS.
AC: Alíquota do COFINS.
TBCP: Total da base de cálculo PIS.
TBCC: Total da base de cálculo COFINS.
*/
if (ie_opcao = 'TPR') then
	select	sum(c.vl_tributo)
	into STRICT	retorno_w
	from 	nota_fiscal b,
		nota_fiscal_trib c,
		dacon_nota_fiscal a
	where 	b.nr_sequencia = c.nr_sequencia
	and	a.nr_seq_nota_fiscal = b.nr_sequencia
	and	c.cd_tributo = (SELECT cd_tributo_pis from dacon where nr_sequencia = nr_sequencia_p)
	and	c.vl_tributo > 0
	and	a.nr_seq_dacon= nr_sequencia_p;
end if;

if (ie_opcao = 'TCR') then
	select	sum(c.vl_tributo)
	into STRICT	retorno_w
	from 	nota_fiscal b,
		nota_fiscal_trib c,
		dacon_nota_fiscal a
	where 	b.nr_sequencia = c.nr_sequencia
	and	a.nr_seq_nota_fiscal = b.nr_sequencia
	and	c.cd_tributo = (SELECT cd_tributo_cofins from dacon where nr_sequencia = nr_sequencia_p)
	and	c.vl_tributo > 0
	and	a.nr_seq_dacon = nr_sequencia_p;
end if;

if (ie_opcao = 'TNPR') then
	select 	sum(b.vl_mercadoria)
	into STRICT	retorno_w
	from 	nota_fiscal b,
		nota_fiscal_trib c,
		dacon_nota_fiscal a
	where 	b.nr_sequencia = c.nr_sequencia
	and	a.nr_seq_nota_fiscal = b.nr_sequencia
	and	c.cd_tributo = (SELECT cd_tributo_pis from dacon where nr_sequencia = nr_sequencia_p)
	and	c.vl_tributo > 0
	and	a.nr_seq_dacon = nr_sequencia_p;
end if;

if (ie_opcao = 'TNCR') then
	select	sum(b.vl_mercadoria)
	into STRICT	retorno_w
	from 	nota_fiscal b,
		nota_fiscal_trib c,
		dacon_nota_fiscal a
	where 	b.nr_sequencia = c.nr_sequencia
	and	a.nr_seq_nota_fiscal = b.nr_sequencia
	and	c.cd_tributo = (SELECT cd_tributo_cofins from dacon where nr_sequencia = nr_sequencia_p)
	and	c.vl_tributo > 0
	and	a.nr_seq_dacon= nr_sequencia_p;
end if;

if (ie_opcao = 'TNSPR') then
	select	sum(b.vl_mercadoria)
	into STRICT	retorno_w
	from 	nota_fiscal b,
		dacon_nota_fiscal a
	where 	a.nr_seq_nota_fiscal = b.nr_sequencia
	and 	(not exists (SELECT  	1 from nota_fiscal_trib c
			  where  	b.nr_sequencia = c.nr_sequencia
			  and     	c.cd_tributo = (select cd_tributo_pis from dacon where nr_sequencia = nr_sequencia_p))
	or 	exists (	select  	1 from nota_fiscal_trib c
			where   	b.nr_sequencia = c.nr_sequencia
			and      	c.cd_tributo = (select cd_tributo_pis from dacon where nr_sequencia = nr_sequencia_p)
			and	c.vl_tributo = 0))
	and	a.nr_seq_dacon = nr_sequencia_p;
end if;

if (ie_opcao = 'TNSCR') then
	select	sum(b.vl_mercadoria)
	into STRICT	retorno_w
	from 	nota_fiscal b,
		dacon_nota_fiscal a
	where 	a.nr_seq_nota_fiscal = b.nr_sequencia
	and 	(not exists	(SELECT	1
				from	nota_fiscal_trib c
				where  	b.nr_sequencia = c.nr_sequencia
				and    	c.cd_tributo = (select cd_tributo_cofins from dacon where nr_sequencia = nr_sequencia_p))
	or 	exists (	select  	1 from nota_fiscal_trib c
			where  	b.nr_sequencia = c.nr_sequencia
			and     	c.cd_tributo = (select cd_tributo_cofins from dacon where nr_sequencia = nr_sequencia_p)
			and     	c.vl_tributo = 0))
	and	a.nr_seq_dacon = nr_sequencia_p;
end if;

if (ie_opcao = 'AP') then
	select	max(pr_imposto)
	into STRICT	retorno_w
	from	regra_calculo_imposto e
	where   e.cd_tributo =	(SELECT	cd_tributo_pis
				from	dacon
				where	nr_sequencia = nr_sequencia_p);

	select	coalesce(max(pr_pis),0)
	into STRICT	pr_pis_w
	from	dacon
	where	nr_sequencia = nr_sequencia_p;

	if (pr_pis_w <> 0) then
		retorno_w := pr_pis_w;
	end if;

end if;

if (ie_opcao = 'AC') then
	select	max(pr_imposto)
	into STRICT	retorno_w
	from   	regra_calculo_imposto e
	where	e.cd_tributo =	(SELECT	cd_tributo_cofins
				from	dacon
				where	nr_sequencia = nr_sequencia_p);

	select	coalesce(max(pr_cofins),0)
	into STRICT	pr_cofins_w
	from	dacon
	where	nr_sequencia = nr_sequencia_p;

	if (pr_cofins_w <> 0) then
		retorno_w := pr_cofins_w;
	end if;

end if;

if (ie_opcao = 'TBCP') then
	select 	sum(c.vl_base_calculo) valores
	into STRICT	retorno_w
	from   	nota_fiscal_trib c,
   		dacon_nota_fiscal a
	where	a.nr_seq_nota_fiscal = c.nr_sequencia
	and	c.cd_tributo = (SELECT cd_tributo_pis from dacon where nr_sequencia = nr_sequencia_p)
	and	a.nr_seq_dacon = nr_sequencia_p;
end if;

if (ie_opcao = 'TBCC') then
	select 	sum(c.vl_base_calculo) valores
	into STRICT	retorno_w
	from   	nota_fiscal_trib c,
	   	dacon_nota_fiscal a
	where	a.nr_seq_nota_fiscal = c.nr_sequencia
	and	c.cd_tributo = (SELECT cd_tributo_cofins from dacon where nr_sequencia = nr_sequencia_p)
	and	a.nr_seq_dacon = nr_sequencia_p;
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_dacon (nr_sequencia_p integer, ie_opcao text) FROM PUBLIC;
