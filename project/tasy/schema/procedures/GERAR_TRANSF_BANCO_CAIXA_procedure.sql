-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_transf_banco_caixa (nr_seq_saldo_caixa_p bigint, ds_lista_movto_p text, nm_usuario_p text, dt_transacao_p timestamp, ds_historico_p text) AS $body$
DECLARE


nr_seq_movto_w			bigint;
nr_seq_movto_transf_w	bigint;
vl_transferencia_w		double precision	:= 0;
dt_referencia_saldo_w		timestamp;
nr_seq_caixa_w			bigint;
cont_w				bigint;
dt_fechamento_w			timestamp;
nr_seq_banco_origem_w		bigint;
nr_seq_lote_w			bigint;
cd_estabelecimento_w		smallint;
nr_seq_trans_financ_w		bigint;
vl_transacao_w			double precision;
nr_seq_trans_banco_caixa_w	bigint;
cd_transacao_w			varchar(10);
CD_PESSOA_FISICA_W		varchar(10);
CD_CGC_W			varchar(14);
NR_DOCUMENTO_W			varchar(22);
DS_HISTORICO_W			varchar(255);
NR_SEQ_CHEQUE_CP_W		bigint;
NR_SEQ_TITULO_PAGAR_W		bigint;
CD_TIPO_BAIXA_CPA_W		integer;
NR_SEQ_TITULO_RECEBER_W		bigint;
CD_TIPO_RECEBIMENTO_W		integer;
NR_BORDERO_W			bigint;
NR_BORDERO_REC_W		bigint;
NR_ADIANTAMENTO_W		bigint;
NR_ADIANT_PAGO_W		bigint;
CD_CONTA_CONTABIL_W		varchar(20);	
CD_CENTRO_CUSTO_W		integer;
CD_CONTA_FINANC_W		bigint;
NR_SEQ_NOTA_FISCAL_W		bigint;
NR_INTERNO_CONTA_W		bigint;
NR_SEQ_BANCO_ESCRIT_W		bigint;
NR_SEQ_CONV_RECEB_W		bigint;
NR_SEQ_MOTIVO_DEV_W		bigint;
NR_SEQ_DEPOSITO_W		bigint;
CD_HISTORICO_W			bigint;	
NR_SEQ_MOVTO_CARTAO_W		bigint;
NR_SEQ_COBR_ESCRIT_W		bigint;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_trans_financ
from	movto_trans_financ a
where	' ' || ds_lista_movto_p || ' ' like '% ' || a.nr_sequencia || ' %'
and	(ds_lista_movto_p IS NOT NULL AND ds_lista_movto_p::text <> '')
and	coalesce(a.nr_seq_movto_transf::text, '') = '';


BEGIN

