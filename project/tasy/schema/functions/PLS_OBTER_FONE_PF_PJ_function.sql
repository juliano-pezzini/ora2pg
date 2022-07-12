-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_fone_pf_pj ( cd_pessoa_fisica_p text, cd_cgc_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* **********************************************
*	 IE_OPCAO_P
*
*	TR - Residencial
*	TC - Comercial
*	CE - Celular (cadastro pessoa física)
*
*********************************************** */
ds_telefone_w		varchar(255);


BEGIN

/* Verificar se a pessoa é Física ou Jurídica */

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	if (ie_opcao_p = 'TR') then
		select	max(a.nr_ddd_telefone)||' '||max(a.nr_telefone)
		into STRICT	ds_telefone_w
		from	compl_pessoa_fisica a
		where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	a.ie_tipo_complemento = 1;

	elsif (ie_opcao_p = 'TC') then
		select	max(a.nr_ddd_telefone)||' '||max(a.nr_telefone)
		into STRICT	ds_telefone_w
		from	compl_pessoa_fisica a
		where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	a.ie_tipo_complemento = 2;

	elsif (ie_opcao_p = 'CE') then
		select	max(a.nr_telefone_celular)
		into STRICT	ds_telefone_w
		from	pessoa_fisica a
		where	a.cd_pessoa_fisica = cd_pessoa_fisica_p;

	end if;

elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then

	if (ie_opcao_p = 'TC') then
		select	max(a.nr_ddd_telefone)||' '||max(a.nr_telefone)
		into STRICT	ds_telefone_w
		from	pessoa_juridica a
		where	a.cd_cgc = cd_cgc_p;

	end if;
end if;

return	ds_telefone_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_fone_pf_pj ( cd_pessoa_fisica_p text, cd_cgc_p text, ie_opcao_p text) FROM PUBLIC;
