-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_coordenadoria_munic_pf (cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
ie_opcao_p
C - Código
D - Descrição
*/
nr_seq_coordenadoria_w	bigint;
ds_coordenadoria_w	varchar(255);
ds_retorno_w		varchar(255);


BEGIN

select 	max(nr_seq_coordenadoria)
into STRICT	nr_seq_coordenadoria_w
from	sus_municipio b,
	compl_pessoa_fisica a
where	a.cd_pessoa_fisica 	= cd_pessoa_fisica_p
and	a.ie_tipo_complemento 	= 1
and	b.cd_municipio_ibge	= a.cd_municipio_ibge;

if (ie_opcao_p = 'C') then
	ds_retorno_w	:= nr_seq_coordenadoria_w;
elsif (ie_opcao_p = 'D') then
	ds_retorno_w	:= substr(sus_obter_desc_coordenad(nr_seq_coordenadoria_w),1,255);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_coordenadoria_munic_pf (cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;

