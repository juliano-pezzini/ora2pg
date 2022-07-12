-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prontuario_envio ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE



	ie_liberado_w				varchar(1) :=  'N';
	ie_liberacao_total_w		varchar(1);
	ie_existe_regra_w			varchar(1);
	ie_existe_regra_externo_w	varchar(1);

	ie_nivel_atencao_perfil_w	perfil.ie_nivel_atencao%type;



BEGIN

	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

		ie_nivel_atencao_perfil_w := wheb_assist_pck.get_nivel_atencao_perfil;

		select	coalesce(max('S'),'N')
		into STRICT	ie_existe_regra_w
		from	pf_lib_pront a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
		and		coalesce(a.ie_situacao,'A')	= 'A'
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		coalesce(a.dt_inativacao::text, '') = '';


		if (ie_existe_regra_w = 'S') then

			select	coalesce(max('S'),'N')
			into STRICT	ie_existe_regra_externo_w
			from	pf_lib_pront a
			where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
			and		coalesce(a.ie_situacao,'A')	= 'A'
			and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and		coalesce(a.dt_inativacao::text, '') = ''
			and		a.IE_NIVEL_ATENCAO_ORIG  = ie_nivel_atencao_perfil_w
			and	    a.ie_nivel_atencao_dest = 'E';

			if ( ie_existe_regra_externo_w = 'S') then

				select	coalesce(max('S'),'N')
				into STRICT	ie_liberado_w
				from	pf_lib_pront a
				where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
				and		coalesce(a.ie_situacao,'A')	= 'A'
				and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
				and		coalesce(a.dt_inativacao::text, '') = ''
				and	    a.ie_nivel_atencao_dest = 'E'
				and		clock_timestamp() between coalesce(a.dt_inicio,clock_timestamp()) and coalesce(a.dt_fim,clock_timestamp());

			end if;

			if ( ie_liberado_w = 'N') then

				select	coalesce(max('S'),'N')
				into STRICT	ie_liberacao_total_w
				from	PF_LIB_PRONT a
				where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
				and		coalesce(a.ie_situacao,'A')	= 'A'
				and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
				and		coalesce(a.dt_inativacao::text, '') = ''
				and		clock_timestamp() between coalesce(a.dt_inicio,clock_timestamp()) and coalesce(a.dt_fim,clock_timestamp())
				and		ie_liberacao_total = 'S';


				return ie_liberacao_total_w;


			end if;

		else

			return 'S';

		end if;


	end if;

	return ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prontuario_envio ( cd_pessoa_fisica_p text) FROM PUBLIC;
