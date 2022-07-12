-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_itens_sca_pck.gerar_sca ( nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, qt_idade_p pls_mensalidade_segurado.qt_idade%type, ie_tipo_estipulante_p pls_mensalidade_segurado.ie_tipo_estipulante%type, nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, dt_referencia_lote_p pls_lote_mensalidade.dt_mesano_referencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_contratacao_p pls_segurado.dt_contratacao%type, dt_rescisao_p pls_segurado.dt_rescisao%type, dt_reativacao_p pls_segurado.dt_reativacao%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, ie_mensalidade_proporcional_p pls_segurado.ie_mensalidade_proporcional%type, ie_titularidade_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_pce_proporcional_p pls_mensalidade_segurado.ie_pce_proporcional%type, dt_inclusao_pce_p pls_segurado.dt_inclusao_pce%type, ie_reativacao_proporcional_p pls_mensalidade_segurado.ie_reativacao_proporcional%type, dt_rescisao_ant_p pls_segurado.dt_rescisao_ant%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_sca_benef_w			integer;
ie_gerar_sca_w			varchar(1);
qt_regra_limite_sca_w		integer;
qt_parcela_sca_w		integer;
cd_motivo_reajuste_w		pls_segurado_preco_origem.cd_motivo_reajuste%type;
tx_proporcional_mens_w		double precision;
qt_dias_w			integer;
dt_ultimo_dia_mes_w		integer;

ie_pce_proporcional_w		varchar(1);
ie_lancamento_mensalidade_w	pls_sca_vinculo.ie_lancamento_mensalidade%type;
dt_referencia_w			pls_mensalidade_segurado.dt_mesano_referencia%type;
qt_sca_mes_w			integer;
nr_parcela_sca_w		bigint;
dt_inicio_cobertura_w		pls_mensalidade_seg_item.dt_inicio_cobertura%type;
dt_fim_cobertura_w		pls_mensalidade_seg_item.dt_fim_cobertura%type;
ie_rescisao_proporcional_w	varchar(1);
nr_indice_preco_pre_w		integer;
nr_indice_preco_reaj_w		integer;

nr_seq_segurado_preco_w		pls_segurado_preco_origem.nr_sequencia%type;
vl_preco_sca_w			pls_segurado_preco_origem.vl_preco_atual%type;
vl_reajuste_indice_w		pls_segurado_preco_origem.vl_preco_atual%type;
nr_seq_reajuste_preco_w		pls_segurado_preco_origem.nr_seq_reajuste_preco%type;
ds_observacao_w			pls_mensalidade_seg_item.ds_observacao%type;
ie_inseriu_item_w		varchar(1);

nr_seq_regra_limite_w		pls_regra_mens_contrato.nr_sequencia%type;
ie_agrupar_valor_lim_w		pls_regra_mens_contrato.ie_agrupar_valor%type;
qt_dias_vencimento_w		pls_regra_mens_contrato.qt_dias_vencimento%type;
ie_primeira_mensalidade_w	pls_regra_mens_contrato.ie_primeira_mensalidade%type;
ie_data_base_adesao_w		pls_regra_mens_contrato.ie_data_base_adesao%type;
ie_sca_proporcional_w		varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_plano,
		coalesce(a.ie_embutido_produto,'N') ie_embutido_produto,
		a.ie_lancamento_mensalidade,
		coalesce(b.ie_lancamento_mensalidade,'D') ie_lancamento_mens_plano,
		a.nr_seq_pagador,
		a.dt_inicio_vigencia dt_adesao_sca,
		coalesce(a.dt_fim_vigencia,dt_rescisao_p) dt_rescisao_sca,
		coalesce(b.qt_idade_min_sca,qt_idade_p) qt_idade_min_sca,
		coalesce(b.qt_idade_sca,qt_idade_p) qt_idade_max_sca,
		coalesce(b.ie_consistir_idade_sca_mens,'N') ie_consistir_idade_sca_mens,
		coalesce(a.ie_importacao,'N') ie_importacao,
		b.ds_plano nm_sca,
		b.qt_parcelas_cobranca,
		coalesce(b.ie_mensalidade_rescisao,'N') ie_mensalidade_rescisao
	from	pls_sca_vinculo a,
		pls_plano	b
	where	a.nr_seq_plano		= b.nr_sequencia
	and	a.nr_seq_segurado	= nr_seq_segurado_p
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	(a.nr_seq_tabela IS NOT NULL AND a.nr_seq_tabela::text <> '')
	and	dt_referencia_p	between trunc(a.dt_inicio_vigencia,'month') and fim_dia(coalesce(a.dt_fim_vigencia,dt_referencia_p));
BEGIN

select	count(1)
into STRICT	qt_sca_benef_w

where	exists (SELECT	1
		from	pls_sca_vinculo
		where	nr_seq_segurado	= nr_seq_segurado_p);

if (qt_sca_benef_w > 0) then
	for r_c01_w in C01 loop
		begin
		ie_gerar_sca_w	:= 'N';
		
		ie_lancamento_mensalidade_w	:= pls_mens_itens_sca_pck.obter_tipo_lancamento_mens(r_c01_w.ie_lancamento_mensalidade, r_c01_w.ie_embutido_produto, r_c01_w.ie_lancamento_mens_plano);
		
		if (r_c01_w.nr_seq_pagador IS NOT NULL AND r_c01_w.nr_seq_pagador::text <> '') then
			if (r_c01_w.nr_seq_pagador = nr_seq_pagador_p) then
				ie_gerar_sca_w	:= 'S';
			end if;
		elsif (pls_mens_itens_pck.obter_se_pagador_item(nr_seq_segurado_p, nr_seq_pagador_p, '15', null, ie_pce_proporcional_p, null) = 'S') then
			ie_gerar_sca_w	:= 'S';
		end if;
		
		if (ie_gerar_sca_w = 'S') then
			if (ie_lancamento_mensalidade_w = 'D') and (r_c01_w.dt_rescisao_sca IS NOT NULL AND r_c01_w.dt_rescisao_sca::text <> '') and (trunc(r_c01_w.dt_adesao_sca,'dd') = trunc(r_c01_w.dt_rescisao_sca,'dd')) then
				ie_gerar_sca_w	:= 'N';
			elsif (dt_referencia_p < dt_referencia_lote_p) then
				SELECT * FROM pls_mensalidade_util_pck.obter_regra_data_limite(nr_seq_contrato_p, nr_seq_intercambio_p, ie_tipo_estipulante_p, dt_referencia_p, nr_seq_regra_limite_w, ie_agrupar_valor_lim_w, qt_dias_vencimento_w, ie_primeira_mensalidade_w, ie_data_base_adesao_w) INTO STRICT nr_seq_regra_limite_w, ie_agrupar_valor_lim_w, qt_dias_vencimento_w, ie_primeira_mensalidade_w, ie_data_base_adesao_w;
				
				select	count(1)
				into STRICT	qt_regra_limite_sca_w
				from	pls_regra_mens_cont_sca
				where	nr_seq_regra	= nr_seq_regra_limite_w;
				
				if (qt_regra_limite_sca_w > 0) then
					select	count(1)
					into STRICT	qt_regra_limite_sca_w
					from	pls_regra_mens_cont_sca
					where	nr_seq_regra		= nr_seq_regra_limite_w
					and	nr_seq_plano_sca	= r_c01_w.nr_seq_plano;
					
					if (qt_regra_limite_sca_w > 0) then
						ie_gerar_sca_w	:= 'S';
					else
						ie_gerar_sca_w	:= 'N';
					end if;
				else
					ie_gerar_sca_w	:= 'S';
				end if;
			else
				ie_gerar_sca_w	:= 'S';
			end if;
		end if;
		
		if (ie_gerar_sca_w = 'S') and
			((r_c01_w.ie_consistir_idade_sca_mens = 'N') or (qt_idade_p between r_c01_w.qt_idade_min_sca and r_c01_w.qt_idade_max_sca)) then
			
			qt_parcela_sca_w	:= trunc(months_between(dt_referencia_p,trunc(r_c01_w.dt_adesao_sca,'month')));
			if (qt_parcela_sca_w > 2) or --Somente verificar anteriores se for ate a terceira parcela
				(r_c01_w.ie_importacao = 'S') then --Se o SCA for importacao de base, entao nao deve gerar para meses anteriores
				qt_parcela_sca_w	:= 0;
			end if;
			
			for i in 0..qt_parcela_sca_w loop
				begin
				dt_referencia_w		:= add_months(dt_referencia_p,-i);
				nr_parcela_sca_w	:= trunc(months_between(dt_referencia_w,trunc(r_c01_w.dt_adesao_sca,'month'))) + 1;
				
				SELECT * FROM pls_mens_itens_sca_pck.obter_data_cobertura(	nr_parcela_sca_w, r_c01_w.dt_adesao_sca, r_c01_w.dt_rescisao_sca, dt_reativacao_p, dt_referencia_w, nr_seq_pagador_p, r_c01_w.nr_seq_pagador, nr_seq_contrato_p, nr_seq_intercambio_p, ie_tipo_estipulante_p, ie_mensalidade_proporcional_p, cd_estabelecimento_p, ie_pce_proporcional_p, dt_inclusao_pce_p, dt_rescisao_ant_p, ie_rescisao_proporcional_w, dt_inicio_cobertura_w, dt_fim_cobertura_w) INTO STRICT ie_rescisao_proporcional_w, dt_inicio_cobertura_w, dt_fim_cobertura_w;
				
				ie_pce_proporcional_w	:= null;
				
				if	(dt_inclusao_pce_p IS NOT NULL AND dt_inclusao_pce_p::text <> '' AND pls_mensalidade_util_pck.get_ie_mens_prop_pce = 'S') then
					for i in 0..3 loop
						begin
						if (trunc(add_months(dt_inclusao_pce_p,i),'mm') = trunc(dt_referencia_p,'mm')) then
							ie_pce_proporcional_w := 'S';
						end if;
						end;
					end loop;
				end if;
				
				if	((ie_pce_proporcional_p = 'S' and dt_inclusao_pce_p between dt_inicio_cobertura_w and dt_fim_cobertura_w) or (ie_pce_proporcional_w = 'S' and dt_inicio_cobertura_w >= dt_inclusao_pce_p)) then
					select	count(1)
					into STRICT	qt_sca_mes_w
					from	pls_mensalidade_sca		a,
						pls_mensalidade_seg_item	b,
						pls_mensalidade_segurado	c,
						pls_mensalidade			d
					where	b.nr_sequencia	= a.nr_seq_item_mens
					and	c.nr_sequencia	= b.nr_seq_mensalidade_seg
					and	d.nr_sequencia	= c.nr_seq_mensalidade
					and	a.nr_seq_vinculo_sca	= r_c01_w.nr_sequencia
					and	a.nr_parcela		= nr_parcela_sca_w
					and	b.dt_fim_cobertura >= dt_inicio_cobertura_w
					and	b.dt_inicio_cobertura <= dt_fim_cobertura_w
					and	d.nr_seq_pagador = nr_seq_pagador_p
					and	coalesce(d.ie_cancelamento::text, '') = '';
				elsif (ie_reativacao_proporcional_p = 'S' and dt_reativacao_p between dt_inicio_cobertura_w and dt_fim_cobertura_w) then
					select	count(1)
					into STRICT	qt_sca_mes_w
					from	pls_mensalidade_sca		a,
						pls_mensalidade_seg_item	b,
						pls_mensalidade_segurado	c,
						pls_mensalidade			d
					where	b.nr_sequencia	= a.nr_seq_item_mens
					and	c.nr_sequencia	= b.nr_seq_mensalidade_seg
					and	d.nr_sequencia	= c.nr_seq_mensalidade
					and	a.nr_seq_vinculo_sca	= r_c01_w.nr_sequencia
					and	a.nr_parcela		= nr_parcela_sca_w
					and	b.dt_fim_cobertura >= dt_inicio_cobertura_w
					and	b.dt_inicio_cobertura <= dt_fim_cobertura_w
					and	coalesce(d.ie_cancelamento::text, '') = '';
				else
					select	count(1)
					into STRICT	qt_sca_mes_w
					from	pls_mensalidade_sca		a,
						pls_mensalidade_seg_item	b,
						pls_mensalidade_segurado	c,
						pls_mensalidade			d
					where	b.nr_sequencia	= a.nr_seq_item_mens
					and	c.nr_sequencia	= b.nr_seq_mensalidade_seg
					and	d.nr_sequencia	= c.nr_seq_mensalidade
					and	a.nr_seq_vinculo_sca	= r_c01_w.nr_sequencia
					and	a.nr_parcela		= nr_parcela_sca_w
					and	coalesce(d.ie_cancelamento::text, '') = '';
				end if;

				if (qt_sca_mes_w = 0) then --Se nao encontrar SCA na tabela de mensalidade, deve buscar nos vetores dos itens ainda nao inseridos
					qt_sca_mes_w	:= pls_mens_itens_pck.obter_se_sca_gerado(r_c01_w.nr_sequencia, nr_parcela_sca_w, ie_lancamento_mensalidade_w, dt_inicio_cobertura_w, dt_fim_cobertura_w);
				end if;

				if (qt_sca_mes_w = 0) and (coalesce(r_c01_w.qt_parcelas_cobranca,nr_parcela_sca_w) >= nr_parcela_sca_w) then
					if (i = 0) then
						ds_observacao_w	:= '';
					else
						ds_observacao_w	:= wheb_mensagem_pck.get_texto(1116068, 'NR_PARCELA='||nr_parcela_sca_w||';NM_SCA='||r_c01_w.nm_sca);
					end if;
					
					select	max(nr_sequencia)
					into STRICT	nr_seq_segurado_preco_w
					from	pls_segurado_preco_origem
					where	nr_seq_vinculo_sca = r_c01_w.nr_sequencia
					and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
					and (dt_referencia_w >= trunc(dt_reajuste, 'month'));
					
					if (nr_seq_segurado_preco_w IS NOT NULL AND nr_seq_segurado_preco_w::text <> '') and
						((coalesce(r_c01_w.dt_rescisao_sca::text, '') = '') or (r_c01_w.ie_mensalidade_rescisao = 'S' and r_c01_w.dt_rescisao_sca > dt_inicio_cobertura_w) or (r_c01_w.ie_mensalidade_rescisao = 'N' and r_c01_w.dt_rescisao_sca > dt_fim_cobertura_w)) then
						
						select	CASE WHEN qt_item_destacado=0 THEN  CASE WHEN pls_mensalidade_util_pck.get_ie_destacar_reajuste_sca='S' THEN  							 CASE WHEN qt_lote_taxa_negativa=0 THEN  vl_preco_atual  ELSE vl_preco_ant END   ELSE vl_preco_atual END   ELSE vl_preco_atual END ,
							cd_motivo_reajuste
						into STRICT	vl_preco_sca_w,
							cd_motivo_reajuste_w
						from	(SELECT	coalesce(a.vl_preco_atual,0) vl_preco_atual,
								coalesce(a.vl_preco_ant,0) vl_preco_ant,
								(select	count(1)
								from	pls_reajuste x
								where	x.nr_sequencia = a.nr_seq_reajuste
								and	x.tx_reajuste < 0
								and	coalesce(x.ie_tipo_lote, 'X') <> 'D') qt_lote_taxa_negativa,
								(select	count(1)
								from	pls_mensalidade_sca x,
									pls_mensalidade_seg_item y,
									pls_mensalidade w
								where	y.nr_sequencia = x.nr_seq_item_mens
								and	w.nr_sequencia = x.nr_seq_mensalidade
								and	a.nr_sequencia = x.nr_seq_segurado_preco
								and	y.ie_tipo_item in ('35','25')
								and	coalesce(w.ie_cancelamento::text, '') = '') qt_item_destacado,
								a.cd_motivo_reajuste
							from	pls_segurado_preco_origem a
							where	a.nr_sequencia	= nr_seq_segurado_preco_w) alias15;
						
						ie_sca_proporcional_w := 'N';
						
						--Calcular o valor proporcional para a primeira parcela
						if	(nr_parcela_sca_w = 1 AND ie_mensalidade_proporcional_p = 'S') or (ie_rescisao_proporcional_w = 'S') or (ie_pce_proporcional_p in ('S','E')) or (ie_reativacao_proporcional_p = 'S') then
							qt_dias_w	:= obter_dias_entre_datas(dt_inicio_cobertura_w, dt_fim_cobertura_w) + 1;
							
							if (pls_mensalidade_util_pck.get_ie_data_base_proporcional = 'T') then
								dt_ultimo_dia_mes_w	:= 30;
								--Se o dia da contratacao for o primeiro dia do mes, pega o valor total, (30 / 30 * valor)
								if (nr_parcela_sca_w = 1) and (ie_rescisao_proporcional_w = 'N') and (trunc(r_c01_w.dt_adesao_sca,'dd') = trunc(r_c01_w.dt_adesao_sca,'month')) then
									qt_dias_w		:= 30;
								end if;
							else
								if	(nr_parcela_sca_w = 1 AND ie_mensalidade_proporcional_p = 'S') then
									dt_ultimo_dia_mes_w	:= to_char(last_day(dt_inicio_cobertura_w),'dd');
								else
									dt_ultimo_dia_mes_w	:= to_char(last_day(dt_referencia_p),'dd');
								end if;
							end if;
							
							ie_sca_proporcional_w		:= 'S';
							tx_proporcional_mens_w		:= (qt_dias_w/(dt_ultimo_dia_mes_w)::numeric );
							vl_preco_sca_w			:= tx_proporcional_mens_w * vl_preco_sca_w;
						end if;
						
						--Calcular o valor de reajuste para destacar na mensalidade
						if (pls_mensalidade_util_pck.get_ie_destacar_reajuste_sca = 'S') and (ie_lancamento_mensalidade_w <> 'E') and (cd_motivo_reajuste_w <> 'E') then
							SELECT * FROM pls_mens_itens_sca_pck.calcular_valor_reajuste(r_c01_w.nr_sequencia, nr_seq_segurado_p, dt_referencia_w, ie_lancamento_mensalidade_w, ie_sca_proporcional_w, tx_proporcional_mens_w, vl_preco_sca_w, vl_reajuste_indice_w, nr_seq_reajuste_preco_w) INTO STRICT vl_preco_sca_w, vl_reajuste_indice_w, nr_seq_reajuste_preco_w;
						else
							vl_reajuste_indice_w := 0;
							nr_seq_reajuste_preco_w := null;
						end if;
						
						if (ie_lancamento_mensalidade_w = 'D') then --Valor destacado na mensalidade
							ie_inseriu_item_w := pls_mens_itens_pck.add_item_sca(nr_seq_mensalidade_p, nr_seq_mensalidade_seg_p, '15', vl_preco_sca_w, r_c01_w.nr_sequencia, nr_parcela_sca_w, dt_inicio_cobertura_w, dt_fim_cobertura_w, nr_seq_segurado_p, nr_seq_segurado_preco_w, '', ds_observacao_w, null, ie_inseriu_item_w);
							
							if (vl_reajuste_indice_w <> 0) then
								ie_inseriu_item_w := pls_mens_itens_pck.add_item_sca(nr_seq_mensalidade_p, nr_seq_mensalidade_seg_p, '35', vl_reajuste_indice_w, r_c01_w.nr_sequencia, nr_parcela_sca_w, dt_inicio_cobertura_w, dt_fim_cobertura_w, nr_seq_segurado_p, nr_seq_segurado_preco_w, '', '', nr_seq_reajuste_preco_w, ie_inseriu_item_w);
							end if;
						else --Valor embutido
							nr_indice_preco_pre_w	:= pls_mens_itens_pck.obter_indice_preco(nr_seq_mensalidade_seg_p,'1');
							
							if (nr_indice_preco_pre_w = -1) then
								null;
								/*
								pls_gerar_mens_log_erro(nr_seq_lote_p, nr_seq_pagador_p, nr_seq_segurado_p, null,
									'Nao foi encontrado o item de Preco pre-estabelecido para embutir os valores de SCA do beneficiario!', cd_estabelecimento_p, nm_usuario_p);
								*/
							else
								CALL pls_mens_itens_pck.add_sca_embutido(nr_indice_preco_pre_w, nr_seq_mensalidade_p, r_c01_w.nr_sequencia, nr_parcela_sca_w, vl_preco_sca_w,
													nr_seq_segurado_preco_w, ie_lancamento_mensalidade_w, dt_inicio_cobertura_w, dt_fim_cobertura_w);
							end if;
							
							if (vl_reajuste_indice_w <> 0) then
								nr_indice_preco_reaj_w	:= pls_mens_itens_pck.obter_indice_preco(nr_seq_mensalidade_seg_p,'25');
								
								if (nr_indice_preco_reaj_w = -1) then --Se nao encontrar o item Reajuste - Variacao de Custo, deve buscar o preco pre-estabelecido
									nr_indice_preco_reaj_w	:= pls_mens_itens_pck.obter_indice_preco(nr_seq_mensalidade_seg_p,'1');
								end if;
								
								if (nr_indice_preco_reaj_w = -1) then --Se nao encontrar o item Reajuste - Variacao de Custo e nem o preco pre-estabelecido, ira criar um novo item para o reajuste do SCA
									ie_inseriu_item_w := pls_mens_itens_pck.add_item_sca(nr_seq_mensalidade_p, nr_seq_mensalidade_seg_p, '35', vl_reajuste_indice_w, r_c01_w.nr_sequencia, nr_parcela_sca_w, dt_inicio_cobertura_w, dt_fim_cobertura_w, nr_seq_segurado_p, nr_seq_segurado_preco_w, '', '', nr_seq_reajuste_preco_w, ie_inseriu_item_w);
								else
									CALL pls_mens_itens_pck.add_sca_embutido(nr_indice_preco_reaj_w, nr_seq_mensalidade_p, r_c01_w.nr_sequencia, nr_parcela_sca_w, vl_reajuste_indice_w,
														nr_seq_segurado_preco_w, ie_lancamento_mensalidade_w, dt_inicio_cobertura_w, dt_fim_cobertura_w);
								end if;
							end if;
						end if;
						
						--Gerar taxa de inscricao do SCA referente a parcela que esta sendo gerada
						if (pls_mens_itens_pck.obter_se_item_grupo('2',null) = 'S') then
							CALL pls_mens_itens_sca_pck.gerar_taxa_inscricao(nr_seq_mensalidade_seg_p, r_c01_w.nr_sequencia, r_c01_w.nr_seq_plano, nr_parcela_sca_w, vl_preco_sca_w, dt_referencia_w, ie_titularidade_p);
						end if;
					end if;
				end if;
				end;
			end loop;
		end if;
		end;
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_itens_sca_pck.gerar_sca ( nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, qt_idade_p pls_mensalidade_segurado.qt_idade%type, ie_tipo_estipulante_p pls_mensalidade_segurado.ie_tipo_estipulante%type, nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, dt_referencia_lote_p pls_lote_mensalidade.dt_mesano_referencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_contratacao_p pls_segurado.dt_contratacao%type, dt_rescisao_p pls_segurado.dt_rescisao%type, dt_reativacao_p pls_segurado.dt_reativacao%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, ie_mensalidade_proporcional_p pls_segurado.ie_mensalidade_proporcional%type, ie_titularidade_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_pce_proporcional_p pls_mensalidade_segurado.ie_pce_proporcional%type, dt_inclusao_pce_p pls_segurado.dt_inclusao_pce%type, ie_reativacao_proporcional_p pls_mensalidade_segurado.ie_reativacao_proporcional%type, dt_rescisao_ant_p pls_segurado.dt_rescisao_ant%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
