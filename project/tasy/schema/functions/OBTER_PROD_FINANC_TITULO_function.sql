-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prod_financ_titulo (nr_titulo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
ie_opcao_p
C	Código
D	Descrição
*/
ds_retorno_w		varchar(255);
nr_seq_produto_w	bigint;


BEGIN

ds_retorno_w := '';

select	max(nr_seq_produto)
into STRICT	nr_seq_produto_w
from	titulo_receber_classif
where	nr_titulo	= nr_titulo_p;

if (ie_opcao_p = 'C') then
	ds_retorno_w	:= nr_seq_produto_w;
elsif (ie_opcao_p = 'D') then
	ds_retorno_w	:= OBTER_DESC_PRODUTO_FINANCEIRO(nr_seq_produto_w);
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prod_financ_titulo (nr_titulo_p bigint, ie_opcao_p text) FROM PUBLIC;
