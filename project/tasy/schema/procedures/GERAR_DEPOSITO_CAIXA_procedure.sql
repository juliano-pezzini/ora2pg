-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_deposito_caixa ( nr_seq_deposito_p bigint, dt_deposito_p timestamp, nr_Seq_trans_financ_p bigint, nr_seq_caixa_p bigint, nm_usuario_p text) AS $body$
DECLARE


cont_w			bigint;
vl_deposito_w		double precision;
ds_caixa_w		varchar(255);
dt_saldo_w		timestamp;
nr_seq_lote_w		bigint;
nr_seq_novo_lote_w	bigint;
cd_estabelecimento_w	bigint;
nr_seq_saldo_caixa_w	bigint;
dt_fechamento_lote_w	timestamp;
ie_deposito_caixa_w	parametro_contas_receber.ie_deposito_caixa%type;
vl_cheque_w		cheque_cr.vl_cheque%type;
nr_seq_cheque_w		cheque_cr.nr_seq_cheque%type;
nr_seq_caixa_w		caixa_saldo_diario.nr_seq_caixa%type;
cont_w2			bigint;
/* Projeto Multimoeda - Variáveis */

vl_deposito_estrang_w	double precision;
vl_cheque_estrang_w	double precision;
vl_complemento_w	double precision;
vl_cotacao_w		cotacao_moeda.vl_cotacao%type;
cd_moeda_w		integer;

C01 CURSOR FOR
SELECT	b.vl_cheque,
	b.nr_seq_cheque,
	b.nr_seq_saldo_caixa,
	b.nr_seq_caixa_rec,
	b.vl_cheque_estrang,
	c.vl_cotacao,
	c.cd_moeda
from	deposito_cheque a,
	cheque_cr b,
	deposito c
where	a.nr_seq_cheque		= b.nr_seq_cheque
and	a.nr_seq_deposito	= c.nr_sequencia
and	a.nr_seq_deposito	= nr_seq_deposito_p
and obter_status_cheque(b.nr_seq_cheque) not in (3,4,5);


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_saldo_caixa_w
from	caixa_saldo_diario
where	nr_seq_caixa	= nr_seq_caixa_p
and	coalesce(dt_fechamento::text, '') = '';

select	b.cd_estabelecimento,
	b.ie_deposito_caixa
into STRICT	cd_estabelecimento_w,
	ie_deposito_caixa_w
from	parametro_contas_receber b,
	deposito a
where	a.cd_estabelecimento	= b.cd_estabelecimento
and	a.nr_sequencia		= nr_seq_deposito_p;

