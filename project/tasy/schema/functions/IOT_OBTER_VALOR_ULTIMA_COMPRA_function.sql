-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION iot_obter_valor_ultima_compra ( cd_estabelecimento_p bigint, qt_dia_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE

 
 
 
vl_retorno_w			double precision;
nr_sequencia_w			bigint;
ie_tipo_w				varchar(10);
ie_consignado_w			varchar(1);
cd_material_estoque_w		integer;
ie_forma_preco_ult_compra_w	varchar(1);

 
/*ie_tipo_p 
Fabio em 24/07/2008 - Tratamento especial para os tipos: 
N	= Material da nota, ou seja: Busca a nota com próprio material passado no parametro 
Senão busca sempre do Material estoque, ou seja: Busca a nota que tenha o material de estoque do material passado no parametro 
*/
 
 

BEGIN 
 
select	coalesce(max(ie_forma_preco_ult_compra), 'N') 
into STRICT	ie_forma_preco_ult_compra_w 
from	parametro_compras 
where	cd_estabelecimento = cd_estabelecimento_p;
 
if (ie_forma_preco_ult_compra_w = 'S') then 
	begin 
 
	select	cd_material_estoque 
	into STRICT	cd_material_estoque_w 
	from	material 
	where	cd_material = cd_material_p;
 
	select	coalesce(max(vl_preco_ult_compra), 0) 
	into STRICT	vl_retorno_w 
	from	saldo_estoque 
	where	cd_estabelecimento = cd_estabelecimento_p 
	and	cd_material = cd_material_estoque_w 
	and	dt_mesano_referencia = ( 
		SELECT	max(dt_mesano_referencia) 
		from	saldo_estoque 
		where	cd_estabelecimento = cd_estabelecimento_p 
		and	cd_material = cd_material_estoque_w);
	end;
 
else 
	begin 
 
	vl_retorno_w		:= 0;
 
 
	/*Fabio 20/03 - Separei em 2 select devido a performance pois fazia com nvl no local*/
 
	if (coalesce(cd_local_estoque_p, 0) = 0) then 
		select	max(a.nr_sequencia) 
		into STRICT	nr_sequencia_w 
		from	natureza_operacao o, 
			operacao_nota p, 
			nota_fiscal b, 
			nota_fiscal_item a 
		where	a.nr_sequencia		= b.nr_sequencia 
		and	b.cd_natureza_operacao	= o.cd_natureza_operacao 
		and	b.cd_operacao_nf 	= p.cd_operacao_nf 
		and	a.cd_estabelecimento	= cd_estabelecimento_p 
		and	a.dt_atualizacao	>= clock_timestamp() - coalesce(qt_dia_p,90) 
		and	a.cd_material 		= cd_material_p 
		and	b.ie_situacao		= '1' 
		and	o.ie_entrada_saida	= 'E' 
		and	p.ie_ultima_compra	= 'S';
 
	elsif (coalesce(cd_local_estoque_p, 0) > 0) then 
		select	max(a.nr_sequencia) 
		into STRICT	nr_sequencia_w 
		from	natureza_operacao o, 
			operacao_nota p, 
			nota_fiscal b, 
			nota_fiscal_item a 
		where	a.nr_sequencia		= b.nr_sequencia 
		and	b.cd_natureza_operacao	= o.cd_natureza_operacao 
		and	b.cd_operacao_nf 	= p.cd_operacao_nf 
		and	a.cd_estabelecimento	= cd_estabelecimento_p 
		and	a.cd_local_estoque	= cd_local_estoque_p 
		and	a.dt_atualizacao	>= clock_timestamp() - coalesce(qt_dia_p,90) 
		and	a.cd_material 		= cd_material_p 
		and	b.ie_situacao		= '1' 
		and	o.ie_entrada_saida	= 'E' 
		and	p.ie_ultima_compra	= 'S';
	end if;
 
 
	if (nr_sequencia_w > 0) then 
		begin 
 
		/*Fabio 20/03 - Separei em 2 select devido a performance pois fazia com nvl com ie_tipo para o material*/
 
		if (coalesce(ie_tipo_p, 'N') = 'N') then 
			select	coalesce(max(dividir(a.vl_total_item_nf,a.qt_item_estoque)),0) 
			into STRICT	vl_retorno_w 
			from 	nota_fiscal_item a 
			where	nr_sequencia 	= nr_sequencia_w 
			and	cd_material	= cd_material_p;
 
		elsif (coalesce(ie_tipo_p, 'N') <> 'N') then 
			select	coalesce(max(dividir(a.vl_total_item_nf,a.qt_item_estoque)),0) 
			into STRICT	vl_retorno_w 
			from 	nota_fiscal_item a 
			where	nr_sequencia 		= nr_sequencia_w 
			and	cd_material_estoque	= cd_material_p;
		end if;
		end;
	end if;
	end;
end if;
 
return vl_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION iot_obter_valor_ultima_compra ( cd_estabelecimento_p bigint, qt_dia_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, ie_tipo_p text) FROM PUBLIC;
