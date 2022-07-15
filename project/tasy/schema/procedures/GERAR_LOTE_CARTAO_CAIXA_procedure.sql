-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lote_cartao_caixa ( nr_seq_lote_cartao_p bigint, dt_baixa_p timestamp, nr_seq_caixa_p bigint, nr_seq_trans_financ_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_acao_p text) AS $body$
DECLARE


/*	ie_acao_p

I	inserindo
E	estornando

*/
nr_seq_saldo_caixa_w	bigint;
vl_lote_w		double precision;
ds_caixa_w		varchar(255);
dt_saldo_w		timestamp;
nr_seq_lote_w		bigint;
nr_seq_novo_lote_w	bigint;
dt_fechamento_lote_w	timestamp;
cont_w			bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_saldo_caixa_w
from	caixa_saldo_diario
where	nr_seq_caixa	= nr_seq_caixa_p
and	coalesce(dt_fechamento::text, '') = '';

if (coalesce(nr_seq_saldo_caixa_w,0) <> 0) then

	select	max(nr_seq_lote),
		max(dt_fechamento_lote),
		count(*)
	into STRICT	nr_seq_lote_w,
		dt_fechamento_lote_w,
		cont_w
	from	movto_trans_financ
	where	nr_seq_caixa		=  nr_seq_caixa_p
	and	(nr_seq_lote IS NOT NULL AND nr_seq_lote::text <> '');

	if (dt_fechamento_lote_w IS NOT NULL AND dt_fechamento_lote_w::text <> '') or (cont_w = 0) then

		nr_seq_novo_lote_w	:= coalesce(nr_seq_lote_w, 0) + 1;

		select	coalesce(sum(a.vl_parcela),0)
		into STRICT	vl_lote_w
		from	movto_cartao_cr_parcela a
		where	a.nr_seq_lote	= nr_seq_lote_cartao_p;

		if (coalesce(ie_acao_p,'I')	= 'E') then
			vl_lote_w	:= coalesce(vl_lote_w,0) * -1;
		end if;

		select	max(dt_saldo)
		into STRICT	dt_saldo_w
		from	caixa_saldo_diario
		where	nr_sequencia	= nr_seq_saldo_caixa_w;

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
			nr_seq_lote_cartao)
		values (clock_timestamp(),
			dt_baixa_p,
			'N',
			nm_usuario_p,
			'0',
			nr_seq_trans_financ_p,
			nextval('movto_trans_financ_seq'),
			vl_lote_w,
			nr_seq_caixa_p,
			nr_seq_saldo_caixa_w,
			nr_seq_novo_lote_w,
			--'Gerado a partir da baixa do lote de cartões ' || nr_seq_lote_cartao_p,
			wheb_mensagem_pck.get_texto(303649,'NR_SEQ_LOTE_CARTAO_P='||nr_seq_lote_cartao_p),
			dt_saldo_w,
			nr_seq_lote_cartao_p);

		CALL atualizar_saldo_caixa(	cd_estabelecimento_p,
					nr_seq_novo_lote_w,
					nr_seq_caixa_p,
					nm_usuario_p,
					'S');
	else
		/* Há um lote aberto, a movimentação não pode ser realizada! */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(244679);
	end if;
else
	ds_caixa_w	:= obter_desc_caixa(nr_seq_caixa_p);
	/* O caixa ds_caixa_w não possui saldo aberto. */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(244680,'DS_CAIXA_W='||ds_caixa_w);
end if;

commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lote_cartao_caixa ( nr_seq_lote_cartao_p bigint, dt_baixa_p timestamp, nr_seq_caixa_p bigint, nr_seq_trans_financ_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_acao_p text) FROM PUBLIC;

