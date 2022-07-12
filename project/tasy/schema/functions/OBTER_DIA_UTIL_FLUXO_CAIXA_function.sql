-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dia_util_fluxo_caixa (dt_referencia_p timestamp, cd_estabelecimento_p bigint, ie_classif_fluxo_p text, ie_tratar_fim_semana_p text, ie_fim_semana_passado_p text) RETURNS timestamp AS $body$
DECLARE


dt_util_w		timestamp;


BEGIN
dt_util_w	:= dt_referencia_p;

if (ie_classif_fluxo_p	= 'P') then

	if (ie_fim_semana_passado_p = 'S') then

		/* Se cair em mes diferente */

		if (trunc(obter_proximo_dia_util(cd_estabelecimento_p,dt_referencia_p),'month') <>
			trunc(dt_referencia_p,'month')) then
			dt_util_w	:= obter_dia_anterior_util(cd_estabelecimento_p,dt_util_w);
		else
			dt_util_w	:= obter_proximo_dia_util(cd_estabelecimento_p,dt_util_w);
		end if;
	end if;

elsif (ie_classif_fluxo_p	= 'R') then

	if (ie_tratar_fim_semana_p = 'S') then

		dt_util_w	:= obter_proximo_dia_util(cd_estabelecimento_p,dt_util_w);
	end if;
end if;

return dt_util_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dia_util_fluxo_caixa (dt_referencia_p timestamp, cd_estabelecimento_p bigint, ie_classif_fluxo_p text, ie_tratar_fim_semana_p text, ie_fim_semana_passado_p text) FROM PUBLIC;

