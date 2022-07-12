-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_perfil_grupo_agserv ( nr_seq_Grupo_p bigint, cd_perfil_p bigint, cd_perfil_regra_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(40);
nr_seq_regra_w			bigint;


BEGIN

begin
select	nr_sequencia
into STRICT	nr_seq_regra_w
from	regra_grupo_agenda_perfil
where	nr_seq_grupo	= nr_seq_grupo_p  LIMIT 1;
exception
	when others then
	nr_Seq_Regra_w	:= 0;
	ds_retorno_w	:= 'N';
end;

if (nr_seq_regra_w <> 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_w
	from	regra_grupo_agenda_perfil
	where	nr_seq_grupo	= nr_seq_grupo_p
	and	cd_perfil	= cd_perfil_p;

	if (nr_seq_regra_w <> 0) then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;
end if;

if (cd_perfil_regra_p	= cd_perfil_p) or
	((coalesce(cd_perfil_regra_p::text, '') = '') and (nr_seq_regra_w	= 0)) then
	ds_retorno_w	:= 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_perfil_grupo_agserv ( nr_seq_Grupo_p bigint, cd_perfil_p bigint, cd_perfil_regra_p bigint) FROM PUBLIC;
