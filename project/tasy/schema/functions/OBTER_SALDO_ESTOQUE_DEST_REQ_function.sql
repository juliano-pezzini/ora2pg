-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_estoque_dest_req ( nr_requisicao_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE



qt_estoque_w			double precision := 0;
cd_estabelecimento_w		smallint;
cd_material_w			integer;
cd_material_ww			integer;
cd_local_estoque_dest_w		smallint;
dt_mesano_referencia_w		timestamp;
cd_cgc_w			varchar(14);
cd_operacao_estoque_w		smallint;
ie_consignado_w			varchar(1);



BEGIN

select	a.cd_estabelecimento,
	coalesce(a.cd_local_estoque_destino,0),
	a.cd_operacao_estoque,
	b.cd_material,
	b.cd_cgc_fornecedor,
	trunc(a.dt_solicitacao_requisicao,'mm')
into STRICT	cd_estabelecimento_w,
	cd_local_estoque_dest_w,
	cd_operacao_estoque_w,
	cd_material_w,
	cd_cgc_w,
	dt_mesano_referencia_w
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao	= b.nr_requisicao
and	b.nr_sequencia	= nr_sequencia_p
and	b.nr_requisicao	= nr_requisicao_p;

if (cd_local_estoque_dest_w <> 0) then
	begin

	select	coalesce(cd_material_estoque, cd_material)
	into STRICT	cd_material_ww
	from	material
	where	cd_material = cd_material_w;

	select	coalesce(max(ie_consignado), '0')
	into STRICT	ie_consignado_w
	from 	operacao_estoque
	where	cd_operacao_estoque = cd_operacao_estoque_w;


	if (ie_consignado_w = '0') then
		qt_estoque_w	:= obter_saldo_disp_estoque(
					cd_estabelecimento_w,
					cd_material_ww,
  		     			cd_local_estoque_dest_w,
					dt_mesano_referencia_w);
	elsif (ie_consignado_w <> '0') then
		qt_estoque_w	:= Obter_Saldo_Estoque_Consig(
					cd_estabelecimento_w,
					cd_cgc_w,
					cd_material_ww,
					cd_local_estoque_dest_w);
	end if;

	end;
end if;

return qt_estoque_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_estoque_dest_req ( nr_requisicao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

