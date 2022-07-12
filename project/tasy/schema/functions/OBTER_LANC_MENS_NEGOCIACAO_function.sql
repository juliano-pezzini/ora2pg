-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lanc_mens_negociacao (nr_seq_negociacao_mens_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000)	:= null;
nr_seq_lancamento_w	bigint;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	pls_lancamento_mensalidade a
where	a.nr_seq_negociacao_mens	= nr_seq_negociacao_mens_p

union all

select	a.nr_sequencia
from	pls_segurado_mensalidade a
where	a.nr_seq_negociacao_mens	= nr_seq_negociacao_mens_p;


BEGIN

if (nr_seq_negociacao_mens_p IS NOT NULL AND nr_seq_negociacao_mens_p::text <> '') then
	open c01;
	loop
	fetch c01 into
		nr_seq_lancamento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (coalesce(ds_retorno_w::text, '') = '') then
			ds_retorno_w	:= ds_retorno_w || nr_seq_lancamento_w;
		else
			ds_retorno_w	:= ds_retorno_w || ', ' || nr_seq_lancamento_w;
		end if;
		end;
	end loop;
	close c01;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lanc_mens_negociacao (nr_seq_negociacao_mens_p bigint) FROM PUBLIC;
