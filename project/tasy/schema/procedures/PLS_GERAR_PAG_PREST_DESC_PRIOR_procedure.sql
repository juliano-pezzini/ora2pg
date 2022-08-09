-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_pag_prest_desc_prior ( nr_seq_vencimento_p bigint, nr_seq_prestador_p bigint, nr_seq_pagamento_p bigint, vl_vencimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar os valores de desconto conforme o tipo de geração destes valores
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
	Utilizada no lugar da pls_pag_prest_desc_prior
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_saldo_negativo_w		varchar(255);
ie_saldo_negativo_conf_w	varchar(255);
ie_tipo_valor_w			varchar(3);
vl_item_w			double precision;
vl_descontar_w			double precision;
vl_vencimento_w			double precision;
vl_producao_w			double precision;
vl_pagamento_item_w		double precision;
nr_seq_evento_w			bigint;
dt_mes_competencia_w		pls_lote_pagamento.dt_mes_competencia%type;
qt_pag_negativo_max_w		pls_prestador_pagto.qt_pag_negativo_max%type;
qt_pag_negativo_ant_w		bigint;
ie_gerar_titulo_w		varchar(255);
ds_observacao_w			pls_pag_prest_venc_valor.ds_observacao%type;
nr_seq_lote_w			pls_lote_pagamento.nr_sequencia%type;
dt_ultima_ger_tit_w		pls_lote_pagamento.dt_geracao_titulos%type;
ie_trib_saldo_tit_nf_w		parametros_contas_pagar.ie_trib_saldo_tit_nf%type;
vl_trib_acum_w			double precision;
dt_mes_competencia_ww		pls_lote_pagamento.dt_mes_competencia%type;
nr_fluxo_pgto_w			pls_periodo_pagamento.nr_fluxo_pgto%type;
vl_minimo_tit_liq_w		pls_prestador_pagto.vl_minimo_tit_liq%type := 0;
nr_seq_evento_movto_w		pls_evento_movimento.nr_sequencia%type;
ie_excecao_pag_negativo_w	pls_prestador_pagto.ie_excecao_pag_negativo%type;
nr_seq_prestador_pagto_w	pls_prestador_pagto.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	sum(a.vl_item),
		b.nr_sequencia,
		coalesce(b.ie_saldo_negativo, 'CP')
	from	pls_evento		b,
		pls_pagamento_item 	a
	where	b.nr_sequencia 		= a.nr_seq_evento
	and	a.nr_seq_pagamento 	= nr_seq_pagamento_p
	group by
		b.nr_sequencia,
		b.ie_saldo_negativo,
		a.nr_prior_desc
	having sum(vl_item) < 0
	order by
		coalesce(a.nr_prior_desc, 0);

C02 CURSOR FOR
	SELECT	distinct nr_seq_lote,
		dt_mes_competencia,
		nr_fluxo_pgto
	from	(SELECT	b.nr_sequencia nr_seq_lote,
			b.dt_mes_competencia dt_mes_competencia,
			a.nr_fluxo_pgto nr_fluxo_pgto
		from	pls_periodo_pagamento 	a,
			pls_pagamento_prestador c,
			pls_lote_pagamento	b
		where	b.nr_sequencia		= c.nr_seq_lote
		and	b.nr_seq_periodo	= a.nr_sequencia
		and	coalesce(c.ie_cancelamento::text, '') = ''
		and	(b.dt_fechamento IS NOT NULL AND b.dt_fechamento::text <> '')
		and	b.nr_sequencia		<> nr_seq_lote_w
		and	b.dt_mes_competencia	<= dt_mes_competencia_w
		and	c.nr_seq_prestador	= nr_seq_prestador_p
		and (b.dt_mes_competencia	> dt_ultima_ger_tit_w or coalesce(dt_ultima_ger_tit_w::text, '') = '')
		and	coalesce(a.ie_complementar,'N') <> 'S'
		and	((ie_excecao_pag_negativo_w = 'N') or
			((ie_excecao_pag_negativo_w = 'S') and
			not exists (	select	1
					from	pls_regra_pag_neg_max_exec 	z
					where	z.nr_seq_prest_pagto		= nr_seq_prestador_pagto_w
					and	z.nr_seq_periodo		= a.nr_sequencia)))
		order by b.dt_mes_competencia desc, a.nr_fluxo_pgto desc) alias10 ORDER by dt_mes_competencia desc,
		nr_fluxo_pgto desc LIMIT (qt_pag_negativo_max_w);

BEGIN
vl_vencimento_w	:= vl_vencimento_p;

if (vl_vencimento_w <= 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_prestador_pagto_w
	from	pls_prestador_pagto
	where	nr_seq_prestador = nr_seq_prestador_p;

	select	coalesce(max(ie_saldo_negativo),'CP'),
		coalesce(max(qt_pag_negativo_max),0),
		coalesce(max(vl_minimo_tit_liq),0),
		coalesce(max(ie_excecao_pag_negativo),'N')
	into STRICT	ie_saldo_negativo_conf_w,
		qt_pag_negativo_max_w,
		vl_minimo_tit_liq_w,
		ie_excecao_pag_negativo_w
	from	pls_prestador_pagto
	where	nr_sequencia = nr_seq_prestador_pagto_w;

	if (ie_saldo_negativo_conf_w = 'CP') then
		select	coalesce(max(ie_saldo_negativo), 'PP')
		into STRICT	ie_saldo_negativo_conf_w
		from	pls_parametro_pagamento
		where	cd_estabelecimento = cd_estabelecimento_p;
	end if;

	select	max(a.nr_seq_lote),
		max(b.dt_mes_competencia)
	into STRICT	nr_seq_lote_w,
		dt_mes_competencia_w
	from	pls_lote_pagamento b,
		pls_pagamento_prestador a
	where	a.nr_seq_lote	= b.nr_sequencia
	and	a.nr_sequencia	= nr_seq_pagamento_p;

	select	sum(vl_item)
	into STRICT	vl_producao_w
	from	pls_pagamento_item a
	where	a.nr_seq_pagamento 	= nr_seq_pagamento_p;

	begin
	select	coalesce(ie_trib_saldo_tit_nf,'N')
	into STRICT	ie_trib_saldo_tit_nf_w
	from	parametros_contas_pagar
	where	cd_estabelecimento	= cd_estabelecimento_p;
	exception
	when others then
		ie_trib_saldo_tit_nf_w := 'N';
	end;

	vl_trib_acum_w := 0;
	if (ie_trib_saldo_tit_nf_w = 'S') then
		select	coalesce(sum(a.vl_imposto),0)
		into STRICT	vl_trib_acum_w
		from	tributo b,
			pls_pag_prest_venc_trib a
		where	a.cd_tributo		= b.cd_tributo
		and	a.ie_pago_prev	 	= 'V'
		and	a.nr_seq_vencimento 	= nr_seq_vencimento_p
		and	coalesce(b.ie_saldo_tit_pagar,'S')	= 'S';
	else
		select	coalesce(sum(CASE WHEN b.ie_soma_diminui='D' THEN  a.vl_imposto WHEN b.ie_soma_diminui='S' THEN  a.vl_imposto * -1  ELSE 0 END ),0)
		into STRICT	vl_trib_acum_w
		from	tributo b,
			pls_pag_prest_venc_trib a
		where	a.cd_tributo		= b.cd_tributo
		and	a.ie_pago_prev	 	= 'V'
		and	a.nr_seq_vencimento 	= nr_seq_vencimento_p;
	end if;

	open C01;
	loop
	fetch C01 into
		vl_item_w,
		nr_seq_evento_w,
		ie_saldo_negativo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_observacao_w	:= '';

		if (ie_saldo_negativo_w = 'CP') then
			ie_saldo_negativo_w	:= ie_saldo_negativo_conf_w;
		end if;

		if (vl_item_w > vl_vencimento_w) then
			vl_descontar_w	:= vl_item_w;
			vl_vencimento_w	:= vl_vencimento_w - vl_item_w;
		else
			select	CASE WHEN ie_saldo_negativo_w='AT' THEN  vl_item_w  ELSE vl_vencimento_w END
			into STRICT	vl_descontar_w
			;

			select	CASE WHEN ie_saldo_negativo_w='AT' THEN  vl_vencimento_w  ELSE 0 END
			into STRICT	vl_vencimento_w
			;
		end if;

		if (vl_vencimento_w > 0) and (ie_saldo_negativo_w <> 'AT') then
			vl_descontar_w	:= 0;
		end if;

		if (ie_saldo_negativo_w = 'TR') then
			vl_producao_w := vl_producao_w - abs(vl_descontar_w) - vl_trib_acum_w;

			if (vl_producao_w >= 0) then
				ie_saldo_negativo_w := 'PP';
			end if;
		end if;

		if (vl_descontar_w <> 0) then

			if (qt_pag_negativo_max_w > 0) then
				ie_gerar_titulo_w		:= 'S';
				qt_pag_negativo_ant_w		:= 0;

				begin
					select	max(b.dt_geracao_titulos)
					into STRICT	dt_ultima_ger_tit_w
					from	pls_pag_prest_vencimento	d,
						pls_periodo_pagamento 		a,
						pls_pagamento_prestador 	c,
						pls_lote_pagamento		b
					where	c.nr_sequencia		= d.nr_seq_pag_prestador
					and	b.nr_sequencia		= c.nr_seq_lote
					and	b.nr_seq_periodo	= a.nr_sequencia
					and	b.nr_sequencia		<> nr_seq_lote_w
					and	b.dt_mes_competencia	<= dt_mes_competencia_w
					and	c.nr_seq_prestador	= nr_seq_prestador_p
					and	coalesce(a.ie_complementar,'N') <> 'S'
					and	(d.nr_titulo_receber IS NOT NULL AND d.nr_titulo_receber::text <> '')
					and	coalesce(c.ie_cancelamento::text, '') = ''
					and	(b.dt_fechamento IS NOT NULL AND b.dt_fechamento::text <> '');
				exception
					when others then
					dt_ultima_ger_tit_w := null;
				end;

				open C02;
				loop
				fetch C02 into
					nr_seq_lote_w,
					dt_mes_competencia_ww,
					nr_fluxo_pgto_w;
				EXIT WHEN NOT FOUND or ie_gerar_titulo_w = 'N';  /* apply on C02 */

					select	coalesce(sum(vl_item),0)
					into STRICT 	vl_pagamento_item_w
					from	pls_pagamento_item	b,
						pls_pagamento_prestador	a
					where	a.nr_sequencia		= b.nr_seq_pagamento
					and	a.nr_seq_lote 		= nr_seq_lote_w
					and	a.nr_seq_prestador 	= nr_seq_prestador_p;

					if (vl_pagamento_item_w > 0) then
						ie_gerar_titulo_w	:= 'N';
					else
						qt_pag_negativo_ant_w	:= qt_pag_negativo_ant_w + 1;
					end if;

				end loop;
				close C02;

				if	(qt_pag_negativo_ant_w >= qt_pag_negativo_max_w AND ie_gerar_titulo_w = 'S') and
					((vl_minimo_tit_liq_w = 0) or ((vl_minimo_tit_liq_w > 0) and (abs(vl_descontar_w) >= vl_minimo_tit_liq_w))) then
					ie_saldo_negativo_w	:= 'TR'; -- Gerar título receber
					ds_observacao_w		:= 'Este valor negativo gerou título a receber porque este prestador já excedeu ' || to_char(qt_pag_negativo_max_w) ||
								' pagamento(s) negativos anteriores.' || chr(13) || chr(10) ||
								'Em caso de dúvida verifique a função OPS - Prestadores\Dados complementares\Dados para pagamento.';
				end if;
			end if;

			select	max(b.nr_sequencia)
			into STRICT	nr_seq_evento_movto_w
			from	pls_evento_movimento		b,
				pls_lote_evento			a
			where	a.nr_sequencia			= b.nr_seq_lote
			and	b.nr_seq_prestador		= nr_seq_prestador_p
			and	a.nr_seq_lote_pgto_apropr	= nr_seq_lote_w
			and	coalesce(b.ie_cancelamento::text, '') = '';

			insert into pls_pag_prest_venc_valor(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_tipo_valor,
				nr_seq_evento,
				nr_seq_vencimento,
				vl_vencimento,
				ds_observacao,
				nr_seq_evento_movto)
			values (nextval('pls_pag_prest_venc_valor_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				ie_saldo_negativo_w,
				nr_seq_evento_w,
				nr_seq_vencimento_p,
				vl_descontar_w,
				ds_observacao_w,
				nr_seq_evento_movto_w);
		end if;
		end;
	end loop;
	close C01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_pag_prest_desc_prior ( nr_seq_vencimento_p bigint, nr_seq_prestador_p bigint, nr_seq_pagamento_p bigint, vl_vencimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
