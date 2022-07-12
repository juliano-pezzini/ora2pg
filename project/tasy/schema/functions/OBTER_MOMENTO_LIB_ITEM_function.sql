-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_momento_lib_item (nr_seq_regra_p bigint, cd_material_p bigint, cd_setor_atendimento_p bigint, cd_intervalo_p text, ie_acm_p text, ie_se_necessario_p text, ie_dose_espec_p text, ie_agora_p text, ie_retorno_vazio_p text) RETURNS varchar AS $body$
DECLARE


ie_precisa_liberacao_w	varchar(1) := coalesce(ie_retorno_vazio_p,'S');

c01 CURSOR FOR
SELECT	ie_precisa_liberacao
from	regra_momento_lib_item
where	nr_seq_regra = nr_seq_regra_p
and	((coalesce(cd_material::text, '') = '') or (cd_material = cd_material_p))
and	((coalesce(cd_setor_atendimento::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
and	((coalesce(cd_intervalo::text, '') = '') or (cd_intervalo = cd_intervalo_p))
and	coalesce(ie_acm,'N') 			= coalesce(ie_acm_p,'N')
and	coalesce(ie_se_necessario,'N') 		= coalesce(ie_se_necessario_p,'N')
and	coalesce(ie_dose_espec,'N')			= coalesce(ie_dose_espec_p,'N')
and	coalesce(ie_agora,'N')			= coalesce(ie_agora_p,'N')
order by cd_material,
	cd_setor_atendimento,
	cd_intervalo,
	ie_acm,
	ie_se_necessario,
	ie_dose_espec,
	ie_agora,
	ie_precisa_liberacao;

BEGIN

open C01;
loop
fetch C01 into
	ie_precisa_liberacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	ie_precisa_liberacao_w	:= ie_precisa_liberacao_w;
end loop;
close C01;

return	ie_precisa_liberacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_momento_lib_item (nr_seq_regra_p bigint, cd_material_p bigint, cd_setor_atendimento_p bigint, cd_intervalo_p text, ie_acm_p text, ie_se_necessario_p text, ie_dose_espec_p text, ie_agora_p text, ie_retorno_vazio_p text) FROM PUBLIC;
