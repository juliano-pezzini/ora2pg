-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_existe_ccusto_proc_aprov ( nr_sequencia_p bigint, cd_centro_custo_p bigint) RETURNS varchar AS $body$
DECLARE



/*Identifica se no documento deste processo de aprovacao, existe o centro de custo*/

ds_retorno_w		varchar(1);
nr_seq_aprovacao_w	processo_compra.nr_sequencia%type;


BEGIN

select	max(nr_seq_aprovacao)
into STRICT	nr_seq_aprovacao_w
from (
	SELECT	b.nr_seq_aprovacao
	from	solic_compra_item b,
		solic_compra a
	where	a.nr_solic_compra = b.nr_solic_compra
	and	b.nr_seq_aprovacao = nr_sequencia_p
	and	a.cd_centro_custo = cd_centro_custo_p
	
union all

	SELECT	a.nr_seq_aprovacao
	from	ordem_compra_item a
	where	a.nr_seq_aprovacao = nr_sequencia_p
	and	a.cd_centro_custo = cd_centro_custo_p
	
union all

	select	b.nr_seq_aprovacao
	from	requisicao_material a,
		item_requisicao_material b
	where	a.nr_requisicao = b.nr_requisicao
	and	b.nr_seq_aprovacao = nr_sequencia_p
	and	a.cd_centro_custo = cd_centro_custo_p
	
union all

	select	b.nr_seq_aprovacao
	from	cot_compra a,
		cot_compra_item b
	where	a.nr_cot_compra = b.nr_cot_compra
	and	b.nr_seq_aprovacao = nr_sequencia_p
	and	obter_dados_solic_item_cot(a.nr_cot_compra, b.nr_item_cot_compra, 'C') = cd_centro_custo_p
	
union all

	select	a.nr_seq_aprovacao
	from	contrato_centro_custo b,
		contrato a
	where	a.nr_sequencia = b.nr_seq_contrato
	and	a.nr_seq_aprovacao = nr_sequencia_p
	and	b.cd_centro_custo = cd_centro_custo_p
	
union all

	select	a.nr_seq_aprovacao
	from	contrato_regra_nf b,
		contrato a
	where	a.nr_sequencia = b.nr_seq_contrato
	and	a.nr_seq_aprovacao = nr_sequencia_p
	and	b.cd_centro_custo = cd_centro_custo_p
	
union all

	select	a.nr_seq_aprovacao
	from	projeto_recurso a
	where	a.nr_seq_aprovacao = nr_sequencia_p
	and	a.cd_centro_custo = cd_centro_custo_p) alias2;	

ds_retorno_w := 'N';
if (nr_seq_aprovacao_w IS NOT NULL AND nr_seq_aprovacao_w::text <> '') then
	ds_retorno_w := 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_existe_ccusto_proc_aprov ( nr_sequencia_p bigint, cd_centro_custo_p bigint) FROM PUBLIC;
