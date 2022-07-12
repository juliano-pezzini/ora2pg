-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_regra_perfil_agenda ( cd_perfil_p bigint, cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1)	:= 'S';
qt_Regra_w		bigint;
qt_regra_perfil_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_Regra_w
from	agenda_regra_lib_perfil
where	cd_agenda	= cd_agenda_p;

if (qt_regra_w	> 0) then
	select	count(*)
	into STRICT	qt_regra_perfil_w
	from	agenda_Regra_lib_perfil
	where	cd_agenda	= cd_agenda_p
	and	cd_perfil	= cd_perfil_p;

	if (qt_Regra_perfil_w	= 0) then
		ds_retorno_w	:= 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_regra_perfil_agenda ( cd_perfil_p bigint, cd_agenda_p bigint) FROM PUBLIC;

