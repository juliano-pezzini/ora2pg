-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_perfil_setor_cargo ( nm_usuario_p text, cd_cargo_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint) AS $body$
BEGIN

if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
	insert into cargo_setor(nr_sequencia,
				cd_cargo,
				cd_setor_atendimento,
				dt_atualizacao,
				nm_usuario)
			values (nextval('cargo_setor_seq'),
				cd_cargo_p,
				cd_setor_atendimento_p,
				clock_timestamp(),
				nm_usuario_p);

elsif (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') then

	insert into cargo_perfil(nr_sequencia,
				cd_cargo,
				cd_perfil,
				dt_atualizacao,
				nm_usuario)
			values (nextval('cargo_perfil_seq'),
				cd_cargo_p,
				cd_perfil_p,
				clock_timestamp(),
				nm_usuario_p);

end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_perfil_setor_cargo ( nm_usuario_p text, cd_cargo_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint) FROM PUBLIC;

