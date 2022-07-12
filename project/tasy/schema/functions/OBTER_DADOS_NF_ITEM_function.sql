-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_nf_item ( nr_sequencia_p bigint, nr_item_nf_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


qt_item_nf_w		double precision := 0;
cd_material_w		integer;
ds_retorno_w		varchar(255);
vl_liquido_w		double precision;
ds_justificativa_w		varchar(255);
cd_serie_w		varchar(20);
cd_conta_contabil_w	varchar(20);
dt_inicio_garantia_w	timestamp;
dt_fim_garantia_w		timestamp;
vl_unit_item_nf_w		double precision;
/*
0 - QT_ITEM_NF
1 - CD_MATERIAL
2 - VL_LIQUIDO
3 - JUSTIFICATIVA
4 - SERIE
5 - Conta contábil
6 - Inicio garantia
7 - Fim garantia
8 - Valor unitário
*/
BEGIN
Select	qt_item_nf,
	cd_material,
	vl_liquido,
	ds_justificativa,
	substr(cd_imob_serie,1,20),
	cd_conta_contabil,
	dt_inicio_garantia,
	dt_fim_garantia,
	vl_unitario_item_nf
into STRICT	qt_item_nf_w,
	cd_material_w,
	vl_liquido_w,
	ds_justificativa_w,
	cd_serie_w,
	cd_conta_contabil_w,
	dt_inicio_garantia_w,
	dt_fim_garantia_w,
	vl_unit_item_nf_w
from	nota_fiscal_item
where	nr_sequencia	= nr_sequencia_p
and	nr_item_nf	= nr_item_nf_p;

if (ie_opcao_p  = 0) then
	ds_retorno_w := qt_item_nf_w;
elsif (ie_opcao_p  = 1) then
	ds_retorno_w := cd_material_w;
elsif (ie_opcao_p  = 2) then
	ds_retorno_w := vl_liquido_w;
elsif (ie_opcao_p  = 3) then
	ds_retorno_w := ds_justificativa_w;
elsif (ie_opcao_p  = 4) then
	ds_retorno_w := cd_serie_w;
elsif (ie_opcao_p  = 5) then
	ds_retorno_w := cd_conta_contabil_w;
elsif (ie_opcao_p  = 6) then
	ds_retorno_w := dt_inicio_garantia_w;
elsif (ie_opcao_p  = 7) then
	ds_retorno_w := dt_fim_garantia_w;
elsif (ie_opcao_p  = 8) then
	ds_retorno_w := vl_unit_item_nf_w;
end if;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_nf_item ( nr_sequencia_p bigint, nr_item_nf_p bigint, ie_opcao_p bigint) FROM PUBLIC;
