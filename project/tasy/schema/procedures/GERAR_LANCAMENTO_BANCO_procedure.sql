-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lancamento_banco (nr_seq_banco_saldo_p bigint, nm_usuario_p text, ie_commit_p text, ie_opcao_p text, dt_fechamento_p timestamp) AS $body$
DECLARE


/* ie_opcao_p
'MB' - Mensal / Baixa
'ME' - Mensal / Estorno
'DB' - Diario / Baixa
'DE' - Diario / Estorno
*/
dt_vigente_w		timestamp;
nr_seq_conta_banco_w	bigint;
nr_seq_trans_financ_w	bigint;
vl_transacao_w		double precision;
nr_seq_regra_banco_w	bigint;
dt_transacao_w		timestamp;
nr_seq_movto_orig_w	movto_trans_financ.nr_sequencia%type;
ie_estorno_w		varchar(1);
ie_utilizacao_w		regra_lancamento_banco.ie_utilizacao%type;
ie_regra_w		regra_lancamento_banco.ie_regra%type;
vl_saldo_banco_w		banco_saldo.vl_saldo%type;
cd_estabelecimento_w	banco_estabelecimento.cd_estabelecimento%type;
vl_saldo_emprestimo_w	fechamento_banco.vl_saldo_emprestimo%type;
dt_fechamento_w		fechamento_banco.dt_fechamento%type;
cd_moeda_banco_w	banco_estabelecimento.cd_moeda%type;
cd_moeda_empresa_w	moeda.cd_moeda%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_trans_financ,
	a.vl_transacao,
	a.ie_regra
from	regra_lancamento_banco a
where	a.nr_seq_conta_banco			= nr_seq_conta_banco_w
and	coalesce(a.ie_situacao,'A')			= 'A'
and	a.dt_inicio_vigencia			<= dt_vigente_w
and	coalesce(a.dt_fim_vigencia,dt_vigente_w)	>= dt_vigente_w
and	coalesce(a.ie_utilizacao,'M')		= ie_utilizacao_w
order by	a.nr_sequencia;


BEGIN

if (ie_opcao_p in ('MB','ME')) then
	ie_utilizacao_w	:= 'M';
elsif (ie_opcao_p in ('DB','DE')) then
	ie_utilizacao_w	:= 'D';
end if;

dt_vigente_w	:= trunc(clock_timestamp(),'dd');

select	max(a.nr_seq_conta),
	fim_mes(max(a.dt_referencia)),
	max(a.vl_saldo),
	max(a.cd_moeda),
	max(obter_moeda_padrao_empresa(coalesce(b.cd_estabelecimento,coalesce(wheb_usuario_pck.get_cd_estabelecimento,1)),'E'))
into STRICT	nr_seq_conta_banco_w,
	dt_transacao_w,
	vl_saldo_banco_w,
	cd_moeda_banco_w,
	cd_moeda_empresa_w
from	banco_estabelecimento b,
	banco_saldo a
where	a.nr_seq_conta	= b.nr_sequencia
and	a.nr_sequencia	= nr_seq_banco_saldo_p;

