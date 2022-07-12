-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_testemunha_cat ( nr_seq_testemunha_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
	N - Nome
	E - Endereço || Número || Complemento
	B - Bairro
	C - CEP
	M - Município
	UF - Unidade federativa
	T - Telefone
*/
ds_retorno_w			varchar(255);
cd_pessoa_fisica_w		varchar(10);
nm_pessoa_fisica_w		varchar(255);
ds_endereco_w			varchar(200);
ds_bairro_w			varchar(40);
cd_cep_w			varchar(15);
nm_municipio_w			varchar(40);
sg_estado_w			pls_cat_testemunha.sg_estado%type;
nr_telefone_w			varchar(15);
nm_testemunha_w			varchar(255);
nr_ddd_telefone_w		varchar(3);
ds_complemento_w		varchar(255);


BEGIN

select	cd_pessoa_fisica,
	ds_endereco || ' - ' || ds_complemento,
	ds_bairro,
	cd_cep,
	nm_municipio,
	sg_estado,
	nr_telefone,
	nm_testemunha
into STRICT	cd_pessoa_fisica_w,
	ds_endereco_w,
	ds_bairro_w,
	cd_cep_w,
	nm_municipio_w,
	sg_estado_w,
	nr_telefone_w,
	nm_testemunha_w
from	pls_cat_testemunha
where	nr_sequencia	= nr_seq_testemunha_p;

/*
select	nm_pessoa_fisica,
	ds_endereco,
	ds_bairro,
	cd_cep,
	ds_municipio,
	sg_estado,
	nr_telefone
into	nm_pessoa_fisica_w,
	ds_endereco_w,
	ds_bairro_w,
	cd_cep_w,
	ds_municipio_w,
	sg_estado_w,
	nr_telefone_w
from	(select	a.nm_pessoa_fisica,
		b.ds_endereco || decode(b.nr_endereco,null,' x ',' , '|| to_char(b.nr_endereco)) ||' '|| b.ds_complemento ds_endereco,
		b.ds_bairro,
		b.cd_cep,
		b.ds_municipio,
		b.sg_estado,
		b.nr_telefone
	from	pessoa_fisica a,
		compl_pessoa_fisica b
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	b.ie_tipo_complemento	= 1
	and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
	UNION ALL
	select	a.nm_pessoa_fisica,
		null ds_endereco,
		null ds_bairro,
		null cd_cep,
		null ds_municipio,
		null sg_estado,
		null nr_telefone
	from	pessoa_fisica a
	where	not exists (	select	1
				from	compl_pessoa_fisica x
				where	a.cd_pessoa_fisica = x.cd_pessoa_fisica
				and	x.ie_tipo_complemento	= 1)
	and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w);*/
if (ie_opcao_p	= 'N') then
	ds_retorno_w	:= nm_testemunha_w;
elsif (ie_opcao_p	= 'E') then
	ds_retorno_w	:= ds_endereco_w;
elsif (ie_opcao_p	= 'B') then
	ds_retorno_w	:= ds_bairro_w;
elsif (ie_opcao_p	= 'C') then
	ds_retorno_w	:= cd_cep_w;
elsif (ie_opcao_p	= 'M') then
	ds_retorno_w	:= nm_municipio_w;
elsif (ie_opcao_p	= 'UF') then
	ds_retorno_w	:= sg_estado_w;
elsif (ie_opcao_p	= 'T') then
	ds_retorno_w	:= nr_telefone_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_testemunha_cat ( nr_seq_testemunha_p bigint, ie_opcao_p text) FROM PUBLIC;

