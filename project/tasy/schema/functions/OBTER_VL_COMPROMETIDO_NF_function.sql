-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_comprometido_nf ( nr_seq_proj_rec_p bigint, nr_seq_nota_fiscal_p bigint) RETURNS bigint AS $body$
DECLARE


vl_comprometido_w	projeto_recurso_saldo.vl_comprometido%type;

vl_titulo_w		titulo_pagar.vl_titulo%type;
vl_total_nota_w		nota_fiscal.vl_total_nota%type;


BEGIN

vl_comprometido_w := 0;

select  coalesce(sum(a.vl_titulo),0)
into STRICT	vl_titulo_w
from    titulo_pagar a
where   a.nr_seq_proj_rec = nr_seq_proj_rec_p
and     ie_situacao in ('L','T')
and     a.nr_seq_nota_fiscal = nr_seq_nota_fiscal_p;

select  sum(b.vl_total_item_nf)
into STRICT	vl_total_nota_w
from    nota_fiscal a,
	nota_fiscal_item b
where   a.nr_sequencia = b.nr_sequencia
and	a.nr_sequencia = nr_seq_nota_fiscal_p
and	b.nr_seq_proj_rec = nr_seq_proj_rec_p
and     a.ie_situacao = 1
and     (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '');

if (vl_total_nota_w > vl_titulo_w) then
	vl_comprometido_w := vl_total_nota_w - vl_titulo_w;
end if;

return	vl_comprometido_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_comprometido_nf ( nr_seq_proj_rec_p bigint, nr_seq_nota_fiscal_p bigint) FROM PUBLIC;
