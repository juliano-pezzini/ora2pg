-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estab_financeiro (cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


cd_estab_financeiro_w	smallint	:= null;


BEGIN

select	max(cd_estab_financeiro)
into STRICT	cd_estab_financeiro_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;

return	cd_estab_financeiro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estab_financeiro (cd_estabelecimento_p bigint) FROM PUBLIC;
