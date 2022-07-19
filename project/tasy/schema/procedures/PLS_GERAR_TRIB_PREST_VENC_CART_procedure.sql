-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_trib_prest_venc_cart ( nr_seq_vencimento_p pls_pag_prest_vencimento.nr_sequencia%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_tributo_p tributo.cd_tributo%type, pr_aliquota_p bigint, dt_tributo_p timestamp, ie_tipo_tributo_p text, ie_forma_retencao_inss_ir_p text, vl_total_base_p INOUT bigint, vl_teto_base_p bigint, nr_seq_regra_trib_p bigint, nm_usuario_p usuario.nm_usuario%type, vl_base_estorno_inss_p INOUT bigint, vl_trib_acum_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
vl_restante_estornar_w			double precision;
vl_carta_w				double precision;
ie_data_ref_tributo_w			varchar(50);
nr_seq_pag_prest_venc_trib_w		pls_pag_prest_venc_trib.nr_sequencia%type;
pr_fator_w				double precision;
vl_saldo_a_maior_w			double precision;
vl_estornado_base_maior_w		double precision;
vl_diferenca_base_w			double precision;
vl_pag_prest_venc_trib_w		double precision;
vl_total_base_ant_retido_sim_w		double precision;
vl_total_base_pag_ant_w			double precision;
vl_total_base_ant_retido_nao_w		double precision;
vl_teto_base_w				tributo_conta_pagar.vl_teto_base_calculo%type;
qt_registro_w				integer;
nr_seq_regra_w				tributo_conta_pagar.nr_sequencia%type;
dt_tributo_w				timestamp;
vl_total_eventos_w			double precision;
nr_seq_pag_prestador_w			pls_pagamento_prestador.nr_sequencia%type;

C01 CURSOR(	nr_seq_vencimento_p		pls_pag_prest_vencimento.nr_sequencia%type,
		cd_pessoa_fisica_p		pessoa_fisica.cd_pessoa_fisica%type,
		cd_tributo_p			tributo.cd_tributo%type,
		pr_aliquota_p			bigint,
		dt_tributo_p			timestamp,
		ie_data_ref_tributo_p		text,
		vl_restante_estornar_w 		bigint ) FOR
	SELECT	a.nr_sequencia nr_seq_venc_trib_a_maior,
		sum(coalesce(a.vl_base_calculo,0)) vl_base_calculo_a_maior,
		a.ie_pago_prev ie_pago_prev,
		a.pr_tributo pr_tributo,
		a.ie_tipo_contratacao ie_tipo_contratacao
	from	pls_lote_pagamento		e,
		pls_prestador			d,
		pls_pagamento_prestador		c,
		pls_pag_prest_vencimento	b,
		pls_pag_prest_venc_trib		a
	where	a.nr_seq_vencimento		= b.nr_sequencia
	and	b.nr_seq_pag_prestador		= c.nr_sequencia
	and	c.nr_seq_prestador		= d.nr_sequencia
	and	e.nr_sequencia			= c.nr_seq_lote
	and	d.cd_pessoa_fisica		= cd_pessoa_fisica_p
	and	a.cd_tributo			= cd_tributo_p
	and	(((ie_data_ref_tributo_w = 'C') and (e.dt_mes_competencia between dt_tributo_w and fim_dia(last_day(dt_tributo_w)))) or
		((ie_data_ref_tributo_w	= 'V') and (b.dt_vencimento between dt_tributo_w and fim_dia(last_day(dt_tributo_w)))))
	and	a.pr_tributo > 0
	and	b.nr_sequencia <> nr_seq_vencimento_p
	and	vl_restante_estornar_w < 0
	and	a.vl_base_calculo <> 0
	and	coalesce(a.nr_seq_trib_estornado::text, '') = ''
	and (SELECT	coalesce(sum(x.vl_base_calculo),0)
		from	pls_pag_prest_venc_trib x
		where	x.nr_seq_trib_estornado	= a.nr_sequencia) < a.vl_base_calculo
	group by
		a.nr_sequencia,
		a.ie_pago_prev,
		a.pr_tributo,
		a.ie_tipo_contratacao
	order by pr_tributo desc;

C02 CURSOR(	nr_seq_vencimento_p		pls_pag_prest_vencimento.nr_sequencia%type,
		cd_pessoa_fisica_p		pessoa_fisica.cd_pessoa_fisica%type,
		cd_tributo_p			tributo.cd_tributo%type,
		pr_aliquota_p			bigint,
		dt_tributo_p			timestamp,
		ie_data_ref_tributo_p		text,
		vl_restante_estornar_w 		bigint ) FOR
	SELECT	nr_seq_venc_trib_a_maior,
		sum(coalesce(vl_base_calculo_a_maior,0)) vl_base_calculo_a_maior,
		ie_pago_prev,
		pr_tributo,
		ie_tipo_contratacao,
		max(nr_seq_pag_item) nr_seq_pag_item
	from	(SELECT	a.nr_sequencia nr_seq_venc_trib_a_maior,
			(coalesce(f.vl_evento_origem,0) - a.vl_base_calculo) vl_base_calculo_a_maior,
			a.ie_pago_prev ie_pago_prev,
			a.pr_tributo pr_tributo,
			a.ie_tipo_contratacao,
			null nr_seq_pag_item,
			'1' ie_ident
		from	pls_pag_item_trib		f,
			pls_lote_pagamento		e,
			pls_prestador			d,
			pls_pagamento_prestador		c,
			pls_pag_prest_vencimento	b,
			pls_pag_prest_venc_trib		a
		where	a.nr_seq_vencimento		= b.nr_sequencia
		and	b.nr_seq_pag_prestador		= c.nr_sequencia
		and	c.nr_seq_prestador		= d.nr_sequencia
		and	e.nr_sequencia			= c.nr_seq_lote
		and	a.nr_sequencia			= f.nr_seq_venc_trib
		and	d.cd_pessoa_fisica		= cd_pessoa_fisica_p
		and	a.cd_tributo			= cd_tributo_p
		and	(((ie_data_ref_tributo_w = 'C') and (e.dt_mes_competencia between dt_tributo_w and fim_dia(last_day(dt_tributo_w)))) or
			((ie_data_ref_tributo_w	= 'V') and (b.dt_vencimento between dt_tributo_w and fim_dia(last_day(dt_tributo_w)))))
		and	a.ie_pago_prev = 'V'
		and	b.nr_sequencia <> nr_seq_vencimento_p
		and	vl_restante_estornar_w < 0
		and (coalesce(f.vl_evento_origem,0) - a.vl_base_calculo) <> 0
		and	coalesce(a.nr_seq_trib_estornado::text, '') = ''
		
union all

		--	PEGAR EVENTOS MIGRADOS
		select	null nr_seq_venc_trib_a_maior,
			p.vl_item vl_base_calculo_a_maior,
			'V' ie_pago_prev,
			CASE WHEN t.ie_tipo_contratacao='CE' THEN 11  ELSE 20 END  pr_tributo,
			t.ie_tipo_contratacao,
			p.nr_sequencia nr_seq_pag_item,
			'2' ie_ident
		from	pls_evento_tributo		u,
			pls_evento_movimento		t,
			pls_pagamento_item		p,
			pls_lote_pagamento		e,
			pls_prestador			d,
			pls_pagamento_prestador		c,
			pls_pag_prest_vencimento	b
		where	c.nr_sequencia			= p.nr_seq_pagamento
		and	b.nr_seq_pag_prestador		= c.nr_sequencia
		and	c.nr_seq_prestador		= d.nr_sequencia
		and	e.nr_sequencia			= c.nr_seq_lote
		and	p.nr_sequencia			= t.nr_seq_pagamento_item
		and	u.cd_tributo			= cd_tributo_p
		and	u.nr_seq_evento			= t.nr_seq_evento
		and	d.cd_pessoa_fisica		= cd_pessoa_fisica_p
		and	(((ie_data_ref_tributo_w = 'C') and (e.dt_mes_competencia between dt_tributo_w and fim_dia(last_day(dt_tributo_w)))) or
			((ie_data_ref_tributo_w	= 'V') and (b.dt_vencimento between dt_tributo_w and fim_dia(last_day(dt_tributo_w)))))
		and	b.nr_sequencia <> nr_seq_vencimento_p
		and	vl_restante_estornar_w < 0
		and	p.vl_item <> 0
		and	(t.ie_tipo_contratacao IS NOT NULL AND t.ie_tipo_contratacao::text <> '')
		and	not exists (select	1
					from	pls_pag_item_trib	i
					where	i.nr_seq_pagamento	= p.nr_sequencia)
		--	PEGAR EVENTOS - PLS_CONTA_MEDICA_RESUMO
		
union all

		select	null nr_seq_venc_trib_a_maior,
			sum(coalesce(d.vl_liberado,0)) vl_base_calculo_a_maior,
			'V' ie_pago_prev,
			CASE WHEN d.ie_tipo_contratacao='CE' THEN 11  ELSE 20 END  pr_tributo,
			d.ie_tipo_contratacao,
			a.nr_sequencia nr_seq_pag_item,
			'3' ie_ident
		FROM pls_pag_prest_vencimento x, pls_prestador p, pls_lote_pagamento l, pls_evento_tributo c, pls_pagamento_prestador b, pls_pagamento_item a, pls_segurado e
LEFT OUTER JOIN pls_conta_medica_resumo d ON (e.nr_sequencia = d.nr_seq_segurado)
WHERE a.nr_sequencia			= d.nr_seq_pag_item and a.nr_seq_evento			= c.nr_seq_evento  and b.nr_sequencia			= a.nr_seq_pagamento and p.nr_sequencia			= b.nr_seq_prestador and l.nr_sequencia			= b.nr_seq_lote and x.nr_seq_pag_prestador		= b.nr_sequencia and c.cd_tributo			= cd_tributo_p and p.cd_pessoa_fisica		= cd_pessoa_fisica_p and (((ie_data_ref_tributo_w = 'C') and (l.dt_mes_competencia between dt_tributo_w and fim_dia(last_day(dt_tributo_w)))) or
			((ie_data_ref_tributo_w	= 'V') and (x.dt_vencimento between dt_tributo_w and fim_dia(last_day(dt_tributo_w))))) and b.nr_sequencia		<> nr_seq_vencimento_p and vl_restante_estornar_w	< 0 and coalesce(d.vl_liberado,0) <> 0 and not exists (select	1
					from	pls_pag_prest_venc_trib	t,
						pls_pag_item_trib	i
					where	i.nr_seq_pagamento	= a.nr_sequencia
					and	i.nr_seq_venc_trib	= t.nr_sequencia
					and	t.cd_tributo		= cd_tributo_p) group by
			d.ie_tipo_contratacao,
			a.nr_sequencia) alias48
	group by
		nr_seq_venc_trib_a_maior,
		ie_pago_prev,
		pr_tributo,
		ie_tipo_contratacao
	order by pr_tributo;
BEGIN
select	count(1)
into STRICT	qt_registro_w
from	pessoa_fisica_trib	p,
	tributo			t
where	t.cd_tributo		= p.cd_tributo
and	p.cd_tributo		= cd_tributo_p
and	p.cd_pessoa_fisica	= cd_pessoa_fisica_p
and	t.ie_tipo_tributo	= 'INSS';

select	max(vl_base_calculo)
into STRICT	vl_carta_w
from	pls_pag_prest_venc_trib
where	nr_seq_vencimento 	= nr_seq_vencimento_p;

if (ie_tipo_tributo_p = 'INSS') and (ie_forma_retencao_inss_ir_p = 'SE') and (qt_registro_w > 0) then

	dt_tributo_w := trunc(dt_tributo_p,'month');

	select	coalesce(max(CASE WHEN a.ie_venc_pls_pag_prod='C' THEN 'C' WHEN a.ie_venc_pls_pag_prod='V' THEN 'V' WHEN coalesce(a.ie_venc_pls_pag_prod::text, '') = '' THEN CASE WHEN a.ie_vencimento='V' THEN 'V' WHEN a.ie_vencimento='C' THEN 'V'  ELSE 'C' END  END ),'C')
	into STRICT	ie_data_ref_tributo_w
	from	tributo a
	where	a.cd_tributo = cd_tributo_p;

	select	sum(coalesce(d.vl_base_calculo,0))
	into STRICT	vl_total_base_ant_retido_sim_w
	from	pls_pag_prest_venc_trib		d,
		pls_pag_prest_vencimento	c,
		pls_pagamento_prestador		b,
		pls_prestador			a,
		pls_lote_pagamento		l
	where	a.nr_sequencia			= b.nr_seq_prestador
	and	c.nr_seq_pag_prestador		= b.nr_sequencia
	and	d.nr_seq_vencimento		= c.nr_sequencia
	and	l.nr_sequencia			= b.nr_seq_lote
	and	d.cd_tributo			= cd_tributo_p
	and	a.cd_pessoa_fisica		= cd_pessoa_fisica_p
	and	trunc(c.dt_vencimento,'month')	= dt_tributo_w
	and	d.ie_pago_prev 			= 'R'
	and	c.nr_sequencia <> nr_seq_vencimento_p
	and	coalesce(b.ie_cancelamento::text, '') = '';

	select	sum(coalesce(d.vl_base_calculo,0)),
		max(d.nr_seq_regra),
		max(b.nr_sequencia)
	into STRICT	vl_total_base_ant_retido_nao_w,
		nr_seq_regra_w,
		nr_seq_pag_prestador_w
	from	pls_pag_prest_venc_trib		d,
		pls_pag_prest_vencimento	c,
		pls_pagamento_prestador		b,
		pls_prestador			a,
		pls_lote_pagamento		l
	where	a.nr_sequencia			= b.nr_seq_prestador
	and	c.nr_seq_pag_prestador		= b.nr_sequencia
	and	d.nr_seq_vencimento		= c.nr_sequencia
	and	l.nr_sequencia			= b.nr_seq_lote
	and	d.cd_tributo			= cd_tributo_p
	and	a.cd_pessoa_fisica		= cd_pessoa_fisica_p
	and	trunc(c.dt_vencimento,'month')	= dt_tributo_w
	and	d.ie_pago_prev 			= 'V'
	and	c.nr_sequencia <> nr_seq_vencimento_p
	and	coalesce(b.ie_cancelamento::text, '') = '';

	vl_teto_base_w := vl_teto_base_p;
	if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') and (coalesce(vl_teto_base_w::text, '') = '') then
		select	max(vl_teto_base_calculo)
		into STRICT	vl_teto_base_w
		from	tributo_conta_pagar
		where	nr_sequencia	= nr_seq_regra_w;
	end if;

	vl_total_base_p			:= coalesce(vl_total_base_ant_retido_sim_w,0) + coalesce(vl_total_base_ant_retido_nao_w,0);
	vl_restante_estornar_w		:= (vl_teto_base_w - abs(vl_carta_w)) - vl_total_base_p;

	-- ENTRA QUANDO:
	if (vl_carta_w > 0) and					-- A CARTA É POSITIVA, OU SEJA, O PRESTADOR QUER AUMENTAR O VALOR DA CARTA CADASTRADA E O
		((vl_total_base_p + vl_carta_w) >= vl_teto_base_w) and	-- (BASE DE INSS RETIDO EM PAG. PASSADOS + A CARTA DE AJUSTE) PASSAM DO TETO OU FICAM IGUAIS AO TETO E AINDA
		(vl_restante_estornar_w < 0) then			-- O VALOR QUE PASSOU DO TETO (BUSCAR DOS 11% E DEPOIS DOS 20% DE VENCIMENTOS PASSADOS (GERAR TRIBUTO NEGATIVOS)
		for r_C01_w in C01( nr_seq_vencimento_p, cd_pessoa_fisica_p, cd_tributo_p, pr_aliquota_p, dt_tributo_w, ie_data_ref_tributo_w, vl_restante_estornar_w ) loop

			select	coalesce(sum(a.vl_base_calculo), 0)
			into STRICT	vl_estornado_base_maior_w
			from	pls_pag_prest_venc_trib a
			where	a.nr_seq_trib_estornado	= r_C01_w.nr_seq_venc_trib_a_maior;

			vl_saldo_a_maior_w	:= r_C01_w.vl_base_calculo_a_maior + vl_estornado_base_maior_w;

			-- Estornar o que foi retido a maior
			if (vl_restante_estornar_w > vl_saldo_a_maior_w) then
				pr_fator_w	:= dividir_sem_round(vl_saldo_a_maior_w, r_C01_w.vl_base_calculo_a_maior);
			else
				pr_fator_w	:= dividir_sem_round(vl_restante_estornar_w, vl_saldo_a_maior_w);
			end if;

			if	((r_C01_w.vl_base_calculo_a_maior - abs(vl_estornado_base_maior_w)) <= abs(vl_restante_estornar_w)) then
				vl_diferenca_base_w	:= (r_C01_w.vl_base_calculo_a_maior - abs(vl_estornado_base_maior_w));
				vl_restante_estornar_w	:= vl_restante_estornar_w + (r_C01_w.vl_base_calculo_a_maior - abs(vl_estornado_base_maior_w));
			else
				vl_diferenca_base_w	:= abs(vl_restante_estornar_w);
				vl_restante_estornar_w	:= 0;
			end if;

			/*select	max(nr_sequencia)
			into	nr_seq_pag_prest_venc_trib_w
			from	pls_pag_prest_venc_trib
			where	ie_tipo_contratacao	= r_C01_w.ie_tipo_contratacao
			and	nr_seq_vencimento	= nr_seq_vencimento_p;*/
			if (vl_diferenca_base_w <> 0) then
				select	nextval('pls_pag_prest_venc_trib_seq')
				into STRICT	nr_seq_pag_prest_venc_trib_w
				;

				insert into pls_pag_prest_venc_trib(nr_sequencia,
					nr_seq_vencimento,
					cd_tributo,
					dt_atualizacao,
					nm_usuario,
					dt_imposto,
					vl_base_calculo,
					vl_imposto,
					pr_tributo,
					vl_nao_retido,
					vl_base_nao_retido,
					vl_trib_adic,
					vl_base_adic,
					ie_pago_prev,
					vl_reducao,
					vl_desc_base,
					cd_darf,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_periodicidade,
					cd_variacao,
					nr_seq_trans_reg,
					nr_seq_trans_baixa,
					ie_tipo_contratacao,
					ie_filantropia,
					nr_seq_trib_estornado,
					cd_beneficiario,
					nr_seq_regra)
				SELECT	nr_seq_pag_prest_venc_trib_w,
					nr_seq_vencimento_p,
					cd_tributo,
					clock_timestamp(),
					nm_usuario_p,
					dt_imposto,
					vl_diferenca_base_w * -1,
					(vl_diferenca_base_w * pr_tributo/100) * -1,
					pr_tributo,
					vl_nao_retido * pr_fator_w * -1,
					vl_base_nao_retido * pr_fator_w * -1,
					vl_trib_adic * pr_fator_w * -1,
					vl_base_adic * pr_fator_w * -1,
					'V',
					vl_reducao * pr_fator_w * -1,
					vl_desc_base * pr_fator_w * -1,
					cd_darf,
					clock_timestamp(),
					nm_usuario_p,
					ie_periodicidade,
					cd_variacao,
					nr_seq_trans_reg,
					nr_seq_trans_baixa,
					ie_tipo_contratacao,
					ie_filantropia,
					r_C01_w.nr_seq_venc_trib_a_maior,
					cd_beneficiario,
					nr_seq_regra_trib_p
				from	pls_pag_prest_venc_trib	a
				where	a.nr_sequencia		= r_C01_w.nr_seq_venc_trib_a_maior;
			/*else
				update	pls_pag_prest_venc_trib
				set	vl_base_calculo	= vl_base_calculo + (vl_diferenca_base_w * 1),
					vl_imposto	= vl_imposto + ((vl_diferenca_base_w * r_C01_w.pr_tributo/100) * -1)
				where	nr_sequencia	= nr_seq_pag_prest_venc_trib_w;
			end if;		*/
				insert into pls_pag_item_trib(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_pagamento,
					nr_seq_venc_trib,
					vl_evento,
					ie_tipo_contratacao,
					vl_evento_origem)
				SELECT	nextval('pls_pag_item_trib_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					x.nr_seq_pagamento,
					nr_seq_pag_prest_venc_trib_w,
					(vl_diferenca_base_w * pr_tributo/100) * -1,
					x.ie_tipo_contratacao,
					vl_diferenca_base_w * -1
				from	pls_pag_item_trib	x,
					pls_pag_prest_venc_trib	a
				where	a.nr_sequencia		= x.nr_seq_venc_trib
				and	a.nr_sequencia		= r_C01_w.nr_seq_venc_trib_a_maior;

				select	a.vl_base_calculo * pr_fator_w * -1
				into STRICT	vl_base_estorno_inss_p
				from	pls_pag_prest_venc_trib	a
				where	a.nr_sequencia		= r_C01_w.nr_seq_venc_trib_a_maior;

				select	coalesce(max(vl_imposto),0)
				into STRICT	vl_pag_prest_venc_trib_w
				from	pls_pag_prest_venc_trib
				where	nr_sequencia		= nr_seq_pag_prest_venc_trib_w;

				vl_trib_acum_p	:= vl_trib_acum_p + vl_pag_prest_venc_trib_w;

				vl_total_base_p := vl_total_base_p + vl_base_estorno_inss_p;
			end if;
		end loop;
	end if;

	if (vl_carta_w < 0) and					-- A CARTA É NEGATIVA, OU SEJA, O PRESTADOR QUER REDUZIR O VALOR DA CARTA CADASTRADA E O
		((vl_total_base_p + vl_carta_w) <= vl_teto_base_w) and	-- (BASE DE INSS RETIDO EM PAG. PASSADOS + A CARTA DE AJUSTE) FICAM MENOR OU IGUAL AO TETO E AINDA
		(vl_restante_estornar_w < 0) then			-- O VALOR QUE FALTA PARA CHEGAR AO TETO (BUSCAR DOS 20% E DEPOIS DOS 11% DE VENCIMENTOS PASSADOS (GERAR TRIBUTO POSITIVOS)
		for r_C02_w in C02( nr_seq_vencimento_p, cd_pessoa_fisica_p, cd_tributo_p, pr_aliquota_p, dt_tributo_w, ie_data_ref_tributo_w, vl_restante_estornar_w ) loop

			vl_estornado_base_maior_w := 0;
			if (r_C02_w.nr_seq_venc_trib_a_maior IS NOT NULL AND r_C02_w.nr_seq_venc_trib_a_maior::text <> '') then
				select	coalesce(sum(a.vl_base_calculo), 0)
				into STRICT	vl_estornado_base_maior_w
				from	pls_pag_prest_venc_trib a
				where	a.nr_seq_trib_estornado	= r_C02_w.nr_seq_venc_trib_a_maior;
			end if;

			vl_saldo_a_maior_w	:= r_C02_w.vl_base_calculo_a_maior + vl_estornado_base_maior_w;

			-- Estornar o que foi retido a maior
			if (vl_restante_estornar_w > vl_saldo_a_maior_w) then
				pr_fator_w	:= dividir_sem_round(vl_saldo_a_maior_w, r_C02_w.vl_base_calculo_a_maior);
			else
				pr_fator_w	:= dividir_sem_round(vl_restante_estornar_w, vl_saldo_a_maior_w);
			end if;

			if (r_C02_w.vl_base_calculo_a_maior <= abs(vl_restante_estornar_w)) then
				vl_diferenca_base_w	:= r_C02_w.vl_base_calculo_a_maior;
				vl_restante_estornar_w	:= vl_restante_estornar_w + r_C02_w.vl_base_calculo_a_maior;
			else
				vl_diferenca_base_w	:= abs(vl_restante_estornar_w);
				vl_restante_estornar_w	:= 0;
			end if;

			if (r_C02_w.nr_seq_venc_trib_a_maior IS NOT NULL AND r_C02_w.nr_seq_venc_trib_a_maior::text <> '') then
				/*select	max(nr_sequencia)
				into	nr_seq_pag_prest_venc_trib_w
				from	pls_pag_prest_venc_trib
				where	ie_tipo_contratacao	= r_C02_w.ie_tipo_contratacao
				and	nr_seq_vencimento	= nr_seq_vencimento_p;*/
				if (vl_diferenca_base_w <> 0) then
					select	nextval('pls_pag_prest_venc_trib_seq')
					into STRICT	nr_seq_pag_prest_venc_trib_w
					;

					insert into pls_pag_prest_venc_trib(nr_sequencia,
						nr_seq_vencimento,
						cd_tributo,
						dt_atualizacao,
						nm_usuario,
						dt_imposto,
						vl_base_calculo,
						vl_imposto,
						pr_tributo,
						vl_nao_retido,
						vl_base_nao_retido,
						vl_trib_adic,
						vl_base_adic,
						ie_pago_prev,
						vl_reducao,
						vl_desc_base,
						cd_darf,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_periodicidade,
						cd_variacao,
						nr_seq_trans_reg,
						nr_seq_trans_baixa,
						ie_tipo_contratacao,
						ie_filantropia,
						nr_seq_trib_estornado,
						cd_beneficiario,
						nr_seq_regra)
					SELECT	nr_seq_pag_prest_venc_trib_w,
						nr_seq_vencimento_p,
						cd_tributo,
						clock_timestamp(),
						nm_usuario_p,
						dt_imposto,
						vl_diferenca_base_w,
						(vl_diferenca_base_w * pr_tributo/100),
						pr_tributo,
						vl_nao_retido * pr_fator_w,
						vl_base_nao_retido * pr_fator_w,
						vl_trib_adic * pr_fator_w,
						vl_base_adic * pr_fator_w,
						'V',
						vl_reducao * pr_fator_w,
						vl_desc_base * pr_fator_w,
						cd_darf,
						clock_timestamp(),
						nm_usuario_p,
						ie_periodicidade,
						cd_variacao,
						nr_seq_trans_reg,
						nr_seq_trans_baixa,
						ie_tipo_contratacao,
						ie_filantropia,
						r_C02_w.nr_seq_venc_trib_a_maior,
						cd_beneficiario,
						nr_seq_regra_trib_p
					from	pls_pag_prest_venc_trib	a
					where	a.nr_sequencia		= r_C02_w.nr_seq_venc_trib_a_maior;
				/*else
					update	pls_pag_prest_venc_trib
					set	vl_base_calculo	= vl_base_calculo + (vl_diferenca_base_w),
						vl_imposto	= vl_imposto + (vl_diferenca_base_w * r_C02_w.pr_tributo/100)
					where	nr_sequencia	= nr_seq_pag_prest_venc_trib_w;
				end if;*/
					insert into pls_pag_item_trib(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_pagamento,
						nr_seq_venc_trib,
						vl_evento,
						ie_tipo_contratacao,
						vl_evento_origem)
					SELECT	nextval('pls_pag_item_trib_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						x.nr_seq_pagamento,
						nr_seq_pag_prest_venc_trib_w,
						(vl_diferenca_base_w * pr_tributo/100),
						x.ie_tipo_contratacao,
						vl_diferenca_base_w
					from	pls_pag_item_trib	x,
						pls_pag_prest_venc_trib	a
					where	a.nr_sequencia		= x.nr_seq_venc_trib
					and	a.nr_sequencia		= r_C02_w.nr_seq_venc_trib_a_maior;

					select	a.vl_base_calculo * pr_fator_w
					into STRICT	vl_base_estorno_inss_p
					from	pls_pag_prest_venc_trib	a
					where	a.nr_sequencia		= r_C02_w.nr_seq_venc_trib_a_maior;
				end if;

			elsif (vl_restante_estornar_w <> 0) then
				select	nextval('pls_pag_prest_venc_trib_seq')
				into STRICT	nr_seq_pag_prest_venc_trib_w
				;

				insert into pls_pag_prest_venc_trib(nr_sequencia,
					nr_seq_vencimento,
					cd_tributo,
					dt_atualizacao,
					nm_usuario,
					dt_imposto,
					vl_base_calculo,
					vl_imposto,
					pr_tributo,
					vl_nao_retido,
					vl_base_nao_retido,
					vl_trib_adic,
					vl_base_adic,
					ie_pago_prev,
					vl_reducao,
					vl_desc_base,
					cd_darf,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_periodicidade,
					cd_variacao,
					nr_seq_trans_reg,
					nr_seq_trans_baixa,
					ie_tipo_contratacao,
					ie_filantropia,
					nr_seq_trib_estornado,
					cd_beneficiario,
					nr_seq_regra)
				values (nr_seq_pag_prest_venc_trib_w,
					nr_seq_vencimento_p,
					cd_tributo_p,
					clock_timestamp(),
					nm_usuario_p,
					dt_tributo_w,
					vl_diferenca_base_w,
					(vl_diferenca_base_w * r_C02_w.pr_tributo/100),
					r_C02_w.pr_tributo,
					0, -- vl_nao_retido * pr_fator_w,
					0, -- vl_base_nao_retido * pr_fator_w,
					0, -- vl_trib_adic * pr_fator_w,
					0, -- vl_base_adic * pr_fator_w,
					'V',
					0, -- vl_reducao * pr_fator_w,
					0, -- vl_desc_base * pr_fator_w,
					null, --cd_darf,
					clock_timestamp(),
					nm_usuario_p,
					null, --ie_periodicidade,
					null, --cd_variacao,
					null, --nr_seq_trans_reg,
					null, --nr_seq_trans_baixa,
					r_C02_w.ie_tipo_contratacao,
					null, --ie_filantropia,
					null, --r_C02_w.nr_seq_venc_trib_a_maior,
					null,-- cd_beneficiario,
					nr_seq_regra_trib_p);

				insert into pls_pag_item_trib(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_pagamento,
					nr_seq_venc_trib,
					vl_evento,
					ie_tipo_contratacao,
					vl_evento_origem)
				values (	nextval('pls_pag_item_trib_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					r_C02_w.nr_seq_pag_item,
					nr_seq_pag_prest_venc_trib_w,
					(vl_diferenca_base_w * r_C02_w.pr_tributo/100),
					r_C02_w.ie_tipo_contratacao,
					vl_diferenca_base_w);
			end if;

			if (vl_restante_estornar_w <> 0) then
				select	coalesce(max(vl_imposto),0)
				into STRICT	vl_pag_prest_venc_trib_w
				from	pls_pag_prest_venc_trib
				where	nr_sequencia		= nr_seq_pag_prest_venc_trib_w;

				vl_trib_acum_p	:= vl_trib_acum_p + vl_pag_prest_venc_trib_w;

				vl_total_base_p := vl_total_base_p + vl_base_estorno_inss_p;
			end if;
		end loop;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_trib_prest_venc_cart ( nr_seq_vencimento_p pls_pag_prest_vencimento.nr_sequencia%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_tributo_p tributo.cd_tributo%type, pr_aliquota_p bigint, dt_tributo_p timestamp, ie_tipo_tributo_p text, ie_forma_retencao_inss_ir_p text, vl_total_base_p INOUT bigint, vl_teto_base_p bigint, nr_seq_regra_trib_p bigint, nm_usuario_p usuario.nm_usuario%type, vl_base_estorno_inss_p INOUT bigint, vl_trib_acum_p INOUT bigint) FROM PUBLIC;

