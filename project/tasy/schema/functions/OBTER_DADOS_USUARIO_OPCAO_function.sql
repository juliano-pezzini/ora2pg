-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_usuario_opcao ( nm_usuario_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
C - código pessoa fisica
S - Setor
R - Cargo
T - Situação
M - Ramal
E - Email
DS - Descrição Setor
DP - descrição Perfil PEP
F - Função
EP - Texto Email Padrão
CE - código estabelecimento do cadastro.
BA - Barras
LA - Login alternativo
NP - Nome pessoa
*/
ds_retorno_w			varchar(255);
cd_pessoa_fisica_w		varchar(20);
cd_setor_atendimento_w	integer;
cd_cargo_w				bigint;
cd_estab_cadastro_w		bigint;
ie_situacao_w			varchar(1);
nr_ramal_w				varchar(20);
ds_email_w				varchar(255);
ie_tipo_evolucao_w		varchar(3);
nr_seq_perfil_w			bigint;
ds_texto_email_w		varchar(4000);
cd_barras_w				varchar(40);
ds_login_w				varchar(50);
cd_perfil_inicial_w		perfil.cd_perfil%type;


BEGIN

select	max(cd_pessoa_fisica),
		max(cd_setor_atendimento),
		max(nr_ramal),
		max(ds_email),
		max(nr_seq_perfil),
		max(ie_tipo_evolucao),
		max(ds_texto_email),
		max(cd_estabelecimento),
		max(cd_barras),
		max(ds_login),
		max(cd_perfil_inicial)
into STRICT	cd_pessoa_fisica_w,
		cd_setor_atendimento_w,
		nr_ramal_w,
		ds_email_w,
		nr_seq_perfil_w,
		ie_tipo_evolucao_w,
		ds_texto_email_w,
		cd_estab_cadastro_w,
		cd_barras_w,
		ds_login_w,
		cd_perfil_inicial_w
from	usuario
where	nm_usuario	= nm_usuario_p;

if (ie_opcao_p	= 'C')	then
	ds_retorno_w	:= cd_pessoa_fisica_w;
elsif (ie_opcao_p	= 'S')	then
	ds_retorno_w	:= cd_setor_atendimento_w;
elsif (ie_opcao_p	= 'R')	then

	select	max(cd_cargo)
	into STRICT	cd_cargo_w
	from	pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

	ds_retorno_w	:= cd_cargo_w;
elsif (ie_opcao_p	= 'M')	then
	ds_retorno_w	:= nr_ramal_w;
elsif (ie_opcao_p	= 'E') then
	ds_retorno_w	:= ds_email_w;
elsif (ie_opcao_p	= 'T') then
	select	coalesce(max(ie_situacao),'I')
	into STRICT	ie_situacao_w
	from	usuario
	where	nm_usuario = nm_usuario_p;
	ds_retorno_w	:= ie_situacao_w;
elsif (ie_opcao_p	= 'DS') then
	ds_retorno_w	:= Obter_nome_setor(cd_setor_atendimento_w);
elsif (ie_opcao_p	= 'F') then
	ds_retorno_w	:= ie_tipo_evolucao_w;
elsif (ie_opcao_p	= 'DF') then
	ds_retorno_w	:= obter_valor_dominio(72,ie_tipo_evolucao_w);
elsif (ie_opcao_p	= 'CPI') then
	ds_retorno_w	:= cd_perfil_inicial_w;
elsif (ie_opcao_p	= 'DP') then
	ds_retorno_w	:= obter_desc_pep_perfil_usuario(nr_seq_perfil_w);
elsif (ie_opcao_p	= 'EP') then
	ds_retorno_w	:= ds_texto_email_w;
elsif (ie_opcao_p	= 'CE') then
	ds_retorno_w	:= cd_estab_cadastro_w;
elsif (ie_opcao_p	= 'BA') then
	ds_retorno_w	:= cd_barras_w;
elsif (ie_opcao_p	= 'LA') then
	ds_retorno_w	:= ds_login_w;
elsif (ie_opcao_p	= 'NP') then
	ds_retorno_w	:= obter_nome_pf(cd_pessoa_fisica_w);
end if;

Return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_usuario_opcao ( nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;
