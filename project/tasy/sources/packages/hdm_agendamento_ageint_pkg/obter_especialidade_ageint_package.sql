-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/* -------------------------------------------------------------------------------------------------------------------
	Finalidade:  Obter a especialidade médica do responsável pelo agendamento
	*/
CREATE OR REPLACE FUNCTION hdm_agendamento_ageint_pkg.obter_especialidade_ageint ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS bigint AS $body$
DECLARE


	cd_especialidade_w	especialidade_medica.cd_especialidade%type;

	C01 CURSOR FOR
		SELECT 	cd_especialidade
		from 	agenda
		where 	cd_pessoa_fisica = cd_pessoa_fisica_p
		and 	cd_estabelecimento = cd_estabelecimento_p
		and 	cd_tipo_agenda = 3 -- 'Consultas por médico'. Domínio(34)
		and 	ie_agenda_integrada = 'S' --Confirma se utiliza na agenda integrada (Cadastrado na agenda Integrada)
		and	(cd_especialidade IS NOT NULL AND cd_especialidade::text <> '')
		and	coalesce(cd_especialidade_w::text, '') = ''
		order by nr_seq_apresent desc;

	
BEGIN
	for r_C01 in C01 loop
		begin
		cd_especialidade_w := r_C01.cd_especialidade;
		end;
	end loop;

	return	cd_especialidade_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION hdm_agendamento_ageint_pkg.obter_especialidade_ageint ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
