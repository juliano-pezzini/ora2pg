-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lib_lote_copartic ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_lote_mens_w		pls_mensalidade.nr_seq_lote%type;

C01 CURSOR FOR
	SELECT	a.nr_seq_conta_coparticipacao,
		b.nr_seq_conta,
		b.nr_seq_mensalidade_seg
	from	pls_lib_coparticipacao	a,
		pls_conta_coparticipacao b
	where	b.nr_sequencia	= a.nr_seq_conta_coparticipacao
	and	a.nr_seq_lote	= nr_seq_lote_p
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and	coalesce(a.nm_usuario_cancelamento::text, '') = ''
	and	b.ie_status_mensalidade in ('G','L');

BEGIN

for r_C01_w in C01 loop

	if (r_c01_w.nr_seq_mensalidade_seg IS NOT NULL AND r_c01_w.nr_seq_mensalidade_seg::text <> '') then
		select	max(b.nr_seq_lote)
		into STRICT	nr_seq_lote_mens_w
		from	pls_mensalidade_segurado a,
			pls_mensalidade b
		where	b.nr_sequencia	= a.nr_seq_mensalidade
		and	a.nr_sequencia	= r_c01_w.nr_seq_mensalidade_seg;

		CALL wheb_mensagem_pck.exibir_mensagem_abort( 353544 , 'NR_SEQ_CONTA='||r_C01_w.nr_seq_conta||';'||'NR_SEQ_LOTE='||nr_seq_lote_mens_w); --O lote não pode ser desfeito pois já existem contas faturadas
	else
		update	pls_conta_coparticipacao
		set	ie_status_mensalidade	= 'P'
		where	nr_sequencia		= r_C01_w.nr_seq_conta_coparticipacao;
	end if;

end loop;

update	pls_lote_coparticipacao
set	dt_liberacao		 = NULL,
	nm_usuario_liberacao	 = NULL,
	ie_status		= 'G'
where	nr_sequencia		= nr_seq_lote_p;


CALL pls_gravar_hist_lote_copartic(	nr_seq_lote_p,
				'Desfazer liberação do lote pelo usuário',
				nm_usuario_p,
				cd_estabelecimento_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lib_lote_copartic ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
