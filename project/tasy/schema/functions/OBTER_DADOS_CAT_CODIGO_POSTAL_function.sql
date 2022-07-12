-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cat_codigo_postal ( nr_seq_cat_cod_postal_p bigint, ie_tipo_inf_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
codigo_w			cat_codigo_postal.codigo%type;
cve_asen_w			cat_codigo_postal.cve_asen%type;
cve_ent_w			cat_codigo_postal.cve_ent%type;
cve_mun_w			cat_codigo_postal.cve_mun%type;
cve_loc_w			cat_codigo_postal.cve_loc%type;
cve_periodo_w			cat_codigo_postal.cve_periodo%type;
agregado_w			cat_codigo_postal.agregado%type;



BEGIN
if (nr_seq_cat_cod_postal_p IS NOT NULL AND nr_seq_cat_cod_postal_p::text <> '') then
	select	codigo,
		cve_asen,
		cve_ent,
		cve_mun,
		cve_loc,
		cve_periodo,
		agregado
	into STRICT	codigo_w,
		cve_asen_w,
		cve_ent_w,
		cve_mun_w,
		cve_loc_w,
		cve_periodo_w,
		agregado_w
	from	cat_codigo_postal
	where	nr_sequencia	= nr_seq_cat_cod_postal_p;

	if (ie_tipo_inf_p = 'CODIGO') then
		ds_retorno_w 	:= codigo_w;

	elsif (ie_tipo_inf_p = 'CVE_ASEN') then
		ds_retorno_w 	:= cve_asen_w;

	elsif (ie_tipo_inf_p = 'CVE_ENT') then
		ds_retorno_w 	:= cve_ent_w;

	elsif (ie_tipo_inf_p = 'CVE_MUN') then
		ds_retorno_w 	:= cve_mun_w;

	elsif (ie_tipo_inf_p = 'CVE_LOC') then
		ds_retorno_w 	:= cve_loc_w;

	elsif (ie_tipo_inf_p = 'CVE_PERIODO') then
		ds_retorno_w 	:= cve_periodo_w;

	elsif (ie_tipo_inf_p = 'AGREGADO') then
		ds_retorno_w 	:= agregado_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cat_codigo_postal ( nr_seq_cat_cod_postal_p bigint, ie_tipo_inf_p text) FROM PUBLIC;
