-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_clinica_perfil ( cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_clinica_p bigint) RETURNS varchar AS $body$
DECLARE

ie_exibir_w	varchar(1);
ie_registros_w      	bigint;


BEGIN

select 	count(*)
into STRICT 	ie_registros_w
from 	pac_fila_regra_clinica
where  	cd_estabelecimento = cd_estabelecimento_p
and	coalesce(ie_situacao,'A') = 'A';

if (ie_registros_w > 0) then
	select 	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT 	ie_exibir_w
	from   	pac_fila_regra_clinica
	where  	cd_estabelecimento = cd_estabelecimento_p
	and	coalesce(ie_situacao,'A') = 'A'
	and	(((coalesce(cd_clinica::text, '') = '') and (ie_toda_clinica = 'S'))
	or	      (cd_clinica IS NOT NULL AND cd_clinica::text <> '' AND cd_clinica = cd_clinica_p)
	or	      ((coalesce(cd_clinica::text, '') = '') and (ie_toda_clinica = 'N') and (coalesce(cd_clinica_p,0) = 0)))
	and	coalesce(cd_perfil, coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0);
else
	ie_exibir_w := 'S';
end if;

return ie_exibir_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_clinica_perfil ( cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_clinica_p bigint) FROM PUBLIC;

