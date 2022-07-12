-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_tres_ult_compras ( cd_estabelecimento_p bigint, qt_dia_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, ie_tipo_p text, ie_compra_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w			double precision;
nr_sequencia_w			bigint;
ie_tipo_w			varchar(10);
ie_consignado_w			varchar(1);
cd_material_estoque_w		integer;
i				smallint;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	natureza_operacao o,
	operacao_nota p,
	nota_fiscal b,
	nota_fiscal_item a
where	a.nr_sequencia		= b.nr_sequencia
and	b.cd_natureza_operacao	= o.cd_natureza_operacao
and	o.ie_entrada_saida	= 'E'
and	cd_material  		= cd_material_p
and	b.cd_operacao_nf 	= p.cd_operacao_nf
and	coalesce(p.ie_ultima_compra, 'S') = 'S'
and	a.dt_atualizacao >= clock_timestamp() - coalesce(qt_dia_p,90)
and	((coalesce(cd_local_estoque_p::text, '') = '') or (cd_local_estoque = cd_local_estoque_p))
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	b.ie_situacao	= '1'
order by a.nr_sequencia desc;


BEGIN
vl_retorno_w		:= 0;
i			:= 0;
open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	i := i + 1;
	if (ie_compra_p <= 1 AND i = 1) then
		exit;
	end if;
	if (ie_compra_p = 2 AND i = 2) then
		exit;
	end if;
	if (ie_compra_p >= 3 AND i = 3) then
		exit;
	end if;
	end;
end loop;
close C01;

if (nr_sequencia_w > 0) and (ie_compra_p = i) then
	select	coalesce(max(dividir((a.vl_total_item_nf - a.vl_desconto -
			vl_desconto_rateio + vl_frete + a.vl_despesa_acessoria + a.vl_seguro),
		a.qt_item_estoque)),0)
	into STRICT	vl_retorno_w
	from 	nota_fiscal_item a
	where	nr_sequencia 		= nr_sequencia_w
	and	((ie_tipo_p = 'N' AND cd_material = cd_material_p) or
		(ie_tipo_p <> 'N' AND cd_material_estoque = cd_material_p));
end if;

return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_tres_ult_compras ( cd_estabelecimento_p bigint, qt_dia_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, ie_tipo_p text, ie_compra_p bigint) FROM PUBLIC;

