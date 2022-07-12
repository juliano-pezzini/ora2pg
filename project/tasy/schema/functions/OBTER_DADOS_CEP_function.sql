-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cep ( cd_cep_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
	CTL	- código do tipo de logradouro
*/
ds_resultado_w		varchar(255)	:= '';


BEGIN

if (ie_opcao_p = 'CTL') then

	select	max(a.cd_tipo_logradouro)
	into STRICT	ds_resultado_w
	from	sus_tipo_logradouro a,
		cep_logradouro_v b
	where	b.cd_cep			= cd_cep_p
	and	upper(a.ds_tipo_logradouro)	= upper(b.ds_tipo_logradouro);

end if;

return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cep ( cd_cep_p text, ie_opcao_p text) FROM PUBLIC;