if (coalesce(nr_seq_saldo_caixa_p, 0) = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(248447);
end if;

if (coalesce(ds_lista_movto_p::text, '') = '') then
	--r.aise_application_error(-20011,'Nenhuma movimentacao foi selecionada!');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(248446);
end if;

if (ds_lista_movto_p IS NOT NULL AND ds_lista_movto_p::text <> '') then
	
	/* Obter dados do caixa onde serao lancada(s) a(s) transferencia(s) */

	select	a.dt_saldo,
		a.dt_fechamento,
		a.nr_seq_caixa,
		b.cd_estabelecimento
	into STRICT	dt_referencia_saldo_w,
		dt_fechamento_w,
		nr_seq_caixa_w,
		cd_estabelecimento_w
	from	caixa b,
		caixa_saldo_diario a
	where	a.nr_seq_caixa	= b.nr_sequencia
	and	a.nr_sequencia	= nr_seq_saldo_caixa_p;

	/* Tratamento de erros */

	if (dt_fechamento_w IS NOT NULL AND dt_fechamento_w::text <> '') then
		--r.aise_application_error(-20011,'A transferencia nao pode ser feita pois o saldo esta fechado!');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(248447);
	end if;

	if (trunc(coalesce(dt_transacao_p,clock_timestamp()),'dd') <> trunc(dt_referencia_saldo_w,'dd')) then
		--r.aise_application_error(-20011,'Nao e possivel realizar uma transferencia com data diferente do saldo!');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(248448);
	end if;

	select	count(*)
	into STRICT	cont_w
	from	movto_trans_financ
	where	nr_seq_caixa	= nr_seq_caixa_w
	and	coalesce(dt_fechamento_lote::text, '') = '';
	
	if (cont_w > 0) then
		--r.aise_application_error(-20011,'A transferencia nao pode ser feita pois ha um lote aberto neste caixa!');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(248449);
	end if;

	select	count(*)
	into STRICT	cont_w
	from	caixa_saldo_diario b,
		caixa_receb a
	where	a.nr_seq_saldo_caixa	= b.nr_sequencia 		
	and	b.nr_seq_caixa		= nr_seq_caixa_w
	and	coalesce(a.dt_fechamento::text, '') = ''
	and	coalesce(a.dt_cancelamento::text, '') = '';

	if (cont_w > 0) then
		--r.aise_application_error(-20011,'A transferencia nao pode ser feita pois ha um recebimento em aberto neste caixa!');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(248450);
	end if;


	/* Se tudo ok gera transferencia(s) */




	/* Transferencia entrada */


	/* Deve ser uma transferencia de entrada para cada de saida */

	open c01;
	loop
	fetch c01 into
		nr_seq_movto_w,
		nr_seq_trans_financ_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		select	nextval('movto_trans_financ_seq')
		into STRICT	nr_seq_movto_transf_w
		;
			
		select	coalesce(a.vl_transacao,0),
			a.nr_seq_banco
		into STRICT	vl_transferencia_w,
			nr_seq_banco_origem_w
		from	movto_trans_financ a
		where	a.nr_sequencia	= nr_seq_movto_w;
		
		select	coalesce(max(nr_seq_lote),0) + 1
		into STRICT	nr_seq_lote_w
		from	movto_trans_financ
		where	nr_seq_caixa	= nr_seq_caixa_w;

		select	coalesce(nr_seq_trans_banco_caixa,0)
		into STRICT	nr_seq_trans_banco_caixa_w
		from	transacao_financeira
		where	nr_sequencia	= nr_seq_trans_financ_w;

		if (nr_seq_trans_banco_caixa_w = 0) then
			select	cd_transacao
			into STRICT	cd_transacao_w
			from	transacao_financeira
			where	nr_sequencia	= nr_seq_trans_financ_w;

			/*r.aise_application_error(-20011,'A transacao a ser transferida nao possui transacao de transf. banco para caixa!' || chr(13) ||
						'Verifique o cadastro da transacao cod: ' || cd_transacao_w);*/
			CALL wheb_mensagem_pck.exibir_mensagem_abort(248451,'CD_TRANSACAO_W='||CD_TRANSACAO_W);

		end if;
		
		select	A.CD_PESSOA_FISICA,
			A.CD_CGC,
			A.NR_DOCUMENTO,
			A.DS_HISTORICO,
			A.NR_SEQ_CHEQUE_CP,
			A.NR_SEQ_TITULO_PAGAR,
			A.CD_TIPO_BAIXA_CPA,
			A.NR_SEQ_TITULO_RECEBER,
			A.CD_TIPO_RECEBIMENTO,
			A.NR_BORDERO,
			A.NR_BORDERO_REC,
			A.NR_ADIANTAMENTO,
			A.NR_ADIANT_PAGO,
			A.CD_CONTA_CONTABIL,
			A.CD_CENTRO_CUSTO,
			A.CD_CONTA_FINANC,
			A.NR_SEQ_NOTA_FISCAL,
			A.NR_INTERNO_CONTA,
			A.NR_SEQ_BANCO_ESCRIT,
			A.NR_SEQ_CONV_RECEB,
			A.NR_SEQ_MOTIVO_DEV,
			A.NR_SEQ_DEPOSITO,
			A.CD_HISTORICO,
			A.NR_SEQ_MOVTO_CARTAO,
			A.NR_SEQ_COBR_ESCRIT
		into STRICT	CD_PESSOA_FISICA_W,
			CD_CGC_W,
			NR_DOCUMENTO_W,
			DS_HISTORICO_W,
			NR_SEQ_CHEQUE_CP_W,
			NR_SEQ_TITULO_PAGAR_W,
			CD_TIPO_BAIXA_CPA_W,
			NR_SEQ_TITULO_RECEBER_W,
			CD_TIPO_RECEBIMENTO_W,
			NR_BORDERO_W,
			NR_BORDERO_REC_W,
			NR_ADIANTAMENTO_W,
			NR_ADIANT_PAGO_W,
			CD_CONTA_CONTABIL_W,
			CD_CENTRO_CUSTO_W,
			CD_CONTA_FINANC_W,
			NR_SEQ_NOTA_FISCAL_W,
			NR_INTERNO_CONTA_W,
			NR_SEQ_BANCO_ESCRIT_W,
			NR_SEQ_CONV_RECEB_W,
			NR_SEQ_MOTIVO_DEV_W,
			NR_SEQ_DEPOSITO_W,
			CD_HISTORICO_W,
			NR_SEQ_MOVTO_CARTAO_W,
			NR_SEQ_COBR_ESCRIT_W
		from	MOVTO_TRANS_FINANC A
		where	A.NR_SEQUENCIA	= NR_SEQ_MOVTO_W;

		insert	into	movto_trans_financ(nr_sequencia,
				dt_transacao,
				nr_seq_trans_financ,
				vl_transacao,
				dt_atualizacao,
				nm_usuario,
				nr_seq_banco_od,
				nr_seq_caixa,
				nr_seq_saldo_caixa,
				dt_referencia_saldo,
				nr_lote_contabil,
				ie_conciliacao,
				nr_seq_lote,
				ds_historico,
				CD_PESSOA_FISICA,
				CD_CGC,
				NR_DOCUMENTO,
				NR_SEQ_CHEQUE_CP,
				NR_SEQ_TITULO_PAGAR,
				CD_TIPO_BAIXA_CPA,
				NR_SEQ_TITULO_RECEBER,
				CD_TIPO_RECEBIMENTO,
				NR_BORDERO,
				NR_BORDERO_REC,
				NR_ADIANTAMENTO,
				NR_ADIANT_PAGO,
				CD_CONTA_CONTABIL,
				CD_CENTRO_CUSTO,
				CD_CONTA_FINANC,
				NR_SEQ_NOTA_FISCAL,
				NR_INTERNO_CONTA,
				NR_SEQ_BANCO_ESCRIT,
				NR_SEQ_CONV_RECEB,
				NR_SEQ_MOTIVO_DEV,
				NR_SEQ_DEPOSITO,
				CD_HISTORICO,
				NR_SEQ_MOVTO_CARTAO,
				NR_SEQ_COBR_ESCRIT)
		values (nr_seq_movto_transf_w,
				coalesce(dt_transacao_p,clock_timestamp()),
				nr_seq_trans_banco_caixa_w,
				vl_transferencia_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_banco_origem_w,
				nr_seq_caixa_w,
				nr_seq_saldo_caixa_p,
				dt_referencia_saldo_w,
				0,
				'N',
				nr_seq_lote_w,
				coalesce(ds_historico_p,DS_HISTORICO_W),
				CD_PESSOA_FISICA_W,
				CD_CGC_W,
				NR_DOCUMENTO_W,
				NR_SEQ_CHEQUE_CP_W,
				NR_SEQ_TITULO_PAGAR_W,
				CD_TIPO_BAIXA_CPA_W,
				NR_SEQ_TITULO_RECEBER_W,
				CD_TIPO_RECEBIMENTO_W,
				NR_BORDERO_W,
				NR_BORDERO_REC_W,
				NR_ADIANTAMENTO_W,
				NR_ADIANT_PAGO_W,
				CD_CONTA_CONTABIL_W,
				CD_CENTRO_CUSTO_W,
				CD_CONTA_FINANC_W,
				NR_SEQ_NOTA_FISCAL_W,
				NR_INTERNO_CONTA_W,
				NR_SEQ_BANCO_ESCRIT_W,
				NR_SEQ_CONV_RECEB_W,
				NR_SEQ_MOTIVO_DEV_W,
				NR_SEQ_DEPOSITO_W,
				CD_HISTORICO_W,
				NR_SEQ_MOVTO_CARTAO_W,
				NR_SEQ_COBR_ESCRIT_W);

		/* Marcar movimentacao como transferida */

		update	movto_trans_financ
		set	nr_seq_movto_transf	= nr_seq_movto_transf_w
		where	nr_sequencia		= nr_seq_movto_w
		and	coalesce(nr_seq_movto_transf::text, '') = '';

		CALL atualizar_saldo_caixa(cd_estabelecimento_w,
					nr_seq_lote_w,
					nr_seq_caixa_w,
					nm_usuario_p,
					'N');
							
	end loop;
	close c01;	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_transf_banco_caixa (nr_seq_saldo_caixa_p bigint, ds_lista_movto_p text, nm_usuario_p text, dt_transacao_p timestamp, ds_historico_p text) FROM PUBLIC;

