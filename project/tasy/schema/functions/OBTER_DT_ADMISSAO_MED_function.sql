-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_admissao_med (cd_medico_p text) RETURNS timestamp AS $body$
DECLARE


ds_retorno_w	timestamp;


BEGIN

select 	dt_admissao
into STRICT 	ds_retorno_w
from 	medico
where 	cd_pessoa_fisica = cd_medico_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_admissao_med (cd_medico_p text) FROM PUBLIC;

