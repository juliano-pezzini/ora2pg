-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cat_lugar_cert_nac ( nr_seq_cat_lugar_nac_p bigint, ie_tipo_inf_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
cd_lug_cert_nasc_w		cat_lugar_cert_nasc.cd_lug_cert_nasc%type;
ds_lug_cert_nasc_w		cat_lugar_cert_nasc.ds_lug_cert_nasc%type;


BEGIN
if (nr_seq_cat_lugar_nac_p IS NOT NULL AND nr_seq_cat_lugar_nac_p::text <> '') then

	select	cd_lug_cert_nasc,
		ds_lug_cert_nasc
	into STRICT	cd_lug_cert_nasc_w,
		ds_lug_cert_nasc_w
	from	cat_lugar_cert_nasc
	where	nr_sequencia	= nr_seq_cat_lugar_nac_p;

	if (ie_tipo_inf_p = 'CD_LUG_CERT_NASC') then
		ds_retorno_w 	:= cd_lug_cert_nasc_w;

	elsif (ie_tipo_inf_p = 'DS_LUG_CERT_NASC') then
		ds_retorno_w 	:= ds_lug_cert_nasc_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cat_lugar_cert_nac ( nr_seq_cat_lugar_nac_p bigint, ie_tipo_inf_p text) FROM PUBLIC;
