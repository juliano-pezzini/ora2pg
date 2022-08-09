-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE egk_inserir_end_convenio ( nm_municipio_p text, cd_cep_p bigint, nm_rua_p text, nr_casa_p text, cd_pessoa_fisica_p text, cd_convenio_p bigint, nm_usuario_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, cd_usuario_convenio_p text) AS $body$
DECLARE


cd_convenio_w bigint;
ds_convenio_w varchar(15);
nr_seq_compl_w compl_pessoa_fisica.nr_sequencia%type;
nr_seq_pessoa_conv_w  bigint;
nr_seq_compl_endereco_w bigint;

BEGIN

	cd_convenio_w := 0;
	/*  Rotina para inserir o endereço  */

	select max(nr_sequencia)
	into STRICT nr_seq_compl_endereco_w
	from compl_pessoa_fisica
	where cd_pessoa_fisica = cd_pessoa_fisica_p;

	if (coalesce(nr_seq_compl_endereco_w,0) = 0) then  /*Se o paciente já ter  endereço cadastrado, então NÃO vai inserir,*/
		select coalesce(max(nr_sequencia),0) + 1
		into STRICT nr_seq_compl_w
		from compl_pessoa_fisica
		where cd_pessoa_fisica = cd_pessoa_fisica_p;

		insert into compl_pessoa_fisica(nr_sequencia,
		cd_pessoa_fisica,
		ie_tipo_complemento,
		cd_cep,
		dt_atualizacao,
		ds_endereco,
		ds_compl_end,
		ds_municipio,
		nm_usuario,
		nm_usuario_nrec,
		dt_atualizacao_nrec)
		values ( nr_seq_compl_w,
		cd_pessoa_fisica_p,
		'1',
		cd_cep_p,
		clock_timestamp(),
		nm_rua_p,
		nr_casa_p,
		nm_municipio_p,
		nm_usuario_p,
		nm_usuario_p,
		clock_timestamp()
		);

	end if;

	commit;

	/*  Rotina para inserir o convenio */

	select max(cd_convenio)
	into STRICT cd_convenio_w
	from convenio
	where ie_situacao = 'A'
	and   cd_integracao = cd_convenio_p;


	if (coalesce(cd_convenio_w,0) > 0) then /*Se o convenio existir, então insere o convenio para o paciente*/
		select count(nr_sequencia)
		into STRICT nr_seq_pessoa_conv_w
		from pessoa_titular_convenio
		where cd_convenio = cd_convenio_w
		and cd_pessoa_fisica = cd_pessoa_fisica_p;

		if (coalesce(nr_seq_pessoa_conv_w,0) = 0) then /*Se ainda nao existe um convenio para este paciente, então insere */
			insert into pessoa_titular_convenio( nr_sequencia,
			cd_convenio,
			cd_pessoa_fisica,
			dt_atualizacao,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			dt_inicio_vigencia,
			dt_fim_vigencia,
			dt_validade_carteira,
            cd_usuario_convenio)
			values ( nextval('pessoa_titular_convenio_seq'),
			cd_convenio_w,
			cd_pessoa_fisica_p,
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			clock_timestamp(),
			dt_inicio_vigencia_p,
			dt_fim_vigencia_p,
			dt_fim_vigencia_p,
            cd_usuario_convenio_p);
		end if;

	end if;

	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE egk_inserir_end_convenio ( nm_municipio_p text, cd_cep_p bigint, nm_rua_p text, nr_casa_p text, cd_pessoa_fisica_p text, cd_convenio_p bigint, nm_usuario_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, cd_usuario_convenio_p text) FROM PUBLIC;
