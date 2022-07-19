-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lanc_programados (nr_seq_lote_evento_p bigint, nr_seq_lote_pgto_p bigint, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
if (nr_seq_lote_evento_p IS NOT NULL AND nr_seq_lote_evento_p::text <> '') then

	update	pls_pag_prest_vencimento	a
	set	a.nr_seq_evento_movto	 = NULL,
		a.ie_proximo_pgto	= 'S'
	where	exists	(SELECT	1
			from	pls_evento_movimento	x,
				pls_lote_evento		e
			where	a.nr_seq_evento_movto	= x.nr_sequencia
			and	e.nr_sequencia		= x.nr_seq_lote
			and	coalesce(e.nr_seq_lote_pgto_apropr::text, '') = ''
			and	((x.nr_seq_lote_pgto	= nr_seq_lote_pgto_p AND nr_seq_lote_pgto_p IS NOT NULL AND nr_seq_lote_pgto_p::text <> '') or
				 (x.nr_seq_lote	= nr_seq_lote_evento_p AND nr_seq_lote_evento_p IS NOT NULL AND nr_seq_lote_evento_p::text <> '')));

	update	pls_pag_prest_vencimento	a
	set	a.nr_seq_evento_movto	 = NULL,
		a.ie_proximo_pgto	= 'S'
	where	exists	(SELECT	1
			from	pls_evento_movimento		x,
				pls_lote_evento			e,
				pls_pag_prest_venc_valor	y
			where	x.nr_sequencia		= y.nr_seq_evento_movto
			and	a.nr_sequencia		= y.nr_seq_vencimento
			and	e.nr_sequencia		= x.nr_seq_lote
			and	coalesce(e.nr_seq_lote_pgto_apropr::text, '') = ''
			and	((x.nr_seq_lote_pgto	= nr_seq_lote_pgto_p AND nr_seq_lote_pgto_p IS NOT NULL AND nr_seq_lote_pgto_p::text <> '') or
				 (x.nr_seq_lote	= nr_seq_lote_evento_p AND nr_seq_lote_evento_p IS NOT NULL AND nr_seq_lote_evento_p::text <> '')));

	update	pls_pag_prest_venc_valor	a
	set	a.nr_seq_evento_movto	 = NULL
	where	exists	(SELECT	1
			from	pls_evento_movimento	x,
				pls_lote_evento		e
			where	a.nr_seq_evento_movto	= x.nr_sequencia
			and	e.nr_sequencia		= x.nr_seq_lote
			and	coalesce(e.nr_seq_lote_pgto_apropr::text, '') = ''
			and	((x.nr_seq_lote_pgto	= nr_seq_lote_pgto_p AND nr_seq_lote_pgto_p IS NOT NULL AND nr_seq_lote_pgto_p::text <> '') or
				 (x.nr_seq_lote	= nr_seq_lote_evento_p AND nr_seq_lote_evento_p IS NOT NULL AND nr_seq_lote_evento_p::text <> '')));

	update 	pls_evento_movimento a
	set	a.nr_seq_lote_pgto  = NULL,
		a.nr_seq_pagamento_item  = NULL
	where	a.nr_seq_lote_pgto = nr_seq_lote_pgto_p
	and	exists (SELECT	1
			from	pls_lote_evento x
			where	x.nr_sequencia	= a.nr_seq_lote
			and	(x.nr_seq_lote_pgto_apropr IS NOT NULL AND x.nr_seq_lote_pgto_apropr::text <> ''));

	update	pls_discussao_evento_movto b
	set	b.nr_seq_evento_movto  = NULL
	where exists (	SELECT	1
			from	pls_evento_movimento a
			where	a.nr_sequencia = b.nr_seq_evento_movto
			and	a.nr_seq_lote = nr_seq_lote_evento_p);

	delete 	FROM pls_evento_movimento
	where	nr_seq_lote = nr_seq_lote_evento_p;

	if (nr_seq_lote_pgto_p IS NOT NULL AND nr_seq_lote_pgto_p::text <> '') then
		update	pls_discussao_evento_movto	a
		set	a.nr_seq_evento_movto 		 = NULL
		where exists (	SELECT	1
				from	pls_evento_movimento 	b
				where	b.nr_sequencia		= a.nr_seq_evento_movto
				and	b.nr_seq_lote_pgto 	= nr_seq_lote_pgto_p);

		delete 	FROM pls_evento_movimento
		where	nr_seq_lote_pgto 	= nr_seq_lote_pgto_p
		and	coalesce(nr_seq_prest_plant_item::text, '') = '';
	end if;
end if;

if (coalesce(ie_commit_p, 'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lanc_programados (nr_seq_lote_evento_p bigint, nr_seq_lote_pgto_p bigint, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;

