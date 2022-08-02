-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_notas_tit_faturas ( nr_seq_lote_p bigint, nr_seq_pls_fatura_p bigint, nr_seq_acao_p bigint, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, nr_seq_classif_fiscal_p bigint, nr_seq_sit_trib_p bigint, cd_serie_nf_p text, dt_emissao_p timestamp, ds_complemento_p text, ds_observacao_p text, ie_gera_titulo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

					
nr_nota_fiscal_w		varchar(255);
nr_ultima_nf_w			varchar(255);
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(10);
ie_tipo_nota_w			varchar(3);
ie_ato_cooperado_w		varchar(2);
vl_fatura_w			double precision;
vl_fatura_ndc_w			double precision;
vl_total_nota_atual_w		double precision;
vl_total_item_w			double precision;
vl_tributo_w			double precision;
vl_mercadoria_w			double precision;
vl_total_nota_w			double precision;
vl_ipi_w			double precision;
vl_descontos_w			double precision;
vl_frete_w			double precision;
vl_seguro_w			double precision;
vl_despesa_acessoria_w		double precision;
vl_item_w			double precision;
vl_item_ndc_w			double precision;
vl_despesa_doc_w		double precision;
cd_procedimento_w		bigint;
cd_procedimento_nf_w		bigint;
nr_sequencia_w			bigint;
cd_condicao_pagamento_w		bigint;
qt_registro_w			bigint	:= 0;
ie_origem_proced_w		bigint;
ie_origem_proced_nf_w		bigint;
condicao_pagamento_w		bigint;
qt_tipo_item_fat_w		bigint;
cd_material_w			integer;
cd_material_nf_w		integer;
nr_item_nf_w			integer;
qt_impedimentos_w		integer;
nr_sequencia_nf_w		bigint;
dt_vencimento_w			timestamp;
nr_titulo_w			bigint;
cd_serie_w			varchar(5) := null;
dt_vencimento_ndc_w		timestamp;
nr_titulo_ndc_w			bigint;
ie_acao_w			varchar(3);
ie_nf_fat_ndc_w			varchar(1);
nr_seq_fatura_w			bigint;
nr_seq_fatura_ndc_w		bigint;
cd_operacao_nf_w		smallint;
cd_natureza_operacao_w		smallint;
nr_seq_classif_fiscal_w		bigint;
nr_seq_sit_trib_w		bigint;
cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;
nr_seq_evento_w			bigint;
nr_seq_regra_fat_w		bigint;
nr_seq_conta_w			bigint;
ie_tipo_relacao_w		varchar(2);
nr_seq_grupo_prest_w		bigint;
ie_valor_w			varchar(1);
ie_valor_ww			varchar(1);
nr_seq_regra_nf_w		bigint;
nr_nota_fiscal_tit_w		titulo_receber.nr_nota_fiscal%type;
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
ie_origem_conta_w		pls_protocolo_conta.ie_origem_protocolo%type;
ie_estab_serie_nf_w		parametro_compras.ie_estab_serie_nf%type;
cd_cgc_emitente_w		estabelecimento.cd_cgc%type := obter_cgc_estabelecimento(cd_estabelecimento_p);
nr_seq_tipo_atendimento_w	pls_conta.nr_seq_tipo_atendimento%type;
nm_regra_w			pls_regra_faturamento.nm_regra%type;
ds_evento_w			pls_evento_faturamento.ds_evento%type;
ds_grupo_w			pls_preco_grupo_prestador.ds_grupo%type;
ds_tipo_atendimento_w		pls_tipo_atendimento.ds_tipo_atendimento%type;
ie_novo_pos_estab_w		pls_visible_false.ie_novo_pos_estab%type := 'N';
ie_regime_atendimento_w		pls_tipo_item_fat.ie_regime_atendimento%type;
ie_saude_ocupacional_w		pls_tipo_item_fat.ie_saude_ocupacional%type;

-- APENAS VALOR DE FATURA
C01 CURSOR FOR
	SELECT	ie_ato_cooperado,
		nr_seq_evento,
		nr_seq_conta,
		sum(vl_faturado),
		ie_tipo_guia,
		ie_origem_conta,
		nr_seq_tipo_atendimento,
		ie_regime_atendimento,
		ie_saude_ocupacional
	from (	SELECT	c.ie_ato_cooperado,
			a.nr_seq_evento,
			b.nr_seq_conta,
			coalesce(d.vl_faturado,0) vl_faturado,
			pls_obter_tipo_guia_princ(x.nr_sequencia, x.nr_seq_conta_princ) ie_tipo_guia,
			e.ie_origem_protocolo ie_origem_conta,
			x.nr_seq_tipo_atendimento,
			x.ie_regime_atendimento,
			x.ie_saude_ocupacional
		from	pls_conta			x,
			pls_conta_proc			c,
			pls_fatura_proc			d,
			pls_fatura_conta		b,
			pls_fatura_evento		a,
			pls_protocolo_conta		e
		where	b.nr_seq_conta	= c.nr_seq_conta
		and	x.nr_sequencia	= c.nr_seq_conta
		and	b.nr_sequencia	= d.nr_seq_fatura_conta
		and	c.nr_sequencia	= d.nr_seq_conta_proc
		and	a.nr_sequencia	= b.nr_seq_fatura_evento
		and	e.nr_sequencia	= x.nr_seq_protocolo
		and	a.nr_seq_fatura	= nr_seq_pls_fatura_p
		
union all

		select	c.ie_ato_cooperado,
			a.nr_seq_evento,
			b.nr_seq_conta,
			coalesce(d.vl_faturado,0) vl_faturado,
			pls_obter_tipo_guia_princ(x.nr_sequencia, x.nr_seq_conta_princ) ie_tipo_guia,
			e.ie_origem_protocolo ie_origem_conta,
			x.nr_seq_tipo_atendimento,
			x.ie_regime_atendimento,
			x.ie_saude_ocupacional
		from	pls_conta		x,
			pls_conta_mat		c,
			pls_fatura_mat		d,
			pls_fatura_conta	b,
			pls_fatura_evento	a,
			pls_protocolo_conta	e
		where	b.nr_seq_conta	= c.nr_seq_conta
		and	x.nr_sequencia	= c.nr_seq_conta
		and	b.nr_sequencia	= d.nr_seq_fatura_conta
		and	c.nr_sequencia	= d.nr_seq_conta_mat
		and	a.nr_sequencia	= b.nr_seq_fatura_evento
		and	e.nr_sequencia	= x.nr_seq_protocolo
		and	a.nr_seq_fatura	= nr_seq_pls_fatura_p) alias5
	group by
		ie_ato_cooperado,
		nr_seq_evento,
		nr_seq_conta,
		ie_tipo_guia,
		ie_origem_conta,
		nr_seq_tipo_atendimento,
		ie_regime_atendimento,
		ie_saude_ocupacional;
		
-- APENAS VALOR DE NDR
C00 CURSOR FOR
	SELECT	ie_ato_cooperado,
		nr_seq_evento,
		nr_seq_conta,
		sum(vl_faturado_ndc),
		ie_tipo_guia,
		ie_origem_conta,
		nr_seq_tipo_atendimento,
		ie_regime_atendimento,
		ie_saude_ocupacional
	from (	SELECT	c.ie_ato_cooperado,
			a.nr_seq_evento,
			b.nr_seq_conta,
			coalesce(d.vl_faturado_ndc,0) vl_faturado_ndc ,
			pls_obter_tipo_guia_princ(x.nr_sequencia, x.nr_seq_conta_princ) ie_tipo_guia,
			e.ie_origem_protocolo ie_origem_conta,
			x.nr_seq_tipo_atendimento,
			x.ie_regime_atendimento,
			x.ie_saude_ocupacional
		from	pls_conta			x,
			pls_conta_pos_estabelecido	f,
			pls_conta_proc			c,
			pls_fatura_proc			d,
			pls_fatura_conta		b,
			pls_fatura_evento		a,
			pls_protocolo_conta		e
		where	b.nr_seq_conta	= c.nr_seq_conta
		and	x.nr_sequencia	= c.nr_seq_conta
		and	b.nr_sequencia	= d.nr_seq_fatura_conta
		and	f.nr_sequencia	= d.nr_seq_conta_pos_estab
		and	c.nr_sequencia	= f.nr_seq_conta_proc
		and	a.nr_sequencia	= b.nr_seq_fatura_evento
		and	e.nr_sequencia	= x.nr_seq_protocolo
		and	a.nr_seq_fatura	= nr_seq_pls_fatura_p
		
union all

		select	c.ie_ato_cooperado,
			a.nr_seq_evento,
			b.nr_seq_conta,
			coalesce(d.vl_faturado_ndc,0) vl_faturado_ndc,
			pls_obter_tipo_guia_princ(x.nr_sequencia, x.nr_seq_conta_princ) ie_tipo_guia,
			e.ie_origem_protocolo ie_origem_conta,
			x.nr_seq_tipo_atendimento,
			x.ie_regime_atendimento,
			x.ie_saude_ocupacional
		from	pls_conta			x,
			pls_conta_pos_estabelecido	f,
			pls_conta_mat			c,
			pls_fatura_mat			d,
			pls_fatura_conta		b,
			pls_fatura_evento		a,
			pls_protocolo_conta		e
		where	b.nr_seq_conta	= c.nr_seq_conta
		and	x.nr_sequencia	= c.nr_seq_conta
		and	b.nr_sequencia	= d.nr_seq_fatura_conta
		and	f.nr_sequencia	= d.nr_seq_conta_pos_estab
		and	c.nr_sequencia	= f.nr_seq_conta_mat
		and	a.nr_sequencia	= b.nr_seq_fatura_evento
		and	e.nr_sequencia	= x.nr_seq_protocolo
		and	a.nr_seq_fatura	= nr_seq_pls_fatura_p) alias5
		group by
			ie_ato_cooperado,
			nr_seq_evento,
			nr_seq_conta,
			ie_tipo_guia,
			ie_origem_conta,
			nr_seq_tipo_atendimento,
			ie_regime_atendimento,
			ie_saude_ocupacional;
			
C02 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		cd_material,
		ie_valor,
		nr_sequencia
	from	pls_tipo_item_fat
	where	cd_estabelecimento = cd_estabelecimento_p
	and	coalesce(ie_ato_cooperado,coalesce(ie_ato_cooperado_w, 'X')) = coalesce(ie_ato_cooperado_w, 'X')
	and	((nr_seq_evento = nr_seq_evento_w) or (coalesce(nr_seq_evento::text, '') = ''))
	and	((nr_seq_regra_fat = nr_seq_regra_fat_w) or (coalesce(nr_seq_regra_fat::text, '') = ''))
	and	((ie_tipo_relacao = ie_tipo_relacao_w) or (coalesce(ie_tipo_relacao::text, '') = ''))
	and	((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia = ie_tipo_guia_w))
	and	((nr_seq_grupo_prestador = coalesce(nr_seq_grupo_prest_w,nr_seq_grupo_prestador)) or (coalesce(nr_seq_grupo_prestador::text, '') = ''))
	and	((ie_origem_conta = ie_origem_conta_w) or (coalesce(ie_origem_conta::text, '') = ''))
	and (coalesce(ie_valor,'A') = ie_valor_ww or coalesce(ie_valor,'A') = 'A')
	and	((nr_seq_tipo_atendimento = nr_seq_tipo_atendimento_w) or (coalesce(nr_seq_tipo_atendimento::text, '') = ''))
	and	((ie_regime_atendimento = ie_regime_atendimento_w) or (coalesce(ie_regime_atendimento::text, '') = ''))
	and	((ie_saude_ocupacional = ie_saude_ocupacional_w) or (coalesce(ie_saude_ocupacional::text, '') = ''))
	order by
		coalesce(ie_tipo_relacao, ' '),
		coalesce(nr_seq_regra_fat, 0),
		coalesce(nr_seq_evento, 0),
		coalesce(nr_seq_grupo_prestador, 0),
		coalesce(ie_ato_cooperado, ' '),
		coalesce(ie_valor,'A'),
		coalesce(ie_tipo_guia,'1');


BEGIN

select	coalesce(max(ie_novo_pos_estab), 'N')
into STRICT	ie_novo_pos_estab_w
from	pls_visible_false
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_novo_pos_estab_w = 'S') then
	CALL pls_faturamento_pck.gerar_notas_tit_faturas(	nr_seq_lote_p,		nr_seq_pls_fatura_p,		nr_seq_acao_p,
							cd_operacao_nf_p,	cd_natureza_operacao_p,		nr_seq_classif_fiscal_p,
							nr_seq_sit_trib_p,	cd_serie_nf_p,			dt_emissao_p,
							ds_complemento_p,	ds_observacao_p,		ie_gera_titulo_p,
							nm_usuario_p,		cd_estabelecimento_p);
