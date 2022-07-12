-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_banco_repasse_pf_pj ( cd_pessoa_fisica_p text, cd_cgc_p text) RETURNS bigint AS $body$
DECLARE



cd_banco_w		pessoa_fisica_conta.cd_banco%type;


BEGIN

if (coalesce(cd_pessoa_fisica_p, 'X') <> 'X') then

	select	max(cd_banco)
	into STRICT	cd_banco_w
	from	pessoa_fisica_conta a
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_situacao		= 'A'
	and	ie_conta_repasse	= 'S';

elsif (coalesce(cd_cgc_p, 'X') <> 'X') then

	select	max(cd_banco)
	into STRICT	cd_banco_w
	from	pessoa_juridica_conta a
	where	cd_cgc			= cd_cgc_p
	and	ie_situacao		= 'A'
	and	ie_conta_repasse	= 'S';

end if;

if (coalesce(cd_banco_w::text, '') = '') then

	if (coalesce(cd_pessoa_fisica_p, 'X') <> 'X') then

		select	max(cd_banco)
		into STRICT	cd_banco_w
		from	pessoa_fisica_conta a
		where	cd_pessoa_fisica	= cd_pessoa_fisica_p
		and	ie_situacao		= 'A'
		and	ie_conta_pagamento	= 'S';

	elsif (coalesce(cd_cgc_p, 'X') <> 'X') then

		select	max(cd_banco)
		into STRICT	cd_banco_w
		from	pessoa_juridica_conta a
		where	cd_cgc			= cd_cgc_p
		and	ie_situacao		= 'A'
		and	ie_conta_pagamento	= 'S';

	end if;
end if;

return	cd_banco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_banco_repasse_pf_pj ( cd_pessoa_fisica_p text, cd_cgc_p text) FROM PUBLIC;
