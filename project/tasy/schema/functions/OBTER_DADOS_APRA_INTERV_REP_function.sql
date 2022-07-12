-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_apra_interv_rep ( cd_intervalo_p text, cd_setor_p bigint, cd_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(10);
ie_limpa_prim_hor_w	varchar(10);
ie_sem_aprazamento_w	varchar(10);


BEGIN

select	coalesce(max(ie_sem_aprazamento),'N'),
		coalesce(max(ie_limpa_prim_hor),'N')
into STRICT		ie_sem_aprazamento_w,
		ie_limpa_prim_hor_w
from		intervalo_aprazamento
where	cd_intervalo		= cd_intervalo_p
and		cd_setor_atendimento	= cd_setor_p
and		((coalesce(cd_material::text, '') = '') or (cd_material = cd_material_p));

if (ie_opcao_p = '1') then
	ds_retorno_w	:= ie_limpa_prim_hor_w;
else
	ds_retorno_w	:= ie_sem_aprazamento_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_apra_interv_rep ( cd_intervalo_p text, cd_setor_p bigint, cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;
