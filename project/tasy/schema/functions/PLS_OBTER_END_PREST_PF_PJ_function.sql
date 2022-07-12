-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_end_prest_pf_pj (cd_cgc_p text, cd_pessoa_fisica_p text, ie_tipo_endereco_p text, nr_seq_compl_adic_p bigint) RETURNS varchar AS $body$
DECLARE

					 
ds_retorno_w		varchar(255);
ie_tipo_endereco_w	varchar(5);
ds_endereco_w		varchar(255)	:= null;
nr_endereco_w		varchar(10)	:= null;
ds_complemento_w	varchar(100)	:= null;
ds_bairro_w		varchar(255)	:= null;
sg_estado_w		pessoa_juridica.sg_estado%type := null;
ds_municipio_w		varchar(40);
nr_seq_compl_adic_w	bigint;
nr_seq_compl_end_w	bigint;


BEGIN 
if (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') or (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then	 
	if (ie_tipo_endereco_p IS NOT NULL AND ie_tipo_endereco_p::text <> '') then 
		ie_tipo_endereco_w	:= ie_tipo_endereco_p;
	end if;
	 
	if (nr_seq_compl_adic_p IS NOT NULL AND nr_seq_compl_adic_p::text <> '') then 
		nr_seq_compl_adic_w 	:= nr_seq_compl_adic_p;
	end if;	
	 
	if (ie_tipo_endereco_w in ('PJ')) then 
		select	CASE WHEN coalesce(b.ds_tipo_logradouro::text, '') = '' THEN ''  ELSE b.ds_tipo_logradouro||' ' END ||a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			a.ds_municipio 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w 
		FROM pessoa_juridica a
LEFT OUTER JOIN cns_tipo_logradouro b ON (a.nr_seq_tipo_logradouro = b.nr_sequencia)
WHERE a.cd_cgc		 = cd_cgc_p;
	elsif (ie_tipo_endereco_w in ('PJA')) and (nr_seq_compl_adic_w > 0) then 
		select	a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			a.ds_municipio 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc	= cd_cgc_p	 
		and	a.nr_sequencia	= nr_seq_compl_adic_w;
	elsif (ie_tipo_endereco_w in ('PJC')) then 
		begin 
		select 	max(nr_sequencia) 
		into STRICT	nr_seq_compl_end_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc		= cd_cgc_p 
		and	a.ie_tipo_complemento 	= 1;	
		 
		select	a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			ds_municipio 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc	= cd_cgc_p 
		and	a.ie_tipo_complemento = 1 
		and	a.nr_sequencia 		= nr_seq_compl_end_w;
		exception 
		when others then 
			ds_endereco_w	:= null;
		end;
	elsif (ie_tipo_endereco_w in ('PJF')) then 
		begin 
		select 	max(nr_sequencia) 
		into STRICT	nr_seq_compl_end_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc		= cd_cgc_p 
		and	a.ie_tipo_complemento 	= 2;
		 
		select	a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			ds_municipio 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w 
		from	pessoa_juridica_compl a 
		where	a.cd_cgc	= cd_cgc_p 
		and	a.ie_tipo_complemento = 2 
		and	a.nr_sequencia 		= nr_seq_compl_end_w;
		exception 
		when others then 
			ds_endereco_w	:= null;
		end;
	elsif (ie_tipo_endereco_w = 'PFR') then 
		select	CASE WHEN coalesce(a.cd_tipo_logradouro::text, '') = '' THEN ''  ELSE sus_obter_desc_tipolog(a.cd_tipo_logradouro)||' ' END ||a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			ds_municipio 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w 
		from	compl_pessoa_fisica a 
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p 
		and	a.ie_tipo_complemento 	= 1;
	elsif (ie_tipo_endereco_w = 'PFC') then 
		select	CASE WHEN coalesce(a.cd_tipo_logradouro::text, '') = '' THEN ''  ELSE sus_obter_desc_tipolog(a.cd_tipo_logradouro)||' ' END ||a.ds_endereco, 
			a.nr_endereco, 
			a.ds_complemento, 
			a.ds_bairro, 
			a.sg_estado, 
			ds_municipio 
		into STRICT	ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			ds_bairro_w, 
			sg_estado_w, 
			ds_municipio_w 
		from	compl_pessoa_fisica a 
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p 
		and	a.ie_tipo_complemento = 2;
		 
		if (nr_seq_compl_adic_w > 0) then 
			select	CASE WHEN coalesce(a.cd_tipo_logradouro::text, '') = '' THEN ''  ELSE sus_obter_desc_tipolog(a.cd_tipo_logradouro)||' ' END ||a.ds_endereco, 
				a.nr_endereco, 
				a.ds_complemento, 
				a.ds_bairro, 
				a.sg_estado, 
				ds_municipio 
			into STRICT	ds_endereco_w, 
				nr_endereco_w, 
				ds_complemento_w, 
				ds_bairro_w, 
				sg_estado_w, 
				ds_municipio_w 
			from	compl_pf_tel_adic a 
			where	a.nr_sequencia	= nr_seq_compl_adic_w;	
		end if;	
	end if;
end if;
 
if (ds_endereco_w IS NOT NULL AND ds_endereco_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ds_endereco_w;
end if;
 
if (nr_endereco_w IS NOT NULL AND nr_endereco_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ', ' || nr_endereco_w;
end if;
 
if (ds_complemento_w IS NOT NULL AND ds_complemento_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ', ' || ds_complemento_w;
end if;
 
if (ds_bairro_w IS NOT NULL AND ds_bairro_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ', ' || ds_bairro_w;
end if;
 
if (ds_municipio_w IS NOT NULL AND ds_municipio_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ', ' || ds_municipio_w;
end if;
 
if (sg_estado_w IS NOT NULL AND sg_estado_w::text <> '') then 
	ds_retorno_w	:= ds_retorno_w || ', ' || sg_estado_w;
end if;
 
 
return 	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_end_prest_pf_pj (cd_cgc_p text, cd_pessoa_fisica_p text, ie_tipo_endereco_p text, nr_seq_compl_adic_p bigint) FROM PUBLIC;
