-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valores_pagar ( dt_referencia_p timestamp, ds_prestador_p text, nr_documento_p bigint) RETURNS bigint AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Obter o valor a pagar por prestador e documento
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [ X]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
Function utilizada para o relatório WPLS/1174 - Registro Auxiliar RN Nº 227
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
vl_retorno_w		double precision;


BEGIN
select	coalesce(sum(vl_pagar),0)
into STRICT	vl_retorno_w
from	(SELECT	sum(CASE WHEN b.ie_situacao='D' THEN (	select	sum(obter_saldo_titulo_pagar(x.nr_titulo, dt_referencia_p))			from	titulo_pagar	x			where	x.nr_titulo_original = b.nr_titulo			and (trunc(x.dt_liquidacao,'month') > trunc(to_date(dt_referencia_p,'dd/mm/yyyy'),'month')			or	coalesce(x.dt_liquidacao::text, '') = '')			and	b.ie_situacao = 'D')  ELSE obter_saldo_titulo_pagar(b.nr_titulo, dt_referencia_p) END ) vl_pagar
	from   	pls_pagamento_prestador		k,
		pls_lote_pagamento 		e,
		pls_pag_prest_vencimento	a,
		titulo_pagar			b
	where	k.nr_sequencia	= a.nr_seq_pag_prestador
	and	e.nr_sequencia	= k.nr_seq_lote
	and	a.nr_titulo	= b.nr_titulo
	and	exists (select	1
			from	--pls_conta 			d,
				--pls_protocolo_conta 		f,
				pls_conta_medica_resumo		x
			--where	x.nr_seq_conta		= d.nr_sequencia
			where	x.nr_seq_lote_pgto	= e.nr_sequencia
			and	x.nr_seq_prestador_pgto	= k.nr_seq_prestador)
			--and	f.nr_sequencia	= d.nr_seq_protocolo)
	and (b.cd_cgc = ds_prestador_p or b.cd_pessoa_fisica = ds_prestador_p)
	and	((b.nr_documento = nr_documento_p) or (coalesce(b.nr_documento::text, '') = ''))
	and	((coalesce(b.dt_liquidacao::text, '') = '') or (b.dt_liquidacao > fim_mes(dt_referencia_p)))
	and	trunc(b.dt_emissao, 'month') <= trunc(dt_referencia_p, 'month')) alias25;

return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valores_pagar ( dt_referencia_p timestamp, ds_prestador_p text, nr_documento_p bigint) FROM PUBLIC;
