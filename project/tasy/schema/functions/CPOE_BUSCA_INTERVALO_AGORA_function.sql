-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_busca_intervalo_agora ( nr_atendimento_p bigint, ie_tipo_item_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_continuo_p text default 'N') RETURNS varchar AS $body$
DECLARE


cd_intervalo_w		intervalo_prescricao.cd_intervalo%type;

c01 CURSOR FOR
SELECT	cd_intervalo cd
from 	intervalo_prescricao
where	ie_situacao = 'A'
and 	Obter_se_intervalo(cd_intervalo,ie_tipo_item_p) = 'S'
and		((coalesce(ie_continuo_p , 'N') = 'N' and coalesce(ie_continuo , 'N') = 'N') or (coalesce(ie_continuo_p, 'N') = 'S' and coalesce(ie_continuo , 'N') = 'S'))
and 	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p))
and 	ie_agora = 'S'
and 	cpoe_obter_se_exibe_interv(nr_atendimento_p, cd_estabelecimento_p, cd_intervalo, cd_perfil_p, nm_usuario_p) = 'S'
order by
		coalesce(nr_seq_apresent,999),
		ds_intervalo;

BEGIN

open c01;
loop
fetch c01 into cd_intervalo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		exit;
	end if;
	end;
end loop;
close c01;

return cd_intervalo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_busca_intervalo_agora ( nr_atendimento_p bigint, ie_tipo_item_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_continuo_p text default 'N') FROM PUBLIC;

