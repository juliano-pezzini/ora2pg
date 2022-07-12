-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_forma_uso_fluxo ( cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


retorno_w	varchar(15);

BEGIN

select	coalesce(max(ie_forma_uso_fluxo),'C')
into STRICT	retorno_w
from	parametro_fluxo_caixa
where	cd_estabelecimento = cd_estabelecimento_p;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_forma_uso_fluxo ( cd_estabelecimento_p bigint) FROM PUBLIC;
