-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nr_parcela_em_dia ( nr_seq_mensalidade_p bigint, nr_seq_mensalidade_segurado_p bigint, nr_seq_bonificacao_vinculo_p bigint) RETURNS bigint AS $body$
DECLARE


nr_parcela_em_dia_w		bigint;
nr_seq_pagador_w		bigint;
dt_pagamento_previsto_w		timestamp;
dt_liquidacao_w			timestamp;
nr_seq_mensalidade_w		bigint;
nr_seq_segurado_w		bigint;
dt_mesano_referencia_w		timestamp;
dt_contratacao_w		timestamp;
qt_meses_restricao_w		bigint;
ie_zerar_parcela_w		varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_referencia,
		c.dt_pagamento_previsto,
		c.dt_liquidacao
	from	pls_mensalidade		a,
		pls_contrato_pagador	b,
		titulo_receber		c
	where	a.nr_seq_pagador	= b.nr_sequencia
	and	c.nr_seq_mensalidade	= a.nr_sequencia
	and	b.nr_sequencia		= nr_seq_pagador_w
	and	coalesce(a.ie_cancelamento::text, '') = ''
	and	a.dt_referencia >= dt_contratacao_w
	order	by a.dt_referencia;


BEGIN
select	a.nr_seq_segurado,
	c.nr_seq_pagador,
	b.dt_contratacao
into STRICT	nr_seq_segurado_w,
	nr_seq_pagador_w,
	dt_contratacao_w
from	pls_mensalidade_segurado a,
	pls_segurado	b,
	pls_mensalidade	c
where	a.nr_seq_segurado	= b.nr_sequencia
and	a.nr_seq_mensalidade	= c.nr_sequencia
and	a.nr_sequencia		= nr_seq_mensalidade_segurado_p;

select	max(c.qt_meses_restricao)
into STRICT	qt_meses_restricao_w
from	pls_bonificacao_v a,
	pls_bonificacao b,
	pls_bonificacao_restricao c
where	a.nr_seq_bonificacao	= b.nr_sequencia
and	b.nr_sequencia		= c.nr_seq_bonificacao
and	a.nr_seq_vinculo	= nr_seq_bonificacao_vinculo_p
and	a.nr_seq_segurado	= nr_seq_segurado_w;

nr_parcela_em_dia_w	:= 0;

open C01;
loop
fetch C01 into
	nr_seq_mensalidade_w,
	dt_mesano_referencia_w,
	dt_pagamento_previsto_w,
	dt_liquidacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ie_zerar_parcela_w := 'N';

	if (coalesce(qt_meses_restricao_w,0) <> 0) then
		ie_zerar_parcela_w := pls_verificar_se_zera_parcela(nr_seq_segurado_w, nr_seq_bonificacao_vinculo_p, dt_mesano_referencia_w);
	end if;

	if	((dt_liquidacao_w <= dt_pagamento_previsto_w) or
		((coalesce(dt_liquidacao_w::text, '') = '') and (trunc(dt_pagamento_previsto_w,'dd') >= trunc(clock_timestamp(),'dd')))) and (ie_zerar_parcela_w = 'N') then
		nr_parcela_em_dia_w	:= coalesce(nr_parcela_em_dia_w,0) + 1;
	else
		nr_parcela_em_dia_w	:= 0;
	end if;
	end;
end loop;
close C01;

return	nr_parcela_em_dia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nr_parcela_em_dia ( nr_seq_mensalidade_p bigint, nr_seq_mensalidade_segurado_p bigint, nr_seq_bonificacao_vinculo_p bigint) FROM PUBLIC;

