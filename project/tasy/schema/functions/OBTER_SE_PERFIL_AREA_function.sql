-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_perfil_area ( nr_seq_area_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ie_utiliza_w	varchar(1) := 'N';
cd_setor_atendimento_w	bigint;


BEGIN

select	coalesce(max('N'),'S')
into STRICT	ie_utiliza_w
from	adep_area_prep_lib
where	nr_seq_area = nr_seq_area_p;


cd_setor_atendimento_w := obter_setor_usuario(wheb_usuario_pck.get_nm_usuario);

if (ie_utiliza_w = 'N') then

	select	coalesce(max('S'),'N')
	into STRICT	ie_utiliza_w
	from	adep_area_prep_lib
	where	nr_seq_area = nr_seq_area_p
	and		coalesce(cd_perfil,cd_perfil_p)	= cd_perfil_p
	and		coalesce(CD_SETOR_ATENDIMENTO,cd_setor_atendimento_w) = cd_setor_atendimento_w;


end if;

return	ie_utiliza_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_perfil_area ( nr_seq_area_p bigint, cd_perfil_p bigint) FROM PUBLIC;