if (ie_deposito_caixa_w = 'S') and (coalesce(nr_seq_caixa_p::text, '') = '') and (coalesce(nr_seq_saldo_caixa_w,0) = 0) then

	open C01;
	loop
	fetch C01 into
	vl_cheque_w,
	nr_seq_cheque_w,
	nr_seq_saldo_caixa_w,
	nr_seq_caixa_w,
	vl_cheque_estrang_w,
	vl_cotacao_w,
	cd_moeda_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		/*select max(nr_seq_caixa)
		into nr_seq_caixa_w
		from caixa_saldo_diario
		where nr_sequencia = nr_seq_saldo_caixa_w
		and dt_fechamento is null; */
		select	max(b.nr_sequencia)
		into STRICT	nr_seq_caixa_w
		from	caixa b,
			caixa_saldo_diario c,
			caixa_receb a
		where	c.nr_seq_caixa	 	= b.nr_sequencia
		and	a.nr_seq_saldo_caixa	= c.nr_sequencia
		and	a.nr_sequencia		= nr_seq_caixa_w;

		select	max(nr_sequencia)
		into STRICT	nr_seq_saldo_caixa_w
		from	caixa_saldo_diario
		where	nr_seq_caixa	= nr_seq_caixa_w
		and	coalesce(dt_fechamento::text, '') = '';

		select	max(nr_seq_lote),
			max(dt_fechamento_lote),
			count(*)
		into STRICT	nr_seq_lote_w,
			dt_fechamento_lote_w,
			cont_w
		from	movto_trans_financ
		where	nr_seq_caixa	=  nr_seq_caixa_w
		and	(nr_seq_lote IS NOT NULL AND nr_seq_lote::text <> '');

		if (dt_fechamento_lote_w IS NOT NULL AND dt_fechamento_lote_w::text <> '') or (cont_w = 0) then

			nr_seq_novo_lote_w := coalesce(nr_seq_lote_w, 0) + 1;

			select	max(dt_saldo)
			into STRICT	dt_saldo_w
			from	caixa_saldo_diario
			where	nr_sequencia	= nr_seq_saldo_caixa_w;

			/* Projeto Multimoeda - Verifica se o depósito é moeda estrangeira, caso positivo calcula os valores,
					caso contrário limpa as variáveis antes de gravar o movimento.*/
			if (coalesce(vl_cheque_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
				-- Recalcula o valor do cheque aplicando a cotação do depósito.
				vl_cheque_w := vl_cheque_estrang_w * vl_cotacao_w;
				vl_complemento_w := vl_cheque_w - vl_cheque_estrang_w;
			else
				vl_cheque_estrang_w := null;
				vl_complemento_w := null;
				vl_cotacao_w := null;
				cd_moeda_w := null;
			end if;

			insert into movto_trans_financ(nr_sequencia,
				dt_atualizacao,
				dt_transacao,
				ie_conciliacao,
				nm_usuario,
				nr_lote_contabil,
				nr_seq_trans_financ,
				vl_transacao,
				nr_seq_caixa,
				nr_seq_saldo_caixa,
				nr_seq_lote,
				ds_observacao,
				dt_referencia_saldo,
				nr_seq_deposito,
				nr_seq_cheque,
				vl_transacao_estrang,
				vl_complemento,
				vl_cotacao,
				cd_moeda)
			values	(nextval('movto_trans_financ_seq'),
				clock_timestamp(),
				dt_deposito_p,
				'N',
				nm_usuario_p,
				'0',
				nr_seq_trans_financ_p,
				vl_cheque_w,
				nr_seq_caixa_w,
				nr_seq_saldo_caixa_w,
				nr_seq_novo_lote_w,
				wheb_mensagem_pck.get_texto(738525, 'NR_SEQ_DEPOSITO_W=' || nr_seq_deposito_p),	--'Gerado a partir da baixa do depósito ' || nr_seq_deposito_p,
				dt_saldo_w,
				nr_seq_deposito_p,
				nr_seq_cheque_w,
				vl_cheque_estrang_w,
				vl_complemento_w,
				vl_cotacao_w,
				cd_moeda_w);

			CALL atualizar_saldo_caixa(	cd_estabelecimento_w,
						nr_seq_novo_lote_w,
						nr_seq_caixa_w,
						nm_usuario_p,
						'S');
		else
			CALL wheb_mensagem_pck.exibir_mensagem_abort(265487,'');
			--Há um lote aberto, a movimentação não pode ser realizada!
		end if;
		end;
	end loop;
	close C01;
elsif (coalesce(nr_seq_saldo_caixa_w,0) <> 0) then

	select	a.vl_especie + a.vl_cheque,
		coalesce(a.vl_especie_estrang,0) + coalesce(a.vl_cheque_estrang,0),
		a.vl_cotacao,
		a.cd_moeda
	into STRICT	vl_deposito_w,
		vl_deposito_estrang_w,
		vl_cotacao_w,
		cd_moeda_w
	from	deposito a
	where	a.nr_sequencia		= nr_seq_deposito_p;

	select	max(nr_seq_lote),
		max(dt_fechamento_lote),
		count(*)
	into STRICT	nr_seq_lote_w,
		dt_fechamento_lote_w,
		cont_w
	from	movto_trans_financ
	where	nr_seq_caixa		= nr_seq_caixa_p
	and	(nr_seq_lote IS NOT NULL AND nr_seq_lote::text <> '');

	select	count(*)
	into STRICT	cont_w2
	from	movto_trans_financ
	where	nr_seq_caixa		= nr_seq_caixa_p
	and	nr_seq_deposito 	= nr_seq_deposito_p;

	if (coalesce(cont_w2, 0) = 0) then
		if (dt_fechamento_lote_w IS NOT NULL AND dt_fechamento_lote_w::text <> '') or (cont_w = 0) then

			nr_seq_novo_lote_w := coalesce(nr_seq_lote_w, 0) + 1;

			select	max(dt_saldo)
			into STRICT	dt_saldo_w
			from	caixa_saldo_diario
			where	nr_sequencia	= nr_seq_saldo_caixa_w;

			/* Projeto Multimoeda - Verifica se o depósito é moeda estrangeira, caso positivo calcula o complemento,
					caso contrário limpa as variáveis antes de gravar o movimento.*/
			if (coalesce(vl_deposito_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
				vl_complemento_w := vl_deposito_w - vl_deposito_estrang_w;
			else
				vl_deposito_estrang_w := null;
				vl_complemento_w := null;
				vl_cotacao_w := null;
				cd_moeda_w := null;
			end if;

			insert into movto_trans_financ(dt_atualizacao,
				dt_transacao,
				ie_conciliacao,
				nm_usuario,
				nr_lote_contabil,
				nr_seq_trans_financ,
				nr_sequencia,
				vl_transacao,
				nr_seq_caixa,
				nr_seq_saldo_caixa,
				nr_seq_lote,
				ds_observacao,
				dt_referencia_saldo,
				nr_seq_deposito,
				vl_transacao_estrang,
				vl_complemento,
				vl_cotacao,
				cd_moeda)
			values	(clock_timestamp(),
				dt_deposito_p,
				'N',
				nm_usuario_p,
				'0',
				nr_seq_trans_financ_p,
				nextval('movto_trans_financ_seq'),
				vl_deposito_w,
				nr_seq_caixa_p,
				nr_seq_saldo_caixa_w,
				nr_seq_novo_lote_w,
				wheb_mensagem_pck.get_texto(738525, 'NR_SEQ_DEPOSITO_W=' || nr_seq_deposito_p),	--'Gerado a partir da baixa do depósito ' || nr_seq_deposito_p,
				dt_saldo_w,
				nr_seq_deposito_p,
				vl_deposito_estrang_w,
				vl_complemento_w,
				vl_cotacao_w,
				cd_moeda_w);

			CALL atualizar_saldo_caixa(	cd_estabelecimento_w,
						nr_seq_novo_lote_w,
						nr_seq_caixa_p,
						nm_usuario_p,
						'S');
		else
			CALL wheb_mensagem_pck.exibir_mensagem_abort(265487,'');
			--Há um lote aberto, a movimentação não pode ser realizada!
		end if;
	end if;
else
	ds_caixa_w	:= obter_desc_caixa(nr_seq_caixa_p);
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265488,'DS_CAIXA= '||ds_caixa_w);
	--O caixa || ds_caixa_w || não possui saldo aberto.
end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_deposito_caixa ( nr_seq_deposito_p bigint, dt_deposito_p timestamp, nr_Seq_trans_financ_p bigint, nr_seq_caixa_p bigint, nm_usuario_p text) FROM PUBLIC;
