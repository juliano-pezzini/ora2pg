-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_telefone_concat_pep (cd_pessoa_fisica_p text, ie_tipo_complemento_p bigint, ie_sbis_p text default null) RETURNS varchar AS $body$
DECLARE


ds_descricao_w             	varchar(255);
nr_ddi_telefone_w			compl_pessoa_fisica.nr_ddi_telefone%type;
nr_ddd_telefone_w			compl_pessoa_fisica.nr_ddd_telefone%type;
nr_telefone_w				compl_pessoa_fisica.nr_telefone%type;

nr_telefone_celular_w		pessoa_fisica.nr_telefone_celular%type;
nr_ddi_celular_w			pessoa_fisica.nr_ddi_celular%type;
nr_ddd_celular_w			pessoa_fisica.nr_ddd_celular%type;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select 	max(obter_compl_pf(cd_pessoa_fisica_p,ie_tipo_complemento_p,'T')),
			max(obter_compl_pf(cd_pessoa_fisica_p,ie_tipo_complemento_p,'DIT')),
			max(obter_compl_pf(cd_pessoa_fisica_p,ie_tipo_complemento_p,'DDT'))
	into STRICT 	nr_telefone_w,
			nr_ddi_telefone_w,
			nr_ddd_telefone_w
	;
	
	if (nr_telefone_w IS NOT NULL AND nr_telefone_w::text <> '') then

		if (nr_ddi_telefone_w IS NOT NULL AND nr_ddi_telefone_w::text <> '') then
		
			if (substr(nr_ddi_telefone_w,1,1) <> '+') then
				ds_descricao_w := '+' || nr_ddi_telefone_w||' ';
			else
				ds_descricao_w := nr_ddi_telefone_w||' ';
			end if;
			
		end if;
		
		if (nr_ddd_telefone_w IS NOT NULL AND nr_ddd_telefone_w::text <> '') then
		
			ds_descricao_w := ds_descricao_w || '('||nr_ddd_telefone_w||') ';
		
		end if;
		
		ds_descricao_w := ds_descricao_w || nr_telefone_w||' ('||substr(obter_valor_dominio(5637,  ie_tipo_complemento_p), 1, 254)||')';
	
	end if;
	
	if (ie_sbis_p IS NOT NULL AND ie_sbis_p::text <> '') then
	
		select 	max(nr_telefone_celular),
				max(nr_ddi_celular),
				max(nr_ddd_celular)
		into STRICT	nr_telefone_celular_w,
				nr_ddi_celular_w,
				nr_ddd_celular_w
		from	pessoa_fisica_alteracao
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
		
	else
	
		select 	max(nr_telefone_celular),
				max(nr_ddi_celular),
				max(nr_ddd_celular)
		into STRICT	nr_telefone_celular_w,
				nr_ddi_celular_w,
				nr_ddd_celular_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
		
	end if;
	
	if (nr_telefone_celular_w IS NOT NULL AND nr_telefone_celular_w::text <> '') then
	
		if (ds_descricao_w IS NOT NULL AND ds_descricao_w::text <> '') then
		
			ds_descricao_w := ds_descricao_w||' / ';
		
		end if;
		
		if (nr_ddi_celular_w IS NOT NULL AND nr_ddi_celular_w::text <> '') then
		
			if (substr(nr_ddi_celular_w,1,1) <> '+') then
				ds_descricao_w := ds_descricao_w||'+' || nr_ddi_celular_w||' ';
			else
				ds_descricao_w := ds_descricao_w||nr_ddi_celular_w||' ';
			end if;
			
		end if;
			
		if (nr_ddd_celular_w IS NOT NULL AND nr_ddd_celular_w::text <> '') then
		
			ds_descricao_w := ds_descricao_w || '('||nr_ddd_celular_w||') ';
		
		end if;
		
		ds_descricao_w := ds_descricao_w || nr_telefone_celular_w||' ('||Wheb_mensagem_pck.get_texto(839507)||')';
	
	end if;
	

end if;

return ds_descricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_telefone_concat_pep (cd_pessoa_fisica_p text, ie_tipo_complemento_p bigint, ie_sbis_p text default null) FROM PUBLIC;

