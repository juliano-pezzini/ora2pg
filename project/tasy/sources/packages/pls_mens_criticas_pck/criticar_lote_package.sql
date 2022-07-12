-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_criticas_pck.criticar_lote ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_critica_mensalidade_w	pls_visible_false.ie_critica_mensalidade%type;
dt_referencia_w			pls_mensalidade_segurado.dt_mesano_referencia%type;
vl_pre_estab_ant_w		pls_mensalidade_segurado.vl_pre_estabelecido%type;
qt_idade_ant_w			pls_mensalidade_segurado.qt_idade%type;
ie_mes_cobranca_reaj_w		pls_contrato.ie_mes_cobranca_reaj%type;
nr_seq_plano_ant_w		pls_plano.nr_sequencia%type;

C01 CURSOR(	nr_seq_lote_pc	pls_lote_mensalidade.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_mensalidade_seg,
		a.nr_seq_segurado,
		a.dt_mesano_referencia dt_referencia,
		a.qt_idade,
		a.vl_pre_estabelecido,
		coalesce(a.ie_rescisao_proporcional,'N') ie_rescisao_proporcional,
		a.nr_seq_segurado_preco,
		b.nr_seq_pagador,
		a.nr_parcela,
		(SELECT	count(1)
		from	pls_mensalidade_seg_item x
		where	a.nr_sequencia = x.nr_seq_mensalidade_seg
		and	x.ie_tipo_item = '5') qt_reaj_fx,
		coalesce((	select	y.ie_mes_cobranca_reaj
			from	pls_contrato_pagador x,
				pls_contrato y
			where	y.nr_sequencia = x.nr_seq_contrato
			and	x.nr_sequencia = b.nr_seq_pagador), 'R') ie_mes_cobranca_reaj,
		(select	ie_regulamentacao
		from	pls_plano x
		where	x.nr_sequencia = a.nr_seq_plano) ie_regulamentacao,
		(select	x.dt_nascimento
		from	pessoa_fisica x,
			pls_segurado y
		where	x.cd_pessoa_fisica = y.cd_pessoa_fisica
		and	y.nr_sequencia = a.nr_seq_segurado) dt_nascimento,
		(select	count(1)
		from	pls_mensalidade_seg_item x
		where	a.nr_sequencia = x.nr_seq_mensalidade_seg
		and	x.ie_tipo_item in ('4','25')) qt_reaj_retro_variacao_custo,
		(select	x.qt_idade_inicial
		from	pls_plano_preco x,
			pls_segurado_preco y
		where	x.nr_sequencia = y.nr_seq_preco
		and	y.nr_sequencia = a.nr_seq_segurado_preco) qt_idade_inicial,
		(select	count(1)
		from	pls_mensalidade_seg_item x,
			pls_mensalidade_sca y
		where	x.nr_sequencia = y.nr_seq_item_mens
		and	a.nr_sequencia = x.nr_seq_mensalidade_seg
		and	x.ie_tipo_item = '15'
		and	y.nr_parcela < 6) qt_sca,
		(select	count(1)
		from	pls_mensalidade_seg_item x
		where	a.nr_sequencia = x.nr_seq_mensalidade_seg
		and	x.ie_tipo_item in ('3','6','13')) qt_item_conta,
		(select	count(1)
		from	pls_mensalidade_seg_item x
		where	a.nr_sequencia = x.nr_seq_mensalidade_seg
		and	x.vl_sca_embutido > 0
		and	not exists (	select	1
					from	pls_mensalidade_sca w
					where	x.nr_sequencia = w.nr_seq_item_mens)) qt_sca_embutido_sem_parcela,
		(select	count(1)
		from	pls_mensalidade_seg_item x
		where	a.nr_sequencia = x.nr_seq_mensalidade_seg
		and	x.ie_tipo_item = '15'
		and	not exists (	select	1
					from	pls_mensalidade_sca w
					where	x.nr_sequencia = w.nr_seq_item_mens)) qt_sca_sem_parcela,
		a.nr_seq_plano nr_seq_plano_atual
	from	pls_mensalidade_segurado a,
		pls_mensalidade b
	where	b.nr_sequencia	= a.nr_seq_mensalidade
	and	b.nr_seq_lote	= nr_seq_lote_pc;
	
BEGIN

PERFORM set_config('pls_mens_criticas_pck.nm_usuario_w', nm_usuario_p, false);

--Limpar os vetores e iniciar o contador

current_setting('pls_mens_criticas_pck.tb_nr_seq_mensalidade_seg_w')::pls_util_cta_pck.t_number_table.delete;
CALL pls_mens_criticas_pck.inserir_criticas();

for r_c01_w in C01(nr_seq_lote_p) loop
	begin
	dt_referencia_w	:= trunc(add_months(r_c01_w.dt_referencia,-1),'month');
	
	select	coalesce(sum(a.vl_pre_estabelecido),0),
		max(a.qt_idade),
		max(a.nr_seq_plano)
	into STRICT	vl_pre_estab_ant_w,
		qt_idade_ant_w,
		nr_seq_plano_ant_w
	from	pls_mensalidade_segurado a,
		pls_mensalidade b
	where	b.nr_sequencia	= a.nr_seq_mensalidade
	and	a.nr_seq_segurado = r_c01_w.nr_seq_segurado
	and	b.nr_seq_pagador = r_c01_w.nr_seq_pagador
	and	a.dt_mesano_referencia = dt_referencia_w
	and	coalesce(b.ie_cancelamento::text, '') = '';
	
	if (nr_seq_plano_ant_w = r_c01_w.nr_seq_plano_atual) then--Valor pre-estabelecido menor do que cobrado no mes anterior
		CALL pls_mens_criticas_pck.criticar_valor_menor(r_c01_w.nr_seq_mensalidade_seg, r_c01_w.vl_pre_estabelecido, vl_pre_estab_ant_w, r_c01_w.nr_parcela, r_c01_w.ie_rescisao_proporcional);
	end if;
	
	--Idade menor do que no mes anterior

	CALL pls_mens_criticas_pck.criticar_idade_menor(r_c01_w.nr_seq_mensalidade_seg, r_c01_w.qt_idade, qt_idade_ant_w);
	
	--Beneficiario na faixa etaria incorreta

	CALL pls_mens_criticas_pck.criticar_faixa_etaria(r_c01_w.nr_seq_mensalidade_seg, r_c01_w.nr_seq_segurado, r_c01_w.nr_seq_segurado_preco, r_c01_w.qt_idade, r_c01_w.dt_referencia, cd_estabelecimento_p);
	
	--Valor de apropriacao inconsistente

	CALL pls_mens_criticas_pck.criticar_apropriacao(r_c01_w.nr_seq_mensalidade_seg);
	
	--Bonificacao duplicada na mensalidade

	CALL pls_mens_criticas_pck.critica_bonificacao_duplicada(r_c01_w.nr_seq_mensalidade_seg);
	
	--Reajuste de faixa etaria aplicado na competencia incorreta

	if (r_c01_w.qt_reaj_fx > 0) then
		if (r_c01_w.ie_mes_cobranca_reaj = 'R') then
			ie_mes_cobranca_reaj_w	:= pls_mensalidade_util_pck.get_ie_mes_reaj_faixa_etaria(r_c01_w.ie_regulamentacao);
		else
			ie_mes_cobranca_reaj_w	:= r_c01_w.ie_mes_cobranca_reaj;
		end if;
	
		CALL pls_mens_criticas_pck.critica_reajuste_faixa_etaria(r_c01_w.nr_seq_mensalidade_seg, ie_mes_cobranca_reaj_w, r_c01_w.dt_referencia, r_c01_w.qt_idade_inicial, r_c01_w.dt_nascimento, r_c01_w.qt_idade);
	end if;
	
	--Cobranca retroativa e Variacao de custo com valor divergente

	if (r_c01_w.qt_reaj_retro_variacao_custo > 0) then
		CALL pls_mens_criticas_pck.critica_reaj_retro_varia_custo(r_c01_w.nr_seq_mensalidade_seg);
	end if;

	--Existe SCA sem cobranca em mensalidade anterior

	if (r_c01_w.qt_sca > 0) then
		CALL pls_mens_criticas_pck.critica_sca_nao_gerado(r_c01_w.nr_seq_mensalidade_seg);
	end if;

	--Cobranca realizada apos 90 dias do fechamento da conta

	if (r_c01_w.qt_item_conta > 0) then
		CALL pls_mens_criticas_pck.critica_fechamento_conta(r_c01_w.nr_seq_mensalidade_seg, r_c01_w.dt_referencia);
	end if;
	
	--Parcela do SCA nao gerada

	if	((r_c01_w.qt_sca_embutido_sem_parcela > 0) or (r_c01_w.qt_sca_sem_parcela > 0)) then
		CALL pls_mens_criticas_pck.add_critica(r_c01_w.nr_seq_mensalidade_seg, 12);
	end if;
	end;
end loop;

--Inserir as criticas pendentes (ainda nao inseridas)

CALL pls_mens_criticas_pck.inserir_criticas();

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_criticas_pck.criticar_lote ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;