-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_pf_benef_local ( cd_pessoa_fisica_p text, dt_referencia_p timestamp, ie_somente_ativo_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

if (ie_somente_ativo_p = 'S') then
	select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	pls_segurado
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_segurado	= 'B'
	and (coalesce(dt_rescisao::text, '') = '' or dt_rescisao > dt_referencia_p);
else
	select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	pls_segurado
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_segurado	= 'B';
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_pf_benef_local ( cd_pessoa_fisica_p text, dt_referencia_p timestamp, ie_somente_ativo_p text) FROM PUBLIC;
