-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_perfil_acomod_regra ( cd_perfil_p bigint, cd_tipo_acomodacao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1)	:= 'S';
qt_regra_perfil_w		integer;
qt_regra_perfil_acomod_w	integer;
cd_estabelecimento_w		integer;


BEGIN
select	count(*)
into STRICT	qt_regra_perfil_w
from	regra_tipo_acomodacao
where	cd_perfil	= cd_perfil_p;

cd_estabelecimento_w	:=	wheb_usuario_pck.get_cd_estabelecimento;

if (qt_regra_perfil_w > 0) then
	select	count(*)
	into STRICT	qt_regra_perfil_acomod_w
	from	regra_tipo_acomodacao
	where	cd_perfil		= cd_perfil_p
	and	cd_tipo_acomodacao	= cd_tipo_acomodacao_p
	and	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w;
end if;

if (qt_regra_perfil_w > 0) and (qt_regra_perfil_acomod_w = 0) then
	ds_retorno_w	:= 'N';
else
	ds_Retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_perfil_acomod_regra ( cd_perfil_p bigint, cd_tipo_acomodacao_p bigint) FROM PUBLIC;

