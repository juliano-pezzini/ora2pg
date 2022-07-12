-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_saldo_teto_aprov ( nr_seq_processo_p bigint, nm_usuario_p text, dt_mesano_referencia_p timestamp, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE


/*ie_opcao_p
1 = Saldo
2 = Total aprovado
*/
cd_pessoa_fisica_w		varchar(10);
cd_cargo_w			bigint;
nr_seq_aprovacao_w		bigint;
dt_mesano_referencia_w		timestamp;
ie_tipo_w				smallint;
vl_total_aprov_w			double precision	:= 0;
vl_total_aprovado_w		double precision	:= 0;
vl_maximo_w			double precision	:= 0;
vl_saldo_w			double precision	:= 0;
vl_retorno_w			double precision	:= 0;

c01 CURSOR FOR
SELECT	nr_sequencia
from (select	nr_sequencia
	from	processo_aprov_compra
	where	trunc(dt_definicao,'mm')	= dt_mesano_referencia_w
	and	nr_seq_proc_aprov		= nr_seq_processo_p
	and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '')
	and	cd_pessoa_fisica		= cd_pessoa_fisica_w
	and	ie_aprov_reprov		= 'A'
	and	ie_automatico		= 'N'
	and	sup_obter_valor_aprovado(nr_sequencia,nr_seq_proc_aprov,cd_pessoa_fisica_w) <= vl_maximo_w
	
union all

	SELECT	nr_sequencia
	from	processo_aprov_compra
	where	trunc(dt_definicao,'mm')	= dt_mesano_referencia_w
	and	nr_seq_proc_aprov		= nr_seq_processo_p
	and	(cd_cargo IS NOT NULL AND cd_cargo::text <> '')
	and	cd_cargo			= cd_cargo_w
	and	ie_aprov_reprov		= 'A'
	and	ie_automatico		= 'N'
	and	sup_obter_valor_aprovado(nr_sequencia,nr_seq_proc_aprov,cd_pessoa_fisica_w) <= vl_maximo_w) alias6
group by	nr_sequencia;


BEGIN

dt_mesano_referencia_w		:= trunc(coalesce(dt_mesano_referencia_p,clock_timestamp()),'mm');

select	b.cd_pessoa_fisica,
	a.cd_cargo
into STRICT	cd_pessoa_fisica_w,
	cd_cargo_w
from	pessoa_fisica a,
	usuario b
where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
and	b.nm_usuario = nm_usuario_p;

select	coalesce(max(vl_maximo),0)
into STRICT	vl_maximo_w
from	processo_aprov_resp
where	nr_sequencia = nr_seq_processo_p;

if (vl_maximo_w > 0) then
	begin

	open c01;
	loop
	fetch c01 into
		nr_seq_aprovacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		select	distinct coalesce(max(ie_tipo),0)
		into STRICT	ie_tipo_w
		from (
			SELECT	1 ie_tipo
			from	ordem_compra_item
			where	nr_seq_aprovacao = nr_seq_aprovacao_w
			
union all

			SELECT	2 ie_tipo
			from	solic_compra_item
			where	nr_seq_aprovacao = nr_seq_aprovacao_w
			
union all

			select	3 ie_tipo
			from	item_requisicao_material
			where	nr_seq_aprovacao = nr_seq_aprovacao_w
			
union all

			select	4 ie_tipo
			from	cot_compra_item
			where	nr_seq_aprovacao = nr_seq_aprovacao_w
			
union all

			select	5 ie_tipo
			from	nota_fiscal_item
			where	nr_seq_aprovacao = nr_seq_aprovacao_w) alias2;

		if (ie_tipo_w = 1) then

			select	coalesce(sum(b.qt_material * b.vl_unitario_material),0) vl_total
			into STRICT	vl_total_aprov_w
			from	ordem_compra a,
				ordem_compra_item b
			where	a.nr_ordem_compra = b.nr_ordem_compra
			and	nr_seq_aprovacao = nr_seq_aprovacao_w;

		elsif (ie_tipo_w = 2) then

			select	coalesce(sum(b.qt_material * coalesce(b.vl_unit_previsto,0)),0) vl_total
			into STRICT	vl_total_aprov_w
			from	solic_compra a,
				solic_compra_item b
			where	a.nr_solic_compra = b.nr_solic_compra
			and	nr_seq_aprovacao = nr_seq_aprovacao_w;

		elsif (ie_tipo_w = 3) then

			select	coalesce(sum(b.qt_material_requisitada * coalesce(b.vl_unit_previsto,0)),0) vl_total
			into STRICT	vl_total_aprov_w
			from	requisicao_material a,
				item_requisicao_material b
			where	a.nr_requisicao = b.nr_requisicao
			and	nr_seq_aprovacao = nr_seq_aprovacao_w;

		elsif (ie_tipo_w = 4) then

			select	coalesce(sum(vl_preco_liquido),0)
			into STRICT	vl_total_aprov_w
			from	cot_compra_resumo a,
				cot_compra_item b
			where	a.nr_cot_compra = b.nr_cot_compra
			and	a.nr_item_cot_compra = b.nr_item_cot_compra
			and	b.nr_seq_aprovacao = nr_seq_aprovacao_w;

		elsif (ie_tipo_w = 5) then

			select	coalesce(sum(qt_item_nf * coalesce(vl_unitario_item_nf,0)),0) vl_total
			into STRICT	vl_total_aprov_w
			from	nota_fiscal_item
			where	nr_seq_aprovacao = nr_seq_aprovacao_w;

		end if;

		vl_total_aprovado_w	:= (vl_total_aprovado_w + vl_total_aprov_w);

		end;
	end loop;
	close c01;

	vl_saldo_w	:= (vl_maximo_w - vl_total_aprovado_w);

	end;
else
	vl_saldo_w	:= 0;
end if;

if (vl_saldo_w < 0) then
	vl_saldo_w	:= 0;
end if;

if (ie_opcao_p = 1) then
	vl_retorno_w	:= vl_saldo_w;
elsif (ie_opcao_p = 2) then
	vl_retorno_w	:= vl_total_aprovado_w;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_saldo_teto_aprov ( nr_seq_processo_p bigint, nm_usuario_p text, dt_mesano_referencia_p timestamp, ie_opcao_p bigint) FROM PUBLIC;
