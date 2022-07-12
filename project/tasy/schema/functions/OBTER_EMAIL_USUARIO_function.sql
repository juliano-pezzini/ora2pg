-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_email_usuario ( cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_email_w		varchar(255);
ie_email_usuario_w		varchar(255);


BEGIN

ie_email_usuario_w := obter_param_usuario(1200, 67, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_email_usuario_w);

if (ie_email_usuario_w = 'S') then

		select	max(ds_email)
		into STRICT	ds_email_w
		from	usuario
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	ie_situacao = 'A';

	else

		select	ds_email
		into STRICT	ds_email_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	ie_tipo_complemento = 1;

end if;

return	ds_email_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_email_usuario ( cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

