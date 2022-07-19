-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_valor_lote_pag ( nr_seq_pagamento_prest_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_itens_w		double precision;
vl_pagamentos_w		double precision;
nr_seq_lote_w		bigint;


BEGIN
if (nr_seq_pagamento_prest_p IS NOT NULL AND nr_seq_pagamento_prest_p::text <> '') then
	select	coalesce(sum(a.vl_item), 0)
	into STRICT	vl_itens_w
	from	pls_pagamento_item	a
	where	a.nr_seq_pagamento	= nr_seq_pagamento_prest_p
	and	coalesce(a.ie_apropriar_total, 'N') = 'N';

	update	pls_pagamento_prestador
	set	vl_pagamento 	= vl_itens_w,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_pagamento_prest_p;

	select	max(nr_seq_lote)
	into STRICT	nr_seq_lote_w
	from	pls_pagamento_prestador
	where 	nr_sequencia = nr_seq_pagamento_prest_p;

	if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then
		select	sum(coalesce(vl_pagamento,0))
		into STRICT	vl_pagamentos_w
		from	pls_pagamento_prestador
		where	nr_seq_lote	= nr_seq_lote_w;

		update	pls_lote_pagamento
		set	vl_lote		= vl_pagamentos_w
		where	nr_sequencia	= nr_seq_lote_w;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_valor_lote_pag ( nr_seq_pagamento_prest_p bigint, nm_usuario_p text) FROM PUBLIC;

