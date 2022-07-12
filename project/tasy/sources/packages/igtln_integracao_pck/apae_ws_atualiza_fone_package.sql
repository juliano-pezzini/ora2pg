-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	-- Atualiza dados telefone
CREATE OR REPLACE PROCEDURE igtln_integracao_pck.apae_ws_atualiza_fone (cd_pessoa_fisica_p text, nm_usuario_p text, ie_tipo_p text, nr_ddd_telefone_p text, nr_telefone_p text) AS $body$
DECLARE

	nr_sequencia_w	bigint;
	
BEGIN
		if (ie_tipo_p = 'F') then
			select	max(nr_sequencia)
			into STRICT	nr_sequencia_w
			from	compl_pessoa_fisica
			where	ie_tipo_complemento = 1
			and		cd_pessoa_fisica = cd_pessoa_fisica_p;

			if (coalesce(nr_sequencia_w::text, '') = '') then
				select	coalesce(max(nr_sequencia),0) + 1
				into STRICT	nr_sequencia_w
				from	compl_pessoa_fisica
				where	cd_pessoa_fisica = cd_pessoa_fisica_p;

				insert into compl_pessoa_fisica(
					nr_sequencia,
					cd_pessoa_fisica,
					ie_tipo_complemento,
					dt_atualizacao,
					nm_usuario,
					nr_ddd_telefone,
					nr_telefone
				) values (
					nr_sequencia_w,
					cd_pessoa_fisica_p,
					1,
					clock_timestamp(),
					nm_usuario_p,
					nr_ddd_telefone_p,
					nr_telefone_p
				);
			else
				update	compl_pessoa_fisica
				set		dt_atualizacao = clock_timestamp(),
						nm_usuario = nm_usuario_p,
						nr_ddd_telefone = nr_ddd_telefone_p,
						nr_telefone = nr_telefone_p
				where	nr_sequencia = nr_sequencia_w
				and		ie_tipo_complemento = 1
				and		cd_pessoa_fisica = cd_pessoa_fisica_p;
			end if;
		end if;

		if (ie_tipo_p = 'M') then
			update	pessoa_fisica
			set		nr_ddd_celular = nr_ddd_telefone_p,
					nr_telefone_celular = nr_telefone_p
			where	cd_pessoa_fisica = cd_pessoa_fisica_p;
		end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE igtln_integracao_pck.apae_ws_atualiza_fone (cd_pessoa_fisica_p text, nm_usuario_p text, ie_tipo_p text, nr_ddd_telefone_p text, nr_telefone_p text) FROM PUBLIC;
