-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_item_pag_pos_tribut (nr_seq_pagamento_p pls_pagamento_prestador.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_item_w		pls_pagamento_item.nr_sequencia%type;

c01 CURSOR(	nr_seq_pagamento_pc	pls_pagamento_prestador.nr_sequencia%type) FOR
	SELECT	a.nr_seq_lote nr_seq_lote_pag,
		c.nr_seq_evento,
		coalesce(c.vl_movimento,0) vl_movimento,
		c.nr_seq_regra_fixo
	from	pls_evento_movimento	c,
		pls_lote_evento		b,
		pls_pagamento_prestador	a
	where	a.nr_sequencia 		= nr_seq_pagamento_pc
	and	a.nr_seq_lote		= b.nr_seq_pgto_desc_liq
	and	b.nr_sequencia		= c.nr_seq_lote
	and	a.nr_seq_prestador	= c.nr_seq_prestador;

BEGIN

for r_C01_w in C01( nr_seq_pagamento_p ) loop
	insert into pls_pagamento_item(nr_sequencia,
		nr_seq_pagamento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_evento,
		nr_seq_regra_fixo_calc,
		ie_apropriar_total,
		vl_item,
		vl_glosa)
	values (nextval('pls_pagamento_item_seq'),
		nr_seq_pagamento_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		r_C01_w.nr_seq_evento,
		r_C01_w.nr_seq_regra_fixo,
		'N',
		r_C01_w.vl_movimento,
		0) returning nr_sequencia into nr_seq_item_w;

	update	pls_pag_prest_vencimento
	set	vl_liquido = vl_liquido - abs(r_C01_w.vl_movimento),
		vl_vencimento = vl_vencimento - abs(r_c01_w.vl_movimento)
	where	nr_seq_pag_prestador = nr_seq_pagamento_p;

	update	pls_lote_pagamento
	set	vl_lote = vl_lote - abs(r_c01_w.vl_movimento)
	where	nr_sequencia = r_c01_w.nr_seq_lote_pag;
end loop;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_item_pag_pos_tribut (nr_seq_pagamento_p pls_pagamento_prestador.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
