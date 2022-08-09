-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE libera_setor_perfil (cd_setor_p bigint,cd_perfil_p bigint,nm_usuario_atual_p text) AS $body$
DECLARE


nm_usuario_w	varchar(15);

C01 CURSOR FOR
	SELECT	a.nm_usuario
	from	usuario_perfil a
	where	a.cd_perfil	= cd_perfil_p
	and		not exists (SELECT 	1
						from	usuario_setor b
						where	a.nm_usuario = b.nm_usuario_param
						and		b.cd_setor_atendimento = cd_setor_p);


BEGIN

open C01;
loop
fetch C01 into
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into	usuario_setor(
		nm_usuario_param,
		cd_setor_atendimento,
		dt_atualizacao,
		nm_usuario)
	values (
		nm_usuario_w,
		cd_setor_p,
		clock_timestamp(),
		nm_usuario_atual_p);
	end;
end loop;
close C01;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE libera_setor_perfil (cd_setor_p bigint,cd_perfil_p bigint,nm_usuario_atual_p text) FROM PUBLIC;
