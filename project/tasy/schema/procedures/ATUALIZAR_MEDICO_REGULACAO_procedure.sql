-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_medico_regulacao ( nr_crm_p text, nr_cpf_p text, cd_prof_regulacao_p text) AS $body$
DECLARE


cd_interno_w    pessoa_fisica.cd_pessoa_fisica%type;
cd_externo_w    conversao_meio_externo.cd_externo%type;


BEGIN

	-- verifica se existe registro para o CRM + nome do médico
	if (cd_prof_regulacao_p IS NOT NULL AND cd_prof_regulacao_p::text <> '') then
		select	max(a.cd_pessoa_fisica)
		into STRICT	cd_interno_w
                from    medico a,
                        pessoa_fisica b
                where   a.cd_pessoa_fisica = b.cd_pessoa_fisica
		and	nr_crm = nr_crm_p
		and	nr_cpf = trim(both nr_cpf_p);

		if (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then
			-- verifica se já existe registro na tabela CONVERSAO_MEIO_EXTERNO
			select	max(cd_externo)
			into STRICT	cd_externo_w
			from	conversao_meio_externo
			where	nm_tabela = 'MEDICO_REGULACAO'
			and	nm_atributo = 'CD_PROFISSIONAL'
			and	cd_interno = cd_interno_w;

			-- se não achou, insere
			if (coalesce(cd_externo_w::text, '') = '') then
				insert into conversao_meio_externo(
					nm_tabela,
					nm_atributo,
					cd_interno,
					cd_externo,
					dt_atualizacao,
					nm_usuario,
					nr_sequencia,
					ie_sistema_externo,
					IE_ENVIO_RECEB
				) values (
					'MEDICO_REGULACAO',
					'CD_PROFISSIONAL',
					cd_interno_w,
					cd_prof_regulacao_p,
					clock_timestamp(),
					'Regulacao',
					nextval('conversao_meio_externo_seq'),
					'REG',
					'A'
				);
			end if;
		end if;

	end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_medico_regulacao ( nr_crm_p text, nr_cpf_p text, cd_prof_regulacao_p text) FROM PUBLIC;

