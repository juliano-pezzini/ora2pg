-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_se_exibe_evolucao (cd_evolucao_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_exibe_w		varchar(1);
ie_tipo_evolucao_w	varchar(3);


BEGIN

if (ie_opcao_p	= 100) then --Todas do usuário
	select	coalesce(max('S'),'N')
	into STRICT	ie_exibe_w
	from	evolucao_paciente
	where	cd_evolucao	= cd_evolucao_p
	and	nm_usuario	= nm_usuario_p
	and	nr_atendimento	= nr_atendimento_p
	and	ie_tipo_evolucao <> '9';

elsif (ie_opcao_p	= 200) then --Todas do atendimento
	select	coalesce(max('S'),'N')
	into STRICT	ie_exibe_w
	from	evolucao_paciente
	where	cd_evolucao	= cd_evolucao_p
	and	nr_atendimento	= nr_atendimento_p
	and	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or (nm_usuario = nm_usuario_p))
	and	ie_tipo_evolucao	<> '9';

elsif (ie_opcao_p	= 300) then --Todas do paciente
	select	coalesce(max('S'),'N')
	into STRICT	ie_exibe_w
	from	evolucao_paciente
	where	cd_evolucao	= cd_evolucao_p
	and	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or (nm_usuario = nm_usuario_p))
	and	ie_tipo_evolucao	<> '9';

elsif (ie_opcao_p	= 400) then --Todas do paciente do usuário
	select	coalesce(max('S'),'N')
	into STRICT	ie_exibe_w
	from	evolucao_paciente
	where	cd_evolucao	= cd_evolucao_p
	and	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	nm_usuario		= nm_usuario_p
	and	ie_tipo_evolucao	<> '9';


elsif (ie_opcao_p	= 500) then --Todas do paciente da função do usuário
	select	max(ie_tipo_evolucao)
	into STRICT	ie_tipo_evolucao_w
	from	usuario
	where	nm_usuario	= nm_usuario_p;

	select	coalesce(max('S'),'N')
	into STRICT	ie_exibe_w
	from	evolucao_paciente
	where	cd_evolucao	= cd_evolucao_p
	and	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or (nm_usuario = nm_usuario_p))
	and	ie_tipo_evolucao	= ie_tipo_evolucao_w;

else

	select	coalesce(max('S'),'N')
	into STRICT	ie_exibe_w
	from	evolucao_paciente
	where	cd_evolucao	= cd_evolucao_p
	and	nr_atendimento	= nr_atendimento_p
	and	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or (nm_usuario = nm_usuario_p))
	and	ie_tipo_evolucao = to_char(coalesce(ie_opcao_p,0));

end if;

return	ie_exibe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_se_exibe_evolucao (cd_evolucao_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p bigint, nm_usuario_p text) FROM PUBLIC;

