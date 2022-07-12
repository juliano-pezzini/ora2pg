-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_estab_financeiro (cd_estab_corrente_p bigint, cd_estab_conta_p bigint) RETURNS varchar AS $body$
DECLARE


ie_estab_financeiro_w	varchar(1):= 'N';
cd_estabelecimento_w	smallint;

C01 CURSOR FOR
	SELECT	cd_estabelecimento
	from	estabelecimento
	where	coalesce(cd_estab_financeiro,cd_estabelecimento) = cd_estab_corrente_p;


BEGIN

ie_estab_financeiro_w:= 'N';

open C01;
loop
fetch C01 into
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (cd_estab_conta_p = cd_estabelecimento_w) then
		ie_estab_financeiro_w:= 'S';
	end if;

	end;
end loop;
close C01;

return	ie_estab_financeiro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_estab_financeiro (cd_estab_corrente_p bigint, cd_estab_conta_p bigint) FROM PUBLIC;
