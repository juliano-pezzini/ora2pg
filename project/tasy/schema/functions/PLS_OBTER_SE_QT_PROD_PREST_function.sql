-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_qt_prod_prest ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, qt_pagamento_prest_p bigint, nr_seq_evento_regra_pag_p pls_evento_regra_pag.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1) := 'N';
qt_pagamentos_prest_w		integer;

C01 CURSOR(	qt_pagamento_prest_pc		bigint,
		nr_seq_evento_regra_pag_pc	pls_evento_regra_pag.nr_sequencia%type) FOR
	SELECT	nr_seq_lote
	from (SELECT	b.nr_sequencia nr_seq_lote
		from	pls_lote_pagamento 	b,
			pls_periodo_pagamento 	a
		where	(a.nr_fluxo_pgto IS NOT NULL AND a.nr_fluxo_pgto::text <> '')
		and	(b.dt_fechamento IS NOT NULL AND b.dt_fechamento::text <> '')
		and	a.ie_complementar 	= 'N'
		and	a.nr_sequencia 		= b.nr_seq_periodo
		and not exists (	select	1
				from	pls_evento_regra_pag_exce 	d
				where	d.nr_seq_evento_regra_pag	= nr_seq_evento_regra_pag_pc
				and	d.nr_seq_periodo		= b.nr_seq_periodo)
		order by b.dt_mes_competencia desc,
			a.nr_fluxo_pgto desc) alias4 LIMIT (qt_pagamento_prest_pc);

BEGIN
if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then
	for r_C01_w in C01(qt_pagamento_prest_p, nr_seq_evento_regra_pag_p) loop
		select	count(*)
		into STRICT 	qt_pagamentos_prest_w
		from	pls_evento 		c,
			pls_pagamento_item 	b,
			pls_pagamento_prestador	a
		where	c.nr_sequencia 		= b.nr_seq_evento
		and	a.nr_sequencia 		= b.nr_seq_pagamento
		and	a.nr_seq_lote 		= r_C01_w.nr_seq_lote
		and	a.nr_seq_prestador 	= nr_seq_prestador_p
		and	c.ie_tipo_evento 	= 'P';

		if (qt_pagamentos_prest_w > 0) then
			ie_retorno_w := 'S';
			exit;
		end if;
	end loop;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_qt_prod_prest ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, qt_pagamento_prest_p bigint, nr_seq_evento_regra_pag_p pls_evento_regra_pag.nr_sequencia%type) FROM PUBLIC;
