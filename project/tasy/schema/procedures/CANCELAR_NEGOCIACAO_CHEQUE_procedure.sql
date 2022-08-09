-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_negociacao_cheque ( nr_seq_caixa_rec_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
dt_fechamento_w		timestamp;
nr_seq_cheque_w		bigint;
nr_seq_caixa_w		bigint;
nr_seq_lote_w		bigint;
dt_fechamento_saldo_w	timestamp;
dt_cancelamento_w	timestamp;
nr_sequencia_w		bigint;
nr_seq_cheque_neg_w	bigint;

c01 CURSOR FOR 
SELECT	nr_sequencia, 
	nr_seq_cheque 
from	cheque_cr_negociado 
where	nr_seq_caixa_rec = nr_seq_caixa_rec_p;

c02 CURSOR FOR 
SELECT	a.nr_seq_cheque 
from	cheque_cr a 
where	a.nr_seq_caixa_rec	= nr_seq_caixa_rec_p;


BEGIN 
 
-- Edgar 29/01/2008 
lock table movto_trans_financ in exclusive mode;
lock table caixa_receb in exclusive mode;
 
select	dt_fechamento, 
	dt_cancelamento 
into STRICT	dt_fechamento_w, 
	dt_cancelamento_w 
from	caixa_receb 
where	nr_sequencia	= nr_seq_caixa_rec_p;
 
if (dt_cancelamento_w IS NOT NULL AND dt_cancelamento_w::text <> '') then 
	/* Este recebimento já foi cancelado! */
 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(242056);
end if;
 
if (dt_fechamento_w IS NOT NULL AND dt_fechamento_w::text <> '') then 
 
	select	b.nr_seq_caixa, 
		b.dt_fechamento 
	into STRICT	nr_seq_caixa_w, 
		dt_fechamento_saldo_w 
	from	caixa_saldo_diario b, 
		caixa_receb a 
	where	a.nr_seq_saldo_caixa	= b.nr_sequencia 
	and	a.nr_sequencia		= nr_seq_caixa_rec_p;
 
	if (dt_fechamento_saldo_w IS NOT NULL AND dt_fechamento_saldo_w::text <> '') then 
		/* O saldo diário deste recebimento já está fechado! */
 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(242057);
	end if;
 
	select	max(nr_seq_lote) 
	into STRICT	nr_seq_lote_w 
	from	movto_trans_financ 
	where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p;
 
	CALL Estornar_lote_tesouraria(nr_seq_caixa_w, 
				nr_seq_lote_w, 
				nm_usuario_p, 
				'N', 
				null);
 
	open C01;
	loop 
	fetch C01 into 
		nr_sequencia_w, 
		nr_seq_cheque_neg_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		insert into cheque_cr_negociado(nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			nr_seq_caixa_rec, 
			nr_seq_cheque, 
			vl_negociado, 
			vl_desconto, 
			vl_acrescimo, 
			dt_negociacao, 
			nr_seq_trans_financ, 
			vl_terceiro, 
			vl_juros, 
			vl_multa) 
		SELECT	nextval('cheque_cr_negociado_seq'), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nr_seq_caixa_rec_p, 
			nr_seq_cheque, 
			vl_negociado * -1, 
			vl_desconto * -1, 
			vl_acrescimo * -1, 
			dt_negociacao, 
			nr_seq_trans_financ, 
			vl_terceiro * -1, 
			coalesce(vl_juros,0) * - 1, 
			coalesce(vl_multa,0) * - 1 
		from	cheque_cr_negociado 
		where	nr_sequencia	= nr_sequencia_w;
 
		update	cheque_cr 
		set	dt_devolucao	 = NULL, 
			dt_atualizacao	= clock_timestamp(), 
			nm_usuario	= nm_usuario_p, 
			vl_saldo_negociado = NULL 
		where	nr_seq_cheque	= nr_seq_cheque_neg_w;
	end loop;
	close c01;
 
	/* Devolver cheques vinculados */
 
	update	cheque_cr 
	set	dt_devolucao	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp(), 
		vl_saldo_negociado = NULL 
	where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p;
	-- dsantos em 11/02/2010 atualizou o vl_saldo_negociado para nulo quando cancelar negociacao 
 
	/* Cancelar cartões vinculados */
 
	update	movto_cartao_cr 
	set	dt_cancelamento	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp() 
	where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p;
 
	/* Cancelar recebimento de caixa */
 
	update	caixa_receb 
	set	dt_cancelamento	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp() 
	where	nr_sequencia	= nr_seq_caixa_rec_p;
else 
	delete	from	cheque_cr_negociado 
	where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p;
 
	delete	from	movto_trans_financ 
	where	coalesce(nr_seq_lote::text, '') = '' 
	and	nr_seq_caixa_rec	= nr_seq_caixa_rec_p;
 
	delete	from	cheque_cr 
	where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p;
 
	delete	from	movto_cartao_cr_parcela 
	where	nr_seq_movto	in (SELECT	nr_sequencia 
					 from	movto_cartao_cr 
					 where	nr_seq_caixa_rec = nr_seq_caixa_rec_p);
 
	delete	from	movto_cartao_cr 
	where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p;
 
	delete	from	caixa_receb 
	where	nr_sequencia		= nr_seq_caixa_rec_p;
end if;
 
open	c02;
loop 
fetch	c02 into 
	nr_seq_cheque_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	/*A negociação de cheques #@NR_SEQ_CAIXA_REC_P#@, onde o cheque encontra-se, foi cancelada.*/
 
	CALL gerar_cheque_cr_hist(nr_seq_cheque_w,wheb_mensagem_pck.get_texto(305681, 'NR_SEQ_CAIXA_REC_P=' || nr_seq_caixa_rec_p),'N',nm_usuario_p);
 
end	loop;
close	c02;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_negociacao_cheque ( nr_seq_caixa_rec_p bigint, nm_usuario_p text) FROM PUBLIC;
