-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_end_prestador_estab ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, ie_tipo_endereco_p pls_prestador.ie_tipo_endereco%type, nr_seq_compl_adic_p pessoa_juridica_compl.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE

					 
-- Se alterar algo, dar manutenção na rotina PLS_OBTER_END_PRESTADOR_PTU 
					 
ds_retorno_w			varchar(4000);
ie_tipo_endereco_w		pls_prestador.ie_tipo_endereco%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_cgc_w			pessoa_juridica.cd_cgc%type;
ds_endereco_w			varchar(255)	:= null;
nr_endereco_w			varchar(10)	:= null;
ds_complemento_w		varchar(255)	:= null;
ds_bairro_w			varchar(255)	:= null;
sg_estado_w			pessoa_juridica.sg_estado%type	:= null;
ds_municipio_w			varchar(40);
nr_seq_compl_adic_w		pls_prestador.nr_seq_compl_pf_tel_adic%type;
nr_seq_tipo_compl_adic_w	pls_prestador.nr_seq_tipo_compl_adic%type;
nr_seq_complemento_w		pessoa_juridica_compl.nr_sequencia%type;
nr_seq_tipo_logradouro_w	pessoa_juridica.nr_seq_tipo_logradouro%type;
ds_tipo_logradouro_w		cns_tipo_logradouro.ds_tipo_logradouro%type;
cd_tipo_logradouro_w		compl_pessoa_fisica.cd_tipo_logradouro%type;


BEGIN 
 
nr_seq_tipo_logradouro_w := null;
cd_tipo_logradouro_w := null;
 
if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then 
	select	a.ie_tipo_endereco, 
		a.cd_pessoa_fisica, 
		a.cd_cgc, 
		coalesce(coalesce(nr_seq_compl_pf_tel_adic,nr_seq_compl_pj),0), 
		nr_seq_tipo_compl_adic 
	into STRICT	ie_tipo_endereco_w, 
		cd_pessoa_fisica_w, 
		cd_cgc_w, 
		nr_seq_compl_adic_w, 
		nr_seq_tipo_compl_adic_w 
	from	pls_prestador a 
	where	a.nr_sequencia		= nr_seq_prestador_p 
	and	a.cd_estabelecimento	= cd_estabelecimento_p;
	 
	if (ie_tipo_endereco_p IS NOT NULL AND ie_tipo_endereco_p::text <> '') then 
		ie_tipo_endereco_w	:= ie_tipo_endereco_p;
	end if;
	 
	if (nr_seq_compl_adic_p IS NOT NULL AND nr_seq_compl_adic_p::text <> '') then 
		nr_seq_compl_adic_w 	:= nr_seq_compl_adic_p;
	end if;	
	 
	if (ie_tipo_endereco_w in ('PJ')) then 
		select	a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			substr(coalesce(obter_desc_municipio_ibge(a.cd_municipio_ibge), a.ds_municipio),1,40), 
			a.nr_seq_tipo_logradouro 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w, 
			nr_seq_tipo_logradouro_w 
		from	pessoa_juridica a 
		where	a.cd_cgc	= cd_cgc_w;
		 
	elsif (ie_tipo_endereco_w in ('PJA')) and (nr_seq_compl_adic_w > 0) then 
		select	a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			substr(coalesce(obter_desc_municipio_ibge(a.cd_municipio_ibge), a.ds_municipio),1,40), 
			null 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w, 
			nr_seq_tipo_logradouro_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc	= cd_cgc_w	 
		and	a.nr_sequencia	= nr_seq_compl_adic_w;
		 
	elsif (ie_tipo_endereco_w in ('PJC')) then 
		begin 
		 
		select 	max(nr_sequencia) 
		into STRICT	nr_seq_complemento_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc		= cd_cgc_w 
		and	a.ie_tipo_complemento 	= 1;		
		 
		select	a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			substr(coalesce(obter_desc_municipio_ibge(a.cd_municipio_ibge), a.ds_municipio),1,40), 
			null 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w, 
			nr_seq_tipo_logradouro_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc		= cd_cgc_w 
		and	a.ie_tipo_complemento 	= 1 
		and	a.nr_sequencia 		= nr_seq_complemento_w;
		exception 
		when others then 
			ds_endereco_w	:= null;
		end;
		 
	elsif (ie_tipo_endereco_w in ('PJF')) then 
		begin 
		 
		select 	max(nr_sequencia) 
		into STRICT	nr_seq_complemento_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc		= cd_cgc_w 
		and	a.ie_tipo_complemento 	= 2;
		 
		select	a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			substr(coalesce(obter_desc_municipio_ibge(a.cd_municipio_ibge), a.ds_municipio),1,40), 
			null 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w, 
			nr_seq_tipo_logradouro_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc		= cd_cgc_w 
		and	a.ie_tipo_complemento 	= 2 
		and	a.nr_sequencia		= nr_seq_complemento_w;
		exception 
		when others then 
			ds_endereco_w	:= null;
		end;
		 
	elsif (ie_tipo_endereco_w = 'PFR') then		 
		begin 
			select	a.ds_endereco, 
				a.nr_endereco, 
				a.ds_complemento, 
				a.ds_bairro, 
				a.sg_estado, 
				substr(coalesce(obter_desc_municipio_ibge(a.cd_municipio_ibge), a.ds_municipio),1,40), 
				a.cd_tipo_logradouro 
			into STRICT	ds_endereco_w, 
				nr_endereco_w, 
				ds_complemento_w, 
				ds_bairro_w, 
				sg_estado_w, 
				ds_municipio_w, 
				cd_tipo_logradouro_w 
			from	compl_pessoa_fisica a 
			where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
			and	a.ie_tipo_complemento = 1;
		exception 
		when others then 
			ds_endereco_w	:= null;
		end;		
		 
	elsif (ie_tipo_endereco_w = 'PFC') then 
		begin 
			select	a.ds_endereco, 
				a.nr_endereco, 
				a.ds_complemento, 
				a.ds_bairro, 
				a.sg_estado, 
				substr(coalesce(obter_desc_municipio_ibge(a.cd_municipio_ibge), a.ds_municipio),1,40), 
				a.cd_tipo_logradouro 
			into STRICT	ds_endereco_w, 
				nr_endereco_w, 
				ds_complemento_w, 
				ds_bairro_w, 
				sg_estado_w, 
				ds_municipio_w, 
				cd_tipo_logradouro_w 
			from	compl_pessoa_fisica a 
			where	a.cd_pessoa_fisica = cd_pessoa_fisica_w 
			and	a.ie_tipo_complemento = 2;
		exception 
		when others then 
			ds_endereco_w	:= null;
		end;	
		 
		if (nr_seq_compl_adic_w > 0) then 
			select	a.ds_endereco, 
				a.nr_endereco, 
				a.ds_complemento, 
				a.ds_bairro, 
				a.sg_estado, 
				substr(coalesce(obter_desc_municipio_ibge(a.cd_municipio_ibge), a.ds_municipio),1,40), 
				a.cd_tipo_logradouro 
			into STRICT	ds_endereco_w, 
				nr_endereco_w, 
				ds_complemento_w, 
				ds_bairro_w, 
				sg_estado_w, 
				ds_municipio_w, 
				cd_tipo_logradouro_w 
			from	compl_pf_tel_adic a 
			where	a.nr_sequencia	= nr_seq_compl_adic_w;	
		end if;	
		 
	elsif (ie_tipo_endereco_w = 'PFA') then 
	 
		if (nr_seq_tipo_compl_adic_w IS NOT NULL AND nr_seq_tipo_compl_adic_w::text <> '') then 
			begin 
			select	ds_endereco, 
				nr_endereco, 
				ds_complemento, 
				ds_bairro, 
				substr(coalesce(obter_desc_municipio_ibge(cd_municipio_ibge), ds_municipio),1,40), 
				cd_tipo_logradouro 
			into STRICT	ds_endereco_w, 
				nr_endereco_w, 
				ds_complemento_w, 
				ds_bairro_w, 
				ds_municipio_w, 
				cd_tipo_logradouro_w 
			from	compl_pessoa_fisica 
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w 
			and	ie_tipo_complemento	= 9 
			and	nr_seq_tipo_compl_adic	= nr_seq_tipo_compl_adic_w;
			exception 
			when others then 
				ds_endereco_w		:= null;
				nr_endereco_w		:= null;
				ds_complemento_w	:= null;
				ds_bairro_w		:= null;
				sg_estado_w		:= null;
				ds_municipio_w		:= null;
				nr_seq_tipo_logradouro_w:= null;
			end;
			 
		else 
			begin 
			select	ds_endereco, 
				nr_endereco, 
				ds_complemento, 
				ds_bairro, 
				substr(coalesce(obter_desc_municipio_ibge(cd_municipio_ibge), ds_municipio),1,40), 
				cd_tipo_logradouro 
			into STRICT	ds_endereco_w, 
				nr_endereco_w, 
				ds_complemento_w, 
				ds_bairro_w, 
				ds_municipio_w, 
				cd_tipo_logradouro_w 
			from	compl_pessoa_fisica 
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w 
			and	ie_tipo_complemento	= 9 
			and	coalesce(nr_seq_tipo_compl_adic::text, '') = ''  LIMIT 1;
			exception 
			when others then 
				ds_endereco_w		:= null;
				nr_endereco_w		:= null;
				ds_complemento_w	:= null;
				ds_bairro_w		:= null;
				sg_estado_w		:= null;
				ds_municipio_w		:= null;
				nr_seq_tipo_logradouro_w:= null;
			end;
			 
		end if;
	end if;	
