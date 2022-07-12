-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atendimento_paciente ( cd_pessoa_fisica_p text, cd_estabelecimento_p text) RETURNS bigint AS $body$
DECLARE

nr_atendimento_w	bigint;

BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	begin
	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atendimento_paciente
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	ie_tipo_atendimento	= 1
	and	coalesce(dt_alta::text, '') = ''
	and	ie_fim_conta <> 'F';

	if (obter_funcao_ativa = 950) and (coalesce(nr_atendimento_w::text, '') = '') then
		CALL Wheb_assist_pck.set_informacoes_usuario(cd_estabelecimento_p, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario);
		if (Wheb_assist_pck.obterParametroFuncao(950,204) = 'S') then
			select	max(nr_atendimento)
			into STRICT	nr_atendimento_w
			from	atendimento_paciente
			where	cd_pessoa_fisica	= cd_pessoa_fisica_p
			and		cd_estabelecimento	= cd_estabelecimento_p
			and		ie_tipo_atendimento	= 7
			and		coalesce(dt_alta::text, '') = ''
			and		ie_fim_conta <> 'F';
		end if;
	end if;
	end;
end if;

return	nr_atendimento_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atendimento_paciente ( cd_pessoa_fisica_p text, cd_estabelecimento_p text) FROM PUBLIC;

