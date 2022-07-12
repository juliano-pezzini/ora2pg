-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_encerra_panorama ( cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_encerra_panorama_w	regra_perm_panorama.ie_encerra_panorama%type;


BEGIN

select	coalesce(max(ie_encerra_panorama),'N')
into STRICT 	ie_encerra_panorama_w
from	regra_perm_panorama
where	cd_perfil = cd_perfil_p;

if (coalesce(ie_encerra_panorama_w,'N') = 'N') then  -- se não encontrou a regra para o perfil, busca uma regra sem perfil definido.
	select	coalesce(max(ie_encerra_panorama),'N')
	into STRICT 	ie_encerra_panorama_w
	from	regra_perm_panorama
	where	coalesce(cd_perfil::text, '') = '';
end if;

ds_retorno_w	:= coalesce(ie_encerra_panorama_w,'N');

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_encerra_panorama ( cd_perfil_p bigint) FROM PUBLIC;
