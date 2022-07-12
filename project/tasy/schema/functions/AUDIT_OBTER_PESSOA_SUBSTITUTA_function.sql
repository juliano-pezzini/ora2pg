-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION audit_obter_pessoa_substituta ( cd_cargo_aprov_p bigint, nm_usuario_aprov_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
ie_substituto_w		varchar(1);
cd_pessoa_substituta_w	varchar(10);
nm_usuario_substituto_w	varchar(15);
cd_pessoa_usuario_w varchar(10);
qt_substituto_w		bigint;


BEGIN

ds_retorno_w	:= 'N';

if (coalesce(cd_cargo_aprov_p,0) <> 0) then

	select	count(*)
	into STRICT	qt_substituto_w
	from	aprov_audit_substituto
	where	cd_cargo = cd_cargo_aprov_p
	and	clock_timestamp() between dt_vigencia_inicial and dt_vigencia_final;

	if (coalesce(qt_substituto_w,0) > 0) then
		select	max(cd_pessoa_substituta)
		into STRICT	cd_pessoa_substituta_w
		from	aprov_audit_substituto
		where	cd_cargo = cd_cargo_aprov_p
	    and	clock_timestamp() between dt_vigencia_inicial and dt_vigencia_final;
	end if;

end if;


if (nm_usuario_aprov_p IS NOT NULL AND nm_usuario_aprov_p::text <> '') then

	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_usuario_w
	from	usuario
	where	nm_usuario = nm_usuario_aprov_p;

	select	count(*)
	into STRICT	qt_substituto_w
	from	aprov_audit_substituto
	where	cd_pessoa_fisica = cd_pessoa_usuario_w
	and	clock_timestamp() between dt_vigencia_inicial and dt_vigencia_final;

	if (coalesce(qt_substituto_w,0) > 0) then
		select	max(cd_pessoa_substituta)
		into STRICT	cd_pessoa_substituta_w
		from	aprov_audit_substituto
		where	cd_pessoa_fisica = cd_pessoa_usuario_w
		and	clock_timestamp() between dt_vigencia_inicial and dt_vigencia_final;
	end if;

end if;

if (cd_pessoa_substituta_w IS NOT NULL AND cd_pessoa_substituta_w::text <> '') then
	ie_substituto_w	:= 'S';
end if;


if (coalesce(ie_substituto_w,'N') = 'S') then

	select	max(nm_usuario)
	into STRICT	nm_usuario_substituto_w
	from	usuario
	where	cd_pessoa_fisica = cd_pessoa_substituta_w;

	if (nm_usuario_substituto_w = nm_usuario_p) then
		ds_retorno_w	:= 'S';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION audit_obter_pessoa_substituta ( cd_cargo_aprov_p bigint, nm_usuario_aprov_p text, nm_usuario_p text) FROM PUBLIC;

