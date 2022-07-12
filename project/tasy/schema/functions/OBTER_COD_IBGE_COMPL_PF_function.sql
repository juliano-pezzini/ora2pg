-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cod_ibge_compl_pf ( cd_pessoa_fisica_p text, ie_tipo_complemento_p text) RETURNS varchar AS $body$
DECLARE


cd_municipio_ibge_w			bigint;				
				

BEGIN

begin
select cd_municipio_ibge
into STRICT	 cd_municipio_ibge_w
from	 compl_pessoa_fisica
where	 cd_pessoa_fisica = cd_pessoa_fisica_p
and    ie_tipo_complemento =  ie_tipo_complemento_p;
exception
when others then
	cd_municipio_ibge_w	:= '';
end;

return	cd_municipio_ibge_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cod_ibge_compl_pf ( cd_pessoa_fisica_p text, ie_tipo_complemento_p text) FROM PUBLIC;
