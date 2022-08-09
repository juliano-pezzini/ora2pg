-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_transferencia_caixa ( nr_seq_saldo_caixa_p bigint, nr_seq_caixa_destino_p bigint, ds_lista_movto_p text, ds_lista_trans_p text, nm_usuario_p text, dt_transacao_p timestamp, ds_historico_p text, nr_seq_movto_rej_p bigint) AS $body$
DECLARE


nr_seq_movto_w		bigint;
nr_seq_movto_transf_w	bigint;
vl_transferencia_w		double precision	:= 0;
dt_referencia_saldo_w	timestamp;
nr_seq_caixa_w		bigint;
cont_w			bigint;
dt_fechamento_w		timestamp;
nr_seq_caixa_origem_w	bigint;
nr_seq_lote_w		bigint;
cd_estabelecimento_w	smallint;
nr_seq_trans_financ_w	bigint;
vl_transacao_w		double precision;
nr_seq_trans_transf_w	bigint;
cd_transacao_w		varchar(10);
ie_consiste_data_saldo_w	varchar(255);
dt_transacao_w		timestamp;
cont_saldo_w		bigint;
ie_transf_saldo_destino_w	varchar(10);
vl_trans_soma_w		double precision;
vl_trans_rejeitado_w	double precision;
dt_transacao_saida_w	timestamp;
ie_obs_trans_entrada_w	varchar(1);
nr_atendimento_trans_w	titulo_receber.nr_atendimento%type;
nr_recibo_trans_w		caixa_receb.nr_recibo%type;
nr_documento_trans_w	titulo_receber.nr_documento%type;
nm_pessoa_fisica_trans_w	varchar(100);
nr_seq_movto_trans_w	movto_trans_financ.nr_seq_movto_transf%type;
/* Projeto Multimoeda - Variaveis */

vl_transacao_estrang_w	double precision;
vl_complemento_w		double precision;
vl_cotacao_w		cotacao_moeda.vl_cotacao%type;
cd_moeda_w		integer;
ie_caixa_estrang_w		varchar(1);
ie_cotacao_caixa_w	varchar(1);
cd_moeda_empresa_w	integer;
reg_integracao_w		gerar_int_padrao.reg_integracao;
cd_pessoa_fisica_w  movto_trans_financ.cd_pessoa_fisica%type;
count_cd_pessoa_fisica_w bigint;
ie_transf_agrupada_w		varchar(1);
nr_seq_transf_w			movto_trans_financ.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_trans_financ,
		a.dt_transacao,
		a.cd_moeda
	from	movto_trans_financ a
	where	' ' || ds_lista_movto_p || ' ' like '% ' || a.nr_sequencia || ' %'
	and	(ds_lista_movto_p IS NOT NULL AND ds_lista_movto_p::text <> '')
	and	coalesce(a.nr_seq_movto_transf::text, '') = '';

C02 CURSOR FOR
	SELECT	a.nr_seq_trans_financ,
		coalesce(sum(OBTER_VALOR_MOVTO_TRANSF_CAIXA(a.nr_sequencia)),0),
		sum(a.vl_transacao_estrang),
		coalesce(a.cd_moeda,cd_moeda_empresa_w),
		null
	from	movto_trans_financ a
	where	' ' || ds_lista_movto_p || ' ' like '% ' || a.nr_sequencia || ' %'
	and	(ds_lista_movto_p IS NOT NULL AND ds_lista_movto_p::text <> '')
	and	coalesce(a.nr_seq_movto_transf::text, '') = ''
	and	coalesce(ie_transf_agrupada_w,'S') = 'S'
	group by a.nr_seq_trans_financ,
		coalesce(a.cd_moeda,cd_moeda_empresa_w)
	
union

	SELECT	a.nr_seq_trans_financ,
		coalesce(OBTER_VALOR_MOVTO_TRANSF_CAIXA(a.nr_sequencia),0),
		a.vl_transacao_estrang,
		coalesce(a.cd_moeda,cd_moeda_empresa_w),
		a.nr_sequencia
	from	movto_trans_financ a
	where	' ' || ds_lista_movto_p || ' ' like '% ' || a.nr_sequencia || ' %'
	and	(ds_lista_movto_p IS NOT NULL AND ds_lista_movto_p::text <> '')
	and	coalesce(a.nr_seq_movto_transf::text, '') = ''
	and	coalesce(ie_transf_agrupada_w,'S') = 'N';

	

