-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_fornecedor_ultima_compra ( cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w  		varchar(14) := '';
cd_estabelecimento_w	smallint;
nr_seq_ultima_compra_w 	bigint;


BEGIN
if (coalesce(cd_estabelecimento_p,0) = 0) then
	cd_estabelecimento_w	:= null;
else
	cd_estabelecimento_w	:= cd_estabelecimento_p;
end if;

select 	coalesce(max(s.nr_sequencia),0)
into STRICT 	nr_seq_ultima_compra_w
from 	sup_dados_ultima_compra s
where 	s.cd_material = cd_material_p
and 	s.cd_estabelecimento = coalesce(cd_estabelecimento_w,s.cd_estabelecimento)
and      exists (SELECT	1
                           from	operacao_estoque a,
                                    nota_fiscal b,
                                    operacao_nota c
                           where	c.cd_operacao_nf		= b.cd_operacao_nf
                           and      a.cd_operacao_estoque      = c.cd_operacao_estoque
                           and	b.nr_sequencia		= s.nr_sequencia
                           and 	a.ie_entrada_saida  = 'E');

if (nr_seq_ultima_compra_w > 0) then

	select 	b.cd_cgc_emitente
	into STRICT 	ds_retorno_w
	from 	nota_fiscal b
	where 	b.nr_sequencia = (
		SELECT 	x.nr_seq_nota
		from 	sup_dados_ultima_compra x
		where 	x.nr_sequencia = nr_seq_ultima_compra_w);
		
else

		
	select 	cd_cgc_emitente
	into STRICT 	ds_retorno_w
	from (
		  SELECT n.cd_cgc_emitente
		  from 	natureza_operacao o,
		    operacao_nota p,
		    nota_fiscal n,
		    nota_fiscal_item b
		  where 	b.nr_sequencia = n.nr_sequencia
		  and 	n.cd_natureza_operacao = o.cd_natureza_operacao
		  and 	b.cd_material = cd_material_p
		  and 	n.cd_estabelecimento = coalesce(cd_estabelecimento_w,n.cd_estabelecimento)
		  and 	o.ie_entrada_saida = 'E'
		  and 	n.cd_operacao_nf = p.cd_operacao_nf
		  and 	coalesce(p.ie_ultima_compra, 'S') = 'S'
		  and 	n.ie_acao_nf = '1'
		  and 	n.ie_situacao = '1'
		  order by b.nr_sequencia desc
	      ) alias2 LIMIT 1;
					
		
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_fornecedor_ultima_compra ( cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
