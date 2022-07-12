-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_setor_intervalo ( cd_intervalo_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_material_p bigint default null, ie_via_aplicacao_p text default null, cd_unidade_basica_p text default null) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1);
ie_registros_w		varchar(1);


BEGIN

select	coalesce(max('S'),'N')
into STRICT		ie_registros_w
from		intervalo_setor
where	cd_intervalo	= cd_intervalo_p;

if (ie_registros_w = 'S') then
	select	coalesce(max('S'),'N')
	into STRICT		ie_retorno_w
	from		intervalo_setor
	where	cd_intervalo = cd_intervalo_p
	and		coalesce(cd_setor_atendimento,cd_setor_atendimento_p) = cd_setor_atendimento_p
	and		((coalesce(cd_estab::text, '') = '') or (cd_estab = coalesce(cd_estabelecimento_p,cd_estab)))
	and		((coalesce(cd_material::text, '') = '') or (cd_material = coalesce(cd_material_p,cd_material)))
	and		((coalesce(ie_via_aplicacao::text, '') = '') or (ie_via_aplicacao = coalesce(ie_via_aplicacao_p,ie_via_aplicacao)))
	and		((coalesce(cd_unidade_basica::text, '') = '') or (cd_unidade_basica = coalesce(cd_unidade_basica_p,cd_unidade_basica)));
else
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_setor_intervalo ( cd_intervalo_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_material_p bigint default null, ie_via_aplicacao_p text default null, cd_unidade_basica_p text default null) FROM PUBLIC;

