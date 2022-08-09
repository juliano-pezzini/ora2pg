-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_consistir_idade ( cd_pessoa_fisica_p text, dt_nascimento_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


qt_idade_min_w	smallint;
qt_idade_max_w	smallint;
qt_idade_w	smallint;
dt_nascimento_w	timestamp;


BEGIN

select	coalesce(max(qt_idade_min),0),
	coalesce(max(qt_idade_max),999)
into STRICT	qt_idade_min_w,
	qt_idade_max_w
from	parametro_agenda_integrada
where	coalesce(cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p;

if (dt_nascimento_p IS NOT NULL AND dt_nascimento_p::text <> '') then
	dt_nascimento_w	:= dt_nascimento_p;
else
	select	max(dt_nascimento)
	into STRICT	dt_nascimento_w
	from	pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p;
end if;

if (dt_nascimento_w IS NOT NULL AND dt_nascimento_w::text <> '') then
	qt_idade_w	:= obter_idade(dt_nascimento_w, clock_timestamp(), 'A');

	if (qt_idade_w	< qt_idade_min_w) then
		ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(279436,'QT_IDADE='|| qt_idade_w ||';QT_IDADE_MIN='|| qt_idade_min_w );
	elsif (qt_idade_w	> qt_idade_max_w) then
		ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(279437,'QT_IDADE='|| qt_idade_w ||';QT_IDADE_MAX='|| qt_idade_max_w );
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_consistir_idade ( cd_pessoa_fisica_p text, dt_nascimento_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
