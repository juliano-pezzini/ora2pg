-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_usuario_estab (nm_usuario_origem_p text, nm_usuario_destino_p text, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w	smallint;
cd_setor_padrao_w	usuario_estabelecimento.cd_setor_padrao%type;

c01 CURSOR FOR
	SELECT	cd_estabelecimento,
		cd_setor_padrao
	from	usuario_estabelecimento a
	where	a.nm_usuario_param = nm_usuario_origem_p
	and	not exists (	SELECT	b.cd_estabelecimento
				from	usuario_estabelecimento b
				where	b.cd_estabelecimento = a.cd_estabelecimento
				and	b.nm_usuario_param   = nm_usuario_destino_p);


BEGIN
open c01;
loop
fetch c01 into
	cd_estabelecimento_w,
	cd_setor_padrao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	insert into usuario_estabelecimento(nm_usuario_param,
							cd_estabelecimento,
							cd_setor_padrao,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec)
		values (nm_usuario_destino_p,
							cd_estabelecimento_w,
							cd_setor_padrao_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p);

end loop;
close c01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_usuario_estab (nm_usuario_origem_p text, nm_usuario_destino_p text, nm_usuario_p text) FROM PUBLIC;
