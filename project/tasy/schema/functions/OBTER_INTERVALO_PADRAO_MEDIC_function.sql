-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_intervalo_padrao_medic ( cd_intervalo_p text, cd_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_opcao_w	varchar(20);
cd_intervalo_w	varchar(20);

/*       OPÇÕES
SC
ACM
AGORA */
BEGIN
if (ie_opcao_p = 'SN') then

	select  max(ie_se_necessario)
	into STRICT	ie_opcao_w
	from	intervalo_prescricao
	where   ie_se_necessario = 'S'
	and     ie_situacao = 'A'
	and     cd_intervalo = cd_intervalo_p
	and     Obter_se_intervalo(cd_intervalo, 1) = 'S';

	if (ie_opcao_w <> 'S') then

		select	max(cd_intervalo)
		into STRICT	cd_intervalo_w
		from	intervalo_prescricao
		where	ie_se_necessario = 'S'
		and	ie_situacao = 'A'
		and     Obter_se_intervalo(cd_intervalo, 1) = 'S';

	else
		cd_intervalo_w := cd_intervalo_p;
	end if;

elsif (ie_opcao_p = 'ACM') then

	select  max(ie_ACM)
	into STRICT	ie_opcao_w
	from	intervalo_prescricao
	where   ie_ACM = 'S'
	and     ie_situacao = 'A'
	and     cd_intervalo = cd_intervalo_p
	and     Obter_se_intervalo(cd_intervalo, 1) = 'S';

	if (ie_opcao_w <> 'S') then

		select	max(cd_intervalo)
		into STRICT	cd_intervalo_w
		from	intervalo_prescricao
		where	ie_ACM = 'S'
		and	ie_situacao = 'A'
		and     Obter_se_intervalo(cd_intervalo, 1) = 'S';

	else
		cd_intervalo_w := cd_intervalo_p;
	end if;

elsif (ie_opcao_p = 'AGORA') then

	select  max(ie_agora)
	into STRICT	ie_opcao_w
	from	intervalo_prescricao
	where   ie_agora = 'S'
	and     ie_situacao = 'A'
	and     cd_intervalo = cd_intervalo_p
	and     Obter_se_intervalo(cd_intervalo, 1) = 'S';

	if (ie_opcao_w <> 'S') then

		select	max(cd_intervalo)
		into STRICT	cd_intervalo_w
		from	intervalo_prescricao
		where	ie_agora = 'S'
		and	ie_situacao = 'A'
		and     Obter_se_intervalo(cd_intervalo, 1) = 'S';

	else
		cd_intervalo_w := cd_intervalo_p;
	end if;

end if;

return	cd_intervalo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_intervalo_padrao_medic ( cd_intervalo_p text, cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;

