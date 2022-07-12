-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_certificado_assinat () RETURNS varchar AS $body$
DECLARE


cd_certificado_w		varchar(100);
nm_usuario_w			varchar(15);
cd_estabelecimento_w		smallint;


BEGIN

nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

select	max(cd_certificado)
into STRICT	cd_certificado_w
from	usuario_estabelecimento
where	nm_usuario_param = nm_usuario_w
and		cd_estabelecimento = cd_estabelecimento_w;	
	

if (coalesce(cd_certificado_w::text, '') = '') then
	select	max(cd_certificado)
	into STRICT	cd_certificado_w
	from	usuario
	where	nm_usuario = nm_usuario_w;

end if;

return cd_certificado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_certificado_assinat () FROM PUBLIC;

