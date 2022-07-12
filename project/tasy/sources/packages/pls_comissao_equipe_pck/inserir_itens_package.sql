-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_comissao_equipe_pck.inserir_itens (nr_seq_lote_p pls_lote_comissao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, dt_referencia_p pls_lote_comissao.dt_referencia%type) AS $body$
DECLARE

		
nr_seq_meta_comissao_w		pls_equipe_meta_comissao.nr_sequencia%type;
qt_idade_w			pls_comissao_equipe_temp.qt_idade%type;
ie_acao_contrato_w		pls_comissao_equipe_temp.ie_acao_contrato%type;
qt_plano_sca_w			integer;
dt_contratacao_w		timestamp;
dt_contrato_w			timestamp;
nr_seq_portabilidade_w		pls_portab_pessoa.nr_sequencia%type;
nr_seq_motivo_inclusao_w	pls_motivo_inclusao_seg.nr_sequencia%type;
nr_seq_tipo_comissao_w		pls_tipo_comissao_contrato.nr_sequencia%type;
current_setting('pls_comissao_equipe_pck.qt_vidas_w')::bigint			bigint;
ie_meta_w			varchar(1);
nr_seq_grupo_contrato_w		pls_grupo_contrato.nr_sequencia%type;
tx_sinistralidade_w		double precision;
tx_resultado_w			pls_prog_reaj_coletivo.tx_resultado_grupo%type;
vl_receita_w			double precision;
vl_custo_w			double precision;
dt_inicio_sinistralidade_w	timestamp;
dt_fim_sinistralidade_w		timestamp;
dt_contrato_fomento_inicial_w	timestamp;
dt_contrato_fomento_final_w	timestamp;
qt_vidas_fomento_w		bigint;
dt_base_contrato_fomento_w	timestamp;

current_setting('pls_comissao_equipe_pck.c01')::CURSOR CURSOR FOR
	SELECT	a.nr_seq_segurado_mens nr_seq_mensalidade_seg,
		a.nr_seq_meta_atingir,
		b.nr_sequencia nr_seq_comissao,
		a.nr_seq_segurado,
		a.nr_sequencia nr_seq_comissao_benef,
		(	SELECT	max(pv.nr_seq_classif_canal)
			from	pls_vendedor	pv
			where	pv.nr_sequencia	= b.nr_seq_canal_venda) nr_seq_classif_canal,
		b.nr_seq_canal_venda
	from	pls_comissao_beneficiario a,
		pls_comissao b
	where	b.nr_sequencia = a.nr_seq_comissao
	and	b.nr_seq_lote = nr_seq_lote_p
	order by
		b.nr_sequencia asc;

