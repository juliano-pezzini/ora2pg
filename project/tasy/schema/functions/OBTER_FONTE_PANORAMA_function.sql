-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_fonte_panorama ( cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
qt_tamanho_fonte_w	regra_perm_panorama.qt_tamanho_fonte%type;


BEGIN

select	max(qt_tamanho_fonte)
into STRICT 	qt_tamanho_fonte_w
from	regra_perm_panorama
where	cd_perfil = cd_perfil_p;

if (coalesce(qt_tamanho_fonte_w::text, '') = '') then  -- se não encontrou a regra para o perfil, busca uma regra sem perfil definido.
	select	max(qt_tamanho_fonte)
	into STRICT 	qt_tamanho_fonte_w
	from	regra_perm_panorama
	where	coalesce(cd_perfil::text, '') = '';
end if;

if (coalesce(qt_tamanho_fonte_w::text, '') = '') then
	ds_retorno_w	:= '12'; -- valor padrão do Panorama.
else
	ds_retorno_w	:= qt_tamanho_fonte_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_fonte_panorama ( cd_perfil_p bigint) FROM PUBLIC;

