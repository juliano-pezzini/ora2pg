-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_parametro_fluxo_caixa ( cd_estabelecimento_p bigint, ie_tipo_dado_p text) RETURNS varchar AS $body$
DECLARE


/* ie_tipo_dado:
	CRE = Código conta financeira recebidos
	CPA = Código conta financeira pagos
	TFS = Tratar fim de semana
*/
cd_conta_financ_cpa_w	bigint;
cd_conta_financ_cre_w	bigint;
ie_tratar_fim_semana_w	varchar(1);
ds_retorno_w		varchar(100);


BEGIN

select	cd_conta_financ_cpa,
	cd_conta_financ_cre,
	ie_tratar_fim_semana
into STRICT	cd_conta_financ_cpa_w,
	cd_conta_financ_cre_w,
	ie_tratar_fim_semana_w
from	parametro_fluxo_caixa
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_tipo_dado_p = 'CPA') then
	ds_retorno_w := cd_conta_financ_cpa_w;
elsif (ie_tipo_dado_p = 'CRE') then
	ds_retorno_w := cd_conta_financ_cre_w;
elsif (ie_tipo_dado_p = 'TFS') then
	ds_retorno_w := ie_tratar_fim_semana_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_parametro_fluxo_caixa ( cd_estabelecimento_p bigint, ie_tipo_dado_p text) FROM PUBLIC;
