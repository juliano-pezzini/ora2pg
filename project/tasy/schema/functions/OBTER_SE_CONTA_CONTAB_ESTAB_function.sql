-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_conta_contab_estab ( cd_conta_contabil_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(01) := 'S';
qt_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_w
from	conta_contabil_estab
where	cd_conta_contabil = cd_conta_contabil_p;

if (qt_w = 0) then
	ds_retorno_w := 'S';
else
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	conta_contabil_estab
	where	cd_conta_contabil = cd_conta_contabil_p
	and	cd_estabelecimento= cd_estabelecimento_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_conta_contab_estab ( cd_conta_contabil_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

