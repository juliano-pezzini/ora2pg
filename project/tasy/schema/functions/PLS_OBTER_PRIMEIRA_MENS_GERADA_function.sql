-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_primeira_mens_gerada ( nr_seq_contrato_p bigint) RETURNS varchar AS $body$
DECLARE


dt_contrato_w		timestamp;
nr_seq_mensalidade_w	bigint;
ds_retorno_w		varchar(1);


BEGIN

select	max(dt_contrato)
into STRICT	dt_contrato_w
from	pls_contrato
where	nr_sequencia	= nr_seq_contrato_p;

select	max(a.nr_sequencia)
into STRICT	nr_seq_mensalidade_w
from	pls_mensalidade		a,
	pls_contrato_pagador	b
where	a.nr_seq_pagador	= b.nr_sequencia
and	b.nr_seq_contrato	= nr_seq_contrato_p
and	coalesce(a.dt_cancelamento::text, '') = ''
and	trunc(a.dt_referencia, 'month')	= trunc(dt_contrato_w, 'month');

if (nr_seq_mensalidade_w IS NOT NULL AND nr_seq_mensalidade_w::text <> '') then
	ds_retorno_w	:= 'S';
else
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_mensalidade_w
	from	pls_mensalidade		a,
		pls_contrato_pagador	b,
		pls_mensalidade_segurado c
	where	a.nr_seq_pagador	= b.nr_sequencia
	and	b.nr_seq_contrato	= nr_seq_contrato_p
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and	a.nr_sequencia		= c.nr_seq_mensalidade
	and	trunc(c.dt_mesano_referencia, 'month')	= trunc(dt_contrato_w, 'month');
	
	if (nr_seq_mensalidade_w IS NOT NULL AND nr_seq_mensalidade_w::text <> '') then
		ds_retorno_w	:= 'S';
	else
		ds_retorno_w	:= 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_primeira_mens_gerada ( nr_seq_contrato_p bigint) FROM PUBLIC;

