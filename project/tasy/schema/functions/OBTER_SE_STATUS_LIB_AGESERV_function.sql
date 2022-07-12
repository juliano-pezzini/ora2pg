-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_status_lib_ageserv ( ie_status_agenda_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_regra_w	bigint := 0;
ie_permite_w	varchar(1) := 'S';


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	agenda_serv_regra_status
where	(((cd_perfil = cd_perfil_p) or (coalesce(cd_perfil::text, '') = ''))
and	((cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = '')))
and		coalesce(ie_situacao,'A')	= 'A';

if (qt_regra_w > 0) then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_permite_w
	from	agenda_serv_regra_status
	where	ie_status_agenda 	= ie_status_agenda_p
	and	(((cd_perfil = cd_perfil_p) or (coalesce(cd_perfil::text, '') = ''))
	and	((cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = '')))
	and	coalesce(ie_situacao,'A')	= 'A';

end if;

return	ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_status_lib_ageserv ( ie_status_agenda_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

