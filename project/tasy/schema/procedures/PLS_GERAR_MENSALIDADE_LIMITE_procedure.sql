-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mensalidade_limite ( nr_seq_segurado_p bigint, nr_seq_mensalidade_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[X] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_contrato_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_pagador_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_lote_w			bigint;
nr_seq_regra_w			bigint;
nr_seq_segurado_preco_w		bigint;
nr_seq_mensalidade_w		bigint;
nr_seq_mensalidade_seg_lim_w	bigint;
nr_parcela_contrato_w		bigint;
nr_parcela_seg_w		bigint;
qt_idade_w			smallint;
qt_meses_parametro_w		bigint;
qt_dias_vencimento_w		bigint;
qt_regra_rescisao_w		bigint;
qt_reg_mensalidade_w		bigint;
qt_dias_mes_w			bigint;
qt_dias_pro_rata_w		bigint;
qt_interv_venc_w		bigint;
vl_preco_atual_w		double precision;
vl_mens_limite_w		double precision;
vl_limite_w			double precision;
dt_adesao_w			timestamp;
dt_rescisao_w			timestamp;
dt_inicio_movimentacao_w	timestamp;
dt_fim_movimentacao_w		timestamp;
dt_base_adesao_w		timestamp;
dt_mes_competencia_w		timestamp;
dt_vencimento_w			timestamp;
ie_primeira_mensalidade_w	varchar(1);
ie_tipo_data_limite_w		varchar(2);
ie_mensalidade_mes_rescisao_w	varchar(1);
ie_agrupar_valor_w		varchar(1);
ie_primeira_mens_regra_w	varchar(1);
ie_data_base_adesao_w		varchar(1);
ie_tipo_contrato_w		varchar(2);
ie_data_base_proporcional_w	varchar(1);
ds_dia_limite_movimentacao_w	varchar(10);
dt_referencia_lote_mens_w	timestamp;
ie_valor_apropriado_w		varchar(1);
--------------------------------------------------------------------------------- 
dt_mesano_referencia_aux_w	pls_mensalidade_segurado.dt_mesano_referencia%type;
nr_seq_segurado_preco_aux_w	pls_mensalidade_segurado.nr_seq_segurado_preco%type;
nr_seq_mensalidade_aux_w	pls_mensalidade_segurado.nr_seq_mensalidade%type;
nr_parcela_aux_w		pls_mensalidade_segurado.nr_parcela%type;
nr_parcela_contrato_aux_w	pls_mensalidade_segurado.nr_parcela_contrato%type;
nr_serie_mensalidade_w		pls_mensalidade.nr_serie_mensalidade%type;
nr_seq_centro_apropriacao_w	pls_centro_apropriacao.nr_sequencia%type;
vl_apropriacao_w		pls_segurado_preco_aprop.vl_apropriacao%type;
vl_preco_nao_subsid_desc_w	pls_segurado_preco.vl_preco_nao_subsid_desc%type;
nr_parcela_segurado_w		bigint;
dt_inicio_cobertura_w		timestamp;
dt_fim_cobertura_w		timestamp;
tx_limite_1a_parc_w		double precision;
ie_pag_complementar_w		varchar(1);
nr_seq_pagador_benef_w		pls_contrato_pagador.nr_sequencia%type;
nr_seq_pagador_item_w		pls_pagador_item_mens.nr_seq_pagador_item%type;
nr_seq_tabela_w			pls_segurado.nr_seq_tabela%type;
qt_registros_w			integer	:= 0;
nr_seq_reajuste_w		pls_segurado_preco.nr_seq_reajuste%type;
vl_reajuste_indice_w		double precision;
nr_seq_lote_reajuste_w		pls_segurado_preco.nr_seq_lote_reajuste%type;
ds_mensagem_reajuste_w		varchar(4000);
nr_seq_item_w			pls_mensalidade_seg_item.nr_sequencia%type;
tx_reajuste_w			pls_reajuste.tx_reajuste%type;
ds_oficio_ans_w			varchar(255);
nr_protocolo_ans_w		varchar(60);
dt_periodo_inicial_w		timestamp;
dt_periodo_final_w		timestamp;
dt_autorizacao_ans_w		timestamp;
dt_reajuste_w			timestamp;
ds_plano_w			varchar(80);
nr_protocolo_ans_plano_w	varchar(20);
cd_scpa_w			varchar(20);
dt_vencimento_mens_w		timestamp;
ie_calculo_proporcional_w	pls_contrato_pagador.ie_calculo_proporcional%type;
ie_tipo_mensalidade_w		varchar(3);
nr_seq_preco_indice_w		pls_segurado_preco.nr_sequencia%type;
dt_mes_competencia_trunc_w 	timestamp;
qt_pagador_vigente_w		integer;
nr_seq_pagador_ww		pls_contrato_pagador.nr_sequencia%type;
ie_preco_w			varchar(2);
ie_tipo_formacao_preco_w	varchar(1);
nr_seq_pagador_fin_w		pls_contrato_pagador_fin.nr_sequencia%type;
nr_seq_item_mensalidade_w	pls_mensalidade_seg_item.nr_sequencia%type;
tx_proporcional_rescisao_w 	double precision := 0;
ie_gerou_item_pre_w		varchar(1);

C01 CURSOR FOR 
	SELECT	trunc(dt_mes_competencia,'month') 
	from	pls_competencia 
	where	dt_mes_competencia between dt_inicio_movimentacao_w and dt_fim_movimentacao_w 
	order by dt_mes_competencia;

C02 CURSOR FOR 
	SELECT	nr_seq_centro_apropriacao, 
		vl_apropriacao 
	from	pls_segurado_preco_aprop 
	where	nr_seq_segurado_preco	= nr_seq_segurado_preco_w;


BEGIN 
qt_meses_parametro_w		:= pls_store_data_mens_pck.get_qt_meses_parametro;
 
nr_seq_contrato_w		:= pls_store_data_mens_pck.get_nr_seq_contrato;
dt_adesao_w			:= pls_store_data_mens_pck.get_dt_contratacao;
nr_seq_plano_w			:= pls_store_data_mens_pck.get_nr_seq_plano;
nr_seq_pagador_w		:= pls_store_data_mens_pck.get_nr_seq_pagador;
nr_seq_intercambio_w		:= pls_store_data_mens_pck.get_nr_seq_intercambio;
dt_rescisao_w			:= pls_store_data_mens_pck.get_dt_rescisao;
 
nr_seq_lote_w			:= pls_store_data_mens_pck.get_nr_seq_lote_mensalidade;
ie_primeira_mensalidade_w	:= pls_store_data_mens_pck.get_ie_primeira_mensalidade;
dt_referencia_lote_mens_w	:= pls_store_data_mens_pck.get_dt_referencia_lote;
 
dt_mesano_referencia_aux_w	:= pls_store_data_mens_pck.get_dt_mesano_referencia;
nr_seq_segurado_preco_aux_w	:= pls_store_data_mens_pck.get_nr_seq_segurado_preco;
nr_seq_mensalidade_aux_w	:= pls_store_data_mens_pck.get_nr_seq_mensalidade;
nr_parcela_aux_w		:= pls_store_data_mens_pck.get_nr_parcela;
nr_parcela_contrato_aux_w	:= pls_store_data_mens_pck.get_nr_parcela_contrato;
nr_serie_mensalidade_w		:= pls_store_data_mens_pck.get_nr_serie_mensalidade;
ie_pag_complementar_w		:= pls_store_data_mens_pck.get_ie_pag_complementar;
ie_tipo_mensalidade_w		:= pls_store_data_mens_pck.get_ie_tipo_mensalidade;
nr_seq_pagador_benef_w		:= pls_store_data_mens_pck.get_nr_seq_pagador_benef;
				 
dt_inicio_movimentacao_w	:= trunc(add_months(dt_referencia_lote_mens_w,-qt_meses_parametro_w),'month');
dt_fim_movimentacao_w		:= last_day(add_months(dt_referencia_lote_mens_w,-1)) + 86399/86400;
 
if (coalesce(nr_seq_contrato_w,0) <> 0) then 
	select	max(a.nr_sequencia) 
	into STRICT	nr_seq_regra_w 
	from	pls_regra_mens_contrato	a, 
		pls_contrato		b 
	where	a.nr_seq_contrato	= b.nr_sequencia 
	and	b.nr_sequencia		= nr_seq_contrato_w 
	and	a.ie_tipo_regra		= 'L' 
	and	trunc(dt_referencia_lote_mens_w,'dd')	>= trunc(a.dt_inicio_vigencia,'dd') 
	and	trunc(dt_referencia_lote_mens_w,'dd')	<= trunc(coalesce(a.dt_fim_vigencia,dt_referencia_lote_mens_w),'dd');
	 
	select	CASE WHEN coalesce(max(cd_pf_estipulante)::text, '') = '' THEN 'PJ'  ELSE 'PF' END  
	into STRICT	ie_tipo_contrato_w 
	from	pls_contrato 
	where	nr_sequencia	= nr_seq_contrato_w;
elsif (coalesce(nr_seq_intercambio_w,0) <> 0) then 
	select	max(a.nr_sequencia) 
	into STRICT	nr_seq_regra_w 
	from	pls_regra_mens_contrato	a, 
		pls_intercambio		b 
	where	a.nr_seq_intercambio	= b.nr_sequencia 
	and	b.nr_sequencia		= nr_seq_intercambio_w 
	and	a.ie_tipo_regra		= 'L' 
	and	trunc(dt_referencia_lote_mens_w,'dd')	>= trunc(a.dt_inicio_vigencia,'dd') 
	and	trunc(dt_referencia_lote_mens_w,'dd')	<= trunc(coalesce(a.dt_fim_vigencia,dt_referencia_lote_mens_w),'dd');
	 
	select	CASE WHEN coalesce(max(cd_pessoa_fisica)::text, '') = '' THEN 'PJ'  ELSE 'PF' END  
	into STRICT	ie_tipo_contrato_w 
	from	pls_intercambio 
	where	nr_sequencia	= nr_seq_intercambio_w;
end if;
 
if (coalesce(nr_seq_regra_w,0) = 0) then 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_regra_w 
	from	pls_regra_mens_contrato 
	where	coalesce(nr_seq_contrato::text, '') = '' 
	and	coalesce(nr_seq_intercambio::text, '') = '' 
	and	ie_tipo_regra		= 'L' 
	and	cd_estabelecimento	= cd_estabelecimento_p 
	and	trunc(dt_referencia_lote_mens_w,'dd')	>= trunc(dt_inicio_vigencia,'dd') 
	and	trunc(dt_referencia_lote_mens_w,'dd')	<= trunc(coalesce(dt_fim_vigencia,dt_referencia_lote_mens_w),'dd') 
	and	((coalesce(ie_pessoa_contrato,'A') = ie_tipo_contrato_w) or (ie_pessoa_contrato = 'A'));
end if;
 
if (coalesce(nr_seq_regra_w,0)	> 0) then 
	select	lpad(to_char(coalesce(a.dt_limite_movimentacao,'0')),2,0), 
		a.ie_tipo_data_limite, 
		coalesce(a.ie_mensalidade_mes_rescisao,'N'), 
		coalesce(a.ie_agrupar_valor,'S'), 
		qt_dias_vencimento, 
		coalesce(ie_primeira_mensalidade,'N'), 
		coalesce(ie_data_base_adesao,'A') 
	into STRICT	ds_dia_limite_movimentacao_w, 
		ie_tipo_data_limite_w, 
		ie_mensalidade_mes_rescisao_w, 
		ie_agrupar_valor_w, 
		qt_dias_vencimento_w, 
		ie_primeira_mens_regra_w, 
		ie_data_base_adesao_w 
	from	pls_regra_mens_contrato a 
	where	a.nr_sequencia	= nr_seq_regra_w;
	 
	if (ds_dia_limite_movimentacao_w = '00') then 
		CALL pls_gerar_mens_log_erro(nr_seq_lote_w,nr_seq_pagador_w,nr_seq_segurado_p, nr_seq_mensalidade_p, 
					'A regra de data limite não possui o dia de limite para a movimentação informado. Verifique a regra do contrato e da operadora!', 
					cd_estabelecimento_p,nm_usuario_p);
	end if;
	 
	if (pls_store_data_mens_pck.get_dt_reativacao IS NOT NULL AND pls_store_data_mens_pck.get_dt_reativacao::text <> '') then 
		dt_base_adesao_w	:= pls_store_data_mens_pck.get_dt_reativacao;
	else 
		if (coalesce(ie_data_base_adesao_w,'A') = 'L') then 
			dt_base_adesao_w := pls_store_data_mens_pck.get_dt_liberacao;
		else 
			dt_base_adesao_w := dt_adesao_w;
		end if;
	end if;
	 
	if	(((dt_base_adesao_w between dt_inicio_movimentacao_w and dt_fim_movimentacao_w) or (ie_tipo_mensalidade_w = 'MR') or (dt_adesao_w > add_months(dt_referencia_lote_mens_w,-pls_store_data_mens_pck.get_qt_parcelas_meses_ant))) and 
		((ie_primeira_mens_regra_w = 'N') or (ie_primeira_mens_regra_w = 'S' AND ie_primeira_mensalidade_w = 'S'))) then 
		 
		select	max(ie_data_base_proporcional) 
		into STRICT	ie_data_base_proporcional_w 
		from	pls_parametros 
		where	cd_estabelecimento	= cd_estabelecimento_p;
		ie_data_base_proporcional_w	:= coalesce(ie_data_base_proporcional_w,'U');
		 
		if (coalesce(nr_seq_contrato_w,0) <> 0) then 
			select	count(1) 
			into STRICT	qt_regra_rescisao_w 
			from	pls_regra_mens_contrato	a, 
				pls_contrato		b 
			where	a.nr_seq_contrato	= b.nr_sequencia 
			and	b.nr_sequencia		= nr_seq_contrato_w 
			and	a.ie_tipo_regra		= 'G' 
			and	coalesce(a.ie_mensalidade_mes_rescisao,'N') = 'S' 
			and	trunc(dt_referencia_lote_mens_w,'dd') between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,dt_referencia_lote_mens_w);
		else 
			select	count(1) 
			into STRICT	qt_regra_rescisao_w 
			from	pls_regra_mens_contrato	a, 
				pls_intercambio		b 
			where	a.nr_seq_intercambio	= b.nr_sequencia 
			and	b.nr_sequencia		= nr_seq_intercambio_w 
			and	a.ie_tipo_regra		= 'G' 
			and	coalesce(a.ie_mensalidade_mes_rescisao,'N') = 'S' 
			and	trunc(dt_referencia_lote_mens_w,'dd') between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,dt_referencia_lote_mens_w);
		end if;
		 
		if (coalesce(qt_regra_rescisao_w,0) = 0) then 
			select	count(1) 
			into STRICT	qt_regra_rescisao_w 
			from	pls_regra_mens_contrato 
			where	coalesce(nr_seq_contrato::text, '') = '' 
			and	coalesce(nr_seq_intercambio::text, '') = '' 
			and	ie_tipo_regra		= 'G' 
			and	coalesce(ie_mensalidade_mes_rescisao,'N') = 'S' 
			and	cd_estabelecimento	= cd_estabelecimento_p 
			and	trunc(dt_referencia_lote_mens_w,'dd') between dt_inicio_vigencia and coalesce(dt_fim_vigencia,dt_referencia_lote_mens_w) 
			and	((coalesce(ie_pessoa_contrato,'A') = ie_tipo_contrato_w) or (ie_pessoa_contrato = 'A'));
		end if;
		 
		if (trunc(dt_base_adesao_w,'month') > dt_inicio_movimentacao_w) then 
			dt_inicio_movimentacao_w	:= trunc(dt_base_adesao_w,'month');
		end if;
		 
		select	max(b.ie_preco) 
		into STRICT	ie_preco_w 
		from	pls_contrato_plano	a, 
			pls_plano		b 
		where	a.nr_seq_plano		= b.nr_sequencia 
		and	a.nr_seq_contrato	= nr_seq_contrato_w;
		 
		if (ie_preco_w in (1,4)) then 
			ie_tipo_formacao_preco_w	:= 'R';
		elsif (ie_preco_w in (2,3)) then 
			ie_tipo_formacao_preco_w	:= 'P';
		end if;
		 
		open C01;
		loop 
		fetch C01 into	 
			dt_mes_competencia_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			nr_seq_preco_indice_w 	:= null;
			vl_reajuste_indice_w	:= null;
			 
			select	max(nr_seq_pagador) 
			into STRICT	nr_seq_pagador_ww 
			from	pls_segurado_pagador 
			where	dt_mes_competencia_w between dt_inicio_vigencia and coalesce(dt_fim_vigencia,dt_mes_competencia_w) 
			and	nr_seq_segurado = nr_seq_segurado_p;
			 
			select	count(1) 
			into STRICT	qt_reg_mensalidade_w 
			from	pls_mensalidade_segurado a, 
				pls_segurado		b, 
				pls_mensalidade		c 
			where	a.nr_seq_segurado	= b.nr_sequencia 
			and	a.nr_seq_mensalidade	= c.nr_sequencia 
			and	b.nr_sequencia		= nr_seq_segurado_p 
			and	coalesce(c.ie_cancelamento::text, '') = '' 
			and	trunc(a.dt_mesano_referencia,'month') = dt_mes_competencia_w 
			and	exists (	SELECT 1 
						from  pls_mensalidade_seg_item y 
						where  y.nr_seq_mensalidade_seg	= a.nr_sequencia 
						and   y.ie_tipo_item in ('1','6','7','8'));
			 
			if (qt_reg_mensalidade_w = 0) and (coalesce(nr_seq_pagador_ww,0) > 0) and 
				((coalesce(dt_rescisao_w::text, '') = '') or 	((((qt_regra_rescisao_w = 0) and (trunc(dt_rescisao_w,'month') > dt_mes_competencia_w)) or 
								((qt_regra_rescisao_w > 0) and (trunc(dt_rescisao_w,'month') >= dt_referencia_lote_mens_w) and /* OS 586842 */
 
								(trunc(dt_rescisao_w,'month') >= dt_mes_competencia_w))) and (trunc(dt_rescisao_w,'dd') <> trunc(dt_adesao_w,'dd')) 
								)) then 
				select	max(a.nr_sequencia) 
				into STRICT	nr_seq_segurado_preco_w 
				from	pls_segurado_preco	a, 
					pls_segurado		b 
				where	a.nr_seq_segurado	= b.nr_sequencia 
				and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
				and	b.nr_sequencia		= nr_seq_segurado_p 
				and	(((trunc(dt_mes_competencia_w,'month') >= trunc(a.dt_reajuste, 'month')) and (a.cd_motivo_reajuste	<> 'E')) 
					or	((a.cd_motivo_reajuste	= 'E') and (trunc(dt_mes_competencia_w,'month') >= trunc(add_months(a.dt_reajuste,1), 'month'))));
				 
				if (coalesce(nr_seq_segurado_preco_w,0) > 0) then 
					select	coalesce(vl_preco_atual,0) - coalesce(vl_desconto,0), 
						coalesce(vl_preco_nao_subsid_desc,0), 
						qt_idade 
					into STRICT	vl_preco_atual_w, 
						vl_preco_nao_subsid_desc_w, 
						qt_idade_w 
					from	pls_segurado_preco 
					where	nr_sequencia	= nr_seq_segurado_preco_w;
				end if;
				 
				if 	((coalesce(qt_dias_vencimento_w,0) <> 0) and (trunc(dt_adesao_w, 'month') = trunc(dt_mes_competencia_w,'month')))	then 
					dt_vencimento_w  := dt_adesao_w + qt_dias_vencimento_w;
				else 
					dt_vencimento_w  := null;
				end if;
 
				qt_interv_venc_w := months_between(dt_mes_competencia_w,dt_referencia_lote_mens_w);
					   
				select	coalesce(dt_vencimento_w,dt_vencimento) 
				into STRICT	dt_vencimento_w 
				from	pls_mensalidade 
				where	nr_sequencia = nr_seq_mensalidade_p;
				 
				if	(nr_seq_pagador_ww = nr_seq_pagador_w AND ie_agrupar_valor_w = 'N') then 
					select	max(nr_sequencia) 
					into STRICT	nr_seq_mensalidade_w 
					from	pls_mensalidade 
					where	nr_seq_lote	= nr_seq_lote_w 
					and	nr_seq_pagador	= nr_seq_pagador_w 
					and	trunc(dt_referencia,'month')	= dt_mes_competencia_w;
					 
					if (coalesce(nr_seq_mensalidade_w,0) = 0) then 
						select	nextval('pls_mensalidade_seq') 
						into STRICT	nr_seq_mensalidade_w 
						;
						 
						insert	into	pls_mensalidade(	nr_sequencia, 
								dt_atualizacao, 
								nm_usuario, 
								nr_seq_pagador, 
								dt_referencia, 
								vl_mensalidade, 
								nr_seq_lote, 
								ds_observacao, 
								dt_vencimento, 
								nr_seq_forma_cobranca, 
								cd_banco, 
								cd_agencia_bancaria, 
								ie_digito_agencia, 
								cd_conta, 
								ie_digito_conta, 
								ie_endereco_boleto, 
								nr_seq_conta_banco, 
								nr_seq_compl_pf_tel_adic, 
								nr_seq_pagador_fin, 
								ie_nota_titulo, 
								ie_tipo_formacao_preco, 
								ie_apresentacao, 
								nr_seq_compl_pj, 
								ie_gerar_cobr_escrit, 
								ie_tipo_geracao_mens, 
								nr_seq_conta_banco_deb_aut, 
								nr_serie_mensalidade) 
							SELECT	nr_seq_mensalidade_w, 
								clock_timestamp(), 
								nm_usuario_p, 
								nr_seq_pagador, 
								dt_mes_competencia_w, 
								0, 
								nr_seq_lote, 
								'', 
								coalesce(dt_vencimento_w, add_months(dt_vencimento,qt_interv_venc_w)), 
								nr_seq_forma_cobranca, 
								cd_banco, 
								cd_agencia_bancaria, 
								ie_digito_agencia, 
								cd_conta, 
								ie_digito_conta, 
								ie_endereco_boleto, 
								nr_seq_conta_banco, 
								nr_seq_compl_pf_tel_adic, 
								nr_seq_pagador_fin, 
								ie_nota_titulo, 
								ie_tipo_formacao_preco, 
								1, 
								nr_seq_compl_pj, 
								ie_gerar_cobr_escrit, 
								'DL', -- data limite 
								nr_seq_conta_banco_deb_aut, 
								nr_serie_mensalidade 
							from	pls_mensalidade 
							where	nr_sequencia	= nr_seq_mensalidade_p;
					end if;
				elsif (ie_agrupar_valor_w = 'S') then 
					nr_seq_mensalidade_w	:= nr_seq_mensalidade_p;
				else 
					select	max(nr_sequencia) 
					into STRICT 	nr_seq_mensalidade_w 
					from 	pls_mensalidade 
					where 	nr_seq_lote = nr_seq_lote_w 
					and 	nr_seq_pagador = nr_seq_pagador_ww 
					and 	trunc(dt_referencia,'month') = dt_mes_competencia_w;	
			 
					select	max(nr_sequencia) 
					into STRICT	nr_seq_pagador_fin_w 
					from	pls_contrato_pagador_fin 
					where	nr_seq_pagador = nr_seq_pagador_ww 
					and   ((coalesce(dt_fim_vigencia::text, '') = '') or (dt_fim_vigencia >= to_date(clock_timestamp())));
					 
					if (coalesce(nr_seq_mensalidade_w,0) = 0) then 
						select nextval('pls_mensalidade_seq') 
						into STRICT nr_seq_mensalidade_w 
						;
						  
						insert into 	pls_mensalidade( 	nr_sequencia, 
								dt_atualizacao, 
								nm_usuario, 
								nr_seq_pagador, 
								dt_referencia, 
								vl_mensalidade, 
								nr_seq_lote, 
								ds_observacao, 
								dt_vencimento, 
								nr_seq_forma_cobranca, 
								cd_banco, 
								cd_agencia_bancaria, 
								ie_digito_agencia, 
								cd_conta, 
								ie_digito_conta, 
								ie_endereco_boleto, 
								nr_seq_conta_banco, 
								nr_seq_compl_pf_tel_adic, 
								nr_seq_pagador_fin, 
								ie_nota_titulo, 
								ie_tipo_formacao_preco, 
								ie_apresentacao, 
								nr_seq_compl_pj, 
								ie_gerar_cobr_escrit, 
								ie_tipo_geracao_mens, 
								nr_seq_conta_banco_deb_aut, 
								nr_serie_mensalidade) 
							SELECT	nr_seq_mensalidade_w, 
								clock_timestamp(), 
								nm_usuario_p, 
								nr_seq_pagador_ww, 
								dt_mes_competencia_w, 
								0, 
								nr_seq_lote_w, 
								'', 
								dt_vencimento_w, 
								a.nr_seq_forma_cobranca, 
								a.cd_banco, 
								a.cd_agencia_bancaria, 
								a.ie_digito_agencia, 
								a.cd_conta, 
								a.ie_digito_conta, 
								b.ie_endereco_boleto, 
								a.nr_seq_conta_banco, 
								b.nr_seq_compl_pf_tel_adic, 
								a.nr_sequencia, 
								a.ie_geracao_nota_titulo, 
								ie_tipo_formacao_preco_w, 
								1, 
								b.nr_seq_compl_pj, 
								a.ie_gerar_cobr_escrit, 
								'DL', 
								a.nr_seq_conta_banco_deb_aut, 
								pls_store_data_mens_pck.get_nr_serie_mensalidade 
							from 	pls_contrato_pagador_fin a, 
								pls_contrato_pagador b 
							where 	a.nr_seq_pagador = b.nr_sequencia 
							and  	a.nr_sequencia = nr_seq_pagador_fin_w;
					end if;		
				end if;
				 
				nr_parcela_segurado_w	:= pls_obter_parcela_segurado(nr_seq_segurado_p, dt_mes_competencia_w, dt_mes_competencia_w);
				 
				/* Obter a data de cobertura da mensalidade do beneficiário */
 
				if (nr_parcela_segurado_w = 1) and (pls_store_data_mens_pck.get_ie_calc_primeira_mens = 'P') then 
					dt_inicio_cobertura_w	:= dt_adesao_w;
					dt_fim_cobertura_w	:= last_day(dt_adesao_w);
				elsif (nr_parcela_segurado_w = 1) and (pls_store_data_mens_pck.get_ie_calc_primeira_mens = 'I') then 
					dt_inicio_cobertura_w	:= dt_adesao_w;
					dt_fim_cobertura_w	:= add_months(dt_adesao_w,1)-1;
				elsif (nr_parcela_segurado_w > 1) then 
					if (pls_store_data_mens_pck.get_ie_mensalidade_proporc = 'S') then 
						dt_inicio_cobertura_w	:= trunc(dt_mes_competencia_w,'month');
						dt_fim_cobertura_w	:= last_day(dt_mes_competencia_w);
					else 
						begin 
						dt_inicio_cobertura_w	:= to_date(to_char(dt_adesao_w,'dd') || '/'|| to_char(dt_mes_competencia_w,'mm/yyyy'));
						exception 
						when others then 
							dt_inicio_cobertura_w	:= last_day(dt_mes_competencia_w);
						end;
						 
						dt_fim_cobertura_w	:= add_months(dt_inicio_cobertura_w,1)-1;
					end if;
				end if;
				 
				select	pls_obter_parcela_segurado(nr_seq_segurado_p, dt_mes_competencia_w, dt_mes_competencia_w), 
					pls_obter_parcela_contrato(nr_seq_contrato_w, dt_mes_competencia_w) 
				into STRICT	nr_parcela_seg_w, 
					nr_parcela_contrato_w 
				;				
				/*Insere o registro na tabela PLS_MENSALIDADE_SEGURADO*/
 
				CALL pls_store_data_mens_pck.insert_record_mensalidade(nm_usuario_p, nr_seq_segurado_p, nr_seq_mensalidade_w, qt_idade_w, 
							dt_mes_competencia_w, nr_parcela_seg_w, nr_seq_plano_w, nr_seq_contrato_w, nr_parcela_contrato_w, 
							pls_store_data_mens_pck.get_nr_seq_reajuste, null, null, dt_inicio_cobertura_w, dt_fim_cobertura_w, pls_store_data_mens_pck.get_nr_seq_titular, 
							dt_rescisao_w, pls_store_data_mens_pck.get_nr_seq_parentesco, 
							pls_store_data_mens_pck.get_nr_seq_subestipulante,pls_store_data_mens_pck.get_nr_seq_localizacao_benef);
				 
				nr_seq_mensalidade_seg_lim_w	:= pls_store_data_mens_pck.get_nr_seq_mensalidade_seg;
				 
				qt_dias_mes_w	:= 0;
				 
				select	max(nr_seq_tabela) 
				into STRICT	nr_seq_tabela_w 
				from	pls_segurado 
				where	nr_sequencia = nr_seq_segurado_p;
				 
				CALL pls_store_data_mens_pck.calcular_vls_reajuste_indice(nr_seq_tabela_w,null,nr_seq_segurado_p);
				nr_seq_preco_indice_w := pls_store_data_mens_pck.get_nr_seq_preco_indice;
				nr_seq_reajuste_w  := pls_store_data_mens_pck.get_nr_seq_reajuste;
				 
				if (nr_seq_reajuste_w IS NOT NULL AND nr_seq_reajuste_w::text <> '') then 
					select	trunc(max(dt_reajuste),'month') 
					into STRICT	dt_reajuste_w 
					from	pls_reajuste_preco 
					where	nr_sequencia = nr_seq_reajuste_w;
					 
					dt_mes_competencia_trunc_w := trunc(dt_mes_competencia_w,'month');
					 
					if (dt_mes_competencia_trunc_w >= dt_reajuste_w) then 
						vl_reajuste_indice_w := pls_store_data_mens_pck.get_vl_reajuste_indice;
					end if;
				end if;
				 
				if (vl_reajuste_indice_w > 0) then 
					vl_preco_atual_w	:= coalesce(vl_preco_atual_w,0) - coalesce(vl_reajuste_indice_w,0);
					ds_mensagem_reajuste_w := pls_store_data_mens_pck.get_ds_mensagem_reajuste;
				end if;
				 
				if (pls_store_data_mens_pck.get_ie_calc_primeira_mens	= 'I') or (nr_parcela_seg_w > 1) then 
					vl_limite_w	:= coalesce(vl_preco_atual_w,0);
				else 
					vl_mens_limite_w	:= coalesce(vl_preco_atual_w,0);
					 
					select	max(ie_calculo_proporcional) 
					into STRICT	ie_calculo_proporcional_w 
					from	pls_contrato_pagador 
					where	nr_sequencia = pls_store_data_mens_pck.get_nr_seq_pagador;
					 
					--Mês calendario adesão 
					if (ie_calculo_proporcional_w	= 'A') then 
						dt_vencimento_mens_w	:= last_day(dt_adesao_w);
					else 
						begin 
						dt_vencimento_mens_w	:= to_date(to_char(pls_store_data_mens_pck.get_dt_dia_vencimento) || '/' || to_char(dt_adesao_w,'mm/yyyy'));
						exception 
						when others then 
							dt_vencimento_mens_w	:= last_day(dt_adesao_w);
						end;
					end if;
					 
					if (dt_vencimento_mens_w < dt_adesao_w) then 
						dt_vencimento_mens_w	:= last_day(dt_vencimento_mens_w);
					end if;
					 
					qt_dias_pro_rata_w	:= obter_dias_entre_datas(dt_adesao_w,dt_vencimento_mens_w) + 1;
					 
					if (ie_data_base_proporcional_w = 'T') then 
						qt_dias_mes_w	:= 30;
						--tratamento mês de fevereiro. 
						if (to_char(dt_vencimento_mens_w,'mm') = 02) then 
							qt_dias_mes_w	:= to_char(last_day(dt_vencimento_mens_w),'dd');
						end if;
					else 
						qt_dias_mes_w	:= (to_char(last_day(dt_vencimento_mens_w),'dd'))::numeric;
					end if;
					 
					if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') then 
						tx_proporcional_rescisao_w := (qt_dias_pro_rata_w / qt_dias_mes_w);	
					end if;
					 
					tx_limite_1a_parc_w 	:= (qt_dias_pro_rata_w / qt_dias_mes_w);
					vl_limite_w		:= tx_limite_1a_parc_w * vl_mens_limite_w;
					vl_preco_nao_subsid_desc_w := tx_limite_1a_parc_w * vl_preco_nao_subsid_desc_w;
					vl_reajuste_indice_w	:= tx_limite_1a_parc_w * vl_reajuste_indice_w;
					 
					update	pls_segurado 
					set	ie_mensalidade_proporcional	= 'S' 
					where	nr_sequencia = nr_seq_segurado_p;
					 
					CALL pls_store_data_mens_pck.set_ie_mensalidade_proporc('S');
				end if;
				 
				if (coalesce(vl_limite_w,0) <> 0) then 
					if (vl_preco_nao_subsid_desc_w > 0) then 
						if (coalesce(pls_store_data_mens_pck.get_seq_pagador_subsid, pls_store_data_mens_pck.get_nr_seq_pagador_benef) = nr_seq_pagador_w) then 
							vl_limite_w	:= vl_limite_w - vl_preco_nao_subsid_desc_w;
							if (vl_limite_w	< 0) then 
								vl_limite_w	:= 0;
							end if;
							 
							nr_seq_item_mensalidade_w := null;
 
							nr_seq_item_mensalidade_w := pls_insert_mens_seg_item('12', nm_usuario_p, null, null, null, null, null, null, null, 'N', null, null, null, null, null, null, null, nr_seq_mensalidade_seg_lim_w, null, null, null, null, null, null, null, null, null, null, null, null, null, vl_preco_nao_subsid_desc_w, nr_seq_item_mensalidade_w);
						end if;
					end if;
					 
					if (coalesce(pls_store_data_mens_pck.get_seq_pagador_preco_pre, pls_store_data_mens_pck.get_nr_seq_pagador_benef) = nr_seq_pagador_w) then 
						 
						ie_gerou_item_pre_w	 := 'N';
						nr_seq_item_mensalidade_w := null;
						 
						nr_seq_item_mensalidade_w := pls_insert_mens_seg_item('1', nm_usuario_p, null, null, null, null, null, null, null, 'N', null, null, null, null, null, null, null, nr_seq_mensalidade_seg_lim_w, null, null, null, null, null, null, null, null, null, null, null, null, null, vl_limite_w, nr_seq_item_mensalidade_w);
									 
						if (nr_seq_item_mensalidade_w IS NOT NULL AND nr_seq_item_mensalidade_w::text <> '') then 
							ie_gerou_item_pre_w := 'S';
							CALL pls_store_data_mens_pck.set_nr_seq_mens_item_pre(nr_seq_item_mensalidade_w);
							CALL pls_inserir_apropriacao_preco('1', nr_seq_item_mensalidade_w, nr_seq_segurado_preco_w, vl_limite_w, 0, tx_limite_1a_parc_w, tx_proporcional_rescisao_w, nm_usuario_p);
						end if;
					end if;
				end if;
				 
				if	((coalesce(vl_reajuste_indice_w,0)	> 0) and (ie_gerou_item_pre_w = 'S')) then 
					if (ie_pag_complementar_w = 'N') then 
						select	max(nr_seq_pagador_item) 
						into STRICT	nr_seq_pagador_item_w 
						from	pls_pagador_item_mens 
						where	nr_seq_pagador	= nr_seq_pagador_w 
						and	ie_tipo_item	= '25';
					else 
						select	max(nr_seq_pagador_item) 
						into STRICT	nr_seq_pagador_item_w 
						from	pls_pagador_item_mens 
						where	nr_seq_pagador_item	= nr_seq_pagador_w 
						and	nr_seq_pagador		= nr_seq_pagador_benef_w 
						and	ie_tipo_item	= '25';
					end if;
					 
					if	(((coalesce(nr_seq_pagador_item_w,nr_seq_pagador_w) = nr_seq_pagador_w) and (ie_pag_complementar_w = 'N')) or 
						(ie_pag_complementar_w = 'S' AND nr_seq_pagador_item_w IS NOT NULL AND nr_seq_pagador_item_w::text <> '')) then 
						 
						nr_seq_item_mensalidade_w := null;
						 
						nr_seq_item_mensalidade_w := pls_insert_mens_seg_item('25', nm_usuario_p, null, ds_mensagem_reajuste_w, null, null, null, null, null, 'N', null, null, null, null, null, null, null, nr_seq_mensalidade_seg_lim_w, null, null, null, null, nr_seq_reajuste_w, null, null, null, null, null, null, null, null, vl_reajuste_indice_w, nr_seq_item_mensalidade_w);
 
						if (nr_seq_item_mensalidade_w IS NOT NULL AND nr_seq_item_mensalidade_w::text <> '') then 
							CALL pls_inserir_apropriacao_preco('25', nr_seq_item_mensalidade_w, nr_seq_preco_indice_w, vl_reajuste_indice_w, 
										0, tx_limite_1a_parc_w, tx_proporcional_rescisao_w, nm_usuario_p);
						end if;
					end if;	
				end if;
				 
				if (coalesce(pls_store_data_mens_pck.get_ie_taxa_inscricao,'N') = 'S') and (ie_pag_complementar_w = 'N') then 
					CALL pls_gerar_mens_taxa_insc(nr_seq_mensalidade_seg_lim_w,nm_usuario_p);
				end if;
				 
				if (ie_pag_complementar_w = 'N') then 
					begin 
					CALL pls_gerar_mens_sca(nr_seq_mensalidade_seg_lim_w,ie_mensalidade_mes_rescisao_w,nm_usuario_p);
					exception 
					when others then 
						CALL pls_gerar_mens_log_erro(nr_seq_lote_w,nr_seq_pagador_w,nr_seq_segurado_p,nr_seq_mensalidade_p, 
									'Erro ao gerar os valores de retroativos de SCA da mensalidade, com regra de data limite'||chr(13)||chr(10)||sqlerrm, 
									cd_estabelecimento_p,nm_usuario_p);
					end;
				end if;
				 
				if (ie_pag_complementar_w = 'N') then 
					/* VIA ADICIONAL */
 
					begin 
					CALL pls_gerar_mens_via_adicional(nr_seq_mensalidade_seg_lim_w, nm_usuario_p);
					exception 
					when others then 
						CALL pls_gerar_mens_log_erro(nr_seq_lote_w,nr_seq_pagador_w,nr_seq_segurado_p,nr_seq_mensalidade_p, 
									'Erro ao gerar os valores adicionais da mensalidade'||chr(13)||chr(10)||sqlerrm,cd_estabelecimento_p,nm_usuario_p);
					end;
				end if;
				 
				if (coalesce(pls_store_data_mens_pck.get_seq_pagador_bonificacao, pls_store_data_mens_pck.get_nr_seq_pagador_benef) = nr_seq_pagador_w) then 
					/* Gerar bonificação */
 
					begin 
					CALL pls_gerar_mens_bonificacao(nr_seq_mensalidade_seg_lim_w, nr_seq_intercambio_w, nr_seq_contrato_w, nr_seq_segurado_p, nm_usuario_p);
					exception 
					when others then 
						CALL pls_gerar_mens_log_erro(nr_seq_lote_w,nr_seq_pagador_w,nr_seq_segurado_p,nr_seq_mensalidade_p, 
									'Erro ao gerar as bonificação da mensalidade, com regra de data limite'||chr(13)||chr(10)||sqlerrm,cd_estabelecimento_p,nm_usuario_p);
					end;
				end if;
				 
				CALL pls_gerar_mens_lanc_prog(nr_seq_mensalidade_seg_lim_w,null,nm_usuario_p);
				/* 
				pls_gerar_mens_coparticipacao(nr_seq_mensalidade_seg_lim_w, nm_usuario_p, cd_estabelecimento_p); 
				pls_gerar_mens_pos_estab(nr_seq_mensalidade_seg_lim_w, null, 'A', nm_usuario_p); 
				pls_gerar_mens_co(nr_seq_mensalidade_seg_lim_w, nm_usuario_p,cd_estabelecimento_p); 
				*/
 
				 
				CALL pls_atualiza_valor_mens_seg(nr_seq_mensalidade_seg_lim_w, nm_usuario_p);
			end if;
			end;
		end loop;
		close C01;
	end if;
end if;
 
CALL pls_store_data_mens_pck.clear_pls_mensalidade_segurado();
CALL pls_store_data_mens_pck.set_dt_mesano_referencia(dt_mesano_referencia_aux_w);
CALL pls_store_data_mens_pck.set_nr_seq_segurado_preco(nr_seq_segurado_preco_aux_w);
CALL pls_store_data_mens_pck.set_nr_seq_mensalidade(nr_seq_mensalidade_aux_w);
CALL pls_store_data_mens_pck.set_nr_parcela(nr_parcela_aux_w);
CALL pls_store_data_mens_pck.set_nr_parcela_contrato(nr_parcela_contrato_aux_w);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mensalidade_limite ( nr_seq_segurado_p bigint, nr_seq_mensalidade_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

