-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_ultimo_atend_pac ( cd_pessoa_fisica_p text, cd_estabelecimento_p text) RETURNS varchar AS $body$
DECLARE


nr_atendimento_w	bigint;
ie_atendimento_w	varchar(1);


BEGIN

ie_atendimento_w := obter_param_usuario(7009, 271, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_atendimento_w);

if (coalesce(ie_atendimento_w,'U') = 'S') then

	select	substr(hd_obter_atend_hd_Dialise(cd_pessoa_fisica_p,hd_obter_hemodialise_atual(cd_pessoa_fisica_p, 'U')),1,30)
	into STRICT	nr_atendimento_w
	;
end if;
if (coalesce(nr_atendimento_w::text, '') = '') then

	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from   	atendimento_paciente a
	where  	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and    	cd_estabelecimento	= cd_estabelecimento_p
	and	ie_fim_conta		<> 'F'
	and	ie_fim_conta		<> 'F'
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and	exists (SELECT 	1
			from 	hd_log_geracao_atend x
			where 	a.nr_atendimento = x.nr_atendimento_nov)
	and	coalesce(dt_alta::text, '') = '';

	if (coalesce(nr_atendimento_w::text, '') = '') then

		select 	max(nr_atendimento)
		into STRICT	nr_atendimento_w
		from   	atendimento_paciente
		where  	cd_pessoa_fisica     	= cd_pessoa_fisica_p
		and    	cd_estabelecimento	= cd_estabelecimento_p
		and	ie_fim_conta		<>  'F'
		and	coalesce(dt_alta::text, '') = ''
		and	coalesce(dt_cancelamento::text, '') = '';
	end if;
end if;

return	nr_atendimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_ultimo_atend_pac ( cd_pessoa_fisica_p text, cd_estabelecimento_p text) FROM PUBLIC;

