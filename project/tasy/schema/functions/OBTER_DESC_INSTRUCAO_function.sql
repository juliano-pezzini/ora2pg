-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_instrucao (cd_instrucao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

select	max(ds_instrucao)
into STRICT	ds_retorno_w
from	instrucao_escritural
where	cd_instrucao	= cd_instrucao_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_instrucao (cd_instrucao_p bigint) FROM PUBLIC;