else
	select	max(a.nr_seq_regra_fat)
	into STRICT	nr_seq_regra_fat_w
	from	pls_lote_faturamento a
	where	a.nr_sequencia = nr_seq_lote_p;

	select	coalesce(max(ie_estab_serie_nf),'N')
	into STRICT	ie_estab_serie_nf_w
	from	parametro_compras
	where	cd_estabelecimento = cd_estabelecimento_p;

	select	max(a.vl_fatura),
		max(b.cd_cgc),
		max(b.cd_pessoa_fisica),
		max(a.dt_vencimento),
		max(a.nr_titulo),
		max(a.dt_vencimento_ndc),
		max(a.nr_titulo_ndc),
		max(a.vl_total_ndc),
		max(nr_seq_grupo_prestador)
	into STRICT	vl_fatura_w,
		cd_cgc_w,
		cd_pessoa_fisica_w,
		dt_vencimento_w,
		nr_titulo_w,
		dt_vencimento_ndc_w,
		nr_titulo_ndc_w,
		vl_fatura_ndc_w,
		nr_seq_grupo_prest_w
	from	pls_fatura		a,
		pls_contrato_pagador	b
	where	b.nr_sequencia	= a.nr_seq_pagador
	and	a.nr_sequencia	= nr_seq_pls_fatura_p;

	select	coalesce(max(ie_acao), '16')
	into STRICT	ie_acao_w
	from	pls_processo_interc_acao
	where	nr_sequencia	= nr_seq_acao_p;

	if (ie_acao_w = 16) then -- 16 - NF Geral
		vl_fatura_w		:= vl_fatura_w + vl_fatura_ndc_w;
		nr_seq_fatura_w		:= nr_seq_pls_fatura_p;
		nr_seq_fatura_ndc_w 	:= null;
		ie_nf_fat_ndc_w 	:= 'N';
	elsif (ie_acao_w = 17) then -- 17 - NF NDC
		vl_fatura_w		:= vl_fatura_ndc_w;
		nr_titulo_w		:= nr_titulo_ndc_w;
		dt_vencimento_w 	:= dt_vencimento_ndc_w;
		ie_nf_fat_ndc_w 	:= 'S';
		nr_seq_fatura_w 	:= null;
		nr_seq_fatura_ndc_w 	:= nr_seq_pls_fatura_p;
	elsif (ie_acao_w = 18) then -- 18 - NF Fatura
		ie_nf_fat_ndc_w 	:= 'S';
		nr_seq_fatura_w 	:= nr_seq_pls_fatura_p;
		nr_seq_fatura_ndc_w 	:= null;
	end if;

	if (coalesce(cd_serie_nf_p::text, '') = '') or (coalesce(cd_operacao_nf_p::text, '') = '') then
		select	max(cd_operacao_nf),
			max(cd_natureza_operacao),
			max(nr_seq_classif_fiscal),
			max(nr_seq_sit_trib),
			max(cd_serie_nf)
		into STRICT	cd_operacao_nf_w,
			cd_natureza_operacao_w,
			nr_seq_classif_fiscal_w,
			nr_seq_sit_trib_w,
			cd_serie_nf_w	
		from	pls_processo_interc_acao
		where	nr_sequencia	= nr_seq_acao_p;
	else
		cd_operacao_nf_w	:= cd_operacao_nf_p;
		cd_natureza_operacao_w	:= cd_natureza_operacao_p;
		nr_seq_classif_fiscal_w	:= nr_seq_classif_fiscal_p;
		nr_seq_sit_trib_w	:= nr_seq_sit_trib_p;
		cd_serie_nf_w		:= cd_serie_nf_p;
	end if;

	if (coalesce(cd_operacao_nf_w::text, '') = '') then -- Operacao nota
		CALL wheb_mensagem_pck.exibir_mensagem_abort(244604);
		
	elsif (coalesce(cd_serie_nf_w::text, '') = '') then -- Serie
		CALL wheb_mensagem_pck.exibir_mensagem_abort(244605);
	end if;

	if (vl_fatura_w > 0) then
		select	nextval('nota_fiscal_seq')
		into STRICT	nr_sequencia_w
		;
		
		nr_nota_fiscal_w	:= nr_sequencia_w + 800000;
		nr_sequencia_nf_w	:= 1;
		vl_mercadoria_w		:= vl_fatura_w;
		vl_total_nota_w		:= vl_fatura_w;
		cd_condicao_pagamento_w	:= null;
		vl_ipi_w		:= 0;
		vl_descontos_w		:= 0;
		vl_frete_w		:= 0;
		vl_seguro_w		:= 0;
		vl_despesa_acessoria_w	:= 0;
		vl_despesa_doc_w	:= 0;
		
		if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
			ie_tipo_nota_w	:= 'SE';
		else
			ie_tipo_nota_w	:= 'SF';
		end if;
		
		select	max(cd_condicao_pagamento)
		into STRICT	cd_condicao_pagamento_w
		from	condicao_pagamento
		where	ie_forma_pagamento = 1;
		
		insert into nota_fiscal(nr_sequencia,
			cd_estabelecimento,
			cd_cgc_emitente,
			cd_serie_nf,
			nr_nota_fiscal,
			nr_sequencia_nf,
			cd_operacao_nf,
			dt_emissao,
			dt_entrada_saida,
			ie_acao_nf,
			ie_emissao_nf,
			ie_tipo_frete,
			vl_mercadoria,
			vl_total_nota,
			qt_peso_bruto,
			qt_peso_liquido,
			dt_atualizacao,
			nm_usuario, --fim obrigatorios
			ie_tipo_nota,
			cd_condicao_pagamento,
			cd_natureza_operacao,
			nr_seq_classif_fiscal,
			ds_observacao,
			vl_ipi,
			vl_descontos,
			vl_frete,
			vl_seguro,
			vl_despesa_acessoria,
			cd_pessoa_fisica,
			cd_cgc,
			nr_seq_fatura,
			ie_situacao,
			nr_lote_contabil,
			ie_entregue_bloqueto,
			vl_despesa_doc,
			nr_seq_fatura_ndc)
		values (nr_sequencia_w, --nr_sequencia
			cd_estabelecimento_p, --cd_estabelecimento
			cd_cgc_emitente_w, --cd_cgc_emitente
			cd_serie_nf_w, --cd_serie_nf
			nr_nota_fiscal_w, --nr_nota_fiscal
			nr_sequencia_nf_w, --nr_sequencia_nf
			cd_operacao_nf_w, --cd_operacao_nf
			dt_emissao_p, --dt_emissao
			dt_emissao_p, --dt_entrada_saida
			'1', --ie_acao_nf
			'0', --ie_emissao_nf
			'0', --ie_tipo_frete
			vl_mercadoria_w, --vl_mercadoria
			vl_total_nota_w, --vl_total_nota
			0, --qt_peso_bruto
			0, --qt_peso_liquido
			clock_timestamp(),
			nm_usuario_p, -- fim obirgatorios
			ie_tipo_nota_w, --ie_tipo_nota
			cd_condicao_pagamento_w, --cd_condicao_pagamento
			cd_natureza_operacao_w, --cd_natureza_operacao
			nr_seq_classif_fiscal_w, --nr_seq_classif_fiscal_p  --nr_seq_classif_fiscal
			ds_observacao_p, --ds_observacao
			vl_ipi_w, --vl_ipi
			vl_descontos_w, --vl_descontos
			vl_frete_w, --vl_frete
			vl_seguro_w, --vl_seguro
			vl_despesa_acessoria_w, --vl_despesa_acessoria
			cd_pessoa_fisica_w, --cd_pessoa_fisica
			cd_cgc_w, --cd_cgc
			nr_seq_fatura_w, --nr_seq_fatura
			'1', --ie_situacao
			0, --nr_lote_contabil
			'N', --ie_entregue_bloqueto
			vl_despesa_doc_w,
			nr_seq_fatura_ndc_w); -- nr_seq_fatura_ndc
			
		-- Gerar itens da nota fiscal
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_tipo_item_fat
		where	cd_estabelecimento = cd_estabelecimento_p;
		
		if (qt_registro_w = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(187432);
		else
			nr_seq_regra_nf_w := null;
			
			if (ie_acao_w in (16,18)) then -- Geral / Fatura
				open C01;
				loop
				fetch C01 into
					ie_ato_cooperado_w,
					nr_seq_evento_w,
					nr_seq_conta_w,
					vl_item_w,
					ie_tipo_guia_w,
					ie_origem_conta_w,
					nr_seq_tipo_atendimento_w,
					ie_regime_atendimento_w,
					ie_saude_ocupacional_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
					begin
					select	max(b.ie_tipo_relacao)
					into STRICT	ie_tipo_relacao_w
					from	pls_prestador	b,
						pls_conta	a
					where	b.nr_sequencia	= a.nr_seq_prestador_exec
					and	a.nr_sequencia	= nr_seq_conta_w;
					
					ie_valor_ww := 'F';
					
					open C02;
					loop
					fetch C02 into
						cd_procedimento_nf_w,
						ie_origem_proced_nf_w,
						cd_material_nf_w,
						ie_valor_w,
						nr_seq_regra_nf_w;
					EXIT WHEN NOT FOUND; /* apply on C02 */
					end loop;
					close C02;
					
					if	((cd_procedimento_nf_w IS NOT NULL AND cd_procedimento_nf_w::text <> '') or (cd_material_nf_w IS NOT NULL AND cd_material_nf_w::text <> '')) then
						select	max(nr_item_nf)
						into STRICT	nr_item_nf_w
						from	nota_fiscal_item
						where	nr_sequencia		= nr_sequencia_w
						and	((cd_procedimento	= cd_procedimento_nf_w and
							coalesce(ie_origem_proced,0) = coalesce(ie_origem_proced_nf_w,0)) or
							cd_material		= cd_material_nf_w);
							
						if (nr_item_nf_w IS NOT NULL AND nr_item_nf_w::text <> '') then
							update	nota_fiscal_item
							set	vl_unitario_item_nf	= vl_unitario_item_nf + vl_item_w,
								vl_total_item_nf	= vl_total_item_nf + vl_item_w,
								vl_liquido		= vl_liquido + vl_item_w
							where	nr_sequencia		= nr_sequencia_w
							and	nr_item_nf		= nr_item_nf_w;	
						else
							select	coalesce(max(nr_item_nf), 0) + 1
							into STRICT	nr_item_nf_w
							from	nota_fiscal_item
							where	nr_sequencia	= nr_sequencia_w;
							
							insert into nota_fiscal_item(nr_sequencia,
								cd_estabelecimento,
								cd_cgc_emitente,
								cd_serie_nf,
								nr_nota_fiscal,
								nr_sequencia_nf,
								nr_item_nf,
								cd_natureza_operacao,
								qt_item_nf,
								vl_unitario_item_nf,
								vl_total_item_nf,
								vl_liquido,
								vl_frete,
								vl_desconto,
								vl_despesa_acessoria,
								vl_desconto_rateio,
								vl_seguro,
								nm_usuario,
								dt_atualizacao, -- fim obrigatorios
								ds_complemento,
								cd_procedimento,
								ie_origem_proced,
								cd_material)
							values (nr_sequencia_w,
								cd_estabelecimento_p,
								cd_cgc_emitente_w,
								cd_serie_nf_w,
								nr_nota_fiscal_w,
								nr_sequencia_nf_w,
								nr_item_nf_w,
								cd_natureza_operacao_w,
								1,
								vl_item_w,
								vl_item_w,
								vl_item_w,
								vl_frete_w,
								vl_descontos_w,
								vl_despesa_acessoria_w,
								0,
								0,
								nm_usuario_p,
								clock_timestamp(), --fim obrigatorios
								ds_complemento_p,
								cd_procedimento_nf_w,
								ie_origem_proced_nf_w,
								cd_material_nf_w);
						end if;
					else
						/* 730743
						Verificar cadastros em 'OPS - Faturamento > Cadastros > Nota fiscal'.
						Item sem regra de processo de intercambio valida.
						Fatura: #@NR_FATURA#@
						Conta: #@NR_SEQ_CONTA#@
						Ato cooperado: #@IE_ATO_COOPERADO#@
						Tipo relacao: #@IE_TIPO_RELACAO#@
						Regra faturamento: #@NR_SEQ_REGRA_FAT#@
						Evento: #@NR_SEQ_EVENTO#@
						Grupo prestador: #@NR_SEQ_GRUPO_PREST#@
						Tipo guia princ: #@IE_TIPO_GUIA#@
						Origem conta: #@IE_ORIGEM_CONTA#@
						Tipo atendimento: #@NR_SEQ_TIPO_ATENDIMENTO#@
						*/
						nm_regra_w := null;
						if (nr_seq_regra_fat_w IS NOT NULL AND nr_seq_regra_fat_w::text <> '') then
							select	nm_regra
							into STRICT	nm_regra_w
							from	pls_regra_faturamento
							where	nr_sequencia = nr_seq_regra_fat_w;
						end if;
						
						ds_evento_w := null;
						if (nr_seq_evento_w IS NOT NULL AND nr_seq_evento_w::text <> '') then
							select	ds_evento
							into STRICT	ds_evento_w
							from	pls_evento_faturamento
							where	nr_sequencia = nr_seq_evento_w;
						end if;
						
						ds_grupo_w := null;
						if (nr_seq_grupo_prest_w IS NOT NULL AND nr_seq_grupo_prest_w::text <> '') then
							select	ds_grupo
							into STRICT	ds_grupo_w
							from	pls_preco_grupo_prestador
							where	nr_sequencia = nr_seq_grupo_prest_w;
						end if;
						
						ds_tipo_atendimento_w := null;
						if (nr_seq_tipo_atendimento_w IS NOT NULL AND nr_seq_tipo_atendimento_w::text <> '') then
							select 	ds_tipo_atendimento
							into STRICT	ds_tipo_atendimento_w
							from	pls_tipo_atendimento
							where	nr_sequencia = nr_seq_tipo_atendimento_w;
						end if;
						
						CALL wheb_mensagem_pck.exibir_mensagem_abort(448428,	'NR_FATURA=' 			|| nr_seq_pls_fatura_p					|| ';' ||
												'NR_SEQ_CONTA='			|| nr_seq_conta_w					|| ';' || 
												'IE_ATO_COOPERADO='		|| obter_descricao_dominio(3418, ie_ato_cooperado_w)	|| ';' || 
												'IE_TIPO_RELACAO='		|| obter_descricao_dominio(1668, ie_tipo_relacao_w)	|| ';' || 
												'NR_SEQ_REGRA_FAT='		|| nm_regra_w						|| ';' || 
												'NR_SEQ_EVENTO='		|| ds_evento_w						|| ';' || 
												'NR_SEQ_GRUPO_PREST='		|| ds_grupo_w						|| ';' || 
												'IE_TIPO_GUIA='			|| obter_descricao_dominio(1746, ie_tipo_guia_w)	|| ';' || 
												'IE_ORIGEM_CONTA='		|| obter_descricao_dominio(3470, ie_origem_conta_w)	|| ';' || 
												'NR_SEQ_TIPO_ATENDIMENTO='	|| ds_tipo_atendimento_w				);
					end if;
					end;
				end loop;
				close C01;
			end if;
			
			nr_seq_regra_nf_w := null;
			cd_procedimento_nf_w := null;
			ie_origem_proced_nf_w := null;
			cd_material_nf_w := null;
			nr_seq_regra_nf_w := null;
			
			if (ie_acao_w in (16,17)) then -- Geral / NDR
				open C00;
				loop
				fetch C00 into
					ie_ato_cooperado_w,
					nr_seq_evento_w,
					nr_seq_conta_w,
					vl_item_w,
					ie_tipo_guia_w,
					ie_origem_conta_w,
					nr_seq_tipo_atendimento_w,
					ie_regime_atendimento_w,
					ie_saude_ocupacional_w;
				EXIT WHEN NOT FOUND; /* apply on C00 */
					begin
					select	max(b.ie_tipo_relacao)
					into STRICT	ie_tipo_relacao_w
					from	pls_prestador	b,
						pls_conta	a
					where	b.nr_sequencia	= a.nr_seq_prestador_exec
					and	a.nr_sequencia	= nr_seq_conta_w;
					
					ie_valor_ww	:= 'N';
					
					open C02;
					loop
					fetch C02 into
						cd_procedimento_nf_w,
						ie_origem_proced_nf_w,
						cd_material_nf_w,
						ie_valor_w,
						nr_seq_regra_nf_w;
					EXIT WHEN NOT FOUND; /* apply on C02 */
					end loop;
					close C02;
					
					if	((cd_procedimento_nf_w IS NOT NULL AND cd_procedimento_nf_w::text <> '') or (cd_material_nf_w IS NOT NULL AND cd_material_nf_w::text <> '')) then
						select	max(nr_item_nf)
						into STRICT	nr_item_nf_w
						from	nota_fiscal_item
						where	nr_sequencia			= nr_sequencia_w
						and	((cd_procedimento		= cd_procedimento_nf_w and
							coalesce(ie_origem_proced,0) 	= coalesce(ie_origem_proced_nf_w,0)) or
							cd_material			= cd_material_nf_w);
						
						if (nr_item_nf_w IS NOT NULL AND nr_item_nf_w::text <> '') then
							update	nota_fiscal_item
							set	vl_unitario_item_nf	= vl_unitario_item_nf + vl_item_w,
								vl_total_item_nf	= vl_total_item_nf + vl_item_w,
								vl_liquido		= vl_liquido + vl_item_w
							where	nr_sequencia		= nr_sequencia_w
							and	nr_item_nf		= nr_item_nf_w;
						else
							select	coalesce(max(nr_item_nf), 0) + 1
							into STRICT	nr_item_nf_w
							from	nota_fiscal_item
							where	nr_sequencia	= nr_sequencia_w;
							
							insert into nota_fiscal_item(nr_sequencia,
								cd_estabelecimento,
								cd_cgc_emitente,
								cd_serie_nf,
								nr_nota_fiscal,
								nr_sequencia_nf,
								nr_item_nf,
								cd_natureza_operacao,
								qt_item_nf,
								vl_unitario_item_nf,
								vl_total_item_nf,
								vl_liquido,
								vl_frete,
								vl_desconto,
								vl_despesa_acessoria,
								vl_desconto_rateio,
								vl_seguro,
								nm_usuario,
								dt_atualizacao, -- fim obrigatorios
								ds_complemento,
								cd_procedimento,
								ie_origem_proced,
								cd_material)
							values (nr_sequencia_w,
								cd_estabelecimento_p,
								cd_cgc_emitente_w,
								cd_serie_nf_w,
								nr_nota_fiscal_w,
								nr_sequencia_nf_w,
								nr_item_nf_w,
								cd_natureza_operacao_w,
								1,
								vl_item_w,
								vl_item_w,
								vl_item_w,
								vl_frete_w,
								vl_descontos_w,
								vl_despesa_acessoria_w,
								0,
								0,
								nm_usuario_p,
								clock_timestamp(), --fim obrigatorios
								ds_complemento_p,
								cd_procedimento_nf_w,
								ie_origem_proced_nf_w,
								cd_material_nf_w);
						end if;
					else
						/* 730743
						Verificar cadastros em 'OPS - Faturamento > Cadastros > Nota fiscal'.
						Item sem regra de processo de intercambio valida.
						Fatura: #@NR_FATURA#@
						Conta: #@NR_SEQ_CONTA#@
						Ato cooperado: #@IE_ATO_COOPERADO#@
						Tipo relacao: #@IE_TIPO_RELACAO#@
						Regra faturamento: #@NR_SEQ_REGRA_FAT#@
						Evento: #@NR_SEQ_EVENTO#@
						Grupo prestador: #@NR_SEQ_GRUPO_PREST#@
						Tipo guia princ: #@IE_TIPO_GUIA#@
						Origem conta: #@IE_ORIGEM_CONTA#@
						Tipo atendimento: #@NR_SEQ_TIPO_ATENDIMENTO#@
						*/
						nm_regra_w := null;
						if (nr_seq_regra_fat_w IS NOT NULL AND nr_seq_regra_fat_w::text <> '') then
							select	nm_regra
							into STRICT	nm_regra_w
							from	pls_regra_faturamento
							where	nr_sequencia = nr_seq_regra_fat_w;
						end if;
						
						ds_evento_w := null;
						if (nr_seq_evento_w IS NOT NULL AND nr_seq_evento_w::text <> '') then
							select	ds_evento
							into STRICT	ds_evento_w
							from	pls_evento_faturamento
							where	nr_sequencia = nr_seq_evento_w;
						end if;
						
						ds_grupo_w := null;
						if (nr_seq_grupo_prest_w IS NOT NULL AND nr_seq_grupo_prest_w::text <> '') then
							select	ds_grupo
							into STRICT	ds_grupo_w
							from	pls_preco_grupo_prestador
							where	nr_sequencia = nr_seq_grupo_prest_w;
						end if;
						
						ds_tipo_atendimento_w := null;
						if (nr_seq_tipo_atendimento_w IS NOT NULL AND nr_seq_tipo_atendimento_w::text <> '') then
							select 	ds_tipo_atendimento
							into STRICT	ds_tipo_atendimento_w
							from	pls_tipo_atendimento
							where	nr_sequencia = nr_seq_tipo_atendimento_w;
						end if;
						
						CALL wheb_mensagem_pck.exibir_mensagem_abort(448428,	'NR_FATURA=' 			|| nr_seq_pls_fatura_p					|| ';' ||
												'NR_SEQ_CONTA='			|| nr_seq_conta_w					|| ';' || 
												'IE_ATO_COOPERADO='		|| obter_descricao_dominio(3418, ie_ato_cooperado_w)	|| ';' || 
												'IE_TIPO_RELACAO='		|| obter_descricao_dominio(1668, ie_tipo_relacao_w)	|| ';' || 
												'NR_SEQ_REGRA_FAT='		|| nm_regra_w						|| ';' || 
												'NR_SEQ_EVENTO='		|| ds_evento_w						|| ';' || 
												'NR_SEQ_GRUPO_PREST='		|| ds_grupo_w						|| ';' || 
												'IE_TIPO_GUIA='			|| obter_descricao_dominio(1746, ie_tipo_guia_w)	|| ';' || 
												'IE_ORIGEM_CONTA='		|| obter_descricao_dominio(3470, ie_origem_conta_w)	|| ';' || 
												'NR_SEQ_TIPO_ATENDIMENTO='	|| ds_tipo_atendimento_w				);
					end if;
					end;
				end loop;
				close C00;
			end if;
			
			/* locar a tabela e obter o numero da nota fiscal */

			lock table serie_nota_fiscal in exclusive mode;
			select	max(nr_ultima_nf) + 1
			into STRICT	nr_ultima_nf_w
			from	serie_nota_fiscal
			where	cd_serie_nf		= cd_serie_nf_w
			and	cd_estabelecimento	= cd_estabelecimento_p;
			
			-- Verifica se o numero da NF ja e utilizado
			select	count(1)
			into STRICT	qt_registro_w
			from	nota_fiscal
			where	cd_estabelecimento	= cd_estabelecimento_p
			and	cd_cgc_emitente		= cd_cgc_emitente_w
			and	cd_serie_nf		= cd_serie_nf_w
			and	nr_nota_fiscal		= nr_ultima_nf_w
			and	nr_sequencia_nf		= nr_sequencia_nf_w;
			
			-- Tabela: NOTA_FISCAL

			-- UK: NOTFISC_UK

			-- Gerar nova sequencia de NF
			if (qt_registro_w > 0) then
				select	max(nr_sequencia_nf) + 1
				into STRICT	nr_sequencia_nf_w
				from	nota_fiscal
				where	nr_nota_fiscal		= nr_ultima_nf_w
				and	cd_serie_nf		= coalesce(cd_serie_nf_w,cd_serie_nf_p)
				and	cd_cgc_emitente		= cd_cgc_emitente_w
				and	cd_estabelecimento	= cd_estabelecimento_p;
			end if;
			
			if (nr_ultima_nf_w IS NOT NULL AND nr_ultima_nf_w::text <> '') then
				if (coalesce(ie_estab_serie_nf_w,'N') = 'S') then
					update	serie_nota_fiscal
					set	nr_ultima_nf 		= nr_ultima_nf_w
					where	cd_serie_nf 		= cd_serie_nf_w
					and	cd_estabelecimento in (SELECT	z.cd_estabelecimento
									from	estabelecimento z
									where	z.cd_cgc = cd_cgc_emitente_w);
				else
					update	serie_nota_fiscal
					set	nr_ultima_nf		= nr_ultima_nf_w
					where	cd_serie_nf		= cd_serie_nf_w
					and	cd_estabelecimento	= cd_estabelecimento_p;
				end if;
			end if;
			
			-- Atualizar informacoes da nota fiscal
			update	nota_fiscal
			set	nr_nota_fiscal	= coalesce(nr_ultima_nf_w,nr_nota_fiscal),
				nr_sequencia_nf	= nr_sequencia_nf_w
			where	nr_sequencia	= nr_sequencia_w;
			
			update	nota_fiscal_item
			set	nr_nota_fiscal	= coalesce(nr_ultima_nf_w,nr_nota_fiscal)
			where	nr_sequencia	= nr_sequencia_w;
		end if;
		
		-- Gerar os impostos sobre a nota fiscal
		CALL gerar_imposto_nf(nr_sequencia_w,
				nm_usuario_p,
				null,
				null);
			
		-- Atualizar total da nota fiscal
		CALL atualiza_total_nota_fiscal(	nr_sequencia_w,
						nm_usuario_p);
						
		-- Gerar nota fiscal vencimento
		while(dt_vencimento_w < trunc(dt_emissao_p,'dd')) loop
			dt_vencimento_w	:= add_months(dt_vencimento_w, 1);
		end loop;
		
		CALL gerar_nota_fiscal_venc(	nr_sequencia_w,
					dt_vencimento_w);
		--Gerar log
		CALL pls_gerar_fatura_log(nr_seq_lote_p, nr_seq_pls_fatura_p, null, 'PLS_GERAR_NOTAS_TIT_FATURAS', 'GN', 'N', nm_usuario_p);
					
		update	nota_fiscal
		set	dt_atualizacao_estoque 	= clock_timestamp()
		where	nr_sequencia 		= nr_sequencia_w;
		
		-- if	(ie_gera_titulo_p = 'S') then
			update	titulo_receber a
			set	a.nr_seq_nf_saida	= CASE WHEN nr_seq_nf_saida = NULL THEN nr_sequencia_w  ELSE nr_seq_nf_saida END ,
				a.cd_serie		= CASE WHEN cd_serie='' THEN cd_serie_nf_p  ELSE cd_serie END
			where	exists (SELECT	1
					from	pls_fatura x
					where	x.nr_titulo	= a.nr_titulo
					and	x.nr_sequencia	= nr_seq_pls_fatura_p);
		-- end if;

		
		/* Gravar o serie da nota fiscal no titulo */

		if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
			begin
			select	cd_serie,
				nr_nota_fiscal
			into STRICT	cd_serie_w,
				nr_nota_fiscal_tit_w
			from	titulo_receber
			where	nr_titulo = nr_titulo_w;
			exception
			when others then
				cd_serie_w	:= null;
			end;
			
			if	((coalesce(cd_serie_w::text, '') = '') or (coalesce(nr_nota_fiscal_tit_w::text, '') = '')) then
				update	titulo_receber
				set	cd_serie	= CASE WHEN cd_serie = NULL THEN cd_serie_nf_p  ELSE cd_serie END ,
					nr_nota_fiscal	= coalesce(nr_ultima_nf_w,nr_nota_fiscal_w)
				where	nr_titulo 	= nr_titulo_w;
			end if;
		end if;
		
		update	pls_fatura
		set	ie_nf_fat_ndc	= ie_nf_fat_ndc_w
		where	nr_sequencia	= nr_seq_pls_fatura_p;
		
		select	coalesce(a.vl_total_nota,0)
		into STRICT	vl_total_nota_atual_w
		from	nota_fiscal	a
		where	a.nr_sequencia	= nr_sequencia_w;
		
		select	coalesce(sum(coalesce(vl_total_item_nf,0)),0)
		into STRICT	vl_total_item_w
		from	nota_fiscal_item	a
		where	nr_sequencia		= nr_sequencia_w;
		
		select	coalesce(sum(coalesce(a.vl_tributo,0)),0)
		into STRICT	vl_tributo_w
		from	nota_fiscal_item_trib	a,
			tributo			b
		where	a.cd_tributo 		= b.cd_tributo
		and	a.nr_sequencia		= nr_sequencia_w;
		
		if (vl_total_nota_w <> vl_total_item_w) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(251103,'NR_FATURA=' || nr_seq_pls_fatura_p);
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_notas_tit_faturas ( nr_seq_lote_p bigint, nr_seq_pls_fatura_p bigint, nr_seq_acao_p bigint, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, nr_seq_classif_fiscal_p bigint, nr_seq_sit_trib_p bigint, cd_serie_nf_p text, dt_emissao_p timestamp, ds_complemento_p text, ds_observacao_p text, ie_gera_titulo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

