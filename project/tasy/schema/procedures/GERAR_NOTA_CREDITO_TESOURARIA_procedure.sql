-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nota_credito_tesouraria (nr_titulo_p bigint, nr_seq_baixa_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_pagador_p bigint, dt_baixa_p timestamp, vl_transacao_p bigint, ie_acao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_saldo_nota_w			double precision;
nr_seq_nota_credito_w		bigint;
ds_observacao_w			nota_credito.ds_observacao%type;
/* Projeto Multimoeda - Variáveis */

vl_transacao_estrang_w		double precision;
vl_complemento_w		double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
cd_moeda_w			integer;


BEGIN

if (ie_acao_p = 'I') then
	/* Projeto Multimoeda - Busca os dados da baixa para verificar se é moeda estrangeira */

	select	max(vl_recebido_estrang),
		max(vl_cotacao),
		max(cd_moeda)
	into STRICT	vl_transacao_estrang_w,
		vl_cotacao_w,
		cd_moeda_w
	from	titulo_receber_liq
	where	nr_titulo = nr_titulo_p
	and	nr_sequencia = nr_seq_baixa_p;
	/* Verifica se a baixa é em moeda estrangeria, caso positivo calcula os valores antes de gravar a nota */

	if (coalesce(vl_transacao_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
		vl_complemento_w := vl_transacao_p - vl_transacao_estrang_w;
	else
		vl_transacao_estrang_w := null;
		vl_complemento_w := null;
		vl_cotacao_w := null;
		cd_moeda_w := null;
	end if;

	select	nextval('nota_credito_seq')
	into STRICT	nr_seq_nota_credito_w
	;
	ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(303052),1,4000);

	insert into nota_credito(nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		vl_nota_credito,
		cd_pessoa_fisica,
		cd_cgc,
		nr_seq_pagador_aprop,
		dt_nota_credito,
		dt_vencimento,
		tx_juros,
		tx_multa,
		cd_tipo_taxa_juro,
		cd_tipo_taxa_multa,
		ie_origem,
		vl_saldo,
		nr_lote_contabil,
		ds_observacao,
		ie_situacao,
		nr_titulo_receber,
		nr_seq_baixa_origem,
		vl_nota_cred_estrang,
		vl_complemento,
		vl_cotacao,
		cd_moeda)
	values (nr_seq_nota_credito_w,
		cd_estabelecimento_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		vl_transacao_p,
		cd_pessoa_fisica_p,
		cd_cgc_p,
		nr_seq_pagador_p,
		dt_baixa_p,
		null,
		null,
		null,
		null,
		null,
		'M',
		vl_transacao_p,
		null,
		ds_observacao_w,
		'A',
		nr_titulo_p,
		nr_seq_baixa_p,
		vl_transacao_estrang_w,
		vl_complemento_w,
		vl_cotacao_w,
		cd_moeda_w);

	insert	into titulo_receber_nc(dt_atualizacao,
		nm_usuario,
		nr_seq_nota_credito,
		nr_sequencia,
		nr_titulo_rec,
		vl_nota_credito,
		nr_seq_liq)
	values (clock_timestamp(),
		nm_usuario_p,
		nr_seq_nota_credito_w,
		nextval('titulo_receber_nc_seq'),
		nr_titulo_p,
		vl_transacao_p,
		nr_seq_baixa_p);
else
	select	max(nr_sequencia)
	into STRICT	nr_seq_nota_credito_w
	from	nota_credito a
	where	a.nr_titulo_receber	= nr_titulo_p
	and	a.nr_seq_baixa_origem	= nr_seq_baixa_p
	and	a.ie_situacao		<> 'C';

	if (nr_seq_nota_credito_w IS NOT NULL AND nr_seq_nota_credito_w::text <> '') then
		select	vl_saldo,
			vl_nota_cred_estrang,
			vl_cotacao,
			cd_moeda
		into STRICT	vl_saldo_nota_w,
			vl_transacao_estrang_w,
			vl_cotacao_w,
			cd_moeda_w
		from	nota_credito a
		where	a.nr_sequencia	= nr_seq_nota_credito_w;

		/* Projeto Multimoeda - Verifica se a nota de crédito é em moeda estrangeira, caso positivo calcula os valores antes de gravar a baixa */

		if (coalesce(vl_transacao_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
			vl_transacao_estrang_w := coalesce(vl_saldo_nota_w,0) / vl_cotacao_w;
			vl_complemento_w := vl_saldo_nota_w - vl_transacao_estrang_w;
		else
			vl_transacao_estrang_w := null;
			vl_complemento_w := null;
			vl_cotacao_w := null;
			cd_moeda_w := null;
		end if;

		insert into nota_credito_baixa(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_nota_credito,
			dt_baixa,
			vl_baixa,
			ie_cancelamento,
			vl_baixa_estrang,
			vl_complemento,
			vl_cotacao,
			cd_moeda)
		values (nextval('nota_credito_baixa_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_nota_credito_w,
			coalesce(dt_baixa_p,clock_timestamp()),
			vl_saldo_nota_w,
			'S',
			vl_transacao_estrang_w,
			vl_complemento_w,
			vl_cotacao_w,
			cd_moeda_w);

		delete	from titulo_receber_nc
		where	nr_seq_nota_credito	= nr_seq_nota_credito_w
		and	nr_titulo_rec		= nr_titulo_p;

		CALL atualizar_saldo_nota_credito(nr_seq_nota_credito_w,nm_usuario_p);
	end if;
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nota_credito_tesouraria (nr_titulo_p bigint, nr_seq_baixa_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_pagador_p bigint, dt_baixa_p timestamp, vl_transacao_p bigint, ie_acao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

