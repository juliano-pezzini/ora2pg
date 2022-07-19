-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_fechar_rec_glosa ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Desfazer o fechamento das contas de recurso através da análise.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_lote_contabil_w		pls_conta_rec_resumo_item.nr_lote_contabil%type;
nr_seq_lote_pgto_w		pls_conta_rec_resumo_item.nr_seq_lote_pgto%type;
qt_rec_glosa_w			integer;
ie_gerar_val_adic_w		pls_parametros_rec_glosa.ie_gerar_val_adic%type;

C01 CURSOR(nr_seq_analise_pc		pls_analise_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_conta_rec,
		a.nr_seq_protocolo
	from	pls_rec_glosa_conta a
	where	a.nr_seq_analise = nr_seq_analise_pc;

C02 CURSOR(nr_seq_conta_rec_pc		pls_rec_glosa_conta.nr_sequencia%type) FOR
	SELECT	a.nr_seq_lote_pgto,
		coalesce(a.nr_lote_contabil,0) nr_lote_contabil
	from	pls_conta_rec_resumo_item a
	where	nr_seq_conta_rec = nr_seq_conta_rec_pc;

C03 CURSOR FOR
	SELECT	nr_sequencia nr_seq_conta_rec
	from	pls_rec_glosa_conta
	where	nr_seq_protocolo = ( 	SELECT max(nr_seq_protocolo)
									from 	pls_rec_glosa_conta
									where 	nr_seq_analise = nr_seq_analise_p);
BEGIN
select	coalesce(max(ie_gerar_val_adic), 'L')
into STRICT	ie_gerar_val_adic_w
from	pls_parametros_rec_glosa
where	cd_estabelecimento = cd_estabelecimento_p;

for r_c03_w in c03 loop

	--Essas verificações ficavam no cursor1. Trouxa para cá, pois antes apenas verificava se alguma conta da análise em questão estava vinculada a lote de pagamento ou análise, porém, como
	--podemos excluir todas as coparticipações do protocolo, teremos que verificar se qualquer conta presente no protocolo esteja vinculada a lotes de pagto e contábil.
	for r_C02_w in C02(r_C03_w.nr_seq_conta_rec) loop
		if (r_C02_w.nr_seq_lote_pgto IS NOT NULL AND r_C02_w.nr_seq_lote_pgto::text <> '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(445102); -- Não é possível desfazer o fechamento da análise de recurso de glosa, pois existem itens em lote de pagamento.
		end if;

		if (r_C02_w.nr_lote_contabil > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(445103); -- Não é possível desfazer o fechamento da análise de recurso de glosa, pois existem itens em lote contábil.
		end if;
	end loop;

	/*
		Adicionei também para desfazer registros adicionais do recurso quando utilizada geração na liberação para pagamento, pois alguns casos o cliente tem o recurso já liberado para pagamento
		com registros de coparticipação gerados, e ao desfazer fechamento de contas na análise, acabava por não excluir aqueles já gerados(pois ie_gerar_val_adic_w = 'L' e só excluía quando igual a F),
		replicando esses registros ao fechar novamente as contas da análise.
	*/
	if (ie_gerar_val_adic_w in ('F','L')) then
		CALL pls_excluir_val_adic_rec_glo(null, r_C03_w.nr_seq_conta_rec);
	end if;

end loop;

for r_C01_w in C01(nr_seq_analise_p) loop

	update	pls_rec_glosa_conta
	set	ie_status 	= '1',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia 	= r_C01_w.nr_seq_conta_rec;

	CALL pls_gerar_log_rec_glosa( 'DFA', null, r_C01_w.nr_seq_conta_rec, nm_usuario_p, 'C', null, null);

	select	count(1)
	into STRICT	qt_rec_glosa_w
	from	pls_rec_glosa_conta
	where	nr_seq_protocolo = r_C01_w.nr_seq_protocolo
	and	ie_status 	= '2'  LIMIT 1;

	if (qt_rec_glosa_w = 0) then
		update	pls_rec_glosa_protocolo
		set	ie_status 	= '2',
			nm_usuario 	= nm_usuario_p,
			dt_atualizacao 	= clock_timestamp()
		where	nr_sequencia 	= r_C01_w.nr_seq_protocolo;
	end if;

	select	count(1)
	into STRICT	qt_rec_glosa_w
	from	pls_rec_glosa_conta
	where	nr_seq_analise = nr_seq_analise_p
	and	ie_status = '2';

	if (qt_rec_glosa_w = 0) then
		update	pls_analise_conta
		set	ie_status	= 'L',
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp(),
			nm_proc_status	= 'PLS_DESFAZER_FECHAR_REC_GLOSA'
		where	nr_sequencia 	= nr_seq_analise_p;
	end if;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_fechar_rec_glosa ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

