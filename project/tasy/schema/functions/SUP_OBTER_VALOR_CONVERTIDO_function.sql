-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_valor_convertido ( cd_material_p bigint, vl_material_p bigint, cd_unidade_medida_p text, cd_unidade_medida_retorno_p text) RETURNS bigint AS $body$
DECLARE


/*Opções cd_unidade_medida_retorno_p:
UME = Unidade Medida Estoque
UMC = Unidade Medida Consumo
UMP = Unidade Medida Compra*/
cd_unidade_medida_compra_w	varchar(30);
cd_unidade_medida_estoque_w	varchar(30);
cd_unidade_medida_consumo_w	varchar(30);
qt_conv_compra_estoque_w		double precision;
qt_conv_estoque_consumo_w	double precision;
vl_retorno_w			double precision;
cd_estabelecimento_w		smallint := wheb_usuario_pck.get_cd_estabelecimento;


BEGIN
select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UMC'),1,30) cd_unidade_medida_compra,
	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UME'),1,30) cd_unidade_medida_estoque,
	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UMS'),1,30) cd_unidade_medida_consumo,
	qt_conv_compra_estoque,
	qt_conv_estoque_consumo
into STRICT	cd_unidade_medida_compra_w,
	cd_unidade_medida_estoque_w,
	cd_unidade_medida_consumo_w,
	qt_conv_compra_estoque_w,
	qt_conv_estoque_consumo_w
from 	material
where	cd_material = cd_material_p;

/*Converte primeiro para valor de estoque*/

if (cd_unidade_medida_p = cd_unidade_medida_estoque_w) then
	vl_retorno_w := vl_material_p;
elsif (cd_unidade_medida_p = cd_unidade_medida_consumo_w) then
	vl_retorno_w := vl_material_p * qt_conv_estoque_consumo_w;
elsif (cd_unidade_medida_p = cd_unidade_medida_compra_w) then
	vl_retorno_w := dividir(vl_material_p, qt_conv_compra_estoque_w);
else
	vl_retorno_w := vl_material_p;
end if;

/*Converte o valor para a unidade de medida desejada, se for  de estoque não converte, pois já está convertido*/

if (cd_unidade_medida_retorno_p = 'UMC') then
	vl_retorno_w := dividir(vl_retorno_w, qt_conv_estoque_consumo_w);
elsif (cd_unidade_medida_retorno_p = 'UMP') then
	vl_retorno_w := vl_retorno_w * qt_conv_compra_estoque_w;
end if;

return	vl_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_valor_convertido ( cd_material_p bigint, vl_material_p bigint, cd_unidade_medida_p text, cd_unidade_medida_retorno_p text) FROM PUBLIC;

