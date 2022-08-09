-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_perfil_padrao ( nm_usuario_cad_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_perfil_w	integer;

C01 CURSOR FOR
	SELECT	cd_perfil
	from	perfil
	where	ie_situacao = 'A'
	and	coalesce(ie_libera_usu_auto,'N') = 'S'
	and	coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p;

BEGIN
if (nm_usuario_cad_p IS NOT NULL AND nm_usuario_cad_p::text <> '') then
	open C01;
	loop
	fetch C01 into
		cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		CALL liberar_perfil_usuario(cd_perfil_w,nm_usuario_cad_p,nm_usuario_p);
		end;
	end loop;
	close C01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_perfil_padrao ( nm_usuario_cad_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
