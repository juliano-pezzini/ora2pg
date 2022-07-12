-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pessoa_ficha_sinan (cd_pessoa_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN


select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	NOTIFICACAO_SINAN
where	cd_paciente	= cd_pessoa_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pessoa_ficha_sinan (cd_pessoa_p text) FROM PUBLIC;
