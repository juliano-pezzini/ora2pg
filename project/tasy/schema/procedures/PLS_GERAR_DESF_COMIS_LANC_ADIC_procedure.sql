-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_desf_comis_lanc_adic ( nr_seq_vendedor_p bigint, nr_seq_comissao_p bigint, dt_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ie_opcao_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Adicionar ou apagar os lançamentos adicionais das comissões.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
Uma determinada comissão só poderá ser desfeita se não houverem lançamentos originados desta
comissão já cobrados em outra comissão ou repasse.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* ie_opcao_p:
	'G'	= Gerar lote comissão
	'D'	= Desfazer lote comissão
*/
/* Campos referente ao cursor 1 */

nr_titulo_w			titulo_receber.nr_titulo%type;

/* Campos referente ao cursor 2 */

vl_descontos_w			titulo_receber_liq.vl_descontos%type;

/* Campos referente ao cursor 3 e 4 */

vl_lancamento_antec_w		double precision;
ds_observacao_w			pls_vendedor_lanc.ds_observacao%type;

/* Campos referente ao cursor 5 */

vl_alteracao_w			alteracao_valor.vl_alteracao%type;

dt_referencia_w			timestamp;
nr_seq_regra_vl_max_w		bigint;
vl_maximo_w			double precision;
ie_cobranca_futura_w		varchar(1);
vl_comissao_w			double precision;
vl_lancamento_w			double precision;
nr_seq_repasse_lanc_w		bigint;
nr_seq_repasse_cobrado_w	bigint;
nr_seq_comissao_cobrada_w	bigint;
nr_seq_lote_w			bigint;
nr_seq_lote_cobrado_w		bigint;
vl_item_mensalidade_w		pls_comissao_benef_item.vl_item_mensalidade%type;
vl_comissao_tit_w		pls_comissao_benef_item.vl_comissao%type;
vl_descontos_aplic_w		titulo_receber_liq.vl_descontos%type;
vl_alteracao_aplic_w		alteracao_valor.vl_alteracao%type;
ie_repasse_sem_liq_tit_w	funcao_parametro.vl_parametro%type;

ie_gerar_desconto_tit_w		pls_parametros.ie_gerar_desconto_tit_repasse%type;
ie_tipo_desconto_tit_w		pls_parametros.ie_tipo_desconto_tit_repasse%type;
ie_valor_percent_desconto_w	pls_parametros.ie_valor_percent_desconto%type;

C01 CURSOR FOR
	SELECT	distinct c.nr_titulo,
			c.ie_situacao
	from	pls_comissao_beneficiario	a,
		pls_mensalidade_segurado	b,
		titulo_receber			c
	where	a.nr_seq_segurado_mens 	= b.nr_sequencia
	and	b.nr_seq_mensalidade 	= c.nr_seq_mensalidade
	and	a.nr_seq_comissao 	= nr_seq_comissao_p;

C02 CURSOR(nr_titulo_pc		titulo_receber.nr_titulo%type) FOR
	SELECT	sum(vl_descontos)
	from	titulo_receber_liq	a
	where	a.nr_titulo 		= nr_titulo_pc;

C03 CURSOR FOR
	SELECT	vl_lancamento,
		ds_observacao
	from	pls_vendedor_lanc
	where	nr_seq_vendedor = nr_seq_vendedor_p
	and	coalesce(nr_seq_comissao::text, '') = ''
	and	coalesce(nr_seq_repasse::text, '') = ''
	and 	ie_origem_lancamento <> 'M';

C04 CURSOR FOR
	SELECT	vl_lancamento,
		ds_observacao
	from	pls_vendedor_lanc
	where	nr_seq_vendedor = nr_seq_vendedor_p
	and	coalesce(nr_seq_comissao::text, '') = ''
	and	coalesce(nr_seq_repasse::text, '') = ''
	and 	trunc(dt_lancamento,'month') = trunc(dt_referencia_p, 'month')
	and 	ie_origem_lancamento = 'M';

C05 CURSOR(nr_titulo_pc		titulo_receber.nr_titulo%type) FOR
	SELECT	sum(vl_alteracao)
	from	alteracao_valor		a
	where	a.nr_titulo 		= nr_titulo_pc
	and	a.ie_aumenta_diminui	= 'D'
	and	trunc(a.dt_alteracao,'month') <= trunc(dt_referencia_p, 'month');

BEGIN
if (ie_opcao_p = 'G') then
	select	coalesce(ie_gerar_desconto_tit_repasse,'N'),
		coalesce(ie_tipo_desconto_tit_repasse,'A'),
		coalesce(ie_valor_percent_desconto,'V')
	into STRICT	ie_gerar_desconto_tit_w,
		ie_tipo_desconto_tit_w,
		ie_valor_percent_desconto_w
	from	pls_parametros
	where	cd_estabelecimento = cd_estabelecimento_p;

	select	vl_comissao_canal
	into STRICT	vl_comissao_w
	from	pls_comissao
	where	nr_sequencia = nr_seq_comissao_p;

	ie_repasse_sem_liq_tit_w := obter_valor_param_usuario(1206, 16, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p);

	vl_comissao_w := coalesce(vl_comissao_w,0);

	open C03;
	loop
	fetch C03 into
		vl_lancamento_antec_w,
		ds_observacao_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		if (coalesce(vl_lancamento_antec_w,0) > 0) then
			update	pls_vendedor_lanc
			set	nr_seq_comissao	= nr_seq_comissao_p,
				dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				dt_lancamento	= dt_referencia_p
			where	nr_seq_vendedor = nr_seq_vendedor_p
			and	coalesce(nr_seq_comissao::text, '') = ''
			and	coalesce(nr_seq_repasse::text, '') = ''
			and 	ie_origem_lancamento <> 'M';

			insert into pls_repasse_lanc(	nr_sequencia, nr_seq_comissao, vl_lancamento, vl_lanc_aplicado,
						dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ie_tipo_lancamento,
						nr_seq_regra, nr_seq_lancamento_vend, ds_observacao )
				values (	nextval('pls_repasse_lanc_seq'), nr_seq_comissao_p, vl_lancamento_antec_w, vl_lancamento_antec_w,
						clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, '2', -- ie_tipo_lancamento = 2 = Lançamento adicional referente ao valor de repasse excedente
						null, null, ds_observacao_w );

			vl_comissao_w := vl_comissao_w + vl_lancamento_antec_w;
		end if;
		end;
	end loop;
	close C03;

	open C04;
	loop
	fetch C04 into
		vl_lancamento_antec_w,
		ds_observacao_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		if (coalesce(vl_lancamento_antec_w,0) <> 0) then
			update	pls_vendedor_lanc
			set	nr_seq_comissao	= nr_seq_comissao_p,
				dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_seq_vendedor = nr_seq_vendedor_p
			and	coalesce(nr_seq_comissao::text, '') = ''
			and	coalesce(nr_seq_repasse::text, '') = ''
			and 	trunc(dt_lancamento,'month') = trunc(dt_referencia_p, 'month')
			and 	ie_origem_lancamento = 'M';

			insert into pls_repasse_lanc(	nr_sequencia, nr_seq_comissao, vl_lancamento, vl_lanc_aplicado,
						dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ie_tipo_lancamento,
						nr_seq_regra, nr_seq_lancamento_vend, ds_observacao )
				values (	nextval('pls_repasse_lanc_seq'), nr_seq_comissao_p, vl_lancamento_antec_w, vl_lancamento_antec_w,
						clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, '4', -- ie_tipo_lancamento = 4 = Lançamento Manual
						null, null, ds_observacao_w );

			vl_comissao_w := vl_comissao_w + vl_lancamento_antec_w;
		end if;
		end;
	end loop;
	close C04;

	if (ie_gerar_desconto_tit_w = 'S') then
		for vet_c01_w in c01 loop
			begin
			if (ie_repasse_sem_liq_tit_w = 'S' or vet_c01_w.ie_situacao = '2') then
				if (ie_tipo_desconto_tit_w in ('A','B')) then
					open C02(vet_c01_w.nr_titulo);
					loop
					fetch C02 into
						vl_descontos_w;
					EXIT WHEN NOT FOUND; /* apply on C02 */
						begin
						if (coalesce(vl_descontos_w,0) > 0) then
							vl_descontos_aplic_w := vl_descontos_w;

							if (ie_valor_percent_desconto_w = 'P') then
								select	sum(b.vl_item_mensalidade),
									sum(b.vl_comissao)
								into STRICT	vl_item_mensalidade_w,
									vl_comissao_tit_w
								from	pls_comissao_benef_item		b,
									pls_comissao_beneficiario	a
								where	a.nr_sequencia = b.nr_seq_comissao_benef
								and	a.nr_seq_comissao = nr_seq_comissao_p
								and	a.nr_titulo = vet_c01_w.nr_titulo;

								vl_descontos_aplic_w := (vl_descontos_w * vl_comissao_tit_w) / vl_item_mensalidade_w;
							end if;

							insert into pls_repasse_lanc(	nr_sequencia, nr_seq_comissao, vl_lancamento, vl_lanc_aplicado,
										dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ie_tipo_lancamento,
										nr_seq_regra, nr_seq_lancamento_vend, nr_titulo )
								values (	nextval('pls_repasse_lanc_seq'), nr_seq_comissao_p, (vl_descontos_w * -1), (vl_descontos_aplic_w * -1),
										clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, '3', -- ie_tipo_lancamento = 3 = Desconto referente ao desconto concedido ao título a receber
										null, null, vet_c01_w.nr_titulo);

							vl_comissao_w := vl_comissao_w - vl_descontos_w;
						end if;
						end;
					end loop;
					close C02;
				end if;

				if (ie_tipo_desconto_tit_w in ('A','V')) then
					open C05(vet_c01_w.nr_titulo);
					loop
					fetch C05 into
						vl_alteracao_w;
					EXIT WHEN NOT FOUND; /* apply on C05 */
						begin
						if (coalesce(vl_alteracao_w,0) > 0) then
							vl_alteracao_aplic_w := vl_alteracao_w;

							if (ie_valor_percent_desconto_w = 'P') then
								select	sum(b.vl_item_mensalidade),
									sum(b.vl_comissao)
								into STRICT	vl_item_mensalidade_w,
									vl_comissao_tit_w
								from	pls_comissao_benef_item		b,
									pls_comissao_beneficiario	a
								where	a.nr_sequencia = b.nr_seq_comissao_benef
								and	a.nr_seq_comissao = nr_seq_comissao_p
								and	a.nr_titulo = vet_c01_w.nr_titulo;

								vl_alteracao_aplic_w := (vl_alteracao_w * vl_comissao_tit_w) / vl_item_mensalidade_w;
							end if;

							insert into pls_repasse_lanc(	nr_sequencia, nr_seq_comissao, vl_lancamento, vl_lanc_aplicado,
										dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ie_tipo_lancamento,
										nr_seq_regra, nr_seq_lancamento_vend, nr_titulo )
								values (	nextval('pls_repasse_lanc_seq'), nr_seq_comissao_p,(vl_alteracao_w * -1), (vl_alteracao_aplic_w * -1),
										clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, '3', -- ie_tipo_lancamento = 3 = Desconto referente ao desconto concedido ao título a receber
										null, null, vet_c01_w.nr_titulo);

							vl_comissao_w := vl_comissao_w - vl_alteracao_w;
						end if;
						end;
					end loop;
					close C05;
				end if;
			end if;
			end;
		end loop;


	end if;

	dt_referencia_w	:= coalesce(dt_referencia_p, clock_timestamp());

	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_vl_max_w
	from	pls_regra_vend_valor_max
	where	nr_seq_vendedor = nr_seq_vendedor_p
	and	dt_referencia_w between coalesce(dt_inicio_vigencia, dt_referencia_w) and coalesce(dt_fim_vigencia, dt_referencia_w);

	if (nr_seq_regra_vl_max_w IS NOT NULL AND nr_seq_regra_vl_max_w::text <> '') then

		select	vl_maximo,
			ie_cobranca_futura
		into STRICT	vl_maximo_w,
			ie_cobranca_futura_w
		from	pls_regra_vend_valor_max
		where	nr_sequencia = nr_seq_regra_vl_max_w;

		if (vl_comissao_w > vl_maximo_w) then

			vl_lancamento_w	:= vl_maximo_w - vl_comissao_w;

			select	nextval('pls_repasse_lanc_seq')
			into STRICT	nr_seq_repasse_lanc_w
			;

			insert into pls_repasse_lanc(	nr_sequencia, nr_seq_comissao, vl_lancamento, vl_lanc_aplicado,
						dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ie_tipo_lancamento,
						nr_seq_regra, nr_seq_lancamento_vend )
				values (	nr_seq_repasse_lanc_w, nr_seq_comissao_p, vl_lancamento_w, vl_lancamento_w,
						clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, '1', -- ie_tipo_lancamento = 1 = Desconto para geração do valor máximo para o canal de venda
						nr_seq_regra_vl_max_w, null );

			if (coalesce(ie_cobranca_futura_w,'N') = 'S') then

				vl_lancamento_w	:= vl_lancamento_w * -1;

				insert into pls_vendedor_lanc(	nr_sequencia, nr_seq_vendedor, nr_seq_comissao,
							dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
							nr_seq_repasse_lanc, vl_lancamento, ie_origem_lancamento)
					values (	nextval('pls_vendedor_lanc_seq'), nr_seq_vendedor_p, null,
							clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
							nr_seq_repasse_lanc_w, vl_lancamento_w, 'C');

			end if;

		end if;
	end if;

elsif (ie_opcao_p = 'D') then

	select	max(b.nr_seq_repasse),
		max(b.nr_seq_comissao)
	into STRICT	nr_seq_repasse_cobrado_w,
		nr_seq_comissao_cobrada_w
	from	pls_repasse_lanc	a,
		pls_vendedor_lanc	b
	where	a.nr_sequencia 		= b.nr_seq_repasse_lanc
	and	a.nr_seq_comissao  	= nr_seq_comissao_p
	and ((b.nr_seq_repasse IS NOT NULL AND b.nr_seq_repasse::text <> '') or
		 (b.nr_seq_comissao IS NOT NULL AND b.nr_seq_comissao::text <> ''));

	select	nr_seq_lote
	into STRICT	nr_seq_lote_w
	from	pls_comissao
	where	nr_sequencia = nr_seq_comissao_p;

	if (nr_seq_repasse_cobrado_w IS NOT NULL AND nr_seq_repasse_cobrado_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(224121, 'NR_SEQ_REPASSE_COBRADO=' || nr_seq_repasse_cobrado_w || ';NR_SEQ_LOTE=' || nr_seq_lote_w);
		/* Mensagem: Lançamentos adicionais originados deste lote já foram cobrados no repasse NR_SEQ_REPASSE_COBRADO! Para desfazer o lote NR_SEQ_LOTE é necessário primeiro desfazer o repasse NR_SEQ_REPASSE_COBRADO. */

	elsif (nr_seq_comissao_cobrada_w IS NOT NULL AND nr_seq_comissao_cobrada_w::text <> '') then

		select	nr_seq_lote
		into STRICT	nr_seq_lote_cobrado_w
		from	pls_comissao
		where	nr_sequencia = nr_seq_comissao_cobrada_w;

		CALL wheb_mensagem_pck.exibir_mensagem_abort(224122, 'NR_SEQ_COMISSAO_COBRADA=' || nr_seq_comissao_cobrada_w || ';NR_SEQ_LOTE=' || nr_seq_lote_w || ';NR_SEQ_LOTE_COBRADO=' || nr_seq_lote_cobrado_w);
		/* Mensagem: Lançamentos adicionais originados deste lote já foram cobrados na comissão NR_SEQ_COMISSAO_COBRADA! Para desfazer o lote NR_SEQ_LOTE é necessário primeiro desfazer o lote de comissões NR_SEQ_LOTE_COBRADO. */

	else
		update	pls_vendedor_lanc
		set	nr_seq_comissao  = NULL,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_seq_comissao = nr_seq_comissao_p;

		delete	from	pls_vendedor_lanc	a
		where	exists (	SELECT	1
				from	pls_repasse_lanc	x
				where	x.nr_sequencia 	  = a.nr_seq_repasse_lanc
				and	x.nr_seq_comissao = nr_seq_comissao_p);

		delete	from	pls_repasse_lanc
		where	nr_seq_comissao	= nr_seq_comissao_p;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_desf_comis_lanc_adic ( nr_seq_vendedor_p bigint, nr_seq_comissao_p bigint, dt_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;
