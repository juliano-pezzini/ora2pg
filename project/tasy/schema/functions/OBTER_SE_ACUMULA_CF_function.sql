-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_acumula_cf ( cd_conta_financ_p bigint) RETURNS varchar AS $body$
DECLARE


ie_acumular_w	conta_financeira.ie_acumular%type;


BEGIN

select	coalesce(max(ie_acumular),'N')
into STRICT	ie_acumular_w
from	conta_financeira
where	cd_conta_financ	= cd_conta_financ_p;

if (coalesce(ie_acumular_w, 'N') = 'N') then
	return 'N';
else
	return 'S';
end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_acumula_cf ( cd_conta_financ_p bigint) FROM PUBLIC;
