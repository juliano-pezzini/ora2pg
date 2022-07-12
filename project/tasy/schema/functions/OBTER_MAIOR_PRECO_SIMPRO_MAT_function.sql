-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_maior_preco_simpro_mat ( cd_material_p bigint, cd_unidade_medida_param_p text, dt_vigencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_preco_fabrica_w			double precision;
vl_preco_venda_w			double precision;
vl_preco_w			double precision;
cd_simpro_w			bigint;
qt_conversao_w			double precision;
ie_tipo_preco_w			varchar(01);
cd_unidade_medida_compra_w	varchar(30);
cd_unidade_medida_estoque_w	varchar(30);
cd_unidade_medida_consumo_w	varchar(30);
qt_conv_compra_estoque_w		double precision;
qt_conv_estoque_consumo_w	double precision;
vl_simpro_w			double precision;
cd_estab_simpro_w	estabelecimento.cd_estabelecimento%type;

c01 CURSOR FOR
SELECT	coalesce(qt_conversao,1),
	coalesce(cd_simpro,0)
from	material_simpro
where	cd_material	= cd_material_p
and	coalesce(dt_vigencia, dt_vigencia_p) <= dt_vigencia_p;


BEGIN

vl_preco_w		:= 0;
vl_simpro_w		:= 0;
cd_estab_simpro_w 	:= wheb_usuario_pck.get_cd_estabelecimento;

open C01;
loop
fetch C01 into
	qt_conversao_w,
	cd_simpro_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (cd_simpro_w > 0) then

		select	coalesce(max(vl_preco_venda),0),
			coalesce(max(vl_preco_fabrica),0),
			coalesce(max(ie_tipo_preco),'X')
		into STRICT	vl_preco_venda_w,
			vl_preco_fabrica_w,
			ie_tipo_preco_w
		from	simpro_preco
		where	cd_simpro = cd_simpro_w
		and     coalesce(cd_estabelecimento, coalesce(cd_estab_simpro_w, 0)) = coalesce(cd_estab_simpro_w, 0)
		and	dt_vigencia = (
			SELECT	max(dt_vigencia)
			from	simpro_preco
			where	cd_simpro = cd_simpro_w
			and     coalesce(cd_estabelecimento, coalesce(cd_estab_simpro_w, 0)) = coalesce(cd_estab_simpro_w, 0)
			and	dt_vigencia <= dt_vigencia_p);

		if (ie_tipo_preco_w = 'V') then
			vl_preco_w	:= vl_preco_venda_w / qt_conversao_w;
		elsif (ie_tipo_preco_w = 'F') then
			vl_preco_w	:= vl_preco_fabrica_w / qt_conversao_w;
		end if;

		if (vl_preco_w > vl_simpro_w) then
			vl_simpro_w := vl_preco_w;
		end if;
	end if;

	end;
end loop;
close C01;

if (vl_simpro_w > 0) then

	select	cd_unidade_medida_compra,
		cd_unidade_medida_estoque,
		cd_unidade_medida_consumo,
		qt_conv_compra_estoque,
		qt_conv_estoque_consumo
	into STRICT	cd_unidade_medida_compra_w,
		cd_unidade_medida_estoque_w,
		cd_unidade_medida_consumo_w,
		qt_conv_compra_estoque_w,
		qt_conv_estoque_consumo_w
	from	material
	where	cd_material = cd_material_p;

	if (cd_unidade_medida_param_p = cd_unidade_medida_compra_w) then
		vl_simpro_w	:= vl_simpro_w * qt_conv_compra_estoque_w * qt_conv_estoque_consumo_w;
	elsif (cd_unidade_medida_param_p = cd_unidade_medida_estoque_w) then
		vl_simpro_w	:= vl_simpro_w * qt_conv_estoque_consumo_w;
	end if;
end if;

return vl_simpro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_maior_preco_simpro_mat ( cd_material_p bigint, cd_unidade_medida_param_p text, dt_vigencia_p timestamp) FROM PUBLIC;
