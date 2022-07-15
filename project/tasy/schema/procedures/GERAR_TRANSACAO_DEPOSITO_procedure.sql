-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_transacao_deposito (nr_seq_deposito_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_aplicacao_w			banco_aplicacao.nr_seq_aplicacao%type;
cd_estabelecimento_w		banco_aplicacao.cd_estabelecimento%type;
nr_seq_trans_fin_dep_w		bigint;
nr_seq_trans_saida_w		transacao_financeira.nr_seq_trans_aplic%type;
dt_deposito_w				timestamp;
nr_seq_conta_bco_dep_w		banco_saldo.nr_seq_conta%type;
nr_seq_conta_bco_resg_w		banco_aplicacao.nr_seq_conta_bco_resg%type;
vl_deposito_w				double precision;
vl_deposito_estrang_w		double precision;
vl_complemento_w			double precision;
vl_cotacao_w				cotacao_moeda.vl_cotacao%type;
cd_moeda_w					cotacao_moeda.cd_moeda%type;
nr_seq_saldo_bco_w			bigint;
nr_seq_saldo_bco_dep_w		banco_saldo.nr_sequencia%type;
dt_referencia_w				timestamp;
ie_saldo_fechado_w			varchar(10);
nr_seq_movto_trans_w		movto_trans_financ.nr_seq_trans_financ%type;
nr_seq_movto_trans_dep_w	movto_trans_financ.nr_seq_trans_financ%type;


BEGIN

-- Busca os dados da aplicacao para gerar as transacoes de entrada e saida do banco
select	a.nr_seq_aplicacao,
	a.cd_estabelecimento,
	a.nr_seq_tran_fin_dep,
	a.dt_deposito,
	a.nr_seq_conta_bco_dep,
	a.vl_deposito,
	a.vl_deposito_estrang,
	a.vl_cotacao,
	a.cd_moeda,
	a.nr_seq_movto_trans_fin,
	b.nr_seq_conta_bco_resg,
	a.nr_seq_movto_tr_fin_dep
into STRICT	nr_seq_aplicacao_w,
	cd_estabelecimento_w,
	nr_seq_trans_fin_dep_w,
	dt_deposito_w,
	nr_seq_conta_bco_dep_w,
	vl_deposito_w,
	vl_deposito_estrang_w,
	vl_cotacao_w,
	cd_moeda_w,
	nr_seq_movto_trans_w,
	nr_seq_conta_bco_resg_w,
	nr_seq_movto_trans_dep_w
from	banco_aplic_deposito a,
	banco_aplicacao b
where	a.nr_seq_aplicacao = b.nr_sequencia
and	a.nr_sequencia = nr_seq_deposito_p;

if (ie_opcao_p = 'I') then

	-- Busca a transacao correspondente para gerar a transacao de saida
	select	max(nr_seq_trans_aplic)
	into STRICT	nr_seq_trans_saida_w
	from	transacao_financeira
	where	nr_sequencia = nr_seq_trans_fin_dep_w;

	if (coalesce(nr_seq_trans_saida_w::text, '') = '') then
		/* Transacao correspondente nao cadastrada para a transacao da aplicacao. */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(354968);
	end if;

	select	max(nr_sequencia),
		max(dt_referencia)
	into STRICT	nr_seq_saldo_bco_dep_w,
		dt_referencia_w
	from	banco_saldo
	where	nr_seq_conta = nr_seq_conta_bco_dep_w
	and	trunc(dt_referencia,'month') = trunc(dt_deposito_w,'month');

	if (coalesce(nr_seq_saldo_bco_dep_w::text, '') = '') then
		/* Nao existe saldo aberto para a conta selecionada na data do deposito. */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1165467);
	end if;

	select	obter_se_banco_fechado(nr_seq_conta_bco_dep_w,dt_referencia_w)
	into STRICT	ie_saldo_fechado_w
	;

	if (coalesce(ie_saldo_fechado_w,'N') = 'S') then
		/* Nao existe saldo aberto para a conta selecionada na data do deposito. */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1165467);
	end if;
	
	select	max(nr_sequencia),
		max(dt_referencia)
	into STRICT	nr_seq_saldo_bco_w,
		dt_referencia_w
	from	banco_saldo
	where	nr_seq_conta = nr_seq_conta_bco_resg_w
	and	trunc(dt_referencia,'month') = trunc(dt_deposito_w,'month');

	if (coalesce(nr_seq_saldo_bco_w::text, '') = '') then
		/* Nao existe saldo aberto para a conta selecionada na data do deposito. */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1165467);
	end if;

	select	obter_se_banco_fechado(nr_seq_conta_bco_resg_w,dt_referencia_w)
	into STRICT	ie_saldo_fechado_w
	;
	if (coalesce(ie_saldo_fechado_w,'N') = 'S') then
		/* Nao existe saldo aberto para a conta selecionada na data do deposito. */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1165467);
	end if;

	/* Projeto Multimoeda - Verifica se a aplicacao e em moeda estrangeira, caso positivo realiza os calculos antes de criar os registros.*/

	if (coalesce(vl_deposito_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
		vl_complemento_w := vl_deposito_w - vl_deposito_estrang_w;
	else
		vl_deposito_estrang_w := null;
		vl_complemento_w := null;
		vl_cotacao_w := null;
	end if;

	begin

	select	nextval('movto_trans_financ_seq')
	into STRICT	nr_seq_movto_trans_w
	;

	-- Saida da conta corrente
	insert into movto_trans_financ(	nr_sequencia,
					cd_estabelecimento,
					nr_seq_trans_financ,
					dt_transacao,
					vl_transacao,
					vl_transacao_estrang,
					vl_complemento,
					vl_cotacao,
					cd_moeda,
					nr_seq_banco,
					nr_seq_saldo_banco,
					nr_seq_aplicacao,
					nr_lote_contabil,
					ie_conciliacao,
					nm_usuario,
					dt_atualizacao)
	values (nr_seq_movto_trans_w,
		cd_estabelecimento_w,
		nr_seq_trans_saida_w,
		dt_deposito_w,
		vl_deposito_w,
		vl_deposito_estrang_w,
		vl_complemento_w,
		vl_cotacao_w,
		cd_moeda_w,
		nr_seq_conta_bco_resg_w,
		nr_seq_saldo_bco_w,
		nr_seq_aplicacao_w,
		0,
		'N',
		nm_usuario_p,
		clock_timestamp());


	select	nextval('movto_trans_financ_seq')
	into STRICT	nr_seq_movto_trans_dep_w
	;

	-- Entrada na conta deposito
	insert into movto_trans_financ(	nr_sequencia,
					cd_estabelecimento,
					nr_seq_trans_financ,
					dt_transacao,
					vl_transacao,
					vl_transacao_estrang,
					vl_complemento,
					vl_cotacao,
					cd_moeda,
					nr_seq_banco,
					nr_seq_saldo_banco,
					nr_seq_aplicacao,
					nr_lote_contabil,
					ie_conciliacao,
					nm_usuario,
					dt_atualizacao,
					nr_seq_movto_transf_bco)
	values (nr_seq_movto_trans_dep_w,
		cd_estabelecimento_w,
		nr_seq_trans_fin_dep_w,
		dt_deposito_w,
		vl_deposito_w,
		vl_deposito_estrang_w,
		vl_complemento_w,
		vl_cotacao_w,
		cd_moeda_w,
		nr_seq_conta_bco_dep_w,
		nr_seq_saldo_bco_dep_w,
		nr_seq_aplicacao_w,
		0,
		'N',
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_movto_trans_w);

	update	banco_aplic_deposito
	set	nr_seq_movto_trans_fin = nr_seq_movto_trans_w,
		nr_seq_movto_tr_fin_dep = nr_seq_movto_trans_dep_w,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_deposito_p;

	end;

elsif (ie_opcao_p = 'E' and (nr_seq_movto_trans_w IS NOT NULL AND nr_seq_movto_trans_w::text <> '') and (nr_seq_movto_trans_dep_w IS NOT NULL AND nr_seq_movto_trans_dep_w::text <> '')) then

	begin

	-- Estorna entrada na conta deposito
	CALL estornar_movto_banco(cd_estabelecimento_w,
				nr_seq_movto_trans_dep_w,
				coalesce(dt_deposito_w,clock_timestamp()),
				nm_usuario_p,
				'N');

	-- Estorna saida na conta corrente
	CALL estornar_movto_banco(cd_estabelecimento_w,
				nr_seq_movto_trans_w,
				coalesce(dt_deposito_w,clock_timestamp()),
				nm_usuario_p,
				'N');
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_transacao_deposito (nr_seq_deposito_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

