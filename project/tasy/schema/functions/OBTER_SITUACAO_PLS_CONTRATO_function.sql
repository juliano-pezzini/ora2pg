-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_situacao_pls_contrato ( nr_titulo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
D - Descrição
*/
ds_retorno_w		varchar(255);
ds_situacao_w		varchar(255);


BEGIN

select	max(substr(obter_valor_dominio(1733,c.ie_situacao),1,50))
into STRICT	ds_situacao_w
from	pls_mensalidade a,
	titulo_receber b,
	pls_contrato c
where	a.nr_sequencia	= b.nr_seq_mensalidade
and	c.nr_sequencia	= a.nr_seq_contrato
and	b.nr_titulo	= nr_titulo_p;

if (ie_opcao_p = 'D') then
	ds_retorno_w	:= ds_situacao_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_situacao_pls_contrato ( nr_titulo_p bigint, ie_opcao_p text) FROM PUBLIC;
