-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_agenda_perfil ( nr_sequencia_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

select	coalesce(max('N'),'S')
into STRICT	ds_retorno_w
from	local_agenda_tasy a,
		local_agenda_tasy_lib b
where	a.nr_sequencia	= b.nr_seq_local
and		a.nr_sequencia	= nr_sequencia_p;

if (ds_retorno_w = 'N') then
	begin
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	local_agenda_tasy a,
			local_agenda_tasy_lib b
	where	a.nr_sequencia						= b.nr_seq_local
	and		a.nr_sequencia						= nr_sequencia_p
	and		coalesce(b.cd_perfil,coalesce(cd_perfil_p,0))	= coalesce(cd_perfil_p,0)
	and		coalesce(b.nm_usuario_liberacao, coalesce(wheb_usuario_pck.get_nm_usuario,'X')) = coalesce(wheb_usuario_pck.get_nm_usuario,'X');
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_agenda_perfil ( nr_sequencia_p bigint, cd_perfil_p bigint) FROM PUBLIC;
