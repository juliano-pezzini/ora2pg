-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION far_obter_dados_entrega (nr_seq_pedido_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/*ie_opcao_p: 
N : Nome; 
C : Contato/Parente; 
E : Endereço; 
NR : Numero; 
B : Bairro; 
M : Municipio; 
T : Telefone; 
CO : Complemento; 
CEP: Cep; 
*/
 
 
 
ds_retorno_w		varchar(255);
cd_pessoa_fisica_w	varchar(10);


BEGIN 
 
select	cd_pessoa_fisica 
into STRICT	cd_pessoa_fisica_w 
from	far_pedido 
where	nr_sequencia = nr_seq_pedido_p;
 
if (ie_opcao_p = 'N') then 
	begin 
	select	 SUBSTR(OBTER_NOME_PF(cd_pessoa_fisica), 0, 255) 
	into STRICT	ds_retorno_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;
	end;
 
elsif (ie_opcao_p = 'C') then 
	begin 
	select	nm_contato 
	into STRICT	ds_retorno_w 
	from	compl_pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	ie_tipo_complemento = 1;
	end;
 
elsif (ie_opcao_p = 'E') then 
	begin 
	select	ds_endereco 
	into STRICT	ds_retorno_w 
	from	compl_pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	ie_tipo_complemento = 1;
	end;
 
elsif (ie_opcao_p = 'NR') then 
	begin 
	select	nr_endereco 
	into STRICT	ds_retorno_w 
	from	compl_pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	ie_tipo_complemento = 1;
	end;
 
elsif (ie_opcao_p = 'B') then 
	begin 
	select	ds_bairro 
	into STRICT	ds_retorno_w 
	from	compl_pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	ie_tipo_complemento = 1;
	end;
 
elsif (ie_opcao_p = 'M') then 
	begin 
	select	coalesce(ds_municipio,substr(obter_desc_municipio_ibge(cd_municipio_ibge),1,255)) 
	into STRICT	ds_retorno_w 
	from	compl_pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	ie_tipo_complemento = 1;
	end;
 
elsif (ie_opcao_p = 'T') then 
	begin 
	select	CASE WHEN coalesce(nr_ddd_telefone::text, '') = '' THEN ''  ELSE '(' || nr_ddd_telefone || ') ' END  || nr_telefone 
	into STRICT	ds_retorno_w 
	from	compl_pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	ie_tipo_complemento = 1;
	end;
 
elsif (ie_opcao_p = 'CO') then 
	begin 
	select	ds_complemento 
	into STRICT	ds_retorno_w 
	from	compl_pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	ie_tipo_complemento = 1;
	end;
 
elsif (ie_opcao_p = 'CEP') then 
	begin 
	select	cd_cep 
	into STRICT	ds_retorno_w 
	from	compl_pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	ie_tipo_complemento = 1;
	end;
 
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION far_obter_dados_entrega (nr_seq_pedido_p bigint, ie_opcao_p text) FROM PUBLIC;
