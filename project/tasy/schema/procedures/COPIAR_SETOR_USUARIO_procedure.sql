-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_setor_usuario (nm_usuario_origem_p text, nm_usuario_destino_p text, ie_limpa_reg_p text, nm_usuario_p text) AS $body$
DECLARE


cd_setor_atendimento_w	integer;

c01 CURSOR FOR
	SELECT	a.cd_setor_atendimento
	from	usuario_setor a
	where	a.nm_usuario_param = nm_usuario_origem_p
	and	a.cd_setor_atendimento not in (SELECT	b.cd_setor_atendimento
						from	usuario_setor b
						where	b.nm_usuario_param = nm_usuario_destino_p);


BEGIN

if (ie_limpa_reg_p		= 'S') then
	delete	from usuario_setor
	where	nm_usuario_param	= nm_usuario_destino_p;
end if;


open c01;
loop
fetch c01 into
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	insert into usuario_setor(nm_usuario_param,
			cd_setor_atendimento,
			dt_atualizacao,
			nm_usuario)
	values (nm_usuario_destino_p,
			cd_setor_atendimento_w,
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
-- REVOKE ALL ON PROCEDURE copiar_setor_usuario (nm_usuario_origem_p text, nm_usuario_destino_p text, ie_limpa_reg_p text, nm_usuario_p text) FROM PUBLIC;

