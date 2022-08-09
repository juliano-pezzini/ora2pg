-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_lote_evento ( nr_seq_lote_p pls_lote_evento.nr_sequencia%type, ie_opcao_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_lote_pgto_p pls_lote_pagamento.nr_sequencia%type, ie_commit_p text) AS $body$
DECLARE


/* ==== IE_OPCAO_P ==== */

/*        L - Liberar Lote	     */

/*        D - Desfazer Lote     */

/* ====================  */

ie_forma_pagto_w		pls_evento_regra_pag.ie_forma_pagto%type;
ie_forma_pagto_ocor_w		pls_evento_movimento.ie_forma_pagto%type;
nr_seq_prestador_w		pls_evento_movimento.nr_seq_prestador%type;
dt_movimento_w			pls_evento_movimento.dt_movimento%type;
nr_sequencia_w			pls_evento_movimento.nr_sequencia%type;
nr_seq_evento_w			pls_evento_movimento.nr_seq_evento%type;
nr_seq_periodo_w		pls_evento_movimento.nr_seq_periodo%type;
cd_estabelecimento_w		pls_lote_evento.cd_estabelecimento%type;
nr_seq_lote_pgto_w		pls_lote_pagamento.nr_sequencia%type;
ie_status_lote_w		varchar(2);
ie_liberar_lote_w		varchar(1)	:= 'N';
qt_vago_w			bigint	:= 0;
qt_lote_pgto_w			integer;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_prestador,
		dt_movimento,
		nr_seq_evento,
		nr_seq_periodo,
		ie_forma_pagto
	from	pls_evento_movimento
	where	nr_seq_lote = nr_seq_lote_p;

C02 CURSOR FOR
	SELECT	ie_forma_pagto
	from	pls_evento_regra_pag
	where	nr_seq_evento = nr_seq_evento_w
	and	coalesce(nr_seq_prestador,coalesce(nr_seq_prestador_w,0)) = coalesce(nr_seq_prestador_w,0)
	and	dt_movimento_w between trunc(dt_inicio_vigencia,'dd') and fim_dia(coalesce(dt_fim_vigencia,dt_movimento_w))
	and (pls_obter_se_qt_prod_prest(nr_seq_prestador_w,qt_pag_sem_movimento, nr_sequencia) = 'N' or coalesce(qt_pag_sem_movimento::text, '') = '')
	order by coalesce(qt_pag_sem_movimento,0),
		coalesce(nr_seq_prestador,0);


BEGIN
if (ie_opcao_p = 'L') then

	open C01;
	loop
	fetch C01 into
		nr_sequencia_w,
		nr_seq_prestador_w,
		dt_movimento_w,
		nr_seq_evento_w,
		nr_seq_periodo_w,
		ie_forma_pagto_ocor_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ie_forma_pagto_w := null;

		if (coalesce(ie_forma_pagto_ocor_w,'X') = 'P') then --Produção Médica
			--Valida se não possui lote de pagamento gerado ou fechado para as ocorrências financeiras.
			SELECT * FROM pls_valida_ocorrencia_financ(dt_movimento_w, nr_seq_periodo_w, nr_seq_lote_pgto_w, ie_status_lote_w) INTO STRICT nr_seq_lote_pgto_w, ie_status_lote_w;

			if (coalesce(ie_status_lote_w,'X') <> 'X') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(389414, 'LOTE=' || nr_seq_lote_pgto_w);
			end if;
		end if;

		open C02;
		loop
		fetch C02 into
			ie_forma_pagto_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			null;
			end;
		end loop;
		close C02;

		update	pls_evento_movimento
		set	ie_forma_pagto		= coalesce(ie_forma_pagto_w,'P')
		where	nr_sequencia		= nr_sequencia_w
		and	coalesce(ie_forma_pagto,'R')	= 'R';
		end;
	end loop;
	close C01;

	update	pls_lote_evento
	set	dt_liberacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_lote_p;

	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	pls_lote_evento
	where	nr_sequencia	= nr_seq_lote_p;

	CALL pls_atualizar_codificacao_pck.pls_atualizar_codificacao(trunc(dt_movimento_w,'month'));
	/* Lepinski - OS 381715 - Atualizar as contas contábeis */

	qt_vago_w := ctb_pls_atualizar_prod_eve_in(nr_seq_lote_p, null, null, nm_usuario_p, cd_estabelecimento_w, qt_vago_w);
elsif (ie_opcao_p = 'D') then
	-- jtonon - OS 827383 - Adicionado consistência afim de não permitir desfazer liberação quando tiver lotes de pagamento vinculados a ocorrências financeiras
	if (coalesce(nr_seq_lote_pgto_p::text, '') = '') then -- wcbernardino - OS 827383 - Só deve consistir se os eventos estiverem sendo desfeitos fora do OPS - Pagamento de Produção Médica
		select	count(1)
		into STRICT	qt_lote_pgto_w
		from	pls_lote_evento a,
			pls_evento_movimento b
		where	a.nr_sequencia = b.nr_seq_lote
		and	coalesce(a.nr_seq_franq_pag::text, '') = ''
		and	b.nr_seq_lote	= nr_seq_lote_p
		and	(b.nr_seq_lote_pgto IS NOT NULL AND b.nr_seq_lote_pgto::text <> '')  LIMIT 1;

		if (coalesce(qt_lote_pgto_w,0) > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(331126);
		end if;
	end if;

	update	pls_lote_evento
	set	dt_liberacao	 = NULL
	where	nr_sequencia	= nr_seq_lote_p;

	update	pls_evento_movimento
	set	ie_forma_pagto	 = NULL
	where	nr_seq_lote	= nr_seq_lote_p;
end if;

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_lote_evento ( nr_seq_lote_p pls_lote_evento.nr_sequencia%type, ie_opcao_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_lote_pgto_p pls_lote_pagamento.nr_sequencia%type, ie_commit_p text) FROM PUBLIC;
