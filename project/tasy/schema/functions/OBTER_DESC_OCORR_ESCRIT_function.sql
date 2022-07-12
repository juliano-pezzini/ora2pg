-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_ocorr_escrit (cd_ocorrencia_p text, cd_banco_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(140);


BEGIN

select 	max(ds_ocorrencia)
into STRICT	ds_Retorno_w
from	banco_ocorrencia_escritural
where	cd_ocorrencia	= cd_ocorrencia_p
and	cd_banco	= cd_banco_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_ocorr_escrit (cd_ocorrencia_p text, cd_banco_p bigint) FROM PUBLIC;
