-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_desconto ( nr_seq_cobranca_p bigint, nr_bordero_p bigint, nr_seq_caixa_rec_p bigint, nr_titulo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_trans_fin_baixa_w	titulo_receber.nr_seq_trans_fin_baixa%type;
nr_seq_negociacao_origem_w	titulo_receber.nr_seq_negociacao_origem%type;
nr_seq_trans_financ_w		caixa_receb.nr_seq_trans_financ%type;
nr_seq_trans_rec_neg_caixa_w	parametro_contas_receber.nr_seq_trans_rec_neg_caixa%type;
cd_estabelecimento_w		caixa.cd_estabelecimento%type;
ie_acao_w			transacao_financeira.ie_acao%type;
ie_trans_fin_baixa_titulo_w	varchar(1);
qt_boleto_w			bigint;
qt_deb_cc_w			bigint;
/* Projeto Multimoeda - Variáveis */

vl_estrang_w			double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
ie_moeda_estrang_w		varchar(1) := 'N';


BEGIN

if (nr_seq_cobranca_p IS NOT NULL AND nr_seq_cobranca_p::text <> '') and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	update	titulo_receber_cobr
	set	vl_desconto		= 0,
		cd_centro_custo_desc	 = NULL,
		nr_seq_motivo_desc	 = NULL
	where	nr_seq_cobranca	= nr_seq_cobranca_p
	and	nr_titulo	= nr_titulo_p;

elsif (nr_bordero_p IS NOT NULL AND nr_bordero_p::text <> '') and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	/* Projeto Multimoeda - Busca os dados para verificar se é moeda estrangeira. */

	select	max(vl_abaixar_estrang),
		max(vl_cotacao)
	into STRICT	vl_estrang_w,
		vl_cotacao_w
	from	bordero_tit_rec
	where	nr_bordero = nr_bordero_p
	and	nr_titulo = nr_titulo_p;

	if (coalesce(vl_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
		ie_moeda_estrang_w := 'S';
	else
		ie_moeda_estrang_w := 'N';
	end if;

	update	bordero_tit_rec
	set	vl_abaixar		= coalesce(vl_abaixar,0) + coalesce(vl_desconto,0),
		vl_desconto		= 0,
		cd_centro_custo_desc	 = NULL,
		nr_seq_motivo_desc	 = NULL,
		vl_abaixar_estrang = CASE WHEN coalesce(ie_moeda_estrang_w,'N')='S' THEN (coalesce(vl_abaixar,0) + coalesce(vl_desconto,0)) / vl_cotacao  ELSE null END
	where	nr_bordero	= nr_bordero_p
	and	nr_titulo	= nr_titulo_p;
	/* Projeto Multimoeda - Atualiza o valor complemento quando moeda estrangeira. */

	if (coalesce(ie_moeda_estrang_w,'N') = 'S') then
		update	bordero_tit_rec
		set	vl_complemento	= vl_abaixar - vl_abaixar_estrang
		where	nr_bordero	= nr_bordero_p
		and	nr_titulo	= nr_titulo_p;
	end if;

elsif (nr_seq_caixa_rec_p IS NOT NULL AND nr_seq_caixa_rec_p::text <> '') and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	select	max(a.nr_seq_trans_financ),
		max(c.cd_estabelecimento)
	into STRICT	nr_seq_trans_financ_w,
		cd_estabelecimento_w
	from	caixa c,
		caixa_saldo_diario b,
		caixa_receb a
	where	a.nr_seq_saldo_caixa	= b.nr_sequencia
	and	b.nr_seq_caixa		= c.nr_sequencia
	and	a.nr_sequencia		= nr_seq_caixa_rec_p;

	ie_trans_fin_baixa_titulo_w := obter_param_usuario(813, 153, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_trans_fin_baixa_titulo_w);

	select	max(nr_seq_trans_rec_neg_caixa)
	into STRICT	nr_seq_trans_rec_neg_caixa_w
	from	parametro_contas_receber
	where	cd_estabelecimento	= cd_estabelecimento_w;

	select	max(coalesce(nr_seq_trans_fin_baixa,0)),
		max(coalesce(nr_seq_negociacao_origem,0))
	into STRICT	nr_seq_trans_fin_baixa_w,
		nr_seq_negociacao_origem_w
	from	titulo_receber
	where	nr_titulo	= nr_titulo_p;

	select	count(nr_sequencia)
	into STRICT	qt_boleto_w
	from	negociacao_cr_boleto
	where	nr_titulo	= nr_titulo_p;

	select	count(nr_sequencia)
	into STRICT	qt_deb_cc_w
	from	negociacao_cr_deb_cc
	where	nr_titulo	= nr_titulo_p;

	if (coalesce(nr_seq_trans_fin_baixa_w,0) > 0) and (coalesce(ie_trans_fin_baixa_titulo_w,'N') = 'S') then
		nr_seq_trans_financ_w	:= nr_seq_trans_fin_baixa_w;
	elsif (nr_seq_negociacao_origem_w IS NOT NULL AND nr_seq_negociacao_origem_w::text <> '') or (qt_deb_cc_w > 0) or (qt_boleto_w > 0) then
		nr_seq_trans_financ_w	:= coalesce(nr_seq_trans_rec_neg_caixa_w,nr_seq_trans_financ_w);
	end if;

	select	coalesce(max(a.ie_acao),1)
	into STRICT	ie_acao_w
	from	transacao_financeira a
	where	a.nr_sequencia		= nr_seq_trans_financ_w;

	if (ie_acao_w = 1) then
		/* Projeto Multimoeda - Busca os dados para verificar se é moeda estrangeira. */

		select	max(vl_recebido_estrang),
			max(vl_cotacao)
		into STRICT	vl_estrang_w,
			vl_cotacao_w
		from	titulo_receber_liq
		where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
		and	nr_titulo = nr_titulo_p;

		if (coalesce(vl_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
			ie_moeda_estrang_w := 'S';
		else
			ie_moeda_estrang_w := 'N';
		end if;

		update	titulo_receber_liq
		set	vl_recebido		= coalesce(vl_recebido,0) + coalesce(vl_descontos,0),
			vl_descontos		= 0,
			cd_centro_custo_desc	 = NULL,
			nr_seq_motivo_desc	 = NULL,
			vl_recebido_estrang	= CASE WHEN coalesce(ie_moeda_estrang_w,'N')='S' THEN (coalesce(vl_recebido,0) + coalesce(vl_descontos,0)) / vl_cotacao  ELSE null END
		where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p
		and	nr_titulo		= nr_titulo_p;

		/* Projeto Multimoeda - Atualiza o valor complemento quando moeda estrangeira. */

		if (coalesce(ie_moeda_estrang_w,'N') = 'S') then
			update	titulo_receber_liq
			set	vl_complemento	= vl_recebido - vl_recebido_estrang
			where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
			and	nr_titulo	= nr_titulo_p;
		end if;
	else
		update	titulo_receber_liq
		set	vl_descontos		= 0,
			cd_centro_custo_desc	 = NULL,
			nr_seq_motivo_desc	 = NULL
		where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p
		and	nr_titulo		= nr_titulo_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_desconto ( nr_seq_cobranca_p bigint, nr_bordero_p bigint, nr_seq_caixa_rec_p bigint, nr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;

