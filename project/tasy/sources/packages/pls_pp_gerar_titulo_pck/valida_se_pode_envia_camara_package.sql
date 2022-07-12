-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_gerar_titulo_pck.valida_se_pode_envia_camara ( nr_seq_lote_camara_comp_p pls_lote_camara_comp.nr_sequencia%type, nr_seq_pp_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_pgto_lote_p pls_lote_pagamento.nr_sequencia%type) AS $body$
DECLARE


nr_seq_lote_camara_w		pls_titulo_lote_camara.nr_sequencia%type;
					

BEGIN
if (coalesce(nr_seq_lote_camara_comp_p::text, '') = '') then
	-- Favor informar um lote de camara de compensacao.

	CALL wheb_mensagem_pck.exibir_mensagem_abort(939995);
end if;

-- Se OPS - Pagamentos de Prestadores

if (nr_seq_pp_lote_p IS NOT NULL AND nr_seq_pp_lote_p::text <> '') then
	select	max(t.nr_sequencia)
	into STRICT	nr_seq_lote_camara_w
	from	pls_pp_prestador v,
		pls_titulo_lote_camara t
	where	t.nr_titulo_pagar	= v.nr_titulo_pagar
	and	v.nr_seq_lote		= nr_seq_pp_lote_p;

-- Se OPS - Pagamentos de Producao Medica

elsif (nr_seq_pgto_lote_p IS NOT NULL AND nr_seq_pgto_lote_p::text <> '') then
	select	max(t.nr_sequencia)
	into STRICT	nr_seq_lote_camara_w
	from	pls_pag_prest_vencimento v,
		pls_pagamento_prestador	p,
		pls_titulo_lote_camara t
	where	v.nr_titulo	= t.nr_titulo_pagar
	and	p.nr_sequencia	= v.nr_seq_pag_prestador
	and	p.nr_seq_lote	= nr_seq_pgto_lote_p;
end if;

if (nr_seq_lote_camara_w IS NOT NULL AND nr_seq_lote_camara_w::text <> '') then
	-- Nao foi possivel enviar para camara pois o lote de pagamento ja possui titulos no lote de camara #@NR_SEQ_LOTE_CAMARA#@.

	CALL wheb_mensagem_pck.exibir_mensagem_abort(1072326,'NR_SEQ_LOTE_CAMARA=' || nr_seq_lote_camara_w);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_gerar_titulo_pck.valida_se_pode_envia_camara ( nr_seq_lote_camara_comp_p pls_lote_camara_comp.nr_sequencia%type, nr_seq_pp_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_pgto_lote_p pls_lote_pagamento.nr_sequencia%type) FROM PUBLIC;
