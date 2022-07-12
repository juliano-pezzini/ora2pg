-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_dados_cadastro (nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ds_cadastro_w		varchar(255);

/*
D - Descricao
*/
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	substr(obter_desc_expressao(cd_exp_cadastro, ds_cadastro), 1, 255) ds_cadastro
	into STRICT	ds_cadastro_w
	from	proj_cadastro
	where	nr_sequencia	= nr_sequencia_p;

	if (ie_opcao_p = 'D') then
		ds_retorno_w	:= ds_cadastro_w;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_dados_cadastro (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

