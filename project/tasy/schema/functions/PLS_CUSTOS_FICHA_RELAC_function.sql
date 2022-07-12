-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_custos_ficha_relac ( nr_seq_grupo_p bigint, tx_admin_p text, nr_seq_contrato_p text, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*
ie_opcao_p
T - Totais
S - Serviços
D - Diversos
*/
vl_custo_w		double precision;


BEGIN

select	sum(vl_custo)
into STRICT	vl_custo_w
from	(	SELECT (coalesce(sum(b.vl_total_beneficiario),coalesce(sum(b.vl_total),0)))* CASE WHEN tx_admin_p='0' THEN 1  ELSE tx_admin_p END  vl_custo
		from	pls_contrato_grupo	e,
			pls_contrato		d,
			pls_segurado		c,
			pls_conta		b
		where	e.nr_seq_contrato	= d.nr_sequencia
		and	c.nr_seq_contrato	= d.nr_sequencia
		and	b.nr_seq_segurado	= c.nr_sequencia
		and	e.nr_seq_grupo		= nr_seq_grupo_p
		and	((d.nr_sequencia	= nr_seq_contrato_p)
		or ('0'	= nr_seq_contrato_p))
		and	b.ie_status		= 'F'
		and	ie_opcao_p		= 'T'
		
union

		SELECT (coalesce(sum(b.vl_total_beneficiario),coalesce(sum(b.vl_total),0)))* CASE WHEN tx_admin_p='0' THEN 1  ELSE tx_admin_p END
		from	pls_contrato_grupo	e,
			pls_contrato		d,
			pls_segurado		c,
			pls_conta		b
		where	e.nr_seq_contrato	= d.nr_sequencia
		and	c.nr_seq_contrato	= d.nr_sequencia
		and	b.nr_seq_segurado	= c.nr_sequencia
		and	e.nr_seq_grupo		= nr_seq_grupo_p
		and	((d.nr_sequencia	= nr_seq_contrato_p)
		or ('0'	= nr_seq_contrato_p))
		and	b.ie_status		= 'F'
		and	ie_opcao_p		= 'S'
		
union

		select	0 vl_custos_diversos
		from	pls_contrato_grupo	e,
			pls_contrato		d,
			pls_segurado		c,
			pls_conta		b
		where	e.nr_seq_contrato	= d.nr_sequencia
		and	c.nr_seq_contrato	= d.nr_sequencia
		and	b.nr_seq_segurado	= c.nr_sequencia
		and	e.nr_seq_grupo		= nr_seq_grupo_p
		and	((d.nr_sequencia	= nr_seq_contrato_p)
		or ('0'	= nr_seq_contrato_p))
		and	b.ie_status		= 'F'
		and	ie_opcao_p		= 'D'	) alias20;

return	vl_custo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_custos_ficha_relac ( nr_seq_grupo_p bigint, tx_admin_p text, nr_seq_contrato_p text, ie_opcao_p text) FROM PUBLIC;

