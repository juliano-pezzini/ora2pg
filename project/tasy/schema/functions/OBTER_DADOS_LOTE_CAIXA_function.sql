-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_lote_caixa ( nr_seq_lote_p bigint, nr_seq_caixa_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


/* ie_tipo
SA = saldo anterior ao lote
SF = saldo final do lote
*/
vl_entradas_w		double precision := 0;
vl_saidas_w		double precision := 0;
vl_saldo_inicial_w	double precision := 0;
vl_retorno_w		double precision := 0;
nr_seq_saldo_caixa_w	bigint;


BEGIN

SELECT	distinct b.nr_sequencia,
	b.vl_saldo_inicial
into STRICT	nr_seq_saldo_caixa_w,
	vl_saldo_inicial_w
FROM	movto_trans_financ_v a,
	caixa_saldo_diario b
WHERE	a.nr_seq_saldo_caixa	= b.nr_sequencia
AND	a.nr_seq_lote		= nr_seq_lote_p
AND	a.nr_seq_caixa		= nr_seq_caixa_p;

if (ie_tipo_p = 'SA') then

	select	sum(CASE WHEN c.ie_saldo_caixa='E' THEN  a.vl_transacao  ELSE 0 END ),
		sum(CASE WHEN c.ie_saldo_caixa='S' THEN  a.vl_transacao  ELSE 0 END )
	into STRICT	vl_entradas_w,
		vl_saidas_w
	from	movto_trans_financ_v a,
		caixa_saldo_diario b,
		transacao_financeira c
	where	a.nr_seq_saldo_caixa	= b.nr_sequencia
	and	a.nr_seq_trans_financ	= c.nr_sequencia
	and	a.nr_seq_lote		< nr_seq_lote_p
	and	a.nr_seq_caixa		= nr_seq_caixa_p
	and	b.nr_sequencia		= nr_seq_saldo_caixa_w
	and	c.ie_caixa		in ('D','A','T');

	vl_retorno_w := coalesce((vl_saldo_inicial_w + (vl_entradas_w - vl_saidas_w)),vl_saldo_inicial_w);

end if;

if (ie_tipo_p = 'SF') then

	select	sum(CASE WHEN c.ie_saldo_caixa='E' THEN  a.vl_transacao  ELSE 0 END ),
		sum(CASE WHEN c.ie_saldo_caixa='S' THEN  a.vl_transacao  ELSE 0 END )
	into STRICT	vl_entradas_w,
		vl_saidas_w
	from	movto_trans_financ_v a,
		caixa_saldo_diario b,
		transacao_financeira c
	where	a.nr_seq_saldo_caixa	= b.nr_sequencia
	and	a.nr_seq_trans_financ	= c.nr_sequencia
	and	a.nr_seq_lote		<= nr_seq_lote_p
	and	a.nr_seq_caixa		= nr_seq_caixa_p
	and	b.nr_sequencia		= nr_seq_saldo_caixa_w
	and	c.ie_caixa		in ('D','A','T');

	vl_retorno_w	:= vl_saldo_inicial_w + (vl_entradas_w - vl_saidas_w);

end if;

return to_char(vl_retorno_w);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_lote_caixa ( nr_seq_lote_p bigint, nr_seq_caixa_p bigint, ie_tipo_p text) FROM PUBLIC;

