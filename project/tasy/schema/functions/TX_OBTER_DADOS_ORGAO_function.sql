-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tx_obter_dados_orgao ( nr_seq_orgao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_orgao_w		varchar(15);
ds_retorno_w		varchar(255);
nm_orgao_w		varchar(80);


BEGIN

select	max(ie_orgao),
	max(nm_orgao)
into STRICT	ie_orgao_w,
	nm_orgao_w
from	tx_orgao
where	nr_sequencia	= nr_seq_orgao_p;

if (ie_opcao_p = 'T') then
	ds_retorno_w	:= ie_orgao_w;
elsif (ie_opcao_p = 'O') then
	ds_retorno_w	:= nm_orgao_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tx_obter_dados_orgao ( nr_seq_orgao_p bigint, ie_opcao_p text) FROM PUBLIC;
