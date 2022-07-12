-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cns_obter_dados_usuario ( nr_sequencia_p bigint, ie_opcao_p text, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


/* IE_OPCAO_P
	CP - Cor pele
	SC - Situacao conjugal
	TP - Tipo certidao
	O  - Orgao emissor
	MR - Municipio residencia
	C  - Codigo domicilio
	CA - Cadastrador
	S  - Sequencia do usuario no domicilio
*/
/* IE_TIPO_P
	C - Codigo
	D - Descricao
*/
cd_pessoa_fisica_w	varchar(10);
nr_seq_cor_pele_w	bigint;
nr_seq_sit_conjugal_w	bigint;
nr_seq_tipo_certidao_w	bigint;
nr_seq_orgao_ci_w	bigint;
cd_ret_w		bigint;
nr_seq_domicilio_w	bigint;
nr_seq_cadastrador_w	bigint;
ds_ret_w		varchar(80);
ds_retorno_w		varchar(80);


BEGIN

select	cd_pessoa_fisica,
	nr_seq_sit_conjugal,
	nr_seq_tipo_certidao,
	nr_seq_orgao_ci,
	nr_seq_cadastrador
into STRICT	cd_pessoa_fisica_w,
	nr_seq_sit_conjugal_w,
	nr_seq_tipo_certidao_w,
	nr_seq_orgao_ci_w,
	nr_seq_cadastrador_w
from	cns_usuario
where	nr_sequencia	= nr_Sequencia_p;

nr_seq_domicilio_w	:= Cns_Obter_Domicilio_Usuario(nr_sequencia_p,'S');

/* Cor pele */

if (ie_opcao_p	= 'CP') then
	begin
	select	nr_seq_cor_pele
	into STRICT	nr_seq_cor_pele_w
	from	pessoa_fisica
	where	cd_pessoa_fisica= cd_pessoa_fisica_w;

	select	cd_cns,
		ds_cor_pele
	into STRICT	cd_ret_w,
		ds_ret_w
	from	cor_pele
	where	nr_sequencia	= nr_seq_cor_pele_w;
	exception
		when others then
			cd_ret_w	:= 9;
			ds_ret_w	:= '';
	end;
/* Situação conjugal */

elsif (ie_opcao_p	= 'SC') then
	begin
	select	cd_situacao_conjugal,
		ds_situacao_conjugal
	into STRICT	cd_ret_w,
		ds_ret_w
	from	cns_situacao_conjugal
	where	nr_sequencia	= nr_seq_sit_conjugal_w;
	end;
/* Tipo certidao */

elsif (ie_opcao_p	= 'TC') then
	begin
	select	cd_tipo_certidao,
		ds_tipo_certidao
	into STRICT	cd_ret_w,
		ds_ret_w
	from	cns_tipo_certidao
	where	nr_sequencia	= nr_seq_tipo_certidao_w;
	end;
/* Orgao emissor do RG */

elsif (ie_opcao_p	= 'O') then
	begin
	select	cd_orgao_emissor,
		ds_orgao_emissor
	into STRICT	cd_ret_w,
		ds_ret_w
	from	cns_orgao_emissor_ci
	where	nr_sequencia	= nr_seq_orgao_ci_w;
	end;
/* Municipio residencia */

elsif (ie_opcao_p	= 'MR') then
	begin
	select	cd_municipio_ibge,
		obter_desc_municipio_ibge(cd_municipio_ibge)
	into STRICT	cd_ret_w,
		ds_ret_w
	from	cns_domicilio
	where	nr_sequencia	= nr_seq_domicilio_w;
	exception
		when others then
		cd_ret_w	:= null;
		ds_ret_w	:= '';
	end;
/* Codigo domicilio */

elsif (ie_opcao_p	= 'C') then
	cd_ret_w	:= Cns_Obter_Domicilio_Usuario(nr_sequencia_p,'C');
elsif (ie_opcao_p	= 'CA') then
	begin
	select	cd_cadastrador,
		nm_cadastrador
	into STRICT	cd_ret_w,
		ds_ret_w
	from	cns_cadastrador
	where	nr_Sequencia	= nr_seq_cadastrador_w;
	end;
elsif (ie_opcao_p	= 'S') then
	select	max(nr_sequencia)
	into STRICT	cd_ret_w
	from	cns_domicilio_usuario
	where	nr_seq_usuario	= nr_sequencia_p
	and	ie_situacao	= 'A';
end if;

if (ie_tipo_p	= 'C') then
	ds_retorno_w	:= cd_ret_w;
elsif (ie_tipo_p	= 'D') then
	ds_retorno_w	:= ds_ret_w;
end if;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cns_obter_dados_usuario ( nr_sequencia_p bigint, ie_opcao_p text, ie_tipo_p text) FROM PUBLIC;

