-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sip_obter_dados_estrutura ( nr_sequencia_p bigint, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(80);
cd_estrutura_w		varchar(40);
ds_estrutura_w		varchar(80);


BEGIN

begin
select	cd_estrutura,
	ds_estrutura
into STRICT	cd_estrutura_w,
	ds_estrutura_w
from	sip_estrutura_proc
where	nr_sequencia	= nr_sequencia_p
and	ie_situacao	= 'A';
exception
	when others then
	cd_estrutura_w	:= '';
	ds_estrutura_w	:= '';
end;

if (ie_tipo_retorno_p	= 'C') then
	ds_retorno_w	:= cd_estrutura_w;
elsif (ie_tipo_retorno_p	= 'D') then
	ds_retorno_w	:= ds_estrutura_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sip_obter_dados_estrutura ( nr_sequencia_p bigint, ie_tipo_retorno_p text) FROM PUBLIC;

