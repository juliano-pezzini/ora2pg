-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE autenticacao_medica_itens ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, ie_opcao_p bigint, nm_usuario_p text) AS $body$
DECLARE

/*
1 - Materiais
2 - Procedimentos
*/
ds_biometria_w			varchar(4000);
ds_biometria_ww			varchar(4000);
cd_medico_autenticacao_w	varchar(15);
dt_autenticacao_w		timestamp;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	max(ds_biometria)
	into STRICT	ds_biometria_w
	from	pessoa_fisica_biometria
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	if (ie_opcao_p = 1) then

		select	max(ds_biometria),
			max(cd_medico_autenticacao),
			max(dt_autenticacao)
		into STRICT	ds_biometria_ww,
			cd_medico_autenticacao_w,
			dt_autenticacao_w
		from	material_atend_paciente
		where	nr_sequencia = nr_sequencia_p;

		if (dt_autenticacao_w IS NOT NULL AND dt_autenticacao_w::text <> '') then

			insert into matpaci_autenticacao(
				nr_sequencia,
				nr_seq_matpaci,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_medico_autenticacao,
				dt_autenticacao,
				ds_biometria)
			values (nextval('matpaci_autenticacao_seq'),
				nr_sequencia_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_medico_autenticacao_w,
				dt_autenticacao_w,
				ds_biometria_ww);

		end if;

		update	material_atend_paciente
		set	cd_medico_autenticacao = cd_pessoa_fisica_p,
			dt_autenticacao = clock_timestamp(),
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
			ds_biometria = ds_biometria_w
		where	nr_sequencia = nr_sequencia_p;

	elsif (ie_opcao_p = 2) then

		select	max(ds_biometria),
			max(cd_medico_autenticacao),
			max(dt_autenticacao)
		into STRICT	ds_biometria_ww,
			cd_medico_autenticacao_w,
			dt_autenticacao_w
		from	procedimento_paciente
		where	nr_sequencia = nr_sequencia_p;

		if (dt_autenticacao_w IS NOT NULL AND dt_autenticacao_w::text <> '') then

			insert into propaci_autenticacao(
				nr_sequencia,
				nr_seq_propaci,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_medico_autenticacao,
				dt_autenticacao,
				ds_biometria)
			values (nextval('propaci_autenticacao_seq'),
				nr_sequencia_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_medico_autenticacao_w,
				dt_autenticacao_w,
				ds_biometria_ww);

		end if;

		update	procedimento_paciente
		set	cd_medico_autenticacao = cd_pessoa_fisica_p,
			dt_autenticacao = clock_timestamp(),
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
			ds_biometria = ds_biometria_w
		where	nr_sequencia = nr_sequencia_p;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE autenticacao_medica_itens ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, ie_opcao_p bigint, nm_usuario_p text) FROM PUBLIC;

