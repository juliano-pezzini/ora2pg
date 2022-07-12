-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_plano_lib_med_agecons ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_pessoa_fisica_p text, cd_plano_p text, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE



ie_medico_credenciado_w		varchar(1);
dt_referencia_w				timestamp;

c01 CURSOR FOR
	SELECT	coalesce(ie_conveniado,'N')
	from	medico_convenio
	where	cd_pessoa_fisica		= cd_pessoa_fisica_p
	and		cd_convenio				= cd_convenio_p
	and		((cd_estabelecimento 	= cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = ''))
	and 	((coalesce(cd_plano_convenio::text, '') = '') or (coalesce(cd_plano_convenio,'0') 	= coalesce(cd_plano_p,'0')))
	and		dt_referencia_w between coalesce(dt_inicio_vigencia,dt_referencia_w) and fim_dia(coalesce(dt_final_vigencia,dt_referencia_w))

	order by	coalesce(cd_estabelecimento,0),
				somente_numero(coalesce(cd_plano_convenio,'0'));


BEGIN

ie_medico_credenciado_w			:= 'N';
dt_referencia_w				:= coalesce(dt_referencia_p,clock_timestamp());

open c01;
loop
fetch c01 into
	ie_medico_credenciado_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ie_medico_credenciado_w		:= ie_medico_credenciado_w;
end loop;
close c01;

return ie_medico_credenciado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_plano_lib_med_agecons ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_pessoa_fisica_p text, cd_plano_p text, dt_referencia_p timestamp) FROM PUBLIC;