end if;
 
if (nr_seq_tipo_logradouro_w IS NOT NULL AND nr_seq_tipo_logradouro_w::text <> '') then 
 
	select	max(ds_tipo_logradouro) 
	into STRICT	ds_tipo_logradouro_w 
	from	cns_tipo_logradouro 
	where	nr_sequencia	= nr_seq_tipo_logradouro_w;
 
elsif (cd_tipo_logradouro_w IS NOT NULL AND cd_tipo_logradouro_w::text <> '') then 
	 
	ds_tipo_logradouro_w := substr(sus_obter_desc_tipolog(cd_tipo_logradouro_w),1,40);	
end if;
 
if (ds_tipo_logradouro_w IS NOT NULL AND ds_tipo_logradouro_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ds_tipo_logradouro_w || ', ';
end if;
 
if (ds_endereco_w IS NOT NULL AND ds_endereco_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ds_endereco_w || ', ';
end if;
 
if (nr_endereco_w IS NOT NULL AND nr_endereco_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || nr_endereco_w || ', ';
end if;
 
if (ds_complemento_w IS NOT NULL AND ds_complemento_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ds_complemento_w || ', ';
end if;
 
if (ds_bairro_w IS NOT NULL AND ds_bairro_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ds_bairro_w || ', ';
end if;
 
if (ds_municipio_w IS NOT NULL AND ds_municipio_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ds_municipio_w || ', ';
end if;
 
if (sg_estado_w IS NOT NULL AND sg_estado_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || sg_estado_w || ', ';
end if;
 
ds_retorno_w := substr(ds_retorno_w,1,length(ds_retorno_w) - 2);
 
return 	substr(ds_retorno_w,1,255);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_end_prestador_estab ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, ie_tipo_endereco_p pls_prestador.ie_tipo_endereco%type, nr_seq_compl_adic_p pessoa_juridica_compl.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

