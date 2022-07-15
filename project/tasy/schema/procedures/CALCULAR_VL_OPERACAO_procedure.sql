-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_vl_operacao (cd_estabelecimento_p bigint, cd_operacao_p bigint, cd_material_p bigint, vl_operacao_p INOUT bigint, cd_unidade_medida_p INOUT text) AS $body$
DECLARE


ie_unidade_medida_w		varchar(10);
qt_conv_estoque_consumo_w	double precision;
vl_retorno_w			double precision;
cd_unicade_medida_w		varchar(30);


BEGIN

vl_retorno_w	:= coalesce(vl_operacao_p,0);

if (coalesce(cd_material_p,0) > 0) then

	select	max(ie_unidade_medida)
	into STRICT	ie_unidade_medida_w
	from	operacao_terceiro
	where	nr_sequencia	= cd_operacao_p;

	select	coalesce(max(qt_conv_estoque_consumo),0),
		max(CASE WHEN ie_unidade_medida_w='S' THEN cd_unidade_medida_compra WHEN ie_unidade_medida_w='E' THEN cd_unidade_medida_estoque  ELSE cd_unidade_medida_consumo END )
	into STRICT	qt_conv_estoque_consumo_w,
		cd_unicade_medida_w
	from	material
	where	cd_material	= cd_material_p;

	if (ie_unidade_medida_w in ('E','S')) then

		if (coalesce(qt_conv_estoque_consumo_w,0) > 0) then
			vl_retorno_w	:= qt_conv_estoque_consumo_w * coalesce(vl_operacao_p,0);
		else
			vl_retorno_w	:= coalesce(vl_operacao_p,0);
		end if;
	end if;
end if;

vl_operacao_p		:= vl_retorno_w;
cd_unidade_medida_p	:= cd_unicade_medida_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_vl_operacao (cd_estabelecimento_p bigint, cd_operacao_p bigint, cd_material_p bigint, vl_operacao_p INOUT bigint, cd_unidade_medida_p INOUT text) FROM PUBLIC;

