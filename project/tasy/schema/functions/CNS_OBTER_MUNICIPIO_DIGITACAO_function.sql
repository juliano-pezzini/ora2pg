-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cns_obter_municipio_digitacao ( cd_estabelecimento_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


/* IE_TIPO_P
	C - Codigo
	D - Descricao
*/
cd_cep_w	varchar(15);
ds_retorno_w	varchar(100);


BEGIN

select	coalesce(max(b.cd_cep),'')
into STRICT	cd_cep_w
from	pessoa_juridica	b,
	estabelecimento a
where	cd_estabelecimento = cd_estabelecimento_p
and	a.cd_cgc = b.cd_cgc;

ds_retorno_w	:= obter_municipio_ibge(campo_numerico(cd_cep_w));

if (ie_tipo_p	= 'D') then
	ds_retorno_w	:= obter_desc_municipio_ibge(ds_retorno_w);
end if;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cns_obter_municipio_digitacao ( cd_estabelecimento_p bigint, ie_tipo_p text) FROM PUBLIC;

