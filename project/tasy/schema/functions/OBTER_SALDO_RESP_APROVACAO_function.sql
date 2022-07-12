-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_resp_aprovacao ( nr_seq_aprovacao_p bigint, nr_seq_proc_aprov_p bigint, dt_mesano_referencia_p timestamp, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE


/*ie_opcao_p			
1 - Saldo
2 - Total ja aprovado

*/
			
vl_maximo_w		double precision := 0;
vl_total_aprov_w	double precision := 0;
vl_saldo_w		double precision := 0;
vl_retorno_w		double precision := 0;
ie_tipo_w		smallint;			
dt_mesano_referencia_w	timestamp;
nr_nivel_processo_w	bigint;
nr_maximo_nivel_w	bigint;
nr_documento_w          processo_aprov_compra.nr_documento%type;
qt_nova_estrutura_w     bigint;			


BEGIN

dt_mesano_referencia_w		:= trunc(coalesce(dt_mesano_referencia_p,clock_timestamp()),'mm');

select	max(nr_documento)
into STRICT	nr_documento_w
from	processo_aprov_compra
where	nr_sequencia = nr_seq_aprovacao_p
and	nr_seq_proc_aprov = nr_seq_proc_aprov_p;

select obter_estrutura_aprovacao(nr_seq_proc_aprov_p, nr_documento_w)
into STRICT   qt_nova_estrutura_w
;

if (qt_nova_estrutura_w > 0) then
	
	select	coalesce(max(vl_maximo),9999999999),
		coalesce(max(nr_nivel_aprovacao),0)
	into STRICT	vl_maximo_w,
		nr_nivel_processo_w
	from	processo_aprov_compra
	where	nr_seq_proc_aprov = nr_seq_proc_aprov_p
	and	nr_documento = nr_documento_w;
	
	select	coalesce(max(a.nr_nivel_aprovacao),0)
	into STRICT	nr_maximo_nivel_w
	from	processo_aprov_compra a
	where	a.cd_processo_aprov in (
		SELECT	x.cd_processo_aprov
		from	processo_aprov_compra x
		where	x.nr_seq_proc_aprov = nr_seq_proc_aprov_p
		and	x.nr_documento = nr_documento_w);
else
	select	coalesce(max(vl_maximo),9999999999),
		coalesce(max(nr_nivel_aprovacao),0)
	into STRICT	vl_maximo_w,
		nr_nivel_processo_w
	from	processo_aprov_resp
	where	nr_sequencia = nr_seq_proc_aprov_p;

	select	coalesce(max(a.nr_nivel_aprovacao),0)
	into STRICT	nr_maximo_nivel_w
	from	processo_aprov_resp a
	where	a.cd_processo_aprov in (
		SELECT	x.cd_processo_aprov
		from	processo_aprov_resp x
		where	x.nr_sequencia = nr_seq_proc_aprov_p);
end if;

select	distinct coalesce(max(ie_tipo),0)
into STRICT	ie_tipo_w
from (
	SELECT	1 ie_tipo
	from	ordem_compra_item
	where	nr_seq_aprovacao = nr_seq_aprovacao_p
	
union all
				 		
	SELECT	2 ie_tipo
	from	solic_compra_item
	where	nr_seq_aprovacao = nr_seq_aprovacao_p
	
union all
				 		
	select	3 ie_tipo
	from	item_requisicao_material
	where	nr_seq_aprovacao = nr_seq_aprovacao_p
	
union all
				 		
	select	4 ie_tipo
	from	cot_compra_item
	where	nr_seq_aprovacao = nr_seq_aprovacao_p
	
union all
				 		
	select	5 ie_tipo
	from	nota_fiscal_item
	where	nr_seq_aprovacao = nr_seq_aprovacao_p) alias2;

if (ie_tipo_w = 1) then

	select	coalesce(sum(b.qt_material * b.vl_unitario_material),0) vl_total
	into STRICT	vl_total_aprov_w
	from	ordem_compra a,
		ordem_compra_item b
	where	a.nr_ordem_compra = b.nr_ordem_compra
	and	b.nr_seq_proc_aprov = nr_seq_proc_aprov_p
	and	trunc(b.dt_aprovacao,'mm') = dt_mesano_referencia_w;

elsif (ie_tipo_w = 2) then

	select	coalesce(sum(b.qt_material * coalesce(b.vl_unit_previsto,0)),0) vl_total
	into STRICT	vl_total_aprov_w
	from	solic_compra a,
		solic_compra_item b
	where	a.nr_solic_compra = b.nr_solic_compra
	and	b.nr_seq_proc_aprov = nr_seq_proc_aprov_p	
	and	trunc(b.dt_autorizacao,'mm') = dt_mesano_referencia_w;

elsif (ie_tipo_w = 3) then

	select	coalesce(sum(b.qt_material_requisitada * coalesce(b.vl_unit_previsto,0)),0) vl_total
	into STRICT	vl_total_aprov_w
	from	requisicao_material a,
		item_requisicao_material b
	where	a.nr_requisicao = b.nr_requisicao
	and	b.nr_seq_proc_aprov = nr_seq_proc_aprov_p
	and	trunc(b.dt_aprovacao,'mm') = dt_mesano_referencia_w;

elsif (ie_tipo_w = 4) then

	select	coalesce(sum(vl_preco_liquido),0)
	into STRICT	vl_total_aprov_w
	from	cot_compra_resumo a,
		cot_compra_item b
	where	a.nr_cot_compra = b.nr_cot_compra
	and	a.nr_item_cot_compra = b.nr_item_cot_compra
	and	b.nr_seq_proc_aprov = nr_seq_proc_aprov_p
	and	trunc(b.dt_aprovacao,'mm') = dt_mesano_referencia_w;

elsif (ie_tipo_w = 5) then

	select	coalesce(sum(qt_item_nf * coalesce(vl_unitario_item_nf,0)),0) vl_total
	into STRICT	vl_total_aprov_w
	from	nota_fiscal_item
	where	nr_seq_proc_aprov = nr_seq_proc_aprov_p
	and	trunc(dt_aprovacao,'mm') = dt_mesano_referencia_w;

end if;

vl_saldo_w	:= vl_maximo_w - vl_total_aprov_w;

if (ie_opcao_p = 1) then
	vl_retorno_w := vl_saldo_w;
elsif (ie_opcao_p = 2) then
	vl_retorno_w := vl_total_aprov_w;
elsif (ie_opcao_p = 3) then
	
	if (nr_maximo_nivel_w = nr_nivel_processo_w) then
		vl_retorno_w := 0;
	else
		vl_retorno_w := vl_saldo_w;
	end if;
end if;
	
return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_resp_aprovacao ( nr_seq_aprovacao_p bigint, nr_seq_proc_aprov_p bigint, dt_mesano_referencia_p timestamp, ie_opcao_p bigint) FROM PUBLIC;

