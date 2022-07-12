-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_regra_consumo_req ( cd_material_p bigint, cd_estabelecimento_p bigint, cd_centro_custo_p bigint, cd_pessoa_requisitante_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* Q - Quantidade maxima permitida */

/* E - Se existe ou não regra */

/* P - Período de consistência (Mensal ou Diário)*/

ds_retorno_w			varchar(20);
ie_existe_regra_w		varchar(1)	:= 'N';
qt_regra_w			bigint;
qt_maxima_permitida_w	double precision;
ie_periodo_w		varchar(1);


BEGIN

select	count(*),
	sum(qt_maxima_permitida),
	max(coalesce(ie_periodo,'M'))
into STRICT	qt_regra_w,
	qt_maxima_permitida_w,
	ie_periodo_w
from	regra_consumo_requisicao
where	cd_material = cd_material_p
and	cd_estabelecimento = cd_estabelecimento_p
and	coalesce(cd_centro_custo, cd_centro_custo_p)	= cd_centro_custo_p
and	coalesce(cd_pessoa_regra, cd_pessoa_requisitante_p) = cd_pessoa_requisitante_p
and	coalesce(ie_requisicao_consumo,'S') = 'S';

if (qt_regra_w > 0) then
	ie_existe_regra_w := 'S';
end if;

if (ie_opcao_p = 'E') then
	ds_retorno_w := ie_existe_regra_w;
elsif (ie_opcao_p = 'Q') then
	ds_retorno_w := qt_maxima_permitida_w;
elsif (ie_opcao_p = 'P') then
	ds_retorno_w := ie_periodo_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_regra_consumo_req ( cd_material_p bigint, cd_estabelecimento_p bigint, cd_centro_custo_p bigint, cd_pessoa_requisitante_p text, ie_opcao_p text) FROM PUBLIC;

