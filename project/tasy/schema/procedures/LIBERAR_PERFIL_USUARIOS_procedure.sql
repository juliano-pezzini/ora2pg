-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_perfil_usuarios ( cd_perfil_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nm_usuario_w	varchar(15);

c01 CURSOR FOR
SELECT	u.nm_usuario
from	usuario u
where	u.ie_situacao = 'A'
and	not exists (
		SELECT	1
		from	usuario_perfil p
		where	p.nm_usuario = u.nm_usuario
		and	p.cd_perfil = cd_perfil_p);


BEGIN
if (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	open c01;
	loop
	fetch c01 into nm_usuario_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		insert into usuario_perfil(
			nm_usuario,
			cd_perfil,
			dt_atualizacao,
			nm_usuario_atual,
			ds_observacao,
			nr_seq_apres,
			dt_liberacao)
		values (
			nm_usuario_w,
			cd_perfil_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_observacao_p,
			null,
			clock_timestamp());
		end;
	end loop;
	close c01;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_perfil_usuarios ( cd_perfil_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