C03 CURSOR FOR
	SELECT	a.nr_seq_trans_financ,
		coalesce(sum(OBTER_VALOR_MOVTO_TRANSF_CAIXA(a.nr_sequencia)),0),
		sum(a.vl_transacao_estrang),
		coalesce(a.cd_moeda,cd_moeda_empresa_w)
	from	movto_trans_financ a
	where	' ' || ds_lista_trans_p || ' ' like '% ' || a.nr_seq_trans_financ || ' %'
	and	(ds_lista_trans_p IS NOT NULL AND ds_lista_trans_p::text <> '')
	and	coalesce(a.nr_seq_movto_transf::text, '') = ''
	and	a.nr_seq_saldo_caixa	= nr_seq_saldo_caixa_p
	group by a.nr_seq_trans_financ,
		coalesce(a.cd_moeda,cd_moeda_empresa_w);

	

BEGIN

if (coalesce(ds_lista_movto_p::text, '') = '' and coalesce(ds_lista_trans_p::text, '') = '') then
	--Nenhuma movimentacao foi selecionada!
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(224934);
end if;

if (ds_lista_movto_p IS NOT NULL AND ds_lista_movto_p::text <> '') or (ds_lista_trans_p IS NOT NULL AND ds_lista_trans_p::text <> '') then

	/* OS 337745 - Solicitada inclusao deste tratamento em 17/08/2011 e solicitada retirada em 11/02/2012 */



	/*if	(nr_seq_movto_rej_p is not null) then
		select	sum(a.vl_transacao)
		into	vl_trans_soma_w
		from	movto_trans_financ a
		where	' ' || ds_lista_movto_p || ' ' like '% ' || a.nr_sequencia || ' %'
		and	ds_lista_movto_p is not null
		and	a.nr_seq_movto_transf is null;

		select	a.vl_transacao
		into	vl_trans_rejeitado_w
		from	movto_trans_financ	a
		where	a.nr_sequencia	= nr_seq_movto_rej_p;
		
		if	(vl_trans_rejeitado_w <> vl_trans_soma_w) then
			R.aise_application_error(-20011,'O valor das transferencias selecionadas, difere do valor da transferencia rejeitada selecionada.');
		end if;
	end if;*/

	

	/* Obter dados do caixa onde sera(ao) lancada(s) a(s) transferencia(s) */

	begin
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
	exception when others then

		-- Nao foi localizado saldo diario para o lancamento da transacao
		CALL wheb_mensagem_pck.exibir_mensagem_abort(139706);
	end;

	ie_transf_saldo_destino_w := obter_param_usuario(813, 96, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_transf_saldo_destino_w);
	ie_obs_trans_entrada_w := obter_param_usuario(813, 168, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_obs_trans_entrada_w);
	ie_transf_agrupada_w := obter_param_usuario(813, 215, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_transf_agrupada_w);

	/* Tratamento de erros */

	if (dt_fechamento_w IS NOT NULL AND dt_fechamento_w::text <> '') then

	--A transferencia nao pode ser feita pois o saldo esta fechado!
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(224935);
	end if;
	
	/* Francisco - 27/02/2012 - Tratar para reenvio de rejeicao sempre pegar data do saldo */

	dt_transacao_saida_w	:= dt_transacao_p;
	if (nr_seq_movto_rej_p IS NOT NULL AND nr_seq_movto_rej_p::text <> '') then
		dt_transacao_saida_w	:= to_date(to_char(dt_referencia_saldo_w,'dd/mm/yyyy') ||
					' ' || to_char(dt_transacao_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	end if;

	if (trunc(coalesce(dt_transacao_saida_w,clock_timestamp()),'dd') <> trunc(dt_referencia_saldo_w,'dd')) then

		--Nao e possivel realizar uma transferencia com data diferente do saldo!
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(224936);
	end if;

	select	count(*)
	into STRICT	cont_w
	from	movto_trans_financ
	where	nr_seq_caixa	= nr_seq_caixa_w
	and	coalesce(dt_fechamento_lote::text, '') = '';
	
	if (cont_w > 0) then
		--A transferencia nao pode ser feita pois ha um lote aberto neste caixa!
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(224937);
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

		--A transferencia nao pode ser feita pois ha um recebimento em aberto neste caixa!
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(224939);
	end if;
	
	/* Projeto Multimoeda - Verifica se o caixa permite moeda estrangeira. Para caixas com moeda estrangeira, verifica se existe cotacao cadastrada
		para a data atual antes de realizar a transferencia. Caso nao exista cotacao para alguma moeda, interrompe a transferencia. */
	select	obter_se_caixa_estrang(nr_seq_caixa_w),
		obter_moeda_padrao_empresa(cd_estabelecimento_w,'E')
	into STRICT	ie_caixa_estrang_w,
		cd_moeda_empresa_w
	;
	if (coalesce(ie_caixa_estrang_w,'N') = 'S') then
		select	verifica_cotacao_moeda_caixa(nr_seq_caixa_w,clock_timestamp())
		into STRICT	ie_cotacao_caixa_w
		;
		if (ie_cotacao_caixa_w = 'N') then
			/* Nao existe cotacao cadastrada nesta data para as moedas liberadas para este caixa. */

			CALL wheb_mensagem_pck.exibir_mensagem_abort(351678);
		end if;
	end if;
	/* Se tudo ok gera transferencia(s) */



	/* Transferencia saida */

	if (nr_seq_caixa_destino_p IS NOT NULL AND nr_seq_caixa_destino_p::text <> '') then
		/* Transferencia em detalhe */

		if (ds_lista_movto_p IS NOT NULL AND ds_lista_movto_p::text <> '') then

			/* Projeto Multimoeda - Realiza a consistencia da moeda das transacoes selecionadas com as moedas aceitas pelo caixa de destino,
				caso existam transacoes em moeda nao aceita pelo caixa o processo e parado para que o usuario verifique as transacoes seleionadas. */
			CALL consiste_moeda_transf_caixa(nr_seq_caixa_destino_p,ds_lista_movto_p);
			
			open C02;
			loop
			fetch C02 into
				nr_seq_trans_financ_w,
				vl_transacao_w,
				vl_transacao_estrang_w,
				cd_moeda_w,
				nr_seq_transf_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */

				select	nextval('movto_trans_financ_seq')
				into STRICT	nr_seq_movto_transf_w
				;

				select	coalesce(max(nr_seq_lote),0) + 1
				into STRICT	nr_seq_lote_w
				from	movto_trans_financ
				where	nr_seq_caixa	= nr_seq_caixa_w;

				select	coalesce(nr_seq_trans_transf,0)
				into STRICT	nr_seq_trans_transf_w
				from	transacao_financeira
				where	nr_sequencia	= nr_seq_trans_financ_w;

				if (nr_seq_trans_transf_w = 0) then
					select	cd_transacao
					into STRICT	cd_transacao_w
					from	transacao_financeira
					where	nr_sequencia	= nr_seq_trans_financ_w;

					--A transacao a ser transferida nao possui transacao para transferencia associada!

					--Verifique o cadastro da transacao cod: #@cd_transacao_w#@
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(224945,'cd_transacao_w='||cd_transacao_w);
				end if;

				if (ie_transf_saldo_destino_w = 'N') then
					select	count(*)
					into STRICT	cont_saldo_w
					from	caixa_saldo_diario a
					where	trunc(a.dt_saldo,'dd')		= trunc(coalesce(dt_transacao_saida_w,clock_timestamp()),'dd')
					and	a.nr_seq_caixa			= nr_seq_caixa_destino_p
					and	coalesce(a.dt_fechamento::text, '') = '';

					if (cont_saldo_w = 0) then
						--Nao permitido gerar transferencia de saida sem saldo aberto para a transacao no caixa destino! Param[96]
						CALL Wheb_mensagem_pck.exibir_mensagem_abort(224942);
					end if;
				end if;
				
				/* Projeto Multimoeda - Verifica se a transacao e em moeda estrangeira, caso positivo calcula os valores antes de gravar a transacao. */

				if (coalesce(cd_moeda_w,cd_moeda_empresa_w) <> cd_moeda_empresa_w) then
					select	obter_cotacao_moeda_financ(cd_moeda_w,clock_timestamp())
					into STRICT	vl_cotacao_w
					;
					if (coalesce(vl_transacao_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
						vl_transacao_w := vl_transacao_estrang_w * vl_cotacao_w;
						vl_complemento_w := vl_transacao_w - vl_transacao_estrang_w;
					else
						vl_transacao_estrang_w := null;
						vl_complemento_w := null;
						vl_cotacao_w := null;
					end if;
				else
					vl_transacao_estrang_w := null;
					vl_complemento_w := null;
					vl_cotacao_w := null;
				end if;

				insert into movto_trans_financ(nr_sequencia,
					dt_transacao,
					nr_seq_trans_financ,
					vl_transacao,
					dt_atualizacao,
					nm_usuario,
					nr_seq_caixa_od,
					nr_seq_caixa,
					nr_seq_saldo_caixa,
					dt_referencia_saldo,
					nr_lote_contabil,
					ie_conciliacao,
					nr_seq_lote,
					ds_historico,
					ie_rejeitado,
					vl_transacao_estrang,
					vl_complemento,
					vl_cotacao,
					cd_moeda,
					cd_estabelecimento)
				values (nr_seq_movto_transf_w,
					coalesce(dt_transacao_saida_w,clock_timestamp()),
					nr_seq_trans_transf_w,
					vl_transacao_w,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_caixa_destino_p,
					nr_seq_caixa_w,
					nr_seq_saldo_caixa_p,
					dt_referencia_saldo_w,
					0,
					'N',
					nr_seq_lote_w,
					ds_historico_p,
					'N',
					vl_transacao_estrang_w,
					vl_complemento_w,
					vl_cotacao_w,
					cd_moeda_w,
					cd_estabelecimento_w);

				CALL GERAR_TRANS_FINANC_TAXA(nr_seq_movto_transf_w,cd_estabelecimento_w,nm_usuario_p);
				
				if (coalesce(ie_transf_agrupada_w,'S') = 'S') then --Faz o que fazia antes da criacao do parametro
					update	movto_trans_financ
					set	nr_seq_movto_transf	= nr_seq_movto_transf_w,
						ie_rejeitado		= 'N'
					where	' ' || ds_lista_movto_p || ' ' like '% ' || nr_sequencia || ' %'
					and	nr_seq_trans_financ	= nr_seq_trans_financ_w
					and	coalesce(nr_seq_movto_transf::text, '') = '';
				else  --Aqui deve fazer o update apenas na sequencia em si e nao na lista toda
					update	movto_trans_financ
					set	nr_seq_movto_transf	= nr_seq_movto_transf_w,
						ie_rejeitado		= 'N'
					where	nr_sequencia = nr_seq_transf_w
					and	nr_seq_trans_financ	= nr_seq_trans_financ_w
					and	coalesce(nr_seq_movto_transf::text, '') = '';
				end if;
					
				CALL atualizar_saldo_caixa(cd_estabelecimento_w,
							nr_seq_lote_w,
							nr_seq_caixa_w,
							nm_usuario_p,
							'N');		
	
			end loop;
			close C02;
			
			if (nr_seq_movto_rej_p IS NOT NULL AND nr_seq_movto_rej_p::text <> '') then
				update	movto_trans_financ
				set	nr_seq_movto_rejeitado	= nr_seq_movto_rej_p
				where	' ' || ds_lista_movto_p || ' ' like '% ' || nr_sequencia || ' %';
			end if;
		/* Transferencia em resumo */

		elsif (ds_lista_trans_p IS NOT NULL AND ds_lista_trans_p::text <> '') then

			/* Projeto Multimoeda - Realiza a consistencia da moeda das transacoes selecionadas com as moedas aceitas pelo caixa de destino,
				caso existam transacoes em moeda nao aceita pelo caixa o processo e parado para que o usuario verifique as transacoes seleionadas. */
			CALL consiste_moeda_transf_caixa(nr_seq_caixa_destino_p,ds_lista_trans_p);
			open C03;
			loop
			fetch C03 into
				nr_seq_trans_financ_w,
				vl_transacao_w,
				vl_transacao_estrang_w,
				cd_moeda_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */

				select	nextval('movto_trans_financ_seq')
				into STRICT	nr_seq_movto_transf_w
				;
			
				select	coalesce(max(nr_seq_lote),0) + 1
				into STRICT	nr_seq_lote_w
				from	movto_trans_financ
				where	nr_seq_caixa	= nr_seq_caixa_w;

				select	coalesce(nr_seq_trans_transf,0)
				into STRICT	nr_seq_trans_transf_w
				from	transacao_financeira
				where	nr_sequencia	= nr_seq_trans_financ_w;

				if (nr_seq_trans_transf_w = 0) then
					select	cd_transacao
					into STRICT	cd_transacao_w
					from	transacao_financeira
					where	nr_sequencia	= nr_seq_trans_financ_w;
					--A transacao a ser transferida nao possui transacao para transferencia associada!

					--Verifique o cadastro da transacao cod: #@cd_transacao_w#@
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(224945,'cd_transacao_w='||cd_transacao_w);
				end if;
				
				/* Projeto Multimoeda - Verifica se a transacao e em moeda estrangeira, caso positivo calcula os valores antes de gravar a transacao. */

				if (coalesce(cd_moeda_w,cd_moeda_empresa_w) <> cd_moeda_empresa_w) then
					select	obter_cotacao_moeda_financ(cd_moeda_w,clock_timestamp())
					into STRICT	vl_cotacao_w
					;
					if (coalesce(vl_transacao_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
						vl_transacao_w := vl_transacao_estrang_w * vl_cotacao_w;
						vl_complemento_w := vl_transacao_w - vl_transacao_estrang_w;
					else
						vl_transacao_estrang_w := null;
						vl_complemento_w := null;
						vl_cotacao_w := null;
					end if;
				else
					vl_transacao_estrang_w := null;
					vl_complemento_w := null;
					vl_cotacao_w := null;
				end if;

				insert into movto_trans_financ(nr_sequencia,
					dt_transacao,
					nr_seq_trans_financ,
					vl_transacao,
					dt_atualizacao,
					nm_usuario,
					nr_seq_caixa_od,
					nr_seq_caixa,
					nr_seq_saldo_caixa,
					dt_referencia_saldo,
					nr_lote_contabil,
					ie_conciliacao,
					nr_seq_lote,
					ds_historico,
					ie_rejeitado,
					vl_transacao_estrang,
					vl_complemento,
					vl_cotacao,
					cd_moeda,
					cd_estabelecimento)
				values (nr_seq_movto_transf_w,
					coalesce(dt_transacao_saida_w,clock_timestamp()),
					nr_seq_trans_transf_w,
					vl_transacao_w,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_caixa_destino_p,
					nr_seq_caixa_w,
					nr_seq_saldo_caixa_p,
					dt_referencia_saldo_w,
					0,
					'N',
					nr_seq_lote_w,
					ds_historico_p,
					'N',
					vl_transacao_estrang_w,
					vl_complemento_w,
					vl_cotacao_w,
					cd_moeda_w,
					cd_estabelecimento_w);

				CALL GERAR_TRANS_FINANC_TAXA(nr_seq_movto_transf_w,cd_estabelecimento_w,nm_usuario_p);

				update	movto_trans_financ
				set	nr_seq_movto_transf	= nr_seq_movto_transf_w,
					ie_rejeitado		= 'N'
				where	nr_seq_trans_financ	= nr_seq_trans_financ_w
				and	nr_seq_saldo_caixa	= nr_seq_saldo_caixa_p
				and	coalesce(nr_seq_movto_transf::text, '') = ''
				and	nr_seq_saldo_caixa	= nr_seq_saldo_caixa_p;
					
				CALL atualizar_saldo_caixa(cd_estabelecimento_w,
							nr_seq_lote_w,
							nr_seq_caixa_w,
							nm_usuario_p,
							'N');
	
			end loop;
			close C03;	
		end if;

	/* Transferencia entrada */

	else
		/* Deve ser uma transferencia de entrada para cada de saida */

		open C01;
		loop
		fetch C01 into
			nr_seq_movto_w,
			nr_seq_trans_financ_w,
			dt_transacao_w,
			cd_moeda_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			
			select	nextval('movto_trans_financ_seq')
			into STRICT	nr_seq_movto_transf_w
			;

			select	coalesce(obter_valor_param_usuario(813,81,obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento), 'N')
			into STRICT	ie_consiste_data_saldo_w
			;

			if (coalesce(ie_consiste_data_saldo_w,'N') = 'S') then
				if (trunc(coalesce(dt_transacao_w,clock_timestamp()),'dd') <> trunc(dt_referencia_saldo_w,'dd')) then  -- dsantos
					--Nao e possivel realizar uma transferencia de entrada com data diferente do saldo!
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(224943);
				end if;
			end if;
			
			select  count(distinct a.cd_pessoa_fisica)
			into STRICT	count_cd_pessoa_fisica_w		
			from	transacao_financeira b,
					movto_trans_financ a
			where	a.nr_seq_trans_financ	= b.nr_sequencia
			and	a.nr_seq_movto_transf	= nr_seq_movto_w;

			cd_pessoa_fisica_w := null;
			if (count_cd_pessoa_fisica_w = 1) then		
				select  max(a.cd_pessoa_fisica)
				into STRICT	cd_pessoa_fisica_w		
				from	transacao_financeira b,
						movto_trans_financ a
				where	a.nr_seq_trans_financ	= b.nr_sequencia
				and	a.nr_seq_movto_transf	= nr_seq_movto_w;
			end if;
	
			select	coalesce(a.vl_transacao,0),
				a.nr_seq_caixa,
				a.vl_transacao_estrang
			into STRICT	vl_transferencia_w,
				nr_seq_caixa_origem_w,
				vl_transacao_estrang_w
			from	movto_trans_financ a
			where	a.nr_sequencia	= nr_seq_movto_w;

			select	coalesce(max(nr_seq_lote),0) + 1
			into STRICT	nr_seq_lote_w
			from	movto_trans_financ
			where	nr_seq_caixa	= nr_seq_caixa_w;

			select	coalesce(nr_seq_trans_transf,0)
			into STRICT	nr_seq_trans_transf_w
			from	transacao_financeira
			where	nr_sequencia	= nr_seq_trans_financ_w;

			if (nr_seq_trans_transf_w = 0) then
				select	cd_transacao
				into STRICT	cd_transacao_w
				from	transacao_financeira
				where	nr_sequencia	= nr_seq_trans_financ_w;

				--A transacao a ser transferida nao possui transacao para transferencia associada!

				--Verifique o cadastro da transacao cod: #@cd_transacao_w#@
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(224945,'cd_transacao_w='||cd_transacao_w);
			end if;

			/* Projeto Multimoeda - Verifica se a transacao e em moeda estrangeira, caso positivo calcula os valores antes de gravar a transacao. */

			if (coalesce(cd_moeda_w,cd_moeda_empresa_w) <> cd_moeda_empresa_w) then
				select	obter_cotacao_moeda_financ(cd_moeda_w,clock_timestamp())
				into STRICT	vl_cotacao_w
				;
				
				if (coalesce(vl_transacao_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
					vl_transacao_w := vl_transacao_estrang_w * vl_cotacao_w;
					vl_complemento_w := vl_transacao_w - vl_transacao_estrang_w;
				else
					vl_transacao_estrang_w := null;
					vl_complemento_w := null;
					vl_cotacao_w := null;
				end if;
			else
				vl_transacao_estrang_w := null;
				vl_complemento_w := null;
				vl_cotacao_w := null;
			end if;

			insert into movto_trans_financ(nr_sequencia,
				dt_transacao,
				nr_seq_trans_financ,
				vl_transacao,
				dt_atualizacao,
				nm_usuario,
				nr_seq_caixa_od,
				nr_seq_caixa,
				nr_seq_saldo_caixa,
				dt_referencia_saldo,
				nr_lote_contabil,
				ie_conciliacao,
				nr_seq_lote,
				ds_historico,
				ie_rejeitado,
				vl_transacao_estrang,
				vl_complemento,
				vl_cotacao,
				cd_moeda,
				cd_estabelecimento,
				cd_pessoa_fisica)
			values (nr_seq_movto_transf_w,
				coalesce(dt_transacao_p,clock_timestamp()),
				nr_seq_trans_transf_w,
				vl_transferencia_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_caixa_origem_w,
				nr_seq_caixa_w,
				nr_seq_saldo_caixa_p,
				dt_referencia_saldo_w,
				0,
				'N',
				nr_seq_lote_w,
				ds_historico_p,
				'N',
				vl_transacao_estrang_w,
				vl_complemento_w,
				vl_cotacao_w,
				cd_moeda_w,
				cd_estabelecimento_w,
				cd_pessoa_fisica_w);

			/*OS 1373493 - 02/06/2017 - Integracao padrao para transferencias de entrada*/
	

			reg_integracao_w := gerar_int_padrao.gravar_integracao('51', nr_seq_movto_transf_w, nm_usuario_p, reg_integracao_w);	
	
			CALL GERAR_TRANS_FINANC_TAXA(nr_seq_movto_transf_w,cd_estabelecimento_w,nm_usuario_p);

			/* Marcar movimentacao como transferida */

			update	movto_trans_financ
			set	nr_seq_movto_transf	= nr_seq_movto_transf_w,
				ie_rejeitado		= 'N'
			where	nr_sequencia		= nr_seq_movto_w
			and	coalesce(nr_seq_movto_transf::text, '') = '';
			
			if (nr_seq_movto_rej_p IS NOT NULL AND nr_seq_movto_rej_p::text <> '') then
				update	movto_trans_financ
				set	nr_seq_movto_rejeitado	= nr_seq_movto_rej_p
				where	nr_sequencia		= nr_seq_movto_w;
			end if;

			CALL atualizar_saldo_caixa(cd_estabelecimento_w,
						nr_seq_lote_w,
						nr_seq_caixa_w,
						nm_usuario_p,
						'N');
						
			if (coalesce(ie_obs_trans_entrada_w,'N') = 'P') then
			
				select	max(nr_sequencia)
				into STRICT	nr_seq_movto_trans_w
				from  	movto_trans_financ
				where 	nr_seq_movto_transf = nr_seq_movto_w;
				
				
				if (nr_seq_movto_trans_w IS NOT NULL AND nr_seq_movto_trans_w::text <> '') then
			
					SELECT 	max(a.nr_atendimento),
						max(c.nr_recibo),              
						max(a.nr_documento),
						SUBSTR(obter_pessoa_movto_trans(nr_seq_movto_trans_w,'N','GE'),1,100)
					into STRICT	nr_atendimento_trans_w,
						nr_recibo_trans_w,
						nr_documento_trans_w,
						nm_pessoa_fisica_trans_w
					FROM   	titulo_receber a,                    
						movto_trans_financ b,                
						caixa_receb c,                       
						titulo_receber_liq d                 
					WHERE  	b.nr_sequencia 		= nr_seq_movto_trans_w    
					AND    	b.nr_seq_caixa_rec 	= c.nr_sequencia
					AND    	c.nr_sequencia 		= d.nr_seq_caixa_rec 
					AND    	a.nr_titulo 		= d.nr_titulo;
					
					update	movto_trans_financ
					set	ds_historico = wheb_mensagem_pck.get_texto(302574,substr('NM_PESSOA_FISICA_TRANS=' || substr(nm_pessoa_fisica_trans_w,1,100) || ';NR_RECIBO_TRANS=' || substr(nr_recibo_trans_w,1,10) || ';NR_ATENDIMENTO_TRANS='|| substr(nr_atendimento_trans_w,1,10) ||';NR_DOCUMENTO_TRANS='|| substr(nr_documento_trans_w,1,22),1,255))
					where	nr_sequencia = nr_seq_movto_transf_w;
				
				end if;
				
			end if;

		end loop;
		close C01;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_transferencia_caixa ( nr_seq_saldo_caixa_p bigint, nr_seq_caixa_destino_p bigint, ds_lista_movto_p text, ds_lista_trans_p text, nm_usuario_p text, dt_transacao_p timestamp, ds_historico_p text, nr_seq_movto_rej_p bigint) FROM PUBLIC;
