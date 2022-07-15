-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_dt_partic_cirur_pepo (cd_funcao_p bigint, nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_cirurgia_p bigint, dt_termino_p timestamp) AS $body$
DECLARE


vl_parametro_w	varchar(255);


BEGIN

if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') and (dt_termino_p IS NOT NULL AND dt_termino_p::text <> '') then
	begin
	vl_parametro_w := obter_param_usuario(	cd_funcao_p, nr_sequencia_p, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);

	if (upper(vl_parametro_w) = 'S') then
		begin
		CALL alterar_dt_partic_cirurgia(	nr_cirurgia_p,
						dt_termino_p,dt_termino_p);
		end;
	end if;
	end;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_dt_partic_cirur_pepo (cd_funcao_p bigint, nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_cirurgia_p bigint, dt_termino_p timestamp) FROM PUBLIC;

