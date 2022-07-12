-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_observacao_lanc_prog ( nr_seq_item_mensalidade_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
nr_seq_lanc_mensalidade_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_lanc_mensalidade_w
from	pls_lancamento_mensalidade
where	nr_seq_mensalidade_item	= nr_seq_item_mensalidade_p;

if (nr_seq_lanc_mensalidade_w IS NOT NULL AND nr_seq_lanc_mensalidade_w::text <> '') then
	select	substr(ds_observacao,1,255)
	into STRICT	ds_retorno_w
	from	pls_lancamento_mensalidade
	where	nr_sequencia	= nr_seq_lanc_mensalidade_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_observacao_lanc_prog ( nr_seq_item_mensalidade_p bigint) FROM PUBLIC;
