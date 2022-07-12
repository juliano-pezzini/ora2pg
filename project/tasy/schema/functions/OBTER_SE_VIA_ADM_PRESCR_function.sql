-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_via_adm_prescr ( cd_material_p bigint, ie_via_adm_p text, nr_prescricao_p bigint) RETURNS char AS $body$
DECLARE


ie_retorno_w		char(1) := 'S';
cd_estabelecimento_w	prescr_medica.cd_estabelecimento%type;
cd_setor_atendimento_w	prescr_medica.cd_setor_atendimento%type;


BEGIN

select	max(cd_estabelecimento)	,
		max(cd_setor_atendimento)
into STRICT	cd_estabelecimento_w,
		cd_setor_atendimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	select	coalesce(max('N'), 'S')
	into STRICT	ie_retorno_w
	from	mat_via_aplic where	cd_material	= cd_material_p
	and	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_w,1))	= coalesce(cd_estabelecimento_w,1) LIMIT 1;

	if (ie_retorno_w = 'N') then
		begin
		select	coalesce(max('S'),'N')
		into STRICT	ie_retorno_w
		from	material
		where	cd_material	= cd_material_p
		and	ie_via_aplicacao = ie_via_adm_p;

		if (ie_retorno_w = 'N') then

			select	coalesce(max('S'),'N')
			into STRICT	ie_retorno_w
			from	mat_via_aplic where	cd_material	= cd_material_p
			and	ie_via_aplicacao = ie_via_adm_p
			and	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_w,1))	= coalesce(cd_estabelecimento_w,1)
			and	coalesce(cd_setor_atendimento,coalesce(cd_setor_atendimento_w,1))	= coalesce(cd_setor_atendimento_w,1)
			and	coalesce(cd_setor_excluir,0) <>  coalesce(cd_setor_atendimento_w,1) LIMIT 1;
		end if;
		end;
	end if;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_via_adm_prescr ( cd_material_p bigint, ie_via_adm_p text, nr_prescricao_p bigint) FROM PUBLIC;

