-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baixar_glosas_discuss_rec ( nr_seq_lote_discuss_p pls_lote_discussao.nr_sequencia%type, nr_seq_acao_interc_p pls_processo_interc_acao.nr_sequencia%type, ie_estorno_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE
	

vl_aceito_proc_w		pls_discussao_proc.vl_aceito%type;
vl_aceito_mat_w			pls_discussao_mat.vl_aceito%type;
nr_seq_ptu_fatura_w		pls_lote_contestacao.nr_seq_ptu_fatura%type;
nr_titulo_w			titulo_receber.nr_titulo%type;
nr_titulo_receber_w		titulo_receber.nr_titulo%type;
nr_seq_baixa_w			titulo_receber_liq.nr_sequencia%type;
dt_baixa_w			timestamp;
cd_tipo_baixa_aceite_w		pls_processo_interc_acao.cd_tipo_receb_aceite%type;
cd_tipo_baixa_rejeicao_w	pls_processo_interc_acao.cd_tipo_receb_rejeicao%type;
nr_seq_trans_fin_aceite_w	pls_processo_interc_acao.nr_seq_trans_fin_aceite%type;
nr_seq_trans_fin_rejeicao_w	pls_processo_interc_acao.nr_seq_trans_fin_rejeicao%type;
cd_moeda_padrao_w		parametros_contas_pagar.cd_moeda_padrao%type;
nr_seq_lote_contest_w		pls_lote_contestacao.nr_sequencia%type;
vl_negado_proc_w		pls_discussao_proc.vl_negado%type;
vl_negado_mat_w			pls_discussao_mat.vl_negado%type;
vl_total_aceito_w		double precision;
vl_total_negado_w		double precision;
cd_cgc_w			pessoa_juridica.cd_cgc%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_moeda_w			titulo_receber.cd_moeda%type;
cd_portador_w			titulo_receber.cd_portador%type;
cd_tipo_portador_w		titulo_receber.cd_tipo_portador%type;
cd_tipo_taxa_juro_w		titulo_receber.cd_tipo_taxa_juro%type;
cd_tipo_taxa_multa_w		titulo_receber.cd_tipo_taxa_multa%type;
pr_juro_padrao_w		titulo_receber.tx_juros%type;
pr_multa_padrao_w		titulo_receber.tx_multa%type;
dt_vencimento_w			timestamp;
qt_dias_vencimento_w		pls_processo_interc_acao.qt_dias_vencimento%type;
nr_seq_pls_fatura_w		pls_lote_contestacao.nr_seq_pls_fatura%type;
vl_saldo_titulo_w		titulo_receber.vl_saldo_titulo%type;
vl_glosa_w			pls_discussao_proc.vl_negado%type;
ie_ato_cooperado_w		pls_conta_proc.ie_ato_cooperado%type;
qt_baixa_w			integer := 0;
qt_liquidacao_w			integer := 0;
nr_titulo_ndc_w			pls_fatura.nr_titulo_ndc%type;
dt_liquidacao_w			titulo_receber.dt_liquidacao%type;
nr_seq_encontro_contas_w	lote_encontro_contas.nr_sequencia%type;
vl_contest_proc_w		pls_discussao_proc.vl_contestado%type;
vl_contest_mat_w		pls_discussao_mat.vl_contestado%type;
ie_tipo_arquivo_w		pls_lote_discussao.ie_tipo_arquivo%type;
ie_valor_baixa_w		pls_processo_interc_acao.ie_valor_baixa%type;
nr_seq_lote_disc_parc_w		pls_lote_discussao.nr_sequencia%type;
vl_negado_proc_parc_w		pls_discussao_proc.vl_negado%type;
vl_negado_mat_parc_w		pls_discussao_mat.vl_negado%type;
vl_aceito_proc_parc_w		pls_discussao_proc.vl_aceito%type;
vl_aceito_mat_parc_w		pls_discussao_mat.vl_aceito%type;
ie_liquidado_w			varchar(5);
ie_tipo_camara_w		pls_camara_compensacao.ie_tipo_camara%type;
nr_seq_camara_w			pls_congenere_camara.nr_seq_camara%type;
ie_data_baixa_tit_rec_w		pls_parametros.ie_data_baixa_tit_rec%type;

C01 CURSOR FOR
	SELECT	sum(coalesce(b.vl_negado,0)),
		c.ie_ato_cooperado
	from	pls_conta_proc 			c,	
		pls_discussao_proc 		b,
		pls_contestacao_discussao 	a
	where	a.nr_sequencia	= b.nr_seq_discussao
	and	c.nr_sequencia	= b.nr_seq_conta_proc
	and	a.nr_seq_lote	= nr_seq_lote_discuss_p
	group by c.ie_ato_cooperado
	
union all

	SELECT	sum(coalesce(b.vl_negado,0)),
		c.ie_ato_cooperado
	from	pls_conta_mat			c,
		pls_discussao_mat 		b,
		pls_contestacao_discussao 	a
	where	a.nr_sequencia	= b.nr_seq_discussao
	and	c.nr_sequencia	= b.nr_seq_conta_mat
	and	a.nr_seq_lote	= nr_seq_lote_discuss_p
	group by c.ie_ato_cooperado;

C02 CURSOR FOR
	SELECT	sum(coalesce(b.vl_aceito,0)),
		c.ie_ato_cooperado
	from	pls_conta_proc 			c,	
		pls_discussao_proc 		b,
		pls_contestacao_discussao 	a
	where	a.nr_sequencia	= b.nr_seq_discussao
	and	c.nr_sequencia	= b.nr_seq_conta_proc
	and	a.nr_seq_lote	= nr_seq_lote_discuss_p
	group by c.ie_ato_cooperado
	
union all

	SELECT	sum(coalesce(b.vl_aceito,0)),
		c.ie_ato_cooperado
	from	pls_conta_mat			c,
		pls_discussao_mat 		b,
		pls_contestacao_discussao 	a
	where	a.nr_sequencia	= b.nr_seq_discussao
	and	c.nr_sequencia	= b.nr_seq_conta_mat
	and	a.nr_seq_lote	= nr_seq_lote_discuss_p
	group by c.ie_ato_cooperado;	
	

BEGIN
if (nr_seq_lote_discuss_p IS NOT NULL AND nr_seq_lote_discuss_p::text <> '') then
	select	coalesce(ie_data_baixa_tit_rec, 'A')
	into STRICT	ie_data_baixa_tit_rec_w
	from	pls_parametros
	where	cd_estabelecimento = cd_estabelecimento_p;
	
	select	coalesce(max(ie_valor_baixa),'VN')
	into STRICT	ie_valor_baixa_w
	from	pls_processo_interc_acao
	where	nr_sequencia = nr_seq_acao_interc_p;
	
	-- Obter o lote de contestacao do lote da discussao

	-- Obter o titulo a receber da fatura PTU
	select	max(a.nr_seq_lote_contest),
		max(b.nr_seq_ptu_fatura),
		max(b.nr_seq_pls_fatura),
		max(ie_tipo_arquivo)
	into STRICT	nr_seq_lote_contest_w,
		nr_seq_ptu_fatura_w,
		nr_seq_pls_fatura_w,
		ie_tipo_arquivo_w
	from	pls_lote_contestacao b,
		pls_lote_discussao a
	where	b.nr_sequencia	= a.nr_seq_lote_contest
	and	a.nr_sequencia	= nr_seq_lote_discuss_p;
	
	dt_baixa_w	:= trunc(clock_timestamp(),'dd');
	
	if (ie_data_baixa_tit_rec_w = 'P') then
		select	coalesce(max(trunc(dt_postagem_arquivo,'dd')), dt_baixa_w)
		into STRICT	dt_baixa_w
		from	ptu_camara_contestacao
		where	nr_seq_lote_contest = nr_seq_lote_contest_w;
	end if;
	
	ie_liquidado_w := pls_obter_dados_lote_contest(nr_seq_lote_contest_w,'PC');
	
	if (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') then
		select	max(a.nr_seq_camara)
		into STRICT	nr_seq_camara_w
		from	pls_congenere_camara	a,
			pls_fatura		f
		where	a.nr_seq_congenere	= f.nr_seq_congenere
		and	f.nr_sequencia		= nr_seq_pls_fatura_w
		and	clock_timestamp() between a.dt_inicio_vigencia_ref and a.dt_fim_vigencia_ref;
		
		if (nr_seq_camara_w IS NOT NULL AND nr_seq_camara_w::text <> '') then
			select	max(ie_tipo_camara)
			into STRICT	ie_tipo_camara_w
			from	pls_camara_compensacao
			where	nr_sequencia	= nr_seq_camara_w;
		
		elsif (coalesce(nr_seq_camara_w::text, '') = '') and -- Sem camara
			(ie_liquidado_w = 'I') then -- Integral
			-- Tratar igual camara Nacional para nao fazer baixa integral
			ie_tipo_camara_w := 'N';
		end if;
	end if;
	
	-- zerar valores
	vl_negado_proc_parc_w	:= 0;
	vl_negado_mat_parc_w	:= 0;
	vl_aceito_proc_parc_w	:= 0;
	vl_aceito_mat_parc_w	:= 0;
	
	-- Caso tenha discussao parcial
	if (ie_tipo_arquivo_w in (3,4,9)) and (ie_valor_baixa_w = 'VN') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_lote_disc_parc_w
		from	pls_lote_discussao
		where	ie_status		= 'F'
		and	nr_seq_lote_contest	= nr_seq_lote_contest_w
		and	ie_tipo_arquivo		in (3,4,9)
		and	nr_sequencia		< nr_seq_lote_discuss_p;
		
		if (nr_seq_lote_disc_parc_w IS NOT NULL AND nr_seq_lote_disc_parc_w::text <> '') then
			select	coalesce(sum(b.vl_aceito),0),
				coalesce(sum(b.vl_negado),0)
			into STRICT	vl_aceito_proc_parc_w,
				vl_negado_proc_parc_w				
			from	pls_discussao_proc b,
				pls_contestacao_discussao a
			where	a.nr_sequencia	= b.nr_seq_discussao
			and	a.nr_seq_lote	= nr_seq_lote_disc_parc_w;
			
			select	coalesce(sum(b.vl_aceito),0),
				coalesce(sum(b.vl_negado),0)
			into STRICT	vl_aceito_mat_parc_w,
				vl_negado_mat_parc_w
			from	pls_discussao_mat b,
				pls_contestacao_discussao a
			where	a.nr_sequencia	= b.nr_seq_discussao
			and	a.nr_seq_lote	= nr_seq_lote_disc_parc_w;
		end if;
	end if;

	/* Somar todo o valor aceito/negado para lancar a baixa */

	select	coalesce(sum(b.vl_aceito),0),
		coalesce(sum(b.vl_negado),0),
		coalesce(sum(b.vl_contestado),0)
	into STRICT	vl_aceito_proc_w,
		vl_negado_proc_w,
		vl_contest_proc_w
	from	pls_discussao_proc b,
		pls_contestacao_discussao a
	where	a.nr_sequencia	= b.nr_seq_discussao
	and	a.nr_seq_lote	= nr_seq_lote_discuss_p;
	
	select	coalesce(sum(b.vl_aceito),0),
		coalesce(sum(b.vl_negado),0),
		coalesce(sum(b.vl_contestado),0)
	into STRICT	vl_aceito_mat_w,
		vl_negado_mat_w,
		vl_contest_mat_w
	from	pls_discussao_mat b,
		pls_contestacao_discussao a
	where	a.nr_sequencia	= b.nr_seq_discussao
	and	a.nr_seq_lote	= nr_seq_lote_discuss_p;
	
	-- Se for do tipo 1, baixa todo o valor contestado de uma vez
	if (ie_valor_baixa_w = 'VC') then
		if (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') and (ie_tipo_arquivo_w = '1') then
			vl_negado_proc_w := vl_contest_proc_w;
			vl_negado_mat_w	 := vl_contest_mat_w;
		else
			vl_negado_proc_w := 0;
			vl_negado_mat_w	 := 0;
			vl_aceito_proc_w := 0;
			vl_aceito_mat_w  := 0;
		end if;
		
		-- Camara Nacional
		if (ie_tipo_camara_w in ('N','F')) then
			-- Titulo pagamento parcial (Fatura BR e Camara Nacional)	/ Titulo pagamento Integral (Fatura BR e Camara Nacional)

			-- Deve fazer baixa no titulo na importacao do tipo 1 (NC1)	/ Nao deve fazer baixa no titulo na importacao do tipo 1 (NC1)
			if (ie_liquidado_w = 'I') then
				vl_negado_proc_w := 0;
				vl_negado_mat_w	 := 0;
				vl_aceito_proc_w := 0;
				vl_aceito_mat_w  := 0;
			end if;
		end if;
	end if;
	
	-- Descontar valor de lote de discussao parcial (o parcial 2 e o total mais o parcial 1, por isso este desconto)
	vl_aceito_proc_w := coalesce(vl_aceito_proc_w,0) - coalesce(vl_aceito_proc_parc_w,0);
	vl_aceito_mat_w := coalesce(vl_aceito_mat_w,0) - coalesce(vl_aceito_mat_parc_w,0);
		
	if (vl_aceito_proc_w + vl_aceito_mat_w > 0) then -- GLOSA ACEITA
		vl_total_aceito_w	:= vl_aceito_proc_w + vl_aceito_mat_w;
		
		if (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') or (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') then

			if (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') then
				select	max(a.nr_titulo)
				into STRICT	nr_titulo_w
				from	titulo_receber a
				where	a.nr_seq_ptu_fatura	= nr_seq_ptu_fatura_w;
			
			elsif (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') then
				select	max(nr_titulo),
					max(nr_titulo_ndc)
				into STRICT	nr_titulo_w,
					nr_titulo_ndc_w
				from	pls_fatura
				where	nr_sequencia	= nr_seq_pls_fatura_w;
				
				nr_titulo_w := coalesce(nr_titulo_w,nr_titulo_ndc_w);
			end if;
			
			select	count(1)
			into STRICT	qt_baixa_w
			from	titulo_receber_liq a
			where	a.nr_titulo	= nr_titulo_w;
			
			select	count(1)
			into STRICT	qt_liquidacao_w
			from	titulo_receber
			where	nr_titulo	= nr_titulo_w
			and	ie_situacao 	= '2'
			and	vl_saldo_titulo	= 0;
			
			select	max(c.nr_sequencia)
			into STRICT	nr_seq_encontro_contas_w
			from	encontro_contas_item	a,
				pessoa_encontro_contas	b,
				lote_encontro_contas	c
			where	a.nr_titulo_receber	= nr_titulo_w
			and	a.nr_seq_pessoa		= b.nr_sequencia
			and	b.nr_seq_lote		= c.nr_sequencia
			and	coalesce(c.dt_cancelamento::text, '') = '';
			
			if (coalesce(nr_seq_encontro_contas_w::text, '') = '') and (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') and
				(((coalesce(ie_estorno_p,'N') = 'S') and (qt_baixa_w > 0)) or ((coalesce(ie_estorno_p,'N') = 'N') and (qt_liquidacao_w = 0))) then
				
				--verificar se o titulo esta liquidado
				select	coalesce(vl_saldo_titulo, 0),
					dt_liquidacao
				into STRICT	vl_saldo_titulo_w,
					dt_liquidacao_w
				from	titulo_receber
				where	nr_titulo = nr_titulo_w;
				
				if (vl_saldo_titulo_w > 0) and (coalesce(dt_liquidacao_w::text, '') = '') and
					(((coalesce(ie_estorno_p,'N')  = 'N') and (vl_saldo_titulo_w >= vl_total_aceito_w)) or (coalesce(ie_estorno_p,'N')  = 'S')) then
					
					select	coalesce(max(nr_sequencia),0) + 1
					into STRICT	nr_seq_baixa_w
					from	titulo_receber_liq a
					where	a.nr_titulo	= nr_titulo_w;
					
					select	coalesce(max(cd_tipo_receb_aceite),'25'),
						max(nr_seq_trans_fin_aceite)
					into STRICT	cd_tipo_baixa_aceite_w,
						nr_seq_trans_fin_aceite_w
					from	pls_processo_interc_acao
					where	nr_sequencia = nr_seq_acao_interc_p;
					
					select	max(cd_moeda_padrao)
					into STRICT	cd_moeda_padrao_w
					from	parametros_contas_pagar
					where	cd_estabelecimento = cd_estabelecimento_p;
					
					-- Estorno
					if (coalesce(ie_estorno_p,'N') = 'S') then
						vl_total_aceito_w := (vl_total_aceito_w * -1);
					end if;
									
					/* Baixar glosa aceita */

					insert	into titulo_receber_liq(nr_titulo,
						nr_sequencia,
						dt_recebimento,
						vl_recebido,
						vl_descontos,
						vl_juros,
						vl_multa,
						vl_rec_maior,
						cd_moeda,
						dt_atualizacao,
						nm_usuario,
						cd_tipo_recebimento,
						ie_acao,
						cd_serie_nf_devol,
						nr_nota_fiscal_devol,
						cd_banco,
						cd_agencia_bancaria,
						nr_documento,
						nr_lote_banco,
						cd_cgc_emp_cred,
						nr_cartao_cred,
						nr_adiantamento,
						nr_lote_contabil,
						nr_seq_trans_fin,
						vl_glosa,
						ie_lib_caixa,
						vl_perdas,
						ds_observacao,
						vl_nota_credito,
						vl_glosa_ato_coop_princ,
						vl_glosa_ato_coop_aux,
						vl_glosa_ato_nao_coop,
						nr_seq_pls_lote_contest,
						nr_seq_pls_lote_disc,
						ie_origem_baixa)
					values (nr_titulo_w,
						nr_seq_baixa_w,
						dt_baixa_w,
						0,
						0,
						0,
						0,
						0,
						cd_moeda_padrao_w,
						clock_timestamp(),
						nm_usuario_p,
						cd_tipo_baixa_aceite_w,
						'I', 
						null, 
						null, 
						null, 
						null, 
						null, 
						null, 
						null,
						null, 
						null, 
						0, 
						nr_seq_trans_fin_aceite_w, 
						vl_total_aceito_w,
						'S',
						0,
						'Baixa de Glosa realizada conforme finalizacao parcial/total do lote de Contestacao n '||nr_seq_lote_contest_w||'.',
						0,
						0,
						0,
						0,
						nr_seq_lote_contest_w,
						nr_seq_lote_discuss_p,
						'CT');
					
					open C02;
					loop
					fetch C02 into	
						vl_glosa_w,
						ie_ato_cooperado_w;
					EXIT WHEN NOT FOUND; /* apply on C02 */
						begin
						if (ie_ato_cooperado_w = '1') then
							update	titulo_receber_liq
							set	vl_glosa_ato_coop_princ	= coalesce(vl_glosa_ato_coop_princ,0) + vl_glosa_w
							where	nr_titulo 		= nr_titulo_w
							and	nr_sequencia 		= nr_seq_baixa_w;
						elsif (ie_ato_cooperado_w = '2') then
							update	titulo_receber_liq
							set	vl_glosa_ato_coop_aux	= coalesce(vl_glosa_ato_coop_aux,0) + vl_glosa_w
							where	nr_titulo 		= nr_titulo_w
							and	nr_sequencia 		= nr_seq_baixa_w;
						else	
							update 	titulo_receber_liq
							set	vl_glosa_ato_nao_coop	= coalesce(vl_glosa_ato_nao_coop,0) + vl_glosa_w
							where	nr_titulo		= nr_titulo_w
							and	nr_sequencia		= nr_seq_baixa_w;
						end if;
						end;
					end loop;
					close C02;
					
					-- Atualiza saldo do titulo a receber
					CALL atualizar_saldo_tit_rec( nr_titulo_w , nm_usuario_p);
					
					-- Gerar classificacao da baixa
					CALL gerar_titulo_rec_liq_cc( cd_estabelecimento_p, null, nm_usuario_p, nr_titulo_w, nr_seq_baixa_w);
				end if;	
			end if;
		end if;
	end if;
	
	-- Descontar valor de lote de discussao parcial (o parcial 2 e o total mais o parcial 1, por isso este desconto)
	vl_negado_proc_w := coalesce(vl_negado_proc_w,0) - coalesce(vl_negado_proc_parc_w,0);
	vl_negado_mat_w := coalesce(vl_negado_mat_w,0) - coalesce(vl_negado_mat_parc_w,0);
	
	if (vl_negado_proc_w + vl_negado_mat_w > 0) then				/* GLOSA NEGADA */
		vl_total_negado_w	:= vl_negado_proc_w + vl_negado_mat_w;	
		
		if (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') or (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') then
			
			if (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') then
				select	max(a.nr_titulo)
				into STRICT	nr_titulo_w
				from	titulo_receber a
				where	a.nr_seq_ptu_fatura	= nr_seq_ptu_fatura_w;
			
			elsif (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') then
				select	max(nr_titulo),
					max(nr_titulo_ndc)
				into STRICT	nr_titulo_w,
					nr_titulo_ndc_w
				from	pls_fatura
				where	nr_sequencia	= nr_seq_pls_fatura_w;
				
				nr_titulo_w := coalesce(nr_titulo_w,nr_titulo_ndc_w);
			end if;
			
			select	count(1)
			into STRICT	qt_baixa_w
			from	titulo_receber_liq a
			where	a.nr_titulo	= nr_titulo_w;
			
			if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') and
				(((coalesce(ie_estorno_p,'N') = 'S') and (qt_baixa_w > 0)) or (coalesce(ie_estorno_p,'N') = 'N')) then
				
				select	coalesce(max(a.nr_sequencia),0) + 1
				into STRICT	nr_seq_baixa_w
				from	titulo_receber_liq a
				where	a.nr_titulo	= nr_titulo_w;
				
				select	coalesce(max(cd_tipo_receb_rejeicao),'25'),
					max(nr_seq_trans_fin_rejeicao),
					coalesce(max(qt_dias_vencimento),0)
				into STRICT	cd_tipo_baixa_rejeicao_w,
					nr_seq_trans_fin_rejeicao_w,
					qt_dias_vencimento_w
				from	pls_processo_interc_acao
				where	nr_sequencia = nr_seq_acao_interc_p;
				
				select	max(cd_moeda_padrao)
				into STRICT	cd_moeda_padrao_w
				from	parametros_contas_pagar
				where	cd_estabelecimento = cd_estabelecimento_p;
				
				-- Estorno
				if (coalesce(ie_estorno_p,'N') = 'S') then
					vl_total_negado_w := (vl_total_negado_w * -1);
				end if;
				
				select	coalesce(vl_saldo_titulo, 0),
					dt_liquidacao
				into STRICT	vl_saldo_titulo_w,
					dt_liquidacao_w
				from	titulo_receber
				where	nr_titulo = nr_titulo_w;
				
				select	max(c.nr_sequencia)
				into STRICT	nr_seq_encontro_contas_w
				from	encontro_contas_item	a,
					pessoa_encontro_contas	b,
					lote_encontro_contas	c
				where	a.nr_titulo_receber	= nr_titulo_w
				and	a.nr_seq_pessoa		= b.nr_sequencia
				and	b.nr_seq_lote		= c.nr_sequencia
				and	coalesce(c.dt_cancelamento::text, '') = '';
				
				--verifica se o titulo ja nao esta liquidado
				if (coalesce(nr_seq_encontro_contas_w::text, '') = '') and (vl_saldo_titulo_w > 0) and (coalesce(dt_liquidacao_w::text, '') = '') then
					
					if (coalesce(ie_estorno_p,'N')  = 'N') and (vl_saldo_titulo_w <= vl_total_negado_w) then
						CALL gerar_comunic_padrao(	clock_timestamp(), substr('Problema na baixa de contestacao do titulo '||nr_titulo_w,1,255),
									substr('A baixa do titulo deveria ser R$ '||vl_total_negado_w||' e esta sendo RS '||vl_saldo_titulo_w||', favor verificar com financeiro.',1,4000),
									'Tasy', 'N', nm_usuario_p, 'N', null, null, null, null, clock_timestamp(), null, null);
						vl_total_negado_w := vl_saldo_titulo_w;
					end if;
					
					/* Baixar glosa negada */

					insert	into titulo_receber_liq(nr_titulo,
						nr_sequencia,
						dt_recebimento,
						vl_recebido,
						vl_descontos,
						vl_juros,
						vl_multa,
						vl_rec_maior,
						cd_moeda,
						dt_atualizacao,
						nm_usuario,
						cd_tipo_recebimento,
						ie_acao,
						cd_serie_nf_devol,
						nr_nota_fiscal_devol,
						cd_banco,
						cd_agencia_bancaria,
						nr_documento,
						nr_lote_banco,
						cd_cgc_emp_cred,
						nr_cartao_cred,
						nr_adiantamento,
						nr_lote_contabil,
						nr_seq_trans_fin,
						vl_glosa,
						ie_lib_caixa,
						vl_perdas,
						ds_observacao,
						vl_nota_credito,
						vl_glosa_ato_coop_princ,
						vl_glosa_ato_coop_aux,
						vl_glosa_ato_nao_coop,
						nr_seq_pls_lote_contest,
						nr_seq_pls_lote_disc,
						ie_origem_baixa)
					values (nr_titulo_w,
						nr_seq_baixa_w,
						dt_baixa_w,
						0,
						0,
						0,
						0,
						0,
						cd_moeda_padrao_w,
						clock_timestamp(),
						nm_usuario_p,
						cd_tipo_baixa_rejeicao_w,
						'I', 
						null, 
						null, 
						null, 
						null, 
						null, 
						null, 
						null,
						null, 
						null, 
						0, 
						nr_seq_trans_fin_rejeicao_w, 
						vl_total_negado_w,
						'S',
						0,
						'Baixa de Glosa realizada conforme finalizacao parcial/total do lote de Contestacao n '||nr_seq_lote_contest_w||'.',
						0,
						0,
						0,
						0,
						nr_seq_lote_contest_w,
						nr_seq_lote_discuss_p,
						'CT');
					
					open C01;
					loop
					fetch C01 into	
						vl_glosa_w,
						ie_ato_cooperado_w;
					EXIT WHEN NOT FOUND; /* apply on C01 */
						begin
						if (ie_ato_cooperado_w = '1') then
							update	titulo_receber_liq
							set	vl_glosa_ato_coop_princ	= coalesce(vl_glosa_ato_coop_princ,0) + vl_glosa_w
							where	nr_titulo 		= nr_titulo_w
							and	nr_sequencia 		= nr_seq_baixa_w;
						elsif (ie_ato_cooperado_w = '2') then
							update	titulo_receber_liq
							set	vl_glosa_ato_coop_aux	= coalesce(vl_glosa_ato_coop_aux,0) + vl_glosa_w
							where	nr_titulo 		= nr_titulo_w
							and	nr_sequencia 		= nr_seq_baixa_w;
						else	
							update 	titulo_receber_liq
							set	vl_glosa_ato_nao_coop	= coalesce(vl_glosa_ato_nao_coop,0) + vl_glosa_w
							where	nr_titulo		= nr_titulo_w
							and	nr_sequencia		= nr_seq_baixa_w;
						end if;
						end;
					end loop;
					close C01;
					
					-- Atualiza saldo do titulo a receber
					CALL atualizar_saldo_tit_rec( nr_titulo_w , nm_usuario_p);
					
					-- Gerar classificacao da baixa
					CALL gerar_titulo_rec_liq_cc( cd_estabelecimento_p, null, nm_usuario_p, nr_titulo_w, nr_seq_baixa_w);
				end if;
				
				-- Estorno
				if (coalesce(ie_estorno_p,'N') = 'N') and (coalesce(nr_seq_pls_fatura_w::text, '') = '') then
					
					/* Obter as informacoes direto do titulo anterior */
	
					select	max(cd_cgc),
						max(cd_estabelecimento),
						max(cd_moeda),
						max(cd_portador),
						max(cd_tipo_portador),
						max(cd_tipo_taxa_juro),
						max(cd_tipo_taxa_multa),
						max(tx_juros),
						max(tx_multa)
					into STRICT	cd_cgc_w,
						cd_estabelecimento_w,
						cd_moeda_w,
						cd_portador_w,
						cd_tipo_portador_w,
						cd_tipo_taxa_juro_w,
						cd_tipo_taxa_multa_w,
						pr_juro_padrao_w,
						pr_multa_padrao_w
					from	titulo_receber
					where	nr_titulo = nr_titulo_w;
					
					select	nextval('titulo_seq')
					into STRICT	nr_titulo_receber_w
					;	
						
					dt_vencimento_w := trunc(clock_timestamp() + qt_dias_vencimento_w,'dd');
						
					insert	into titulo_receber		/* GERAR TITUTLO A RECEBER */
						(cd_cgc,
						cd_estabelecimento,
						cd_moeda,
						cd_portador,
						cd_tipo_portador,
						cd_tipo_taxa_juro,
						cd_tipo_taxa_multa,
						dt_atualizacao,
						dt_emissao,
						dt_pagamento_previsto,
						dt_vencimento,
						ie_origem_titulo,
						ie_situacao,
						ie_tipo_emissao_titulo,
						ie_tipo_inclusao,
						ie_tipo_titulo,
						nm_usuario,
						nr_titulo,
						tx_desc_antecipacao,
						tx_juros,
						tx_multa,
						vl_saldo_juros,
						vl_saldo_multa,
						vl_saldo_titulo,
						vl_titulo,
						nr_seq_pls_lote_contest,
						ds_observacao_titulo,
						nr_documento,
						nr_lote_contabil,
						nm_usuario_orig,
						dt_inclusao,
						nr_seq_ptu_fatura)
					values (cd_cgc_w,
						cd_estabelecimento_w,
						cd_moeda_w,
						cd_portador_w,
						cd_tipo_portador_w,
						cd_tipo_taxa_juro_w,
						cd_tipo_taxa_multa_w,
						clock_timestamp(),
						trunc(clock_timestamp(),'dd'),
						dt_vencimento_w,
						dt_vencimento_w,
						'11', --Contestacao
						'1',
						1,
						'2',
						'13', --Nota a receber (credito/debito)
						nm_usuario_p,
						nr_titulo_receber_w,
						0,
						pr_juro_padrao_w,
						pr_multa_padrao_w,
						0,
						0,
						vl_total_negado_w,
						vl_total_negado_w,
						nr_seq_lote_contest_w,
						'Titulo gerado pela funcao OPS - Controle de Contestacoes e Recursos de Glosa, no fechamento da discussao.',
						nr_titulo_receber_w,
						0,
						nm_usuario_p,
						clock_timestamp(),
						nr_seq_ptu_fatura_w);				
					
					update	pls_lote_discussao
					set	nr_titulo_receber	= nr_titulo_receber_w
					where	nr_sequencia		= nr_seq_lote_discuss_p;
					
					-- Gerar classificacao do titulo
					CALL pls_gerar_tit_rec_class_disc( nr_titulo_w, nm_usuario_p, 'N');
				else
					select	max(nr_titulo_receber)
					into STRICT	nr_titulo_receber_w
					from	pls_lote_discussao
					where	nr_sequencia	= nr_seq_lote_discuss_p;
					
					if (nr_titulo_receber_w IS NOT NULL AND nr_titulo_receber_w::text <> '') then
						CALL cancelar_titulo_receber(nr_titulo_receber_w,nm_usuario_p,'N',clock_timestamp());
						
						update	pls_lote_discussao
						set	nr_titulo_receber  = NULL
						where	nr_sequencia = nr_seq_lote_discuss_p;
					end if;
				end if;
			end if;
		end if;
	end if;
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baixar_glosas_discuss_rec ( nr_seq_lote_discuss_p pls_lote_discussao.nr_sequencia%type, nr_seq_acao_interc_p pls_processo_interc_acao.nr_sequencia%type, ie_estorno_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

