-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dl_obter_dados_socio ( nr_seq_socio_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

			 
ds_retorno_w	varchar(255);
	
/*	ie_opcao_p 
	N - nome do socio 
	T - tipo do socio 
	PF - codigo pessoa fisica do socio 
*/
 
	 

BEGIN 
ds_retorno_w	:= '';
 
if (ie_opcao_p = 'N') then 
	select	substr(obter_nome_pf(cd_pessoa_fisica),1,255) 
	into STRICT	ds_retorno_w 
	from	dl_socio 
	where	nr_sequencia	= nr_seq_socio_p;
elsif (ie_opcao_p = 'T') then 
	select	ie_tipo_socio 
	into STRICT	ds_retorno_w 
	from	dl_socio 
	where	nr_sequencia	= nr_seq_socio_p;
elsif (ie_opcao_p = 'PF') then 
	select	cd_pessoa_fisica 
	into STRICT	ds_retorno_w 
	from	dl_socio 
	where	nr_sequencia	= nr_seq_socio_p;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dl_obter_dados_socio ( nr_seq_socio_p bigint, ie_opcao_p text) FROM PUBLIC;
