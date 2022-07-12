-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_conv_agecons (cd_estabelecimento_p bigint, cd_medico_p text, cd_convenio_p bigint, ie_forma_restricao_p text) RETURNS varchar AS $body$
DECLARE


ie_exibe_conv_w		varchar(1) := 'S';
ie_medico_credenciado_w	varchar(1);
ie_convenio_agecons_w	varchar(1);
ie_conv_lib_usuario_w   	varchar(1);


BEGIN
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') and (ie_forma_restricao_p IS NOT NULL AND ie_forma_restricao_p::text <> '') then

	if (ie_forma_restricao_p = 'N') then

		ie_exibe_conv_w	:= 'S';

	elsif (ie_forma_restricao_p = 'M') then

		if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then
		select	obter_se_medico_cred_agecons(cd_estabelecimento_p, cd_medico_p, cd_convenio_p, null, null,null,null,null,null,null,null,null)
		into STRICT	ie_medico_credenciado_w
		;

		ie_exibe_conv_w	:= ie_medico_credenciado_w;

		end if;

	elsif (ie_forma_restricao_p = 'H') then

		select	obter_valor_conv_estab(cd_convenio_p, cd_estabelecimento_p, 'IE_AGENDA_CONSULTA')
		into STRICT	ie_convenio_agecons_w
		;

		ie_exibe_conv_w	:= ie_convenio_agecons_w;

	elsif (ie_forma_restricao_p = 'MHO') then

		if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then
		select	obter_se_medico_credenciado(cd_estabelecimento_p, cd_medico_p, cd_convenio_p, null, null,null,null,null,null,null,null,null)
		into STRICT	ie_medico_credenciado_w
		;
		
		end if;

		select	obter_valor_conv_estab(cd_convenio_p, cd_estabelecimento_p, 'IE_AGENDA_CONSULTA')
		into STRICT	ie_convenio_agecons_w
		;

		if (ie_medico_credenciado_w = 'S') or (ie_convenio_agecons_w = 'S') then

			ie_exibe_conv_w	:= 'S';

		else

			ie_exibe_conv_w	:= 'N';

		end if;
		
	elsif (ie_forma_restricao_p = 'MHA') then

		if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then
		select	obter_se_medico_credenciado(cd_estabelecimento_p, cd_medico_p, cd_convenio_p, null, null,null,null,null,null,null,null,null)
		into STRICT	ie_medico_credenciado_w
		;
		
		end if;
		
		select	obter_valor_conv_estab(cd_convenio_p, cd_estabelecimento_p, 'IE_AGENDA_CONSULTA')
		into STRICT	ie_convenio_agecons_w
		;

		if (ie_medico_credenciado_w = 'S') and (ie_convenio_agecons_w = 'S') then

			ie_exibe_conv_w	:= 'S';

		else

			ie_exibe_conv_w	:= 'N';

		end if;	

	elsif (ie_forma_restricao_p = 'U') then
		
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_conv_lib_usuario_w
		from	convenio_estabelecimento
		where	cd_convenio = cd_convenio_p
		and	cd_estabelecimento = cd_estabelecimento_p;
		
		if (ie_conv_lib_usuario_w = 'S') then
			
			ie_exibe_conv_w := 'S';
		
		else
		
			ie_exibe_conv_w := 'N';
		
		end if;
	

	end if;

	
end if;

return ie_exibe_conv_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_conv_agecons (cd_estabelecimento_p bigint, cd_medico_p text, cd_convenio_p bigint, ie_forma_restricao_p text) FROM PUBLIC;

