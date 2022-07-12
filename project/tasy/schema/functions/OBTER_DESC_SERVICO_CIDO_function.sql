-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_servico_cido ( cd_servico_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(100);


BEGIN

if (cd_servico_p IS NOT NULL AND cd_servico_p::text <> '') then
	select	ds_servico
	into STRICT	ds_retorno_w
	from	cido_servico
	where	cd_servico = cd_servico_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_servico_cido ( cd_servico_p text) FROM PUBLIC;
