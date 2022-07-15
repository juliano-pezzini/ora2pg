-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intdisp_valida_usuario ( cd_barras_p text, cd_local_estoque_p text, nm_usuario_lib_p INOUT text, ie_tipo_lib_p INOUT text, ds_erro_p INOUT text) AS $body$
DECLARE


nm_usuario_w		varchar(15);
ie_tipo_lib_w		varchar(15);
ie_situacao_w		varchar(1);

c01 CURSOR FOR
	SELECT	ie_tipo_lib
	from	dis_lib_usuario a
	where	cd_local_estoque = cd_local_estoque_p
	and	exists (	SELECT	1
			from	usuario_perfil x
			where	x.nm_usuario like nm_usuario_w
			and	x.cd_perfil = coalesce(a.cd_perfil, x.cd_perfil))
	and	coalesce(a.nm_usuario_lib,nm_usuario_w) like nm_usuario_w
	order by nm_usuario_lib desc,
		cd_perfil desc;


BEGIN

begin
ds_erro_p := null;

select	nm_usuario,
	ie_situacao
into STRICT	nm_usuario_w,
	ie_situacao_w
from	usuario
where	cd_barras like cd_barras_p;
exception
when others then
	ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(280366);
end;

if (ie_situacao_w <> 'A') then
	ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(280367);
end if;

if (coalesce(ds_erro_p::text, '') = '') and (nm_usuario_w IS NOT NULL AND nm_usuario_w::text <> '') then
	begin

	open C01;
	loop
	fetch C01 into
		ie_tipo_lib_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;

	nm_usuario_lib_p := nm_usuario_w;
	ie_tipo_lib_p := coalesce(ie_tipo_lib_w,'XXX');

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intdisp_valida_usuario ( cd_barras_p text, cd_local_estoque_p text, nm_usuario_lib_p INOUT text, ie_tipo_lib_p INOUT text, ds_erro_p INOUT text) FROM PUBLIC;

