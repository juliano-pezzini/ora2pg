-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_email_pagador_mens ( cd_pessoa_fisica_p text, cd_cgc_p text, ie_endereco_boleto_p text, cd_estabelecimento_p pessoa_juridica_estab.cd_estabelecimento%type default 0) RETURNS varchar AS $body$
DECLARE


ds_email_retorno_w	pls_contrato_pagador.ds_email%type	:= null;
nr_seq_w		pls_contrato_pagador.nr_sequencia%type;
cd_estabelecimento_w pessoa_juridica_estab.cd_estabelecimento%type;


BEGIN

begin
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	if (ie_endereco_boleto_p = 'PFR') then
		select	ds_email
		into STRICT	ds_email_retorno_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento = 1
		and	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_endereco_boleto_p = 'PFC') then
		select	ds_email
		into STRICT	ds_email_retorno_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento = 2
		and	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_endereco_boleto_p = 'PFA') then
		select	ds_email
		into STRICT	ds_email_retorno_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento	= 9
		and	cd_pessoa_fisica	= cd_pessoa_fisica_p;
	elsif (ie_endereco_boleto_p = 'PFV') then
		select	ds_email
		into STRICT	ds_email_retorno_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento	= 3
		and	cd_pessoa_fisica	= cd_pessoa_fisica_p;
	elsif (ie_endereco_boleto_p = 'PFP') then
		select	ds_email
		into STRICT	ds_email_retorno_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento	= 4
		and	cd_pessoa_fisica	= cd_pessoa_fisica_p;
	elsif (ie_endereco_boleto_p = 'PFM') then
		select	ds_email
		into STRICT	ds_email_retorno_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento	= 5
		and	cd_pessoa_fisica	= cd_pessoa_fisica_p;
	elsif (ie_endereco_boleto_p = 'PFJ') then
		select	ds_email
		into STRICT	ds_email_retorno_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento	= 6
		and	cd_pessoa_fisica	= cd_pessoa_fisica_p;
	end if;	
elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
	if (ie_endereco_boleto_p = 'PJA') then
		select	a.ds_email
		into STRICT	ds_email_retorno_w
		from	pessoa_juridica_compl a
		where	a.ie_tipo_complemento	= 6
		and	a.cd_cgc		= cd_cgc_p;
	elsif (ie_endereco_boleto_p = 'PJC') then
		select	a.ds_email
		into STRICT	ds_email_retorno_w
		from	pessoa_juridica_compl a
		where	a.ie_tipo_complemento	= 1
		and	a.cd_cgc		= cd_cgc_p;
	elsif (ie_endereco_boleto_p = 'PJF') then
		select	a.ds_email
		into STRICT	ds_email_retorno_w
		from	pessoa_juridica_compl a
		where	a.ie_tipo_complemento	= 2
		and	a.cd_cgc		= cd_cgc_p;
	elsif (ie_endereco_boleto_p = 'PJ') then

    cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

    if (cd_estabelecimento_p <> 0) then
      cd_estabelecimento_w := cd_estabelecimento_p;
    end if;

		select	substr(max(ds_email),1,255)
		into STRICT	ds_email_retorno_w
		from	pessoa_juridica_estab
		where	cd_cgc = cd_cgc_p
		and	cd_estabelecimento	= cd_estabelecimento_w;
		
		if (coalesce(ds_email_retorno_w::text, '') = '') then
			select	substr(max(ds_email),1,255)
			into STRICT	ds_email_retorno_w
			from	pessoa_juridica
			where	cd_cgc = cd_cgc_p;
		end if;
	end if;
end if;
exception
when others then
	ds_email_retorno_w := null;
end;

return	ds_email_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_email_pagador_mens ( cd_pessoa_fisica_p text, cd_cgc_p text, ie_endereco_boleto_p text, cd_estabelecimento_p pessoa_juridica_estab.cd_estabelecimento%type default 0) FROM PUBLIC;
