-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_inicio_trat_dialise ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_inicio_w	timestamp;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	min(dt_inicio_tratamento)
	into STRICT	dt_inicio_w
	from	hd_pac_renal_cronico
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	if (coalesce(dt_inicio_w::text, '') = '') then
		select	min(dt_inicio_tratamento)
		into STRICT	dt_inicio_w
		from	hd_pac_renal_cronico
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	end if;

end if;

return	dt_inicio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_inicio_trat_dialise ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

