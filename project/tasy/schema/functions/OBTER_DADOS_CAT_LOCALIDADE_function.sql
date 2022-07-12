-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cat_localidade ( nr_seq_cat_localidade_p bigint, ie_tipo_inf_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_efe_w		cat_localidade.cd_efe%type;
cd_cat_localidade_w	cat_localidade.cd_cat_localidade%type;
ds_cat_localidade_w	cat_localidade.ds_cat_localidade%type;
cd_cat_municipio_w	cat_localidade.cd_cat_municipio%type;


BEGIN
if (nr_seq_cat_localidade_p IS NOT NULL AND nr_seq_cat_localidade_p::text <> '') then
	select	cd_efe,
		cd_cat_localidade,
		ds_cat_localidade,
		cd_cat_municipio
	into STRICT	cd_efe_w,
		cd_cat_localidade_w,
		ds_cat_localidade_w,
		cd_cat_municipio_w
	from	cat_localidade
	where	nr_sequencia	= nr_seq_cat_localidade_p;

	if (ie_tipo_inf_p = 'CD_EFE') then
		ds_retorno_w 	:= cd_efe_w;

	elsif (ie_tipo_inf_p = 'CD_CAT_LOCALIDADE') then
		ds_retorno_w 	:= cd_cat_localidade_w;

	elsif (ie_tipo_inf_p = 'DS_CAT_LOCALIDADE') then
		ds_retorno_w 	:= ds_cat_localidade_w;

	elsif (ie_tipo_inf_p = 'CD_CAT_MUNICIPIO') then
		ds_retorno_w 	:= cd_cat_municipio_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cat_localidade ( nr_seq_cat_localidade_p bigint, ie_tipo_inf_p text) FROM PUBLIC;
