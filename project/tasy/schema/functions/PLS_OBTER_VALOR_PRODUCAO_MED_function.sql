-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_producao_med (nr_seq_pagamento_p bigint, nr_titulo_p bigint) RETURNS bigint AS $body$
DECLARE


vl_producao_w	double precision := 0;


BEGIN

if (coalesce(nr_seq_pagamento_p,0) > 0) then
	select	coalesce(sum(a.vl_item),0)
	into STRICT	vl_producao_w
	from	pls_evento b,
		pls_pagamento_item a
	where	a.nr_seq_evento		= b.nr_sequencia
	and	b.ie_tipo_evento	= 'P'
	and	a.nr_seq_pagamento	= nr_seq_pagamento_p;
elsif (coalesce(nr_titulo_p,0) > 0) then
	select	coalesce(sum(a.vl_item),0)
	into STRICT	vl_producao_w
	from	pls_evento b,
		pls_pagamento_item a
	where	a.nr_seq_evento		= b.nr_sequencia
	and	b.ie_tipo_evento		= 'P'
	and	a.nr_seq_pagamento	in (SELECT	x.nr_seq_pag_prestador
		from	pls_pag_prest_vencimento x
		where	x.nr_titulo		= nr_titulo_p);
end if;

return	vl_producao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_producao_med (nr_seq_pagamento_p bigint, nr_titulo_p bigint) FROM PUBLIC;
