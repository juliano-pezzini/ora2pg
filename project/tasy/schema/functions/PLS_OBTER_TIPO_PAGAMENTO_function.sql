-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tipo_pagamento ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, dt_competencia_p pls_rel_pag_prestador.dt_competencia%type) RETURNS varchar AS $body$
DECLARE


-- ds_retorno_w
-- 1 = OPS - Pagamentos de Producao Medica
-- 2 = OPS - Pagamentos de Prestadores
ds_retorno_w		varchar(1);


BEGIN

select	CASE WHEN count(1)=0 THEN  ds_retorno_w  ELSE '1' END
into STRICT	ds_retorno_w
from	pls_pagamento_prestador	b,
	pls_lote_pagamento	a
where	a.nr_sequencia		= b.nr_seq_lote
and	b.nr_seq_prestador	= nr_seq_prestador_p
and	a.dt_mes_competencia	= trunc(dt_competencia_p, 'mm')
and	a.ie_status		= 'D'
and	coalesce(b.ie_cancelamento::text, '') = '';

if (coalesce(ds_retorno_w::text, '') = '') then
	select	CASE WHEN count(1)=0 THEN  ds_retorno_w  ELSE '2' END
	into STRICT	ds_retorno_w
	from	pls_pp_prestador	b,
		pls_pp_lote		a
	where	a.nr_sequencia		= b.nr_seq_lote
	and	b.nr_seq_prestador	= nr_seq_prestador_p
	and	a.dt_mes_competencia	= trunc(dt_competencia_p, 'mm')
	and	a.ie_status		= 'D'
	and	b.ie_cancelado		= 'N';
end if;

return	coalesce(ds_retorno_w, '1');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tipo_pagamento ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, dt_competencia_p pls_rel_pag_prestador.dt_competencia%type) FROM PUBLIC;

