-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nfse_obter_se_brasileiro (cd_pessoa_fisica_p text, cd_cgc_p text) RETURNS varchar AS $body$
DECLARE


ie_brasileiro_w			varchar(1) := 'N';
cd_nacionalidade_w	varchar(8);
ie_internacional_w 	varchar(1) := 'N';
nr_cpf_w 					pessoa_fisica.nr_cpf%type;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	coalesce(max(cd_nacionalidade),'0'),
				coalesce(max(nr_cpf),'0')
	into STRICT		cd_nacionalidade_w,
				nr_cpf_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	
	if ((nr_cpf_w IS NOT NULL AND nr_cpf_w::text <> '') and nr_cpf_w != '0') then
		ie_brasileiro_w := 'S';
	elsif (cd_nacionalidade_w = '0') then
		ie_brasileiro_w := 'S';
	else
		select	coalesce(max(ie_brasileiro),'N')
		into STRICT		ie_brasileiro_w
		from	nacionalidade
		where	cd_nacionalidade = cd_nacionalidade_w;
	end if;
elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
	select	coalesce(max(a.ie_internacional),'N')
	into STRICT	ie_internacional_w
	from	tipo_pessoa_juridica a,
		pessoa_juridica b
	where	a.cd_tipo_pessoa = b.cd_tipo_pessoa
	and	b.cd_cgc = cd_cgc_p;
	
	if (ie_internacional_w = 'N') then
		ie_brasileiro_w := 'S';
	end if;
	
end if;

return ie_brasileiro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nfse_obter_se_brasileiro (cd_pessoa_fisica_p text, cd_cgc_p text) FROM PUBLIC;
