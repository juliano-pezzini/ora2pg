-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cid_equivalente ( cd_doenca_1_p text, cd_doenca_2_p text ) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1) := 'N';


BEGIN

if (cd_doenca_1_p IS NOT NULL AND cd_doenca_1_p::text <> '') and (cd_doenca_2_p IS NOT NULL AND cd_doenca_2_p::text <> '') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	from	cid_equivalente
	where	((cd_doenca_1	=	cd_doenca_1_p) or (cd_doenca_1 = cd_doenca_2_p))
	and	((cd_doenca_2	=	cd_doenca_1_p) or (cd_doenca_2 = cd_doenca_2_p));

	if (cd_doenca_1_p = cd_doenca_2_p) then
		ie_retorno_w := 'S';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cid_equivalente ( cd_doenca_1_p text, cd_doenca_2_p text ) FROM PUBLIC;
