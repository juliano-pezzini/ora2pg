-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cnpj_natureza_oper_nf ( cd_estabelecimento_p bigint, cd_cnpj_p text, cd_natureza_operacao_p bigint) RETURNS varchar AS $body$
DECLARE


/*
Se a natureza for do tipo Dentro do estado, irá retornar S caso a pessoa jurídica seja do mesmo estado do estabelecimento
Se a natureza for do tipo Fora do estado, irá retornar S caso a pessoa jurídica não seja do mesmo estado do estabelecimento
Se a natureza for do tipo Importação ou Exportação, irá retornar S caso o estado da pessoa jurídica seja Outros (Internacional)
*/
ie_retorno_w		varchar(1)	:= 'N';
ie_tipo_natureza_w		varchar(5);
sg_estado_estab_w		pessoa_juridica.sg_estado%type;
sg_estado_cnpj_w		pessoa_juridica.sg_estado%type;



BEGIN

if (cd_natureza_operacao_p > 0) then

	select	coalesce(max(ie_tipo_natureza),'0')
	into STRICT	ie_tipo_natureza_w
	from	natureza_operacao
	where	cd_natureza_operacao = cd_natureza_operacao_p;

	if (ie_tipo_natureza_w = '0') then /*Nãi foi informado tipo*/
		ie_retorno_w := 'S';
	elsif (ie_tipo_natureza_w = 'D') then /*Dentro do estado*/
		select	sg_estado
		into STRICT	sg_estado_estab_w
		from	pessoa_juridica a,
			estabelecimento b
		where	a.cd_cgc = b.cd_cgc
		and	b.cd_estabelecimento = cd_estabelecimento_p;

		select	sg_estado
		into STRICT	sg_estado_cnpj_w
		from	pessoa_juridica
		where	cd_cgc = cd_cnpj_p;

		if (sg_estado_cnpj_w = sg_estado_estab_w) then
			ie_retorno_w := 'S';
		end if;

	elsif (ie_tipo_natureza_w = 'F') then /*Fora do estado*/
		select	sg_estado
		into STRICT	sg_estado_estab_w
		from	pessoa_juridica a,
			estabelecimento b
		where	a.cd_cgc = b.cd_cgc
		and	b.cd_estabelecimento = cd_estabelecimento_p;

		select	sg_estado
		into STRICT	sg_estado_cnpj_w
		from	pessoa_juridica
		where	cd_cgc = cd_cnpj_p;

		if (sg_estado_cnpj_w <> sg_estado_estab_w) then
			ie_retorno_w := 'S';
		end if;

	elsif (ie_tipo_natureza_w = 'I') then /*Importação*/
		select	sg_estado
		into STRICT	sg_estado_cnpj_w
		from	pessoa_juridica
		where	cd_cgc = cd_cnpj_p;

		if (sg_estado_cnpj_w = 'IN') then
			ie_retorno_w := 'S';
		end if;

	elsif (ie_tipo_natureza_w = 'D') then	/*Exportação*/
		select	sg_estado
		into STRICT	sg_estado_cnpj_w
		from	pessoa_juridica
		where	cd_cgc = cd_cnpj_p;

		if (sg_estado_cnpj_w = 'IN') then
			ie_retorno_w := 'S';
		end if;

	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cnpj_natureza_oper_nf ( cd_estabelecimento_p bigint, cd_cnpj_p text, cd_natureza_operacao_p bigint) FROM PUBLIC;
