-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_municipio_em_uf ( cd_municipio_ibge_p text, sg_estado_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1);
sg_estado_w		sus_municipio.ds_unidade_federacao%type;


BEGIN

ie_retorno_w	:= 'N';

if (cd_municipio_ibge_p IS NOT NULL AND cd_municipio_ibge_p::text <> '') and (sg_estado_p IS NOT NULL AND sg_estado_p::text <> '') then
	sg_estado_w	:= obter_uf_ibge(cd_municipio_ibge_p);

	if (sg_estado_w	= sg_estado_p) then
		ie_retorno_w	:= 'S';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_municipio_em_uf ( cd_municipio_ibge_p text, sg_estado_p text) FROM PUBLIC;

