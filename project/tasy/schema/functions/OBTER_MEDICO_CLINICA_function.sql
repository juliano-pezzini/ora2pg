-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_clinica (ie_clinica_p bigint default 0, ie_tipo_atendimento_p bigint default 0, cd_pessoa_fisica_p text default null) RETURNS varchar AS $body$
DECLARE


cd_medico_w	varchar(10);
cd_perfil_w	bigint;
C01 CURSOR FOR
	SELECT	cd_medico_resp
	from	regra_clinica_medico_resp
	where	(((ie_clinica_p IS NOT NULL AND ie_clinica_p::text <> '') and ie_clinica_p = 0) or (ie_clinica = ie_clinica_p))
	and	    ((coalesce(ie_tipo_atendimento_p,0) = 0) or (ie_tipo_atendimento = ie_tipo_atendimento_p) or (coalesce(ie_tipo_atendimento::text, '') = ''))
	and	coalesce(cd_perfil_ativo, cd_perfil_w) = cd_perfil_w
	and	cd_estabelecimento = obter_estabelecimento_ativo
	and (coalesce(cd_pessoa_fisica::text, '') = '' or (cd_pessoa_fisica = cd_pessoa_fisica_p or coalesce(cd_pessoa_fisica_p::text, '') = ''))
	order by coalesce(cd_pessoa_fisica,0),
		 coalesce(cd_perfil_ativo,0),
		 coalesce(ie_clinica,0),		
		 coalesce(ie_tipo_atendimento,0);

BEGIN

cd_perfil_w := coalesce(obter_perfil_ativo, 0);
open C01;
loop
fetch C01 into	
	cd_medico_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	cd_medico_w := cd_medico_w;
	end;
end loop;
close C01;

return	cd_medico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_clinica (ie_clinica_p bigint default 0, ie_tipo_atendimento_p bigint default 0, cd_pessoa_fisica_p text default null) FROM PUBLIC;
