-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_obj_dados_rescisao_pck.obter_dados_rescisao ( nr_seq_rescisao_fin_p pls_solic_rescisao_fin.nr_sequencia%type, cd_estabelecimento_p bigint) RETURNS SETOF T_DADOS_RESCISAO AS $body$
DECLARE


linha_w				t_dados_rescisao_row;

vl_mensalidade_w		pls_segurado_preco.vl_preco_atual%type;
dt_origem_w			pls_solicitacao_rescisao.dt_solicitacao%type;
dt_origem_ww			pls_solicitacao_rescisao.dt_solicitacao%type;
dt_fim_multa_contr_w		pls_solicitacao_rescisao.dt_solicitacao%type;
vl_mensalidades_nao_geradas_w	pls_segurado_preco.vl_preco_atual%type;
qt_meses_nao_gerados_w		bigint;
qt_registros_w			bigint;
qt_dias_cobertura_w		bigint;
qt_dias_cobertura_pro_w		bigint;
qt_dias_w			double precision;
qt_dias_mes_w			bigint;
qt_passegens_loop_w		bigint;
dt_mensalidade_w		timestamp;
ie_devolver_dia_rescisao_w	pls_resc_fin_mens.ie_devolver_dia_rescisao%type;
ie_contas_medicas_pendentes_w	pls_resc_fin_mens.ie_contas_medicas_pendentes%type;
ie_lanc_prog_pendentes_w	pls_resc_fin_mens.ie_lanc_prog_pendentes%type;
ie_baixa_dev_titulo_w		pls_resc_fin_mens.ie_baixa_dev_titulo%type;
ie_desc_liq_rescisao_w		pls_resc_fin_mens.ie_desconsiderar_liq_rescisao%type;
ie_devolucao_item_w		varchar(1);
nr_titulo_w			titulo_receber.nr_titulo%type;
dt_solicitacao_w		pls_solicitacao_rescisao.dt_solicitacao%type;
nr_hora_minuto_w		double precision;
ie_status_w			pls_solic_rescisao_fin.nr_sequencia%type;
ie_titulo_liq_mens_w		pls_resc_fin_mens.ie_titulo_liq_mens%type;
ie_situacao_tit_w		titulo_receber.ie_situacao%type;
ie_exibir_w			varchar(1);
ie_isentar_multa_w		pls_motivo_cancelamento.ie_isentar_multa%type;
nr_seq_regra_w			pls_resc_fin_mens.nr_sequencia%type;
tx_valor_dev_w			double precision;
vl_devolucao_mens_w		double precision;
vl_pro_rata_w			double precision;
vl_antecipacao_w		double precision;
vl_ato_cooperado_w		double precision;
vl_ato_nao_cooperado_w		double precision;
vl_ato_auxiliar_w		double precision;
vl_ato_auxiliar_antec_w		double precision;
vl_ato_nao_coop_antec_w		double precision;
vl_ato_cooperado_antec_w	double precision;
vl_ato_auxiliar_pro_rata_w	double precision;
vl_ato_nao_coop_pro_rata_w	double precision;
vl_ato_cooperado_pro_rata_w	double precision;
vl_total_ato_w			double precision;
ie_baixa_rescisao_contrato_w	titulo_receber_liq.ie_baixa_rescisao_contrato%type;
ie_mes_rescisao_w		varchar(1);
ie_mes_posterior_rescisao_w	varchar(1);

C01 CURSOR FOR
	SELECT	 b.nr_seq_segurado,
		 a.nr_seq_pagador
	from	 pls_solic_rescisao_fin a,
		 pls_solic_rescisao_benef b,
		 pls_solicitacao_rescisao c,
		 pls_segurado_pagador d
	where	 c.nr_sequencia	= b.nr_seq_solicitacao	
	and	 c.nr_sequencia	= a.nr_seq_solicitacao
	and	 d.nr_seq_segurado = b.nr_seq_segurado
	and	 d.nr_seq_pagador = a.nr_seq_pagador
	and	 a.nr_sequencia	= nr_seq_rescisao_fin_p
	group by b.nr_seq_segurado,
		 a.nr_seq_pagador;

--1 - Mensalidade

