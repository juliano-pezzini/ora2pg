-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_regra_proc (nr_seq_regra_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/*	E - Edição 
	DE - Descrição da Edição 
	P - Produto 
	A - Acomodação 
	TA - Tipo atendimento 
	CL - Clínica 
	CA - Categoria 
	D - Descrição da Regra 
*/
 
 
cd_edicao_amb_w		integer;
ds_edicao_amb_w		varchar(255);
ds_retorno_w		varchar(255);
ds_tipo_acomodacao_w	varchar(255);
ds_tipo_atendimento_w	varchar(255);
ds_clinica_w		varchar(255);
ds_categoria_w		varchar(255);
ds_plano_w		varchar(255);
ds_regra_w		pls_regra_preco_proc.ds_regra%type;


BEGIN 
 
select	cd_edicao_amb, 
	substr(obter_desc_edicao_amb(cd_edicao_amb),1,255), 
	substr(obter_descricao_padrao('PLS_TIPO_ACOMODACAO','DS_TIPO_ACOMODACAO',nr_seq_tipo_acomodacao),1,255), 
	substr(obter_descricao_padrao('PLS_TIPO_ATENDIMENTO','DS_TIPO_ATENDIMENTO',nr_seq_tipo_atendimento),1,255), 
	substr(obter_descricao_padrao('PLS_CLINICA','DS_CLINICA',nr_seq_clinica),1,255), 
	substr(obter_descricao_padrao('PLS_CATEGORIA','DS_CATEGORIA',nr_seq_categoria),1,255), 
	substr(pls_obter_dados_produto(nr_seq_plano,'N'),1,255), 
	ds_regra 
into STRICT	cd_edicao_amb_w, 
	ds_edicao_amb_w, 
	ds_tipo_acomodacao_w, 
	ds_tipo_atendimento_w, 
	ds_clinica_w, 
	ds_categoria_w, 
	ds_plano_w, 
	ds_regra_w 
from	pls_regra_preco_proc 
where	nr_sequencia	= nr_seq_regra_p;
 
if (ie_opcao_p = 'E') then 
	ds_retorno_w	:= to_char(cd_edicao_amb_w);
elsif (ie_opcao_p = 'DE') then 
	ds_retorno_w	:= ds_edicao_amb_w;
elsif (ie_opcao_p = 'P') then 
	ds_retorno_w	:= ds_plano_w;
elsif (ie_opcao_p = 'A') then 
	ds_retorno_w	:= ds_tipo_acomodacao_w;
elsif (ie_opcao_p = 'TA') then 
	ds_retorno_w	:= ds_tipo_atendimento_w;
elsif (ie_opcao_p = 'CL') then 
	ds_retorno_w	:= ds_clinica_w;
elsif (ie_opcao_p = 'CA') then 
	ds_retorno_w	:= ds_categoria_w;
elsif (ie_opcao_p = 'D') then 
	ds_retorno_w	:= ds_regra_w;
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_regra_proc (nr_seq_regra_p bigint, ie_opcao_p text) FROM PUBLIC;

