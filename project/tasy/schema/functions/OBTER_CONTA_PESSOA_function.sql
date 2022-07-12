-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_pessoa (cd_favorecido_p text, ie_tipo_favorecido_p text, ie_tipo_dado_p text) RETURNS varchar AS $body$
DECLARE


/* Tipos de Favorecidos
F - Pessoa Fisica 
J - Pessoa Juridica */


/* Tipos de Dados
B - Banco
A - Agencia Bancaria
C - Numero Conta  
CD - Conta com digito
AD - Agencia com digito
CI - Codigo Identificacao (Somente para Pessoa Juridica)
NB - Nome do banco
DA - Digito agencia
DC - Digito conta
*/
nr_seq_pessoa_conta_w			bigint	:= null;
cd_banco_w				banco.cd_banco%type	:= null;
cd_agencia_w				varchar(08)	:= null;
nr_conta_w				varchar(20)	:= null;
ds_retorno_w				varchar(40)	:= null;
ie_digito_agencia_w			varchar(02)	:= null;
nr_digito_conta_w			varchar(02)	:= null;
cd_codigo_identificacao_w		varchar(20)	:= null;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_banco,
		cd_agencia_bancaria,
		nr_conta,
		ie_digito_agencia,
		nr_digito_conta
	from	pessoa_fisica_conta
	where	cd_pessoa_fisica = cd_favorecido_p
	and	ie_situacao = 'A'
	order by 1;

c02 CURSOR FOR
	SELECT	nr_sequencia,
		cd_banco,
		cd_agencia_bancaria,
		nr_conta,
		ie_digito_agencia,
		nr_digito_conta,
		cd_codigo_identificacao
	from	pessoa_juridica_conta
	where	cd_cgc = cd_favorecido_p
	and	ie_situacao = 'A'
	order by 1;
			

BEGIN

if (ie_tipo_favorecido_p = 'F') then
	begin
	open c01;
	loop
	fetch c01 into
		nr_seq_pessoa_conta_w,
		cd_banco_w,
		cd_agencia_w,
		nr_conta_w,
		ie_digito_agencia_w,
		nr_digito_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;
	end;
elsif (ie_tipo_favorecido_p = 'J') then
	begin
	open c02;
	loop
	fetch c02 into
		nr_seq_pessoa_conta_w,
		cd_banco_w,
		cd_agencia_w,
		nr_conta_w,
		ie_digito_agencia_w,
		nr_digito_conta_w,
		cd_codigo_identificacao_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	end loop;
	close c02;
	end;
end if;

if (ie_tipo_dado_p = 'B') then
	ds_retorno_w	:= cd_banco_w;
elsif (ie_tipo_dado_p = 'A') then
	ds_retorno_w	:= cd_agencia_w;
elsif (ie_tipo_dado_p = 'C') then
	ds_retorno_w	:= nr_conta_w;
elsif (ie_tipo_dado_p = 'CI') then
	ds_retorno_w	:= cd_codigo_identificacao_w;
elsif (ie_tipo_dado_p = 'AD') then
	if (ie_digito_agencia_w IS NOT NULL AND ie_digito_agencia_w::text <> '') then
		ds_retorno_w	:= cd_agencia_w ||'-'||ie_digito_agencia_w;
	else
		ds_retorno_w	:= cd_agencia_w;
	end if;
elsif (ie_tipo_dado_p = 'CD') then
	if (nr_digito_conta_w IS NOT NULL AND nr_digito_conta_w::text <> '') then
		ds_retorno_w	:= nr_conta_w ||'-'||nr_digito_conta_w;
	else
		ds_retorno_w	:= nr_conta_w;
	end if;
elsif (ie_tipo_dado_p	= 'NB') then

	select	substr(max(a.ds_banco),1,40)
	into STRICT	ds_retorno_w
	from	banco a
	where	a.cd_banco	= cd_banco_w;
elsif (ie_tipo_dado_p = 'DA') then
	ds_retorno_w	:= ie_digito_agencia_w;
elsif (ie_tipo_dado_p = 'DC') then
	ds_retorno_w	:= nr_digito_conta_w;
end if;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_pessoa (cd_favorecido_p text, ie_tipo_favorecido_p text, ie_tipo_dado_p text) FROM PUBLIC;

