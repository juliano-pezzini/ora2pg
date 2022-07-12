-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_cnes_prestador ( ie_tipo_endereco_p pls_prestador.ie_tipo_endereco%type, cd_pessoa_fisica_p pls_prestador.cd_pessoa_fisica%type, cd_cgc_p pls_prestador.cd_cgc%type, nr_seq_compl_pf_tel_adic_p pls_prestador.nr_seq_compl_pf_tel_adic%type, nr_seq_compl_pj_p pls_prestador.nr_seq_compl_pj%type) RETURNS varchar AS $body$
DECLARE

					
cd_cnes_w			varchar(255);
nr_seq_ident_cnes_w		bigint;
ds_retorno_w			varchar(255);


BEGIN
				
if (ie_tipo_endereco_p in ('PJ','PJC','PJF','PJA')) then
	if (ie_tipo_endereco_p = 'PJ') then
		select	a.cd_cnes,
			a.nr_seq_ident_cnes
		into STRICT	cd_cnes_w,
			nr_seq_ident_cnes_w
		from	pessoa_juridica a
		where	a.cd_cgc	= cd_cgc_p;
		
		if (nr_seq_ident_cnes_w IS NOT NULL AND nr_seq_ident_cnes_w::text <> '') then
			select	CASE WHEN coalesce(max(cd_cnes)::text, '') = '' THEN cd_cnes_w  ELSE max(cd_cnes) END
			into STRICT	ds_retorno_w
			from	cnes_identificacao
			where	nr_sequencia	= nr_seq_ident_cnes_w;
			
		elsif (cd_cnes_w IS NOT NULL AND cd_cnes_w::text <> '') then
			ds_retorno_w := cd_cnes_w;
		end if;
	elsif (ie_tipo_endereco_p = 'PJC') then
		select	max(b.cd_cnes)
		into STRICT	ds_retorno_w
		from	cnes_identificacao	b,
			pessoa_juridica_compl	a
		where	b.nr_sequencia		= a.nr_seq_ident_cnes
		and	a.cd_cgc		= cd_cgc_p
		and	a.ie_tipo_complemento	= 1;
	elsif (ie_tipo_endereco_p = 'PJF') then
		select	max(b.cd_cnes)
		into STRICT	ds_retorno_w
		from	cnes_identificacao	b,
			pessoa_juridica_compl	a
		where	b.nr_sequencia		= a.nr_seq_ident_cnes
		and	a.cd_cgc		= cd_cgc_p
		and	a.ie_tipo_complemento	= 2;
	else
		select	max(b.cd_cnes)--obter_compl_pj(cd_cgc,ie_tipo_complemento,'CNES')
		into STRICT	ds_retorno_w
		from	cnes_identificacao	b,
			pessoa_juridica_compl	a
		where	a.nr_seq_ident_cnes	= b.nr_sequencia
		and	a.nr_sequencia		= nr_seq_compl_pj_p
		and	a.cd_cgc		= cd_cgc_p;
	end if;
elsif (ie_tipo_endereco_p in ('PFR')) then
	select	max(a.cd_cnes)
	into STRICT	ds_retorno_w
	from	pessoa_fisica a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_p;
elsif (ie_tipo_endereco_p in ('PFC')) then
	if (nr_seq_compl_pf_tel_adic_p IS NOT NULL AND nr_seq_compl_pf_tel_adic_p::text <> '') then
		select	nr_seq_ident_cnes	
		into STRICT	nr_seq_ident_cnes_w
		from	compl_pf_tel_adic
		where	cd_pessoa_fisica	= cd_pessoa_fisica_p
		and	nr_sequencia		= nr_seq_compl_pf_tel_adic_p;
		
		if (nr_seq_ident_cnes_w IS NOT NULL AND nr_seq_ident_cnes_w::text <> '') then
			select	cd_cnes
			into STRICT	ds_retorno_w
			from	cnes_identificacao
			where	nr_sequencia	= nr_seq_ident_cnes_w;
		end if;
	else
		select	obter_compl_pf(cd_pessoa_fisica_p,2,'CNES')
		into STRICT	ds_retorno_w
		;
	end if;	
elsif (ie_tipo_endereco_p = 'PFC2') then
	select	obter_compl_pf(cd_pessoa_fisica_p,7,'CNES')
	into STRICT	ds_retorno_w
	;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_cnes_prestador ( ie_tipo_endereco_p pls_prestador.ie_tipo_endereco%type, cd_pessoa_fisica_p pls_prestador.cd_pessoa_fisica%type, cd_cgc_p pls_prestador.cd_cgc%type, nr_seq_compl_pf_tel_adic_p pls_prestador.nr_seq_compl_pf_tel_adic%type, nr_seq_compl_pj_p pls_prestador.nr_seq_compl_pj%type) FROM PUBLIC;
