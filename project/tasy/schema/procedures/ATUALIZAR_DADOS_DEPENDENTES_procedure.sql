-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_dependentes ( cd_pessoa_fisica_p text, qt_dependentes_p bigint) AS $body$
DECLARE


qt_dependentes_w smallint;


BEGIN


if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (qt_dependentes_p IS NOT NULL AND qt_dependentes_p::text <> '') then

	begin

	select	CASE WHEN count(*)=0 THEN null  ELSE count(*) END
	into STRICT	qt_dependentes_w
	from	pessoa_fisica_dependente
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and (coalesce(dt_fim_vigencia::text, '') = '' or (dt_fim_vigencia >= clock_timestamp()));

	if (coalesce(qt_dependentes_w,0) <> qt_dependentes_p)  then

		begin

		update	pessoa_fisica
		set		qt_dependente 		= qt_dependentes_w
		where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

		commit;

		end;

	end if;

	end;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_dependentes ( cd_pessoa_fisica_p text, qt_dependentes_p bigint) FROM PUBLIC;
