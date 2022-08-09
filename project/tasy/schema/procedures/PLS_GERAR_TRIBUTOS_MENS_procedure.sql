-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_tributos_mens ( nr_seq_mensalidade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar os tributos da mensalidade por item
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicion?rio [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relat?rios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de aten??o:
	Se o tributo ? gerado pelo corpo ou pelo item

	N?O ALTERAR ESTA ROTINA CASO N?O SEJA OS DE DEFEITO OU DE
	EXTREMA IMPORT?NCIA

-------------------------------------------------------------------------------------------------------------------

Refer?ncias:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_reteu_w			varchar(255)	:= 'N';
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(10);
ie_acumulativo_w		varchar(10);
ie_saldo_tit_rec_w		varchar(2)	:= 'N';
ie_tipo_contrato_w		varchar(2);
ie_tipo_pessoa_pagador_w	varchar(2);
vl_item_base_w			double precision	:= 0;
vl_minimo_tributo_w		double precision;
vl_tributo_w			double precision;
vl_trib_nao_retido_w		double precision;
vl_base_nao_retido_w		double precision;
vl_trib_adic_w			double precision;
vl_base_adic_w			double precision;
vl_soma_trib_nao_retido_w	double precision;
vl_soma_base_nao_retido_w	double precision;
vl_soma_trib_adic_w		double precision;
vl_soma_base_adic_w		double precision;
vl_minimo_base_w		double precision;
vl_teto_base_w			double precision;
vl_item_ww			double precision;
vl_desc_dependente_w		double precision;
vl_trib_anterior_w		double precision;
vl_total_base_w			double precision;
vl_reducao_w			double precision;
vl_item_base_corpo_w		double precision;
vl_tributo_corpo_w		double precision;
vl_proporcional_base_w		double precision;
vl_base_aux_w			double precision;
vl_itens_mens_w			double precision;
nr_seq_regra_w			bigint;
qt_regra_item_w			integer;
nr_seq_contrato_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_mens_trib_w		bigint;
nr_seq_mens_trib_aux_w		bigint;
pr_imposto_w			double precision;
cd_estabelecimento_w		smallint;
dt_referencia_w			timestamp;
dt_referencia_trunc_w		timestamp;
dt_referencia_fim_mes_w		timestamp;
vl_item_base_aux_w		double precision	:= 0;
vl_base_ared_w			double precision;
vl_trib_ared_w			double precision;
ie_origem_titulo_w		smallint;
vl_total_tributo_w		double precision := 0;
vl_arredondamento_w		double precision;
nr_seq_regra_irpf_w		regra_calculo_irpf.nr_sequencia%type;
countAux_w			bigint;
nr_seq_tipo_lanc_w		pls_mensalidade_seg_item.nr_seq_tipo_lanc%type;
vl_item_w			pls_mensalidade_seg_item.vl_item%type;
pr_desc_base_w			regra_calculo_imposto.pr_desc_base%type;
pr_desc_base_ww			regra_calculo_imposto.pr_desc_base%type;
vl_reducao_ww			pls_mensalidade_trib.vl_reducao_base%type;
ie_retencao_w			regra_calculo_imposto.ie_retencao%type;
vl_trib_adic_ww			double precision;
qt_benef_mens_w			bigint;
vl_adicional_rateio_w		double precision;
vl_diferenca_w			double precision;
vl_trib_adic_rateio_w		double precision;
vl_trib_adic_base_rateio_w	double precision;
vl_diferenca_ww			double precision;
vl_adic_base_rateio_w		double precision;
vl_total_arredondado_w		double precision;
vl_total_tributo_ww		double precision;

cd_darf_w		regra_calculo_imposto.cd_darf%type;

C01 CURSOR FOR
	SELECT	b.cd_tributo,
		b.ie_tipo_tributo,
		coalesce(b.ie_corpo_item,'C') ie_corpo_item
	from	tributo b
	
	where	b.ie_situacao	= 'A'
	and	((b.ie_pf_pj = 'A') or (b.ie_pf_pj = ie_tipo_pessoa_pagador_w))
	and	((cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = ''))
	order by
		coalesce(b.cd_estabelecimento,0),
		b.cd_tributo;

C02 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_item,
		a.ie_tipo_item,
		a.nr_seq_tipo_lanc,
		a.vl_item,
		a.vl_ato_cooperado,
		a.vl_ato_auxiliar,
		a.vl_ato_nao_cooperado,
		b.nr_seq_segurado
	from	pls_mensalidade_seg_item	a,
		pls_mensalidade_segurado	b
	where	a.nr_seq_mensalidade_seg	= b.nr_sequencia
	and	b.nr_seq_mensalidade		= nr_seq_mensalidade_p;

C03 CURSOR(	nr_seq_mensalidade_pc	pls_mensalidade.nr_sequencia%type,
		cd_tributo_pc		tributo.cd_tributo%type) FOR
	SELECT	vl_base_calculo,
		tx_tributo
	from	pls_mensalidade_trib a
	where	a.nr_seq_mensalidade	= nr_seq_mensalidade_pc
	and	a.cd_tributo		= cd_tributo_pc
	and	a.vl_tributo		> 0;

C04 CURSOR(	nr_seq_mensalidade_pc	pls_mensalidade.nr_sequencia%type,
		cd_tributo_pc		tributo.cd_tributo%type) FOR
	SELECT	nr_seq_item_mens
	from	pls_mensalidade_trib
	where	vl_trib_adic <> 0
	and	nr_seq_mensalidade = nr_seq_mensalidade_pc
	and	cd_tributo = cd_tributo_pc;

BEGIN
select	max(b.cd_cgc),
	max(b.cd_pessoa_fisica),
	max(a.dt_referencia),
	max(b.nr_seq_contrato),
	max(b.nr_seq_pagador_intercambio)
into STRICT	cd_cgc_w,
	cd_pessoa_fisica_w,
	dt_referencia_w,
	nr_seq_contrato_w,
	nr_seq_intercambio_w
from	pls_contrato_pagador	b,
	pls_mensalidade		a
where	a.nr_seq_pagador	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_mensalidade_p;

dt_referencia_trunc_w	:= trunc(dt_referencia_w,'month');
dt_referencia_fim_mes_w	:= fim_dia(last_day(dt_referencia_trunc_w));

if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
	ie_tipo_pessoa_pagador_w	:= 'PJ';
else
	ie_tipo_pessoa_pagador_w	:= 'PF';
end if;

if (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
	ie_tipo_contrato_w	:= 'CI';
else
	ie_tipo_contrato_w	:= 'CO';
end if;

select	coalesce(ie_origem_titulo,3)
into STRICT	ie_origem_titulo_w
from	pls_parametros
where	cd_estabelecimento = cd_estabelecimento_p;

for r_c01_w in C01 loop
	begin
	vl_total_tributo_w := 0;
	nr_seq_mens_trib_w := 0;
	
	select	count(1)
	into STRICT	qt_regra_item_w
	
	where	exists (SELECT	1
			from	pls_regra_base_trib_mens
			where	cd_tributo = r_c01_w.cd_tributo);
	
	ie_reteu_w	:= 'N';
	
	begin
	select	coalesce(max(pr_desc_base),0)
	into STRICT	pr_desc_base_w
	from	regra_calculo_imposto
	where	cd_tributo = r_c01_w.cd_tributo
	and	((coalesce(dt_fim_vigencia::text, '') = '')
	 or (dt_referencia_w between dt_vigencia and dt_fim_vigencia))
	and	cd_estabelecimento = cd_estabelecimento_p
	and	(((coalesce(cd_cgc::text, '') = '') and (coalesce(cd_pessoa_fisica::text, '') = '')) or
		((cd_cgc = cd_cgc_w) and (coalesce(cd_pessoa_fisica::text, '') = '')) or
		((cd_pessoa_fisica = cd_pessoa_fisica_w) and (coalesce(cd_cgc::text, '') = '')));
	exception
	when others then
		pr_desc_base_w := 0;
	end;
	
	if (r_c01_w.ie_corpo_item = 'C') and (qt_regra_item_w > 0) then
		select	sum(a.vl_item)
		into STRICT	vl_itens_mens_w
		from	pls_mensalidade_seg_item	a,
			pls_mensalidade_segurado	b
		where	b.nr_sequencia		= a.nr_seq_mensalidade_seg
		and	b.nr_seq_mensalidade	= nr_seq_mensalidade_p;
		
		vl_item_base_corpo_w := pls_obter_base_calc_mens(nr_seq_mensalidade_p, null, r_c01_w.cd_tributo, r_c01_w.ie_tipo_tributo, vl_item_base_corpo_w);
	else
		vl_item_base_corpo_w	:= 0;
	end if;
	
	vl_proporcional_base_w	:= 1;
	
	if (vl_item_base_corpo_w <> 0) then
		SELECT * FROM obter_dados_trib_tit_rec(r_c01_w.cd_tributo, cd_estabelecimento_p, null, dt_referencia_w, 'N', pr_imposto_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, cd_pessoa_fisica_w, cd_cgc_w, ie_tipo_contrato_w, ie_origem_titulo_w, 0, nr_seq_regra_w, cd_darf_w) INTO STRICT pr_imposto_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, nr_seq_regra_w, cd_darf_w;
		
		if (pr_imposto_w > 0) then
			begin
			select	coalesce(sum(vl_trib_nao_retido),0),
				coalesce(sum(vl_base_nao_retido),0),
				coalesce(sum(vl_trib_adic),0),
				coalesce(sum(vl_base_adic),0),
				coalesce(sum(vl_tributo),0),
				coalesce(sum(vl_base_calculo),0),
				coalesce(sum(vl_reducao_base),0)
			into STRICT	vl_soma_trib_nao_retido_w,
				vl_soma_base_nao_retido_w,
				vl_soma_trib_adic_w,
				vl_soma_base_adic_w,
				vl_trib_anterior_w,
				vl_total_base_w,
				vl_reducao_w
			from (	SELECT	coalesce(a.vl_trib_nao_retido,0) vl_trib_nao_retido,
					coalesce(a.vl_base_nao_retido,0) vl_base_nao_retido,
					coalesce(a.vl_trib_adic,0) vl_trib_adic,
					coalesce(a.vl_base_adic,0) vl_base_adic,
					coalesce(a.vl_tributo,0) vl_tributo,
					coalesce(a.vl_base_calculo,0) vl_base_calculo,
					coalesce(a.vl_reducao_base,0) vl_reducao_base
				from	pls_mensalidade_trib  a,
					pls_mensalidade       b,
					pls_contrato_pagador  c
				where	c.nr_sequencia  = b.nr_seq_pagador
				and	b.nr_sequencia  = a.nr_seq_mensalidade
				and	b.nr_sequencia	<> nr_seq_mensalidade_p
				and	coalesce(b.ie_cancelamento::text, '') = ''
				and	a.cd_tributo	= r_c01_w.cd_tributo
				and	c.cd_pessoa_fisica  = cd_pessoa_fisica_w
				and	(c.cd_pessoa_fisica IS NOT NULL AND c.cd_pessoa_fisica::text <> '')
				and	b.dt_referencia between dt_referencia_trunc_w and dt_referencia_fim_mes_w
				
union all

				SELECT	coalesce(a.vl_trib_nao_retido,0),
					coalesce(a.vl_base_nao_retido,0),
					coalesce(a.vl_trib_adic,0),
					coalesce(a.vl_base_adic,0),
					coalesce(a.vl_tributo,0),
					coalesce(a.vl_base_calculo,0),
					coalesce(a.vl_reducao_base,0)
				from	pls_mensalidade_trib  a,
					pls_mensalidade       b,
					pls_contrato_pagador  c
				where	c.nr_sequencia  = b.nr_seq_pagador
				and	b.nr_sequencia  = a.nr_seq_mensalidade
				and	b.nr_sequencia	<> nr_seq_mensalidade_p
				and	coalesce(b.ie_cancelamento::text, '') = ''
				and	a.cd_tributo	= r_c01_w.cd_tributo
				and	c.cd_cgc  = cd_cgc_w 
				and	(c.cd_cgc IS NOT NULL AND c.cd_cgc::text <> '')
				and	b.dt_referencia between dt_referencia_trunc_w and dt_referencia_fim_mes_w) alias33;
			exception
			when others then
				vl_soma_trib_nao_retido_w	:= 0;
				vl_soma_base_nao_retido_w	:= 0;
				vl_soma_trib_adic_w		:= 0;
				vl_soma_base_adic_w		:= 0;
				vl_trib_anterior_w		:= 0;
				vl_total_base_w			:= 0;
				vl_reducao_w			:= 0;
			end;
			
			SELECT * FROM obter_valores_tributo(	ie_acumulativo_w, pr_imposto_w, vl_minimo_base_w, vl_minimo_tributo_w, vl_soma_trib_nao_retido_w, 0, --vl_soma_trib_adic_w,
						vl_soma_base_nao_retido_w, vl_soma_base_adic_w, vl_item_base_corpo_w, vl_tributo_corpo_w, vl_trib_nao_retido_w, vl_trib_adic_w, vl_base_nao_retido_w, vl_base_adic_w, vl_teto_base_w, vl_trib_anterior_w, 'N', vl_total_base_w, vl_reducao_w, vl_desc_dependente_w, 0, 0, 0, null, 0, clock_timestamp(), nr_seq_regra_irpf_w) INTO STRICT pr_imposto_w, vl_item_base_corpo_w, vl_tributo_corpo_w, vl_trib_nao_retido_w, vl_trib_adic_w, vl_base_nao_retido_w, vl_base_adic_w, vl_reducao_w, vl_desc_dependente_w, nr_seq_regra_irpf_w;
			
			if (vl_tributo_corpo_w > 0) and (vl_item_base_corpo_w >= vl_itens_mens_w)then
				ie_reteu_w	:= 'S';
			elsif (vl_tributo_corpo_w > 0) then
				vl_proporcional_base_w	:= dividir_sem_round(vl_item_base_corpo_w, vl_itens_mens_w);
			else
				vl_proporcional_base_w	:= 1;
			end if;
		end if;
	end if;
	
	vl_base_aux_w	:= 0;
	qt_benef_mens_w := 0;
	
	for r_c02_w in C02 loop
		begin
		if (qt_regra_item_w > 0) then
			CALL pls_store_data_mens_pck.set_tributo_item(r_c02_w.ie_tipo_item, r_c02_w.nr_seq_tipo_lanc, r_c02_w.vl_item,
								r_c02_w.vl_ato_cooperado, r_c02_w.vl_ato_auxiliar, r_c02_w.vl_ato_nao_cooperado, r_c02_w.nr_seq_segurado);
			vl_item_base_w := pls_obter_base_calc_mens(null, r_c02_w.nr_seq_item, r_c01_w.cd_tributo, r_c01_w.ie_tipo_tributo, vl_item_base_w);
			CALL pls_store_data_mens_pck.clear_tributo_item();
		else
			vl_item_base_w	:= 0;
		end if;
		
		if (vl_item_base_w <> 0) then
			SELECT * FROM obter_dados_trib_tit_rec(r_c01_w.cd_tributo, cd_estabelecimento_p, null, dt_referencia_w, 'N', pr_imposto_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, cd_pessoa_fisica_w, cd_cgc_w, ie_tipo_contrato_w, ie_origem_titulo_w, 0, nr_seq_regra_w, cd_darf_w) INTO STRICT pr_imposto_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, nr_seq_regra_w, cd_darf_w;
			
			if (ie_reteu_w = 'S') then
				vl_minimo_tributo_w	:= 0;
				vl_minimo_base_w	:= 0;
			else
				if (vl_proporcional_base_w = 1) then
					vl_minimo_tributo_w	:= vl_minimo_tributo_w * vl_proporcional_base_w;
					vl_minimo_base_w	:= vl_minimo_base_w * vl_proporcional_base_w;
				else
					vl_minimo_tributo_w	:= 0;
					vl_minimo_base_w	:= 0;
				end if;
				
				vl_desc_dependente_w	:= vl_desc_dependente_w * vl_proporcional_base_w;
				vl_item_base_aux_w	:= vl_item_base_w;
				if (qt_regra_item_w = 0) then
					vl_item_base_w		:= vl_item_base_w * vl_proporcional_base_w;
				end if;
			end if;
			
			if (pr_imposto_w > 0) then
				if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
					select	coalesce(sum(a.vl_trib_nao_retido), 0) vl_trib_nao_retido,
						coalesce(sum(a.vl_base_nao_retido), 0) vl_base_nao_retido,
						coalesce(sum(a.vl_trib_adic), 0) vl_trib_adic,
						coalesce(sum(a.vl_base_adic), 0) vl_base_adic,
						coalesce(sum(a.vl_tributo), 0) vl_tributo,
						coalesce(sum(a.vl_base_calculo), 0) vl_base_calculo,
						coalesce(sum(a.vl_reducao_base), 0) vl_reducao_base
					into STRICT	vl_soma_trib_nao_retido_w,
						vl_soma_base_nao_retido_w,
						vl_soma_trib_adic_w,
						vl_soma_base_adic_w,
						vl_trib_anterior_w,
						vl_total_base_w,
						vl_reducao_w
					from	pls_contrato_pagador	c,
						pls_mensalidade		b,
						pls_mensalidade_trib	a
					where	c.nr_sequencia		= b.nr_seq_pagador
					and	b.nr_sequencia		= a.nr_seq_mensalidade
					and	coalesce(b.ie_cancelamento::text, '') = ''
					and	c.cd_cgc	= cd_cgc_w
					and	b.dt_referencia	= dt_referencia_trunc_w
					and	b.nr_sequencia <> nr_seq_mensalidade_p
					and	a.ie_tipo_item	= r_c02_w.ie_tipo_item
					and	a.cd_tributo	= r_c01_w.cd_tributo;
				elsif (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
					select 	coalesce(sum(a.vl_trib_nao_retido), 0) vl_trib_nao_retido,
						coalesce(sum(a.vl_base_nao_retido), 0) vl_base_nao_retido,
						coalesce(sum(a.vl_trib_adic), 0) vl_trib_adic,
						coalesce(sum(a.vl_base_adic), 0) vl_base_adic,
						coalesce(sum(a.vl_tributo), 0) vl_tributo,
						coalesce(sum(a.vl_base_calculo), 0) vl_base_calculo,
						coalesce(sum(a.vl_reducao_base), 0) vl_reducao_base
					into STRICT	vl_soma_trib_nao_retido_w,
						vl_soma_base_nao_retido_w,
						vl_soma_trib_adic_w,
						vl_soma_base_adic_w,
						vl_trib_anterior_w,
						vl_total_base_w,
						vl_reducao_w
					from	pls_contrato_pagador c,
						pls_mensalidade b,
						pls_mensalidade_trib a
					where	c.nr_sequencia	= b.nr_seq_pagador
					and	b.nr_sequencia	= a.nr_seq_mensalidade
					and	coalesce(b.ie_cancelamento::text, '') = ''
					and	c.cd_pessoa_fisica = cd_pessoa_fisica_w
					and	b.dt_referencia	= dt_referencia_trunc_w
					and	b.nr_sequencia <> nr_seq_mensalidade_p
					and	a.ie_tipo_item	= r_c02_w.ie_tipo_item
					and	a.cd_tributo	= r_c01_w.cd_tributo;
				else
					vl_soma_trib_nao_retido_w	:= 0;
					vl_soma_base_nao_retido_w	:= 0;
					vl_soma_trib_adic_w		:= 0;
					vl_soma_base_adic_w		:= 0;
					vl_trib_anterior_w		:= 0;
					vl_total_base_w			:= 0;
					vl_reducao_w			:= 0;
				end if;
				
				if (vl_proporcional_base_w < 1) and (vl_proporcional_base_w > 0) then
					vl_soma_trib_nao_retido_w	:= vl_soma_trib_nao_retido_w * vl_proporcional_base_w;
					vl_soma_base_nao_retido_w	:= vl_soma_base_nao_retido_w * vl_proporcional_base_w;
					vl_soma_trib_adic_w		:= vl_soma_trib_adic_w * vl_proporcional_base_w;
					vl_soma_base_adic_w		:= vl_soma_base_adic_w * vl_proporcional_base_w;
					vl_trib_anterior_w		:= vl_trib_anterior_w * vl_proporcional_base_w;
					vl_total_base_w			:= vl_total_base_w * vl_proporcional_base_w;
					vl_reducao_w			:= vl_reducao_w * vl_proporcional_base_w;
				end if;
				
				if (pr_desc_base_w > 0) then
					pr_desc_base_ww :=	(100 - pr_desc_base_w);
					vl_reducao_ww	:= 	(vl_item_base_w/100) * pr_desc_base_w;
					vl_item_base_w	:= 	(vl_item_base_w/100) * pr_desc_base_ww;
				end if;
				
				SELECT * FROM obter_valores_tributo(	ie_acumulativo_w, pr_imposto_w, vl_minimo_base_w, vl_minimo_tributo_w, vl_soma_trib_nao_retido_w, vl_soma_trib_adic_w, vl_soma_base_nao_retido_w, vl_soma_base_adic_w, vl_item_base_w, vl_tributo_w, vl_trib_nao_retido_w, vl_trib_adic_ww, vl_base_nao_retido_w, vl_base_adic_w, vl_teto_base_w, vl_trib_anterior_w, 'N', vl_total_base_w, vl_reducao_w, vl_desc_dependente_w, 0, 0, 0, null, 0, clock_timestamp(), nr_seq_regra_irpf_w) INTO STRICT pr_imposto_w, vl_item_base_w, vl_tributo_w, vl_trib_nao_retido_w, vl_trib_adic_ww, vl_base_nao_retido_w, vl_base_adic_w, vl_reducao_w, vl_desc_dependente_w, nr_seq_regra_irpf_w;
				
				select	max(ie_saldo_tit_rec),
					max(ie_retencao)
				into STRICT	ie_saldo_tit_rec_w,
					ie_retencao_w
				from	regra_calculo_imposto
				where	nr_sequencia	= nr_seq_regra_w;
				
				if (ie_retencao_w = 'P') then
					select	ie_soma_diminui
					into STRICT	ie_retencao_w
					from	tributo
					where	cd_tributo = r_c01_w.cd_tributo;
				end if;
				
				ie_saldo_tit_rec_w	:= coalesce(ie_saldo_tit_rec_w, 'N');
				
				select	nextval('pls_mensalidade_trib_seq')
				into STRICT	nr_seq_mens_trib_w
				;
				
				vl_base_aux_w	:= vl_base_aux_w + vl_item_base_w;
				
				insert into pls_mensalidade_trib(nr_sequencia,
					cd_tributo,
					tx_tributo,
					vl_tributo,
					vl_base_calculo,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					vl_trib_nao_retido,
					vl_base_nao_retido,
					vl_trib_adic,
					vl_base_adic,
					nr_seq_item_mens,
					ie_origem_tributo,
					nr_seq_mensalidade,
					ie_tipo_item,
					vl_reducao_base,
					ie_retencao,
					cd_cgc,
					cd_pessoa_fisica)
				values (nr_seq_mens_trib_w,
					r_c01_w.cd_tributo,
					pr_imposto_w,
					vl_tributo_w,
					vl_item_base_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					vl_trib_nao_retido_w,
					vl_base_nao_retido_w,
					coalesce(vl_trib_adic_w,0),
					0,
					r_c02_w.nr_seq_item,
					CASE WHEN ie_saldo_tit_rec_w='S' THEN 'CD'  ELSE 'C' END ,
					nr_seq_mensalidade_p,
					r_c02_w.ie_tipo_item,
					vl_reducao_ww,
					ie_retencao_w,
					cd_cgc_w,
					cd_pessoa_fisica_w);
				
				qt_benef_mens_w := qt_benef_mens_w + 1;
			end if;
		end if;
		end;
	end loop;
	
	select	count(1)
	into STRICT	countAux_w
	from	pls_mensalidade_trib a
	where	a.nr_seq_mensalidade	= nr_seq_mensalidade_p
	and	a.cd_tributo		= r_c01_w.cd_tributo
	and	a.vl_tributo		> 0;
	
	/* Calcula o valor total de tributos com o valor base de c?lculo e taxa de tributo aplicados. */

	for r_c03_w in C03(nr_seq_mensalidade_p, r_c01_w.cd_tributo) loop
		vl_total_tributo_w := vl_total_tributo_w + (r_c03_w.vl_base_calculo * (r_c03_w.tx_tributo/100));
		
		countAux_w := countAux_w - 1;
		if (countAux_w = 0) then
			SELECT * FROM obter_dados_trib_tit_rec(r_c01_w.cd_tributo, cd_estabelecimento_p, null, dt_referencia_w, 'N', pr_imposto_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, cd_pessoa_fisica_w, cd_cgc_w, ie_tipo_contrato_w, ie_origem_titulo_w, 0, nr_seq_regra_w, cd_darf_w) INTO STRICT pr_imposto_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, nr_seq_regra_w, cd_darf_w;
			
			if	((vl_total_tributo_w < vl_minimo_tributo_w) and (coalesce(vl_trib_adic_w,0) = 0)) then
				
				update pls_mensalidade_trib
				set	vl_tributo = 0
				where	nr_seq_mensalidade	= nr_seq_mensalidade_p
				and	cd_tributo		= r_c01_w.cd_tributo
				and	vl_tributo		> 0;
				
				vl_total_tributo_w := 0;
				
			end if;
		end if;
	end loop;
	
	if (qt_benef_mens_w > 0) then
		vl_adicional_rateio_w	:= vl_trib_adic_w/qt_benef_mens_w;
		
		vl_diferenca_w		:= (vl_adicional_rateio_w * qt_benef_mens_w) - vl_trib_adic_w;
		
		vl_adic_base_rateio_w	:= vl_total_base_w/qt_benef_mens_w;
		
		vl_diferenca_ww		:= (vl_adic_base_rateio_w * qt_benef_mens_w) - vl_total_base_w;
	end if;
	
	for r_c04_w in C04(nr_seq_mensalidade_p, r_c01_w.cd_tributo) loop
		vl_trib_adic_rateio_w	:= vl_adicional_rateio_w;
		vl_trib_adic_base_rateio_w := vl_adic_base_rateio_w;
		
		if (vl_diferenca_w > 0) then
			vl_diferenca_w	:= vl_diferenca_w - 0.01;
			vl_trib_adic_rateio_w	:= vl_adicional_rateio_w - 0.01;
		elsif (vl_diferenca_w < 0) then
			vl_diferenca_w	:= vl_diferenca_w + 0.01;
			vl_trib_adic_rateio_w	:= vl_adicional_rateio_w + 0.01;
		end if;
		
		if (vl_diferenca_ww > 0) then
			vl_diferenca_ww	:= vl_diferenca_ww - 0.01;
			vl_trib_adic_base_rateio_w := vl_adic_base_rateio_w - 0.01;
		elsif (vl_diferenca_ww < 0) then
			vl_diferenca_ww	:= vl_diferenca_ww + 0.01;
			vl_trib_adic_base_rateio_w := vl_adic_base_rateio_w + 0.01;
		end if;
		
		update	pls_mensalidade_trib
		set	vl_trib_adic = vl_trib_adic_rateio_w,
			vl_tributo = vl_tributo + vl_trib_adic_rateio_w,
			vl_base_adic = vl_trib_adic_base_rateio_w
		where	nr_seq_item_mens = r_c04_w.nr_seq_item_mens;
	end loop;
	
	select (coalesce(vl_total_tributo_w,0) + coalesce(vl_trib_adic_w,0)) - coalesce(sum(x.vl_tributo),0)
	into STRICT	vl_arredondamento_w
	from	pls_mensalidade_trib x
	where	x.nr_seq_mensalidade 	= nr_seq_mensalidade_p
	and	x.cd_tributo 		= r_c01_w.cd_tributo;
	
	--Se o total recalculado for diferente que o valor de tributo gerado, ? realizado o arredondamento do ?ltimo tributo gerado
	if (vl_arredondamento_w <> 0) then
		update 	pls_mensalidade_trib
		set	vl_tributo 	= vl_tributo + vl_arredondamento_w
		where	nr_sequencia 	= nr_seq_mens_trib_w;
	end if;
	
	if (vl_base_aux_w > vl_teto_base_w) and (vl_teto_base_w > 0) then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_mens_trib_aux_w
		from	pls_mensalidade_trib	a
		where	a.nr_seq_mensalidade	= nr_seq_mensalidade_p
		and	a.vl_tributo > 0
		and	a.cd_tributo = r_c01_w.cd_tributo;
		
		update	pls_mensalidade_trib
		set	vl_base_calculo	= vl_base_calculo - (vl_base_aux_w - vl_teto_base_w),
			vl_tributo	= (vl_base_calculo * tx_tributo) / 100
		where	nr_sequencia	= nr_seq_mens_trib_aux_w;
	end if;
	
	select	sum(a.vl_base_calculo),
		sum(a.vl_tributo)
	into STRICT	vl_base_ared_w,
		vl_trib_ared_w
	from	pls_mensalidade_trib	a
	where	a.nr_seq_mensalidade	= nr_seq_mensalidade_p
	and	a.cd_tributo		= r_c01_w.cd_tributo;
	
	if	(((vl_base_ared_w * pr_imposto_w) / 100) <> vl_trib_ared_w) then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_mens_trib_aux_w
		from	pls_mensalidade_trib	a
		where	a.nr_seq_mensalidade	= nr_seq_mensalidade_p
		and	a.vl_tributo > 0
		and	a.cd_tributo = r_c01_w.cd_tributo;
		
		update	pls_mensalidade_trib
		set	vl_tributo	= (vl_tributo + coalesce(vl_trib_adic_w,0)) - (vl_trib_ared_w - ((vl_base_ared_w * pr_imposto_w) / 100))
		where	nr_sequencia	= nr_seq_mens_trib_aux_w;
		
		vl_total_arredondado_w := round((vl_base_ared_w * pr_imposto_w) / 100,2);
		
		select	sum(vl_tributo)
		into STRICT	vl_total_tributo_ww
		from	pls_mensalidade_trib
		where	nr_seq_mensalidade	= nr_seq_mensalidade_p
		and	cd_tributo		= r_c01_w.cd_tributo;
		
		if (vl_total_arredondado_w > vl_total_tributo_ww) then
			update	pls_mensalidade_trib
			set	vl_tributo	= vl_tributo + 0.01
			where	nr_sequencia	= nr_seq_mens_trib_aux_w;
		end if;
	end if;
	end;
end loop;

--commit; N?o pode dar commit nesta rotina!!!
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_tributos_mens ( nr_seq_mensalidade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
