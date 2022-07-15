-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_movto_adiant_pago (nr_adiantamento_p bigint, nm_usuario_p text, dt_movto_p timestamp) AS $body$
DECLARE


nr_seq_trans_w			bigint;
nr_seq_conta_banco_w		bigint;
vl_saldo_w			double precision;
nr_seq_movto_w			bigint;
nr_lote_contabil_w		bigint;
cd_estabelecimento_w		bigint;
dt_inclusao_w			timestamp;
/* Projeto Multimoeda - Variáveis */

vl_adto_estrang_w		double precision;
vl_complemento_w		double precision;
vl_saldo_estrang_w		double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
cd_moeda_w			integer;


BEGIN

select	nr_seq_conta_banco,
	coalesce(nr_seq_trans_fin,0),
	vl_saldo,
	coalesce(nr_lote_contabil,0),
	cd_estabelecimento,
	dt_adiantamento,
	vl_adto_estrang, -- Busca dados em moeda estrangeira
	vl_saldo_estrang,
	vl_cotacao,
	cd_moeda
into STRICT	nr_seq_conta_banco_w,
	nr_seq_trans_w,
	vl_saldo_w,
	nr_lote_contabil_w,
	cd_estabelecimento_w,
	dt_inclusao_w,
	vl_adto_estrang_w,
	vl_saldo_estrang_w,
	vl_cotacao_w,
	cd_moeda_w
from	adiantamento_pago
where	nr_adiantamento = nr_adiantamento_p;

if (coalesce(nr_seq_conta_banco_w, 0) <> 0) then

	if (nr_seq_trans_w = 0) then
		--r.aise_application_error(-20011, 'Transação do adiantamento não cadastrada!');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(267350);
	end if;

	/* Projeto Multimoeda - Verifica se o adiantamento é em moeda estrangeira, caso positivo calcula os valores,
			caso negativo limpa as variáveis antes de inserir o movimento. */
	if (coalesce(vl_adto_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
		vl_saldo_w := vl_saldo_estrang_w * vl_cotacao_w;
		vl_complemento_w := vl_saldo_w - vl_saldo_estrang_w;
	else
		vl_saldo_estrang_w := null;
		vl_complemento_w := null;
		vl_cotacao_w := null;
		cd_moeda_w := null;
	end if;

	select	nextval('movto_trans_financ_seq')
	into STRICT	nr_seq_movto_w
	;

	insert into movto_trans_financ(nr_sequencia,
					dt_transacao,
					nr_seq_trans_financ,
					vl_transacao,
					dt_atualizacao,
					nm_usuario,
					nr_adiant_pago,
					nr_seq_banco,
					nr_lote_contabil,
					ie_conciliacao,
					vl_transacao_estrang,
					vl_complemento,
					vl_cotacao,
					cd_moeda)
	values (nr_seq_movto_w,
		coalesce(dt_movto_p, dt_inclusao_w),
		nr_seq_trans_w,
		vl_saldo_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_adiantamento_p,
		nr_seq_conta_banco_w,
		nr_lote_contabil_w,
		'N',
		vl_saldo_estrang_w,
		vl_complemento_w,
		vl_cotacao_w,
		cd_moeda_w);

	CALL atualizar_transacao_financeira(cd_estabelecimento_w, nr_seq_movto_w, nm_usuario_p, 'I');

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_movto_adiant_pago (nr_adiantamento_p bigint, nm_usuario_p text, dt_movto_p timestamp) FROM PUBLIC;

