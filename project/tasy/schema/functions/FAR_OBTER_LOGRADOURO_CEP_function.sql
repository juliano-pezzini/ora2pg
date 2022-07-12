-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION far_obter_logradouro_cep ( cd_cep_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

select	nm_logradouro
into STRICT	ds_retorno_w
from	cep_logradouro
where	cd_logradouro = cd_cep_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION far_obter_logradouro_cep ( cd_cep_p text) FROM PUBLIC;
