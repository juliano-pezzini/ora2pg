-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_dados_cc ( cd_centro_custo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



/* Cópia da Ctb_Obter_Dados_Centro_Custo porem com um nome menor para poder ser utilizado em relatorio */

/*ie_opcao_p
'D' 	- Descricao
'C' 	- Classificacao
'G' 	- Grupo
'T' 	- Tipo
'TC'	- Tipo de custo
'S' 	- Cod sistema contabil
'SI'	- Situação (ativo/inativo)
*/
ds_centro_custo_w		varchar(80);
cd_classificacao_w		varchar(40);
cd_grupo_w		bigint;
ie_tipo_w			varchar(01);
ie_tipo_custo_w		varchar(5);
cd_sistema_contabil_w	varchar(20);
ie_situacao_w		varchar(1);
ds_retorno_w		varchar(255);


BEGIN
select	ds_centro_custo,
	cd_classificacao,
	cd_grupo,
	ie_tipo,
	cd_sistema_contabil,
	ie_tipo_custo,
	ie_situacao
into STRICT	ds_centro_custo_w,
	cd_classificacao_w,
	cd_grupo_w,
	ie_tipo_w,
	cd_sistema_contabil_w,
	ie_tipo_custo_w,
	ie_situacao_w
from	centro_custo
where	cd_centro_custo = cd_centro_custo_p;

if (ie_opcao_p = 'D') then
	return ds_centro_custo_w;
elsif (ie_opcao_p = 'C') then
	return cd_classificacao_w;
elsif (ie_opcao_p = 'G') then
	return cd_grupo_w;
elsif (ie_opcao_p = 'T') then
	return ie_tipo_w;
elsif (ie_opcao_p = 'S') then
	return cd_sistema_contabil_w;
elsif (ie_opcao_p = 'TC') then
	return ie_tipo_custo_w;
elsif (ie_opcao_p = 'SI') then
	return ie_situacao_w;
else
	return ds_retorno_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_dados_cc ( cd_centro_custo_p bigint, ie_opcao_p text) FROM PUBLIC;

