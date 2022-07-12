-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_se_perm_forcar_agenda ( cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(3)	:= 'N';


BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	qt_perm_forcar_agendamento
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and		ie_situacao			= 'A';
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_se_perm_forcar_agenda ( cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