C02 CURSOR(	nr_seq_segurado_pc	bigint,
		nr_seq_pagador_pc	bigint,
		dt_solicitacao_pc	timestamp) FOR
	SELECT	a.vl_item,
		b.dt_mesano_referencia,
		coalesce(a.dt_inicio_cobertura, b.dt_inicio_cobertura) dt_inicio_cobertura,
		coalesce(a.dt_fim_cobertura, b.dt_fim_cobertura) dt_fim_cobertura,
		a.nr_sequencia nr_seq_item_mensalidade,
		c.nr_sequencia nr_seq_mensalidade,
		a.ie_tipo_item ie_tipo_item_mens,
		a.nr_seq_tipo_lanc,
		null nr_titulo,
		(SELECT	max(ie_situacao)
		from	titulo_receber x
		where	c.nr_sequencia = x.nr_seq_mensalidade) ie_situacao_tit,
		coalesce(a.vl_ato_auxiliar, 0) vl_ato_auxiliar,
		coalesce(a.vl_ato_auxiliar_antec, 0) vl_ato_auxiliar_antec,
		coalesce(a.vl_ato_auxiliar_pro_rata, 0) vl_ato_auxiliar_pro_rata,
		coalesce(a.vl_ato_cooperado, 0) vl_ato_cooperado,
		coalesce(a.vl_ato_cooperado_antec, 0) vl_ato_cooperado_antec,
		coalesce(a.vl_ato_cooperado_pro_rata, 0) vl_ato_cooperado_pro_rata,
		coalesce(a.vl_ato_nao_coop_antec, 0) vl_ato_nao_coop_antec,
		coalesce(a.vl_ato_nao_cooperado, 0) vl_ato_nao_cooperado,
		coalesce(a.vl_ato_nao_coop_pro_rata, 0) vl_ato_nao_coop_pro_rata,
		coalesce(a.vl_pro_rata_dia, 0) vl_pro_rata_dia,
		coalesce(a.vl_antecipacao, 0) vl_antecipacao
	from	pls_mensalidade_seg_item a,
		pls_mensalidade_segurado b,
		pls_mensalidade c,
		pls_lote_mensalidade d
	where	b.nr_sequencia	= a.nr_seq_mensalidade_seg
	and	c.nr_sequencia	= b.nr_seq_mensalidade
	and	d.nr_sequencia	= c.nr_seq_lote
	and	b.nr_seq_segurado = nr_seq_segurado_pc
	and	c.nr_seq_pagador = nr_seq_pagador_pc
	and	d.ie_status = 2
	and	coalesce(c.ie_cancelamento::text, '') = ''
	and	((dt_solicitacao_pc between coalesce(a.dt_inicio_cobertura,b.dt_inicio_cobertura) and coalesce(a.dt_fim_cobertura,b.dt_fim_cobertura))
	or (coalesce(a.dt_inicio_cobertura,b.dt_inicio_cobertura) > dt_solicitacao_pc))
	
union all
  --Titulos atrasados / Com cobertura anterior a rescisao do beneficiario
	select	a.vl_item,
		b.dt_mesano_referencia,
		coalesce(a.dt_inicio_cobertura, b.dt_inicio_cobertura) dt_inicio_cobertura,
		coalesce(a.dt_fim_cobertura, b.dt_fim_cobertura) dt_fim_cobertura,
		a.nr_sequencia nr_seq_item_mensalidade,
		c.nr_sequencia nr_seq_mensalidade,
		a.ie_tipo_item ie_tipo_item_mens,
		a.nr_seq_tipo_lanc,
		d.nr_titulo nr_titulo,
		d.ie_situacao ie_situacao_tit,
		coalesce(a.vl_ato_auxiliar, 0) vl_ato_auxiliar,
		coalesce(a.vl_ato_auxiliar_antec, 0) vl_ato_auxiliar_antec,
		coalesce(a.vl_ato_auxiliar_pro_rata, 0) vl_ato_auxiliar_pro_rata,
		coalesce(a.vl_ato_cooperado, 0) vl_ato_cooperado,
		coalesce(a.vl_ato_cooperado_antec, 0) vl_ato_cooperado_antec,
		coalesce(a.vl_ato_cooperado_pro_rata, 0) vl_ato_cooperado_pro_rata,
		coalesce(a.vl_ato_nao_coop_antec, 0) vl_ato_nao_coop_antec,
		coalesce(a.vl_ato_nao_cooperado, 0) vl_ato_nao_cooperado,
		coalesce(a.vl_ato_nao_coop_pro_rata, 0) vl_ato_nao_coop_pro_rata,
		coalesce(a.vl_pro_rata_dia, 0) vl_pro_rata_dia,
		coalesce(a.vl_antecipacao, 0) vl_antecipacao
	from	pls_mensalidade_seg_item a,
		pls_mensalidade_segurado b,
		pls_mensalidade c,
		titulo_receber d
	where	b.nr_sequencia	= a.nr_seq_mensalidade_seg
	and	c.nr_sequencia	= b.nr_seq_mensalidade
	and	c.nr_sequencia	= d.nr_seq_mensalidade
	and	d.ie_situacao	= '1'
	and	b.nr_seq_segurado = nr_seq_segurado_pc
	and	c.nr_seq_pagador = nr_seq_pagador_pc
	and	coalesce(c.ie_cancelamento::text, '') = ''
	and	coalesce(a.dt_fim_cobertura,b.dt_fim_cobertura) < dt_solicitacao_pc;