current_setting('pls_comissao_equipe_pck.c02')::CURSOR( CURSOR(	nr_seq_mensalidade_seg_pc	pls_mensalidade_segurado.nr_sequencia%type) FOR
	SELECT	a.ie_tipo_item,
		b.nr_parcela,
		b.nr_parcela_contrato,
		b.nr_seq_contrato,
		a.nr_sequencia nr_seq_item_mens,
		b.nr_seq_plano,
		a.nr_seq_bonificacao_vinculo,
		a.vl_item,
		b.nr_seq_segurado_preco,
		c.nr_seq_vinculo_sca,
		c.nr_seq_segurado_preco nr_seq_segurado_preco_origem,
		(	SELECT 	max(pp.ie_coparticipacao)
			from	pls_plano	pp
			where	pp.nr_sequencia = b.nr_seq_plano) ie_coparticipacao,
		d.nr_seq_forma_cobranca,
		b.nr_seq_segurado,
		c.nr_parcela nr_parcela_sca
	FROM pls_mensalidade d, pls_mensalidade_segurado b, pls_mensalidade_seg_item a
LEFT OUTER JOIN pls_mensalidade_sca c ON (a.nr_sequencia = c.nr_seq_item_mens)
WHERE b.nr_sequencia = a.nr_seq_mensalidade_seg  and d.nr_sequencia = b.nr_seq_mensalidade and b.nr_sequencia = nr_seq_mensalidade_seg_pc order by
		b.nr_sequencia;
	
current_setting('pls_comissao_equipe_pck.c03')::CURSOR( CURSOR(	nr_seq_meta_atingir_pc	pls_equipe_meta_atingir.nr_sequencia%type,
		qt_idade_pc		bigint,
		nr_parcela_pc		pls_mensalidade_segurado.nr_parcela%type,
		nr_parcela_contrato_pc	pls_mensalidade_segurado.nr_parcela_contrato%type,
		dt_contratacao_pc	pls_segurado.dt_contratacao%type,
		dt_contrato_pc		pls_contrato.dt_contrato%type) FOR
	SELECT	a.nr_sequencia nr_seq_meta_comissao,
		coalesce(a.pr_comissao,0) pr_comissao,
		coalesce(a.vl_comissao,0) vl_comissao,
		a.ie_vl_integral_1_parcela,
		a.ie_tipo_item_mensalidade,
		a.ie_acao_contrato,
		a.ie_portabilidade,
		a.nr_seq_motivo_inclusao,
		a.nr_seq_tipo_comissao,
		a.nr_seq_contrato,
		a.nr_seq_plano_sca,
		coalesce(a.ie_coparticipacao, 'A') ie_coparticipacao,
		a.nr_seq_forma_cobranca,
		a.nr_seq_classif_canal,
		a.qt_vidas_inicial,
		a.qt_vidas_final,
		coalesce(a.ie_tipo_meta_vidas,'N') ie_tipo_meta_vidas,
		a.qt_periodo_sinistralidade,
		a.ie_base_sinistralidade,
		a.pr_sinistralidade_inicial,
		a.pr_sinistralidade_final,
		a.nr_parcela_inicial_sca,
		a.nr_parcela_final_sca,
		a.qt_meses_fomento_inicial,
		a.qt_meses_fomento_final,
		a.qt_vidas_fomento_inicial,
		a.qt_vidas_fomento_final,
		a.ie_base_fomento
	from	pls_equipe_meta_comissao	a,
		pls_equipe_meta_atingir		b
	where	a.nr_seq_meta_atingir = b.nr_sequencia
	and	b.nr_sequencia = nr_seq_meta_atingir_pc
	and	qt_idade_pc between coalesce(a.qt_idade_inicial,qt_idade_pc) and coalesce(a.qt_idade_final,qt_idade_pc)
	and	nr_parcela_pc between coalesce(a.nr_parcela_inicial,nr_parcela_pc) and coalesce(a.nr_parcela_final,nr_parcela_pc)
	and	nr_parcela_contrato_pc between coalesce(a.nr_parcela_contr_inicial,nr_parcela_contrato_pc) and coalesce(a.nr_parcela_contr_final,nr_parcela_contrato_pc)
	and 	dt_contratacao_pc between coalesce(a.dt_adesao_inicial,dt_contratacao_pc) and coalesce(a.dt_adesao_final,dt_contratacao_pc)
	and	dt_contrato_pc between coalesce(a.dt_contrato_inicial, dt_contrato_pc) and coalesce(a.dt_contrato_final,dt_contrato_pc)
	order by 
		coalesce(a.nr_seq_contrato, '0'),
		coalesce(a.nr_seq_plano_sca, '0'),
		coalesce(a.ie_acao_contrato, ' '),
		coalesce(a.qt_idade_inicial, '0'),
		coalesce(a.qt_idade_final, '0'),
		coalesce(a.nr_parcela_inicial, '0'),
		coalesce(a.nr_parcela_final, '0'),
		coalesce(a.nr_parcela_contr_inicial, '0'),
		coalesce(a.nr_parcela_contr_final, '0'),
		coalesce(a.ie_tipo_item_mensalidade, '0'),
		coalesce(a.ie_portabilidade, ' '),
		coalesce(a.nr_seq_motivo_inclusao, '0'),
		coalesce(a.nr_seq_tipo_comissao, '0'),
		coalesce(a.ie_coparticipacao, ' '),
		coalesce(a.nr_seq_forma_cobranca, '0'),
		coalesce(a.nr_seq_classif_canal, '0'),
		coalesce(a.qt_vidas_inicial, '0'),
		coalesce(a.qt_vidas_final, '0'),
		coalesce(a.ie_tipo_meta_vidas, ' '),
		coalesce(a.qt_periodo_sinistralidade, '0'),
		dt_contrato_inicial desc,
		dt_contrato_final desc,
		dt_adesao_inicial desc,
		dt_adesao_final desc;
BEGIN

limpar_vetor_itens;

for r_c01_w in current_setting('pls_comissao_equipe_pck.c01')::loop CURSOR
	begin
	select	max(ie_acao_contrato),
		max(qt_idade),
		max(nr_seq_portabilidade),
		max(nr_seq_motivo_inclusao),
		max(nr_seq_tipo_comissao),
		max(dt_contratacao),
		max(dt_contrato)
	into STRICT	ie_acao_contrato_w,
		qt_idade_w,
		nr_seq_portabilidade_w,
		nr_seq_motivo_inclusao_w,
		nr_seq_tipo_comissao_w,
		dt_contratacao_w,
		dt_contrato_w
	from	pls_comissao_equipe_temp
	where	nr_seq_segurado = r_c01_w.nr_seq_segurado
	and	nr_seq_mensalidade_seg = r_c01_w.nr_seq_mensalidade_seg
	and	nr_seq_comissao = r_c01_w.nr_seq_comissao;
	
	for r_c02_w in current_setting('pls_comissao_equipe_pck.c02')::CURSOR( (r_c01_w.nr_seq_mensalidade_seg) loop
		begin
		
		nr_seq_meta_comissao_w	:= null;
		
		for r_c03_w in current_setting('pls_comissao_equipe_pck.c03')::CURSOR( (	r_c01_w.nr_seq_meta_atingir, qt_idade_w, r_c02_w.nr_parcela,
					r_c02_w.nr_parcela_contrato, dt_contratacao_w, dt_contrato_w) loop
			begin
			if	((coalesce(r_c03_w.ie_tipo_item_mensalidade::text, '') = '') or (pls_obter_se_item_lista(r_c03_w.ie_tipo_item_mensalidade, r_c02_w.ie_tipo_item) = 'S')) and
				((coalesce(r_c03_w.ie_acao_contrato::text, '') = '') or (pls_obter_se_item_lista(r_c03_w.ie_acao_contrato, ie_acao_contrato_w) = 'S')) and
				((coalesce(r_c03_w.ie_portabilidade,'N') = 'S' and (nr_seq_portabilidade_w IS NOT NULL AND nr_seq_portabilidade_w::text <> '')) or (coalesce(r_c03_w.ie_portabilidade,'N') = 'N')) and
				((r_c03_w.nr_seq_motivo_inclusao = nr_seq_motivo_inclusao_w) or (coalesce(r_c03_w.nr_seq_motivo_inclusao::text, '') = '')) and
				((r_c03_w.nr_seq_tipo_comissao = nr_seq_tipo_comissao_w) or (coalesce(r_c03_w.nr_seq_tipo_comissao::text, '') = '')) and
				((r_c03_w.nr_seq_contrato = r_c02_w.nr_seq_contrato) or (coalesce(r_c03_w.nr_seq_contrato::text, '') = '')) and
				((r_c03_w.ie_coparticipacao = 'A') or (coalesce(r_c02_w.ie_coparticipacao, 'N') = r_c03_w.ie_coparticipacao)) and
				((r_c03_w.nr_seq_forma_cobranca = r_c02_w.nr_seq_forma_cobranca) or (coalesce(r_c03_w.nr_seq_forma_cobranca::text, '') = '')) and
				((r_c03_w.nr_seq_classif_canal = r_c01_w.nr_seq_classif_canal) or (coalesce(r_c03_w.nr_seq_classif_canal::text, '') = '')) then
				
				ie_meta_w		:= 'S';
				PERFORM set_config('pls_comissao_equipe_pck.qt_vidas_w', null, false);
				qt_vidas_fomento_w 	:= null;
				
				if	((r_c03_w.qt_vidas_inicial IS NOT NULL AND r_c03_w.qt_vidas_inicial::text <> '') or (r_c03_w.qt_vidas_final IS NOT NULL AND r_c03_w.qt_vidas_final::text <> '')) then
					if (r_c03_w.ie_tipo_meta_vidas = 'C') then
						PERFORM set_config('pls_comissao_equipe_pck.qt_vidas_w', pls_obter_quantidade_vidas(r_c02_w.nr_seq_segurado,'T','C'), false);
					elsif (r_c03_w.ie_tipo_meta_vidas = 'G') then
						nr_seq_grupo_contrato_w		:= pls_dados_grupo_relac_contr(r_c02_w.nr_seq_contrato,'S');
						
						if (nr_seq_grupo_contrato_w IS NOT NULL AND nr_seq_grupo_contrato_w::text <> '') then
							PERFORM set_config('pls_comissao_equipe_pck.qt_vidas_w', pls_obter_qt_vidas_grupo_relac(nr_seq_grupo_contrato_w,current_setting('pls_comissao_equipe_pck.dt_referencia_fim_w')::timestamp), false);
						end if;
					end if;
					
					if (current_setting('pls_comissao_equipe_pck.qt_vidas_w')::(bigint IS NOT NULL AND bigint::text <> '')) then
						if (current_setting('pls_comissao_equipe_pck.qt_vidas_w')::bigint not between coalesce(r_c03_w.qt_vidas_inicial, current_setting('pls_comissao_equipe_pck.qt_vidas_w')::bigint) and coalesce(r_c03_w.qt_vidas_final, current_setting('pls_comissao_equipe_pck.qt_vidas_w')::bigint)) then
							ie_meta_w	:= 'N';
						end if;
					end if;
				end if;
				
				if	((r_c03_w.nr_parcela_inicial_sca IS NOT NULL AND r_c03_w.nr_parcela_inicial_sca::text <> '') or (r_c03_w.nr_parcela_final_sca IS NOT NULL AND r_c03_w.nr_parcela_final_sca::text <> '') or (r_c03_w.nr_seq_plano_sca IS NOT NULL AND r_c03_w.nr_seq_plano_sca::text <> '')) then
					select	count(1)
					into STRICT	qt_plano_sca_w
					from	pls_sca_vinculo
					where	nr_sequencia = r_c02_w.nr_seq_vinculo_sca
					and	((nr_seq_plano = r_c03_w.nr_seq_plano_sca) or (coalesce(r_c03_w.nr_seq_plano_sca::text, '') = ''))
					and	r_c02_w.nr_parcela_sca between coalesce(r_c03_w.nr_parcela_inicial_sca, r_c02_w.nr_parcela_sca) and coalesce(r_c03_w.nr_parcela_final_sca, r_c02_w.nr_parcela_sca);

					if (qt_plano_sca_w = 0) then
						ie_meta_w	:= 'N';
					end if;
				end if;
				
				if (r_c03_w.qt_periodo_sinistralidade IS NOT NULL AND r_c03_w.qt_periodo_sinistralidade::text <> '') then
					dt_inicio_sinistralidade_w	:= add_months(dt_referencia_p, -r_c03_w.qt_periodo_sinistralidade);
					dt_fim_sinistralidade_w		:= add_months(current_setting('pls_comissao_equipe_pck.dt_referencia_fim_w')::timestamp, -1);
					
					if (r_c03_w.ie_base_sinistralidade = 0) then
						if (r_c02_w.nr_seq_contrato IS NOT NULL AND r_c02_w.nr_seq_contrato::text <> '') then
							SELECT * FROM pls_ar_gerar_resultado_pck.obter_sinistralidade(r_c02_w.nr_seq_contrato, null, null, null, dt_inicio_sinistralidade_w, dt_fim_sinistralidade_w, current_setting('pls_comissao_equipe_pck.ie_remido_sinist_reaj_w')::pls_parametros.ie_remido_sinistralidade_reaj%type, cd_estabelecimento_p, tx_sinistralidade_w, tx_resultado_w, vl_receita_w, vl_custo_w) INTO STRICT tx_sinistralidade_w, tx_resultado_w, vl_receita_w, vl_custo_w;
						end if;
					elsif (r_c03_w.ie_base_sinistralidade = 1) then
						nr_seq_grupo_contrato_w		:= pls_dados_grupo_relac_contr(r_c02_w.nr_seq_contrato,'S');
						
						if (nr_seq_grupo_contrato_w IS NOT NULL AND nr_seq_grupo_contrato_w::text <> '') then
							SELECT * FROM pls_ar_gerar_resultado_pck.obter_sinistralidade(null, null, nr_seq_grupo_contrato_w, null, dt_inicio_sinistralidade_w, dt_fim_sinistralidade_w, current_setting('pls_comissao_equipe_pck.ie_remido_sinist_reaj_w')::pls_parametros.ie_remido_sinistralidade_reaj%type, cd_estabelecimento_p, tx_sinistralidade_w, tx_resultado_w, vl_receita_w, vl_custo_w) INTO STRICT tx_sinistralidade_w, tx_resultado_w, vl_receita_w, vl_custo_w;
						end if;
					elsif (r_c03_w.ie_base_sinistralidade = 2) then
						SELECT * FROM pls_ar_gerar_resultado_pck.obter_sinistralidade(null, null, null, r_c01_w.nr_seq_canal_venda, dt_inicio_sinistralidade_w, dt_fim_sinistralidade_w, current_setting('pls_comissao_equipe_pck.ie_remido_sinist_reaj_w')::pls_parametros.ie_remido_sinistralidade_reaj%type, cd_estabelecimento_p, tx_sinistralidade_w, tx_resultado_w, vl_receita_w, vl_custo_w) INTO STRICT tx_sinistralidade_w, tx_resultado_w, vl_receita_w, vl_custo_w;
					end if;
					
					if (tx_sinistralidade_w not between coalesce(r_c03_w.pr_sinistralidade_inicial, tx_sinistralidade_w) and coalesce(r_c03_w.pr_sinistralidade_final, tx_sinistralidade_w)) then
						ie_meta_w	:= 'N';
					end if;
				end if;

				if	(r_c03_w.qt_meses_fomento_inicial IS NOT NULL AND r_c03_w.qt_meses_fomento_inicial::text <> '' AND r_c03_w.qt_meses_fomento_final IS NOT NULL AND r_c03_w.qt_meses_fomento_final::text <> '') then
					dt_base_contrato_fomento_w	:= null;
					
					if (r_c03_w.ie_base_fomento = 1) then
						nr_seq_grupo_contrato_w		:= pls_dados_grupo_relac_contr(r_c02_w.nr_seq_contrato,'S');
						
						if (nr_seq_grupo_contrato_w IS NOT NULL AND nr_seq_grupo_contrato_w::text <> '') then
							select	min(dt_contrato)
							into STRICT	dt_base_contrato_fomento_w
							from (SELECT	b.dt_contrato
								from	pls_contrato_grupo a,
									pls_contrato b
								where	b.nr_sequencia = a.nr_seq_contrato
								and	a.nr_seq_grupo = nr_seq_grupo_contrato_w) alias2;
						end if;
					else
						dt_base_contrato_fomento_w	:= dt_contrato_w;
					end if;
					
					if (dt_base_contrato_fomento_w IS NOT NULL AND dt_base_contrato_fomento_w::text <> '') then
						dt_contrato_fomento_inicial_w	:= trunc(add_months(dt_base_contrato_fomento_w, r_c03_w.qt_meses_fomento_inicial), 'mm');
						dt_contrato_fomento_final_w	:= fim_mes(add_months(dt_base_contrato_fomento_w, r_c03_w.qt_meses_fomento_final));

						if (dt_referencia_p between dt_contrato_fomento_inicial_w and dt_contrato_fomento_final_w) then
							if (r_c03_w.ie_base_fomento = 0) then
								select	count(1)
								into STRICT	qt_vidas_fomento_w
								from	pls_segurado
								where	coalesce(dt_cancelamento::text, '') = ''
								and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
								and	nr_seq_contrato = r_c02_w.nr_seq_contrato
								and	dt_contratacao between dt_contrato_fomento_inicial_w and dt_contrato_fomento_final_w;
							elsif (r_c03_w.ie_base_fomento = 1) then
								select	count(1)
								into STRICT	qt_vidas_fomento_w
								from	pls_segurado a
								where	coalesce(a.dt_cancelamento::text, '') = ''
								and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
								and	a.dt_contratacao between dt_contrato_fomento_inicial_w and dt_contrato_fomento_final_w
								and	exists (SELECT	1
										from	pls_contrato_grupo x
										where	x.nr_seq_grupo = nr_seq_grupo_contrato_w
										and	x.nr_seq_contrato = a.nr_seq_contrato);
							end if;
							
							if (qt_vidas_fomento_w not between coalesce(r_c03_w.qt_vidas_fomento_inicial, qt_vidas_fomento_w) and coalesce(r_c03_w.qt_vidas_fomento_final, qt_vidas_fomento_w)) then
								ie_meta_w	:= 'N';
							end if;
						else
							ie_meta_w 	:= 'N';
						end if;
					else
						ie_meta_w 	:= 'N';
					end if;
				end if;
				
				if (ie_meta_w = 'S') then
					nr_seq_meta_comissao_w		:= r_c03_w.nr_seq_meta_comissao;
					PERFORM set_config('pls_comissao_equipe_pck.pr_comissao_w', r_c03_w.pr_comissao, false);
					PERFORM set_config('pls_comissao_equipe_pck.vl_comissao_w', r_c03_w.vl_comissao, false);
					PERFORM set_config('pls_comissao_equipe_pck.ie_vl_integral_1_parcela_w', r_c03_w.ie_vl_integral_1_parcela, false);
				end if;
			end if;
			end;
		end loop;
		
		if (nr_seq_meta_comissao_w IS NOT NULL AND nr_seq_meta_comissao_w::text <> '') then			
			CALL pls_comissao_equipe_pck.setar_valor_dados_item(	r_c02_w.ie_tipo_item, r_c02_w.nr_seq_vinculo_sca, r_c02_w.nr_seq_plano,
						r_c02_w.nr_parcela, r_c02_w.vl_item, r_c02_w.nr_seq_segurado_preco_origem,
						r_c02_w.nr_seq_segurado_preco, r_c02_w.nr_seq_bonificacao_vinculo);

			current_setting('pls_comissao_equipe_pck.tb_pr_comissao_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)		:= current_setting('pls_comissao_equipe_pck.pr_comissao_w')::pls_equipe_meta_comissao.pr_comissao%type;
			current_setting('pls_comissao_equipe_pck.tb_vl_comissao_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)		:= current_setting('pls_comissao_equipe_pck.vl_comissao_w')::pls_equipe_meta_comissao.vl_comissao%type;
			current_setting('pls_comissao_equipe_pck.tb_nr_seq_regra_meta_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)	:= nr_seq_meta_comissao_w;
			current_setting('pls_comissao_equipe_pck.tb_nr_seq_comissao_benef_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)	:= r_c01_w.nr_seq_comissao_benef;
			current_setting('pls_comissao_equipe_pck.tb_ie_tipo_item_w')::pls_util_cta_pck.t_varchar2_table_2(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)		:= r_c02_w.ie_tipo_item;
			current_setting('pls_comissao_equipe_pck.tb_nr_seq_item_mens_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)	:= r_c02_w.nr_seq_item_mens;
			current_setting('pls_comissao_equipe_pck.tb_nr_seq_plano_item_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)	:= current_setting('pls_comissao_equipe_pck.nr_seq_plano_w')::pls_plano.nr_sequencia%type;
			current_setting('pls_comissao_equipe_pck.tb_nr_seq_sca_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)		:= current_setting('pls_comissao_equipe_pck.nr_seq_plano_sca_w')::pls_plano.nr_sequencia%type;
			current_setting('pls_comissao_equipe_pck.tb_nr_seq_bonificacao_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)	:= current_setting('pls_comissao_equipe_pck.nr_seq_bonificacao_w')::pls_bonificacao.nr_sequencia%type;
			current_setting('pls_comissao_equipe_pck.tb_vl_item_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)		:= current_setting('pls_comissao_equipe_pck.vl_item_w')::pls_mensalidade_seg_item.vl_item%type;
			current_setting('pls_comissao_equipe_pck.tb_ie_sca_embutido_w')::pls_util_cta_pck.t_varchar2_table_1(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)	:= current_setting('pls_comissao_equipe_pck.ie_sca_embutido_w')::varchar(1);
			current_setting('pls_comissao_equipe_pck.tb_vl_origem_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)		:= current_setting('pls_comissao_equipe_pck.vl_origem_w')::pls_comissao_benef_item.vl_origem%type;
			current_setting('pls_comissao_equipe_pck.tb_vl_comissao_venda_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer)	:= current_setting('pls_comissao_equipe_pck.vl_comissao_venda_w')::pls_comissao_benef_item.vl_comissao%type;
			current_setting('pls_comissao_equipe_pck.tb_nr_seq_regra_equipe_sup_w')::pls_util_cta_pck.t_number_table(current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer) := null;

			if (current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer >= pls_util_pck.qt_registro_transacao_w) then
				CALL pls_comissao_equipe_pck.inserir_dados_comissao_itens(nm_usuario_p);
			else
				PERFORM set_config('pls_comissao_equipe_pck.nr_indice_itens_comissao_w', current_setting('pls_comissao_equipe_pck.nr_indice_itens_comissao_w')::integer + 1, false);
			end if;
		end if;
		end;
	end loop;
	
	end;
end loop;

CALL pls_comissao_equipe_pck.inserir_dados_comissao_itens(nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_comissao_equipe_pck.inserir_itens (nr_seq_lote_p pls_lote_comissao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, dt_referencia_p pls_lote_comissao.dt_referencia%type) FROM PUBLIC;
