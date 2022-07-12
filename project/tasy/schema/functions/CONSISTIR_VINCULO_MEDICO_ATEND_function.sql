-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_vinculo_medico_atend ( cd_medico_p text, vl_parametro_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);



BEGIN

select	obter_se_contido(ie_vinculo_medico, ('('||vl_parametro_p||')'))
into STRICT	ds_retorno_w
from	medico
where	cd_pessoa_fisica = cd_medico_p;

if (ds_retorno_w = 'S') then
	ds_retorno_w := 'N';
else
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_vinculo_medico_atend ( cd_medico_p text, vl_parametro_p text) FROM PUBLIC;