if (cd_moeda_empresa_w = coalesce(cd_moeda_banco_w,cd_moeda_empresa_w)) then

	if (ie_utilizacao_w = 'D') then

		dt_transacao_w	:= fim_dia(dt_fechamento_p);

		select	obter_saldo_banco_diario(nr_seq_banco_saldo_p,dt_transacao_w)
		into STRICT	vl_saldo_banco_w
		;

	end if;

	open	c01;
	loop
	fetch	c01 into
		nr_seq_regra_banco_w,
		nr_seq_trans_financ_w,
		vl_transacao_w,
		ie_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		if (ie_regra_w in ('A','P')) then

			vl_transacao_w	:= 0;

			select	max(a.dt_fechamento)
			into STRICT	dt_fechamento_w
			from	fechamento_banco a
			where	a.dt_fechamento		< trunc(dt_transacao_w,'dd')
			and	coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_w,0))	= coalesce(coalesce(cd_estabelecimento_w,a.cd_estabelecimento),0)
			and	a.nr_seq_conta_banco	= nr_seq_conta_banco_w;

			select	max(a.vl_saldo_emprestimo)
			into STRICT	vl_saldo_emprestimo_w
			from	fechamento_banco a
			where	a.dt_fechamento		= dt_fechamento_w
			and	coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_w,0))	= coalesce(coalesce(cd_estabelecimento_w,a.cd_estabelecimento),0)
			and	a.nr_seq_conta_banco	= nr_seq_conta_banco_w;

			/* Empréstimo bancário */

			if (ie_regra_w	= 'A') and
				((coalesce(vl_saldo_banco_w,0) * -1) > coalesce(vl_saldo_emprestimo_w,0)) then

				vl_transacao_w	:= (coalesce(vl_saldo_banco_w,0) * -1) - coalesce(vl_saldo_emprestimo_w,0);

			/* Pagamento de empréstimo bancário */

			elsif (ie_regra_w	= 'P') and (coalesce(vl_saldo_emprestimo_w,0)	> 0) then

				if (coalesce(vl_saldo_banco_w,0) < 0) then

					if	((coalesce(vl_saldo_banco_w,0) * -1) < coalesce(vl_saldo_emprestimo_w,0)) then

						vl_transacao_w	:= coalesce(vl_saldo_emprestimo_w,0) - (coalesce(vl_saldo_banco_w,0) * -1);

					end if;

				else

					vl_transacao_w	:= coalesce(vl_saldo_emprestimo_w,0);

				end if;

			end if;

		end if;

		if (ie_opcao_p in ('ME','DE')) then

			select	max(a.nr_sequencia)
			into STRICT	nr_seq_movto_orig_w
			from	movto_trans_financ a
			where	nr_seq_saldo_banco	= nr_seq_banco_saldo_p
			and	nr_seq_regra_banco	= nr_seq_regra_banco_w
			and	not exists (	SELECT	1
						from	movto_trans_financ x
						where	x.nr_seq_movto_orig = a.nr_sequencia);

			ie_estorno_w	:= 'E';

		else
			nr_seq_movto_orig_w	:= null;
			ie_estorno_w		:= null;
		end if;

		if (ie_opcao_p in ('DE','ME')) then

			vl_transacao_w	:= coalesce(vl_transacao_w,0) * -1;

		end if;

		if	((ie_opcao_p not in ('ME','DE')) or (nr_seq_movto_orig_w IS NOT NULL AND nr_seq_movto_orig_w::text <> '')) and (coalesce(vl_transacao_w,0) <> 0) then

			insert	into movto_trans_financ(dt_atualizacao,
				ds_observacao,
				dt_transacao,
				ie_conciliacao,
				nm_usuario,
				nr_lote_contabil,
				nr_seq_banco,
				nr_seq_regra_banco,
				nr_seq_saldo_banco,
				nr_seq_trans_financ,
				nr_sequencia,
				vl_transacao,
				nr_seq_movto_orig,
				ie_estorno)
			values (clock_timestamp(),
				wheb_mensagem_pck.get_texto(303066,null), --Transação gerada pela regra automática de movimentação do banco (função Cadastros Financeiros)
				dt_transacao_w,
				'N',
				nm_usuario_p,
				0,
				nr_seq_conta_banco_w,
				nr_seq_regra_banco_w,
				nr_seq_banco_saldo_p,
				nr_seq_trans_financ_w,
				nextval('movto_trans_financ_seq'),
				vl_transacao_w,
				nr_seq_movto_orig_w,
				ie_estorno_w);

		end if;

	end	loop;
	close	c01;

	if (coalesce(ie_commit_p,'S')	= 'S') then

		commit;

	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lancamento_banco (nr_seq_banco_saldo_p bigint, nm_usuario_p text, ie_commit_p text, ie_opcao_p text, dt_fechamento_p timestamp) FROM PUBLIC;