C10 CURSOR(	nr_seq_rescisao_fin_pc bigint) FOR
	SELECT	nr_sequencia,
		ie_tipo_item,
		ie_tipo_valor,
		nr_seq_segurado,
		vl_item,
		vl_devolucao_mens,
		dt_referencia,
		qt_dias_cobertura,
		qt_dias_devolucao,
		nr_seq_mensalidade,
		nr_seq_item_mensalidade,
		ie_acao,
		nr_titulo,
		vl_pro_rata_dia,
		vl_antecipacao,
		vl_ato_auxiliar,
		vl_ato_auxiliar_antec,
		vl_ato_auxiliar_pro_rata,	
		vl_ato_cooperado,		
		vl_ato_cooperado_antec,		
		vl_ato_cooperado_pro_rata,	
		vl_ato_nao_cooperado,		
		vl_ato_nao_coop_antec,		
		vl_ato_nao_coop_pro_rata,
		vl_devolver,
		vl_cancelar,
		dt_contabil
	from	pls_solic_resc_fin_item
	where	nr_seq_solic_resc_fin	= nr_seq_rescisao_fin_pc;

BEGIN

if (nr_seq_rescisao_fin_p IS NOT NULL AND nr_seq_rescisao_fin_p::text <> '') then
	select	ie_status
	into STRICT	ie_status_w
	from	pls_solic_rescisao_fin
	where	nr_sequencia	= nr_seq_rescisao_fin_p;
	
	if (ie_status_w <> 1) then --Se o status nao for Pendente
		for r_c10_w in C10(nr_seq_rescisao_fin_p) loop
			begin
			linha_w	:= null;
			linha_w.nr_sequencia			:= r_c10_w.nr_sequencia;
			linha_w.ie_tipo_item			:= r_c10_w.ie_tipo_item;
			linha_w.ie_tipo_valor			:= r_c10_w.ie_tipo_valor;
			linha_w.nr_seq_segurado			:= r_c10_w.nr_seq_segurado;
			linha_w.vl_item				:= r_c10_w.vl_item;
			linha_w.vl_devolucao_mens		:= r_c10_w.vl_devolucao_mens;
			linha_w.dt_referencia			:= r_c10_w.dt_referencia;
			linha_w.qt_dias_cobertura		:= r_c10_w.qt_dias_cobertura;
			linha_w.qt_dias_devolucao		:= r_c10_w.qt_dias_devolucao;
			linha_w.nr_seq_mensalidade		:= r_c10_w.nr_seq_mensalidade;
			linha_w.nr_seq_item_mensalidade		:= r_c10_w.nr_seq_item_mensalidade;
			linha_w.ie_acao				:= r_c10_w.ie_acao;
			linha_w.nr_titulo			:= r_c10_w.nr_titulo;
			linha_w.vl_pro_rata_dia			:= r_c10_w.vl_pro_rata_dia;
			linha_w.vl_antecipacao			:= r_c10_w.vl_antecipacao;
			linha_w.vl_ato_auxiliar			:= r_c10_w.vl_ato_auxiliar;
			linha_w.vl_ato_auxiliar_antec		:= r_c10_w.vl_ato_auxiliar_antec;
			linha_w.vl_ato_auxiliar_pro_rata	:= r_c10_w.vl_ato_auxiliar_pro_rata;
			linha_w.vl_ato_cooperado		:= r_c10_w.vl_ato_cooperado;
			linha_w.vl_ato_cooperado_antec		:= r_c10_w.vl_ato_cooperado_antec;
			linha_w.vl_ato_cooperado_pro_rata	:= r_c10_w.vl_ato_cooperado_pro_rata;
			linha_w.vl_ato_nao_cooperado		:= r_c10_w.vl_ato_nao_cooperado;
			linha_w.vl_ato_nao_coop_antec		:= r_c10_w.vl_ato_nao_coop_antec;
			linha_w.vl_ato_nao_coop_pro_rata	:= r_c10_w.vl_ato_nao_coop_pro_rata;
			linha_w.vl_devolver			:= r_c10_w.vl_devolver;
			linha_w.vl_cancelar			:= r_c10_w.vl_cancelar;
			linha_w.dt_contabil			:= r_c10_w.dt_contabil;
			RETURN NEXT linha_w;
			end;
		end loop;
	else
		select	coalesce(b.dt_rescisao,b.dt_solicitacao) --A data de rescisao pode ser diferente e precisa ser considerada nos calculos
		into STRICT	dt_solicitacao_w
		from	pls_solic_rescisao_fin a,
			pls_solicitacao_rescisao b
		where	b.nr_sequencia	= a.nr_seq_solicitacao
		and	a.nr_sequencia	= nr_seq_rescisao_fin_p;
		
		nr_seq_regra_w	:= pls_obter_regra_resc_fin(nr_seq_rescisao_fin_p, cd_estabelecimento_p);
		
		select	max(ie_devolver_dia_rescisao),
			coalesce(max(ie_contas_medicas_pendentes),'N'),
			coalesce(max(ie_lanc_prog_pendentes),'N'),
			coalesce(max(ie_titulo_liq_mens), 'N'),
			coalesce(max(ie_baixa_dev_titulo),'N'),
			coalesce(max(ie_desconsiderar_liq_rescisao),'N')
		into STRICT	ie_devolver_dia_rescisao_w,
			ie_contas_medicas_pendentes_w,
			ie_lanc_prog_pendentes_w,
			ie_titulo_liq_mens_w,
			ie_baixa_dev_titulo_w,
			ie_desc_liq_rescisao_w
		from	pls_resc_fin_mens
		where	nr_sequencia	= nr_seq_regra_w;
		
		if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
			for r_C01_w in C01 loop
				--1 - Mensalidade

				for r_C02_w in C02(	r_C01_w.nr_seq_segurado,
							r_C01_w.nr_seq_pagador,
							trunc(dt_solicitacao_w,'dd')) loop
					ie_exibir_w	:= 'S';

					if (coalesce(r_c02_w.nr_titulo::text, '') = '') then
						select	max(nr_titulo)
						into STRICT	nr_titulo_w
						from	titulo_receber
						where	nr_seq_mensalidade = r_c02_w.nr_seq_mensalidade;
						
						if (ie_titulo_liq_mens_w = 'S') then
							if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
								select	max(ie_situacao)
								into STRICT	ie_situacao_tit_w
								from	titulo_receber
								where	nr_titulo = nr_titulo_w;
								
								if (ie_situacao_tit_w = '2') then
									ie_exibir_w	:= 'S';
								else
									ie_exibir_w	:= 'N';
								end if;
							else
								ie_exibir_w	:= 'N';
							end if;
						end if;
					elsif (ie_titulo_liq_mens_w = 'S') then
						ie_exibir_w	:= 'N';
					else
						nr_titulo_w	:= r_c02_w.nr_titulo;
					end if;
					
					if (ie_desc_liq_rescisao_w = 'S') and (ie_exibir_w = 'S') and (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
						select	count(1)
						into STRICT	qt_registros_w
						from	titulo_receber_liq
						where	nr_titulo	= nr_titulo_w
						and	coalesce(ie_baixa_rescisao_contrato,'N') = 'S';
						
						if (qt_registros_w > 0) then
							ie_exibir_w	:= 'N';
						end if;
					end if;
					
					if (ie_exibir_w = 'S') then
						linha_w := null;
						linha_w.ie_tipo_item	:= 1;
						linha_w.ie_tipo_valor	:= 'P'; --Pagar - Devolucacao
						linha_w.nr_seq_segurado	:= r_C01_w.nr_seq_segurado;
						
						select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
						into STRICT	ie_devolucao_item_w
						from	pls_resc_fin_mens_item x,
							pls_resc_fin_mens y
						where	y.nr_sequencia		= x.nr_seq_regra
						and	y.nr_sequencia		= nr_seq_regra_w
						and	x.ie_tipo_item		= r_c02_w.ie_tipo_item_mens
						and (x.nr_seq_tipo_lanc = r_c02_w.nr_seq_tipo_lanc or coalesce(x.nr_seq_tipo_lanc::text, '') = '');

						if (trunc(r_c02_w.dt_inicio_cobertura,'mm') = trunc(dt_solicitacao_w,'mm')) then
							ie_mes_rescisao_w := 'S';
							ie_mes_posterior_rescisao_w := 'N';
						else
							ie_mes_rescisao_w := 'N';
							
							if (trunc(r_c02_w.dt_fim_cobertura,'mm') > trunc(r_c02_w.dt_inicio_cobertura,'mm')) then
								if (trunc(r_c02_w.dt_fim_cobertura,'mm') = trunc(dt_solicitacao_w,'mm')) then
									ie_mes_posterior_rescisao_w := 'S';
								else
									ie_mes_posterior_rescisao_w := 'N';
								end if;
							else
								ie_mes_posterior_rescisao_w := 'N';
							end if;
						end if;
						
						if (r_c02_w.dt_inicio_cobertura > dt_solicitacao_w) then
							linha_w.vl_item			:= r_C02_w.vl_item;
							linha_w.qt_dias_cobertura	:= round(trunc(r_C02_w.dt_fim_cobertura,'dd') - r_C02_w.dt_inicio_cobertura)+1;
							
							if (ie_devolucao_item_w = 'S') then
								vl_devolucao_mens_w			:= r_c02_w.vl_item;
								linha_w.qt_dias_devolucao		:= round(trunc(r_C02_w.dt_fim_cobertura,'dd') - r_C02_w.dt_inicio_cobertura)+1;
								linha_w.vl_devolucao_mens		:= vl_devolucao_mens_w;
								linha_w.vl_ato_cooperado		:= r_c02_w.vl_ato_cooperado;
								linha_w.vl_ato_auxiliar			:= r_c02_w.vl_ato_auxiliar;
								linha_w.vl_ato_nao_cooperado		:= r_c02_w.vl_ato_nao_cooperado;
								
								if (ie_mes_posterior_rescisao_w = 'S') then
									linha_w.vl_ato_auxiliar_antec		:= r_c02_w.vl_ato_auxiliar_antec + r_c02_w.vl_ato_auxiliar_pro_rata;
									linha_w.vl_ato_cooperado_antec		:= r_c02_w.vl_ato_cooperado_antec + r_c02_w.vl_ato_cooperado_pro_rata;
									linha_w.vl_ato_nao_coop_antec		:= r_c02_w.vl_ato_nao_coop_antec + r_c02_w.vl_ato_nao_coop_pro_rata;
									linha_w.vl_ato_auxiliar_pro_rata	:= 0;
									linha_w.vl_ato_cooperado_pro_rata	:= 0;
									linha_w.vl_ato_nao_coop_pro_rata	:= 0;
									linha_w.vl_pro_rata_dia			:= 0;
									linha_w.vl_antecipacao			:= r_c02_w.vl_antecipacao + r_c02_w.vl_pro_rata_dia;
								else
									linha_w.vl_ato_auxiliar_antec		:= r_c02_w.vl_ato_auxiliar_antec;
									linha_w.vl_ato_cooperado_antec		:= r_c02_w.vl_ato_cooperado_antec;
									linha_w.vl_ato_nao_coop_antec		:= r_c02_w.vl_ato_nao_coop_antec;
									linha_w.vl_ato_auxiliar_pro_rata	:= r_c02_w.vl_ato_auxiliar_pro_rata;
									linha_w.vl_ato_cooperado_pro_rata	:= r_c02_w.vl_ato_cooperado_pro_rata;
									linha_w.vl_ato_nao_coop_pro_rata	:= r_c02_w.vl_ato_nao_coop_pro_rata;
									linha_w.vl_pro_rata_dia			:= r_c02_w.vl_pro_rata_dia;
									linha_w.vl_antecipacao			:= r_c02_w.vl_antecipacao;
								end if;
							else
								vl_devolucao_mens_w			:= 0;
								linha_w.qt_dias_devolucao		:= 0;
								linha_w.vl_devolucao_mens		:= vl_devolucao_mens_w;
								linha_w.vl_ato_auxiliar			:= 0;
								linha_w.vl_ato_auxiliar_antec		:= 0;
								linha_w.vl_ato_auxiliar_pro_rata	:= 0;
								linha_w.vl_ato_cooperado		:= 0;
								linha_w.vl_ato_cooperado_antec		:= 0;
								linha_w.vl_ato_cooperado_pro_rata	:= 0;
								linha_w.vl_ato_nao_coop_antec		:= 0;
								linha_w.vl_ato_nao_cooperado		:= 0;
								linha_w.vl_ato_nao_coop_pro_rata	:= 0;
								linha_w.vl_pro_rata_dia			:= 0;
								linha_w.vl_antecipacao			:= 0;
							end if;
						elsif (trunc(dt_solicitacao_w,'dd') between r_C02_w.dt_inicio_cobertura and r_c02_w.dt_fim_cobertura) then
							qt_dias_cobertura_w	:= round(trunc(r_C02_w.dt_fim_cobertura,'dd') - r_C02_w.dt_inicio_cobertura)+1;
							qt_dias_w		:= round(trunc(r_C02_w.dt_fim_cobertura,'dd') - trunc(dt_solicitacao_w,'dd'));
							
							if (ie_devolver_dia_rescisao_w = 'S') then
								qt_dias_w := qt_dias_w+1;
							elsif (ie_devolver_dia_rescisao_w = 'P') then
								if (fim_dia(r_c02_w.dt_fim_cobertura) = dt_solicitacao_w) then
									ie_devolucao_item_w := 'N';
								else
									nr_hora_minuto_w := ((to_number(((to_char(dt_solicitacao_w,'hh24'))::numeric *60) + (to_char(dt_solicitacao_w,'mi'))::numeric ) / 1440) - 1) *-1;
									qt_dias_w := qt_dias_w+nr_hora_minuto_w;
								end if;
							end if;
							
							linha_w.vl_item			:= r_C02_w.vl_item;
							linha_w.qt_dias_cobertura	:= qt_dias_cobertura_w;
							
							if (ie_devolucao_item_w = 'S') then
								vl_devolucao_mens_w			:= (r_C02_w.vl_item/qt_dias_cobertura_w) * qt_dias_w;
								tx_valor_dev_w				:= dividir_sem_round(vl_devolucao_mens_w, r_c02_w.vl_item);
								
								vl_ato_cooperado_w			:= r_c02_w.vl_ato_cooperado * tx_valor_dev_w;
								vl_ato_nao_cooperado_w			:= r_c02_w.vl_ato_nao_cooperado * tx_valor_dev_w;
								vl_ato_auxiliar_w			:= r_c02_w.vl_ato_auxiliar * tx_valor_dev_w;
								
								vl_total_ato_w				:= vl_ato_cooperado_w + vl_ato_nao_cooperado_w + vl_ato_auxiliar_w;

								if (vl_devolucao_mens_w <> vl_total_ato_w) then
									if (vl_ato_cooperado_w	<> 0) then
										vl_ato_cooperado_w	:= vl_ato_cooperado_w + (vl_devolucao_mens_w - vl_total_ato_w);
									elsif (vl_ato_auxiliar_w	<> 0) then
										vl_ato_auxiliar_w	:= vl_ato_auxiliar_w + (vl_devolucao_mens_w - vl_total_ato_w);
									elsif (vl_ato_nao_cooperado_w <> 0) then
										vl_ato_nao_cooperado_w	:= vl_ato_nao_cooperado_w + (vl_devolucao_mens_w - vl_total_ato_w);
									end if;
								end if;
								
								if (ie_mes_rescisao_w = 'S') then
									if	(r_c02_w.vl_pro_rata_dia <> 0 AND r_c02_w.vl_antecipacao <> 0) then -- Se tiver valor de pro rata e antecipacao faz o rateio
										if (dt_solicitacao_w <= fim_mes(r_C02_w.dt_inicio_cobertura)) then
											vl_antecipacao_w	:= r_c02_w.vl_antecipacao;
											vl_pro_rata_w		:= vl_devolucao_mens_w - vl_antecipacao_w;
										else
											vl_pro_rata_w		:= 0;
											vl_antecipacao_w	:= vl_devolucao_mens_w;
										end if;
									else	-- Se tiver apenas o valor de pro rata, o sistema usa o valor da devolucao para o valor de pro rata e o valor de antecipacao fica 0
										vl_pro_rata_w			:= vl_devolucao_mens_w;
										vl_antecipacao_w		:= 0;
									end if;

									/*
									Devolucao, Exemplo 30$
										Valor dev	Pro-rata	Antecipacao
									Item	R$ 30,00	R$ 21,00	 R$ 9,00
									Ato coop	R$ 10,50	R$ 3,00	 R$ 7,50
									Ato aux	R$ 6,00	R$ 6,00	 R$ 0,00
									Ato nao	R$ 13,50	R$ 12,00	 R$ 1,50 
									*/

									
									vl_ato_auxiliar_antec_w			:= r_c02_w.vl_ato_auxiliar_antec * tx_valor_dev_w;
									vl_ato_nao_coop_antec_w			:= r_c02_w.vl_ato_nao_coop_antec * tx_valor_dev_w;
									vl_ato_cooperado_antec_w		:= r_c02_w.vl_ato_cooperado_antec * tx_valor_dev_w;
									
									if	(vl_antecipacao_w <> (vl_ato_nao_coop_antec_w + vl_ato_auxiliar_antec_w + vl_ato_cooperado_antec_w)) then
										if (vl_ato_nao_coop_antec_w <> 0) then
											vl_ato_nao_coop_antec_w		:= vl_ato_nao_coop_antec_w + (vl_antecipacao_w - (vl_ato_nao_coop_antec_w + vl_ato_auxiliar_antec_w + vl_ato_cooperado_antec_w));
										elsif (vl_ato_auxiliar_antec_w <> 0) then
											vl_ato_auxiliar_antec_w		:= vl_ato_auxiliar_antec_w + (vl_antecipacao_w - (vl_ato_nao_coop_antec_w + vl_ato_auxiliar_antec_w + vl_ato_cooperado_antec_w));
										elsif (vl_ato_cooperado_antec_w <> 0) then
											vl_ato_cooperado_antec_w	:= vl_ato_cooperado_antec_w + (vl_antecipacao_w - (vl_ato_nao_coop_antec_w + vl_ato_auxiliar_antec_w + vl_ato_cooperado_antec_w));
										end if;
									end if;
									
									vl_ato_auxiliar_pro_rata_w	:= vl_ato_auxiliar_w - vl_ato_auxiliar_antec_w;
									vl_ato_nao_coop_pro_rata_w	:= vl_ato_nao_cooperado_w - vl_ato_nao_coop_antec_w;
									vl_ato_cooperado_pro_rata_w	:= vl_ato_cooperado_w - vl_ato_cooperado_antec_w;
								else
									/*
									Devolucao, Exemplo 30$
										Valor dev	Pro-rata	Antecipacao
									Item	R$ 30,00	R$ 0	 R$ 30,00
									Ato coop	R$ 10,50	R$ 0	 R$ 10,50
									Ato aux	R$ 6,00	R$ 0	 R$ 6,00
									Ato nao	R$ 13,50	R$ 0	 R$ 13,50 
									*/

									
									vl_antecipacao_w		:= vl_devolucao_mens_w;
									vl_pro_rata_w			:= 0;
									vl_ato_auxiliar_pro_rata_w	:= 0;
									vl_ato_cooperado_pro_rata_w	:= 0;
									vl_ato_nao_coop_pro_rata_w	:= 0;
									vl_ato_auxiliar_antec_w		:= vl_ato_auxiliar_w;
									vl_ato_cooperado_antec_w	:= vl_ato_cooperado_w;
									vl_ato_nao_coop_antec_w		:= vl_ato_nao_cooperado_w;
								end if;
									
								linha_w.qt_dias_devolucao		:= qt_dias_w;
								linha_w.vl_devolucao_mens		:= vl_devolucao_mens_w;
								linha_w.vl_pro_rata_dia			:= vl_pro_rata_w;
								linha_w.vl_antecipacao			:= vl_antecipacao_w;
								linha_w.vl_ato_auxiliar			:= vl_ato_auxiliar_w;
								linha_w.vl_ato_auxiliar_antec		:= vl_ato_auxiliar_antec_w;
								linha_w.vl_ato_auxiliar_pro_rata	:= vl_ato_auxiliar_pro_rata_w;
								linha_w.vl_ato_cooperado		:= vl_ato_cooperado_w;
								linha_w.vl_ato_cooperado_antec		:= vl_ato_cooperado_antec_w;
								linha_w.vl_ato_cooperado_pro_rata	:= vl_ato_cooperado_pro_rata_w;
								linha_w.vl_ato_nao_cooperado		:= vl_ato_nao_cooperado_w;
								linha_w.vl_ato_nao_coop_antec		:= vl_ato_nao_coop_antec_w;
								linha_w.vl_ato_nao_coop_pro_rata	:= vl_ato_nao_coop_pro_rata_w;
							else
								vl_devolucao_mens_w			:= 0;
								linha_w.qt_dias_devolucao		:= 0;
								linha_w.vl_devolucao_mens		:= vl_devolucao_mens_w;
								linha_w.vl_ato_auxiliar			:= 0;
								linha_w.vl_ato_auxiliar_antec		:= 0;
								linha_w.vl_ato_auxiliar_pro_rata	:= 0;
								linha_w.vl_ato_cooperado		:= 0;
								linha_w.vl_ato_cooperado_antec		:= 0;
								linha_w.vl_ato_cooperado_pro_rata	:= 0;
								linha_w.vl_ato_nao_coop_antec		:= 0;
								linha_w.vl_ato_nao_cooperado		:= 0;
								linha_w.vl_ato_nao_coop_pro_rata	:= 0;
								linha_w.vl_pro_rata_dia			:= 0;
								linha_w.vl_antecipacao			:= 0;
							end if;
						else
							vl_devolucao_mens_w			:= 0;
							linha_w.vl_item				:= r_C02_w.vl_item;
							linha_w.qt_dias_cobertura		:= round(trunc(r_C02_w.dt_fim_cobertura,'dd') - r_C02_w.dt_inicio_cobertura)+1;
							linha_w.qt_dias_devolucao		:= 0;
							linha_w.vl_devolucao_mens		:= vl_devolucao_mens_w;
							linha_w.vl_ato_auxiliar			:= 0;
							linha_w.vl_ato_auxiliar_antec		:= 0;
							linha_w.vl_ato_auxiliar_pro_rata	:= 0;
							linha_w.vl_ato_cooperado		:= 0;
							linha_w.vl_ato_cooperado_antec		:= 0;
							linha_w.vl_ato_cooperado_pro_rata	:= 0;
							linha_w.vl_ato_nao_coop_antec		:= 0;
							linha_w.vl_ato_nao_cooperado		:= 0;
							linha_w.vl_ato_nao_coop_pro_rata	:= 0;
							linha_w.vl_pro_rata_dia			:= 0;
							linha_w.vl_antecipacao			:= 0;
						end if;
						

						if (coalesce(r_c02_w.ie_situacao_tit, '1') = '2') or (ie_baixa_dev_titulo_w = 'N') then
							linha_w.vl_devolver := vl_devolucao_mens_w;
							linha_w.vl_cancelar := 0;
						else
							linha_w.vl_cancelar := vl_devolucao_mens_w;
							linha_w.vl_devolver := 0;
						end if;

						if (r_C02_w.dt_mesano_referencia > dt_solicitacao_w) then
							linha_w.dt_contabil	:= r_C02_w.dt_mesano_referencia;
						else
							linha_w.dt_contabil	:= dt_solicitacao_w;
						end if;
						
						linha_w.nr_seq_mensalidade	:= r_c02_w.nr_seq_mensalidade;
						linha_w.nr_seq_item_mensalidade	:= r_C02_w.nr_seq_item_mensalidade;
						linha_w.dt_referencia		:= r_C02_w.dt_mesano_referencia;
						linha_w.nr_titulo		:= nr_titulo_w;
						linha_w.ie_acao			:= 2; --Devolver

						if (coalesce(nr_titulo_w::text, '') = '') then
							linha_w.ie_exibir := 'N';
						end if;
						
						RETURN NEXT linha_w;
					end if;
				end loop; --C02
			end loop; --C01
		end if;
	end if;
end if;

--Nao retorna nada

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obj_dados_rescisao_pck.obter_dados_rescisao ( nr_seq_rescisao_fin_p pls_solic_rescisao_fin.nr_sequencia%type, cd_estabelecimento_p bigint) FROM PUBLIC;
