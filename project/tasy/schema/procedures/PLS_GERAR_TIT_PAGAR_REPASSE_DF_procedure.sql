-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_tit_pagar_repasse_df ( nr_seq_lote_repasse_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_titulo_w			bigint;
vl_vencimento_w			double precision;
ds_observacao_w			varchar(1000);

cd_cgc_w			varchar(14);
cd_moeda_padrao_w		integer;
ds_empresa_w			varchar(255);
dt_vencimento_w			timestamp;
dt_referencia_w			timestamp;
cd_condicao_pagamento_w		bigint;
ie_forma_pagamento_w		smallint;
ie_acao_venc_nao_util_w		varchar(1);
tx_fracao_parcela_w		double precision	:= 0;
tx_acrescimo_w			double precision	:= 0;
nr_seq_classif_w		bigint;
cd_conta_financ_w		bigint;

cd_tipo_portador_w		numeric(5,0)	:= 0;
cd_portador_w			numeric(10,0)	:= 0;
ie_tipo_emissao_titulo_w	numeric(5)	:= 1;
cd_estab_financeiro_w		bigint;
ie_gerar_imposto_w		varchar(1);
nr_seq_trans_fin_nf_w		bigint;
nr_seq_trans_fin_baixa_w	bigint;
cd_tipo_taxa_juros_plano_w	bigint	:= null;
tx_juros_plano_w		double precision	:= null;
cd_tipo_taxa_multa_plano_w	bigint	:= null;
tx_multa_plano_w		double precision	:= null;
nr_seq_reajuste_w		bigint;
ie_origem_titulo_plano_w	varchar(10)	:= null;
nr_seq_conta_banco_w		bigint	:= null;
vl_comissao_w			double precision;
vl_titulo_w			double precision;
nr_seq_tit_liq_w		bigint;
vl_comissao_ww			double precision;
vl_titulo_ww			double precision;
vl_vencimento_ww		double precision;
i				bigint	:= 0;
qt_parcelas_w			bigint;
vl_diferenca_round_w		double precision;
dt_emissao_w			timestamp;

C01 CURSOR FOR
	SELECT	tx_fracao_parcela,	/* A Prazo   */
		coalesce(tx_acrescimo,0),
		Obter_data_vencimento(	dt_referencia_w,
					qt_dias_parcela,
					cd_estabelecimento_p,
					ie_corrido_util,
					ie_acao_venc_nao_util_w)
	from	parcela
	where	cd_condicao_pagamento 	= cd_condicao_pagamento_w
	and	ie_forma_pagamento_w	<> 1
	
UNION

	SELECT	100, /* A Vista   */
		0,
		dt_emissao_w
	
	where	ie_forma_pagamento_w	= 1;


BEGIN

dt_emissao_w	:= clock_timestamp();

select	b.cd_cgc,
	substr(obter_razao_social(b.cd_cgc),1,255),
	coalesce(a.dt_referencia,clock_timestamp()),
	(	select	max(x.cd_condicao_pagamento)
		from	pls_desc_empresa_regra x
		where	x.nr_seq_empresa = b.nr_sequencia
		and	a.dt_referencia between trunc(coalesce(x.dt_inicio_vigencia,a.dt_referencia),'dd') and fim_dia(x.dt_fim_vigencia)) cd_condicao_pagamento,
	coalesce(a.vl_total_titulos,0) - coalesce(a.vl_repasse_lote,0),
	coalesce(a.vl_repasse_lote,0),
	coalesce(a.vl_total_titulos,0)
into STRICT	cd_cgc_w,
	ds_empresa_w,
	dt_referencia_w,
	cd_condicao_pagamento_w,
	vl_vencimento_ww,
	vl_comissao_ww,
	vl_titulo_ww
from	pls_desc_lote_comissao	a,
	pls_desc_empresa	b
where	b.nr_sequencia	= a.nr_seq_empresa
and	a.nr_sequencia	= nr_seq_lote_repasse_p;

if (coalesce(cd_condicao_pagamento_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort('Condição de pagamento não informada no cadastro da empresa.');
end if;

select	coalesce(max(ie_forma_pagamento),3),
	coalesce(max(ie_acao_nao_util),'M')
into STRICT	ie_forma_pagamento_w,
	ie_acao_venc_nao_util_w
from	condicao_pagamento
where	cd_condicao_pagamento = cd_condicao_pagamento_w
and	ie_situacao           = 'A';

select	coalesce(cd_estab_financeiro, cd_estabelecimento)
into STRICT	cd_estab_financeiro_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;

/*ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(303936,	'DS_EMPRESA=' || ds_empresa_w || ';' ||
							'NR_SEQ_LOTE_REPASSE=' || nr_seq_lote_repasse_p),1,4000);*/
open c01;
loop
fetch c01 into
	tx_fracao_parcela_w,
	tx_acrescimo_w,
	dt_vencimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	i	:= i + 1;

	if (coalesce(tx_fracao_parcela_w,0) > 0) then
		vl_vencimento_w 	:= ((vl_vencimento_ww * tx_fracao_parcela_w) / 100);
		vl_comissao_w		:= ((vl_comissao_ww * tx_fracao_parcela_w) / 100);
		vl_titulo_w		:= ((vl_titulo_ww * tx_fracao_parcela_w) / 100);
	end if;

	if (tx_acrescimo_w <> 0) then
		vl_vencimento_w 	:= vl_vencimento_ww + ((vl_vencimento_w * tx_acrescimo_w) / 100);
		vl_comissao_w		:= vl_comissao_ww + ((vl_comissao_w * tx_acrescimo_w) / 100);
		vl_titulo_w		:= vl_titulo_ww + ((vl_titulo_w * tx_acrescimo_w) / 100);
	end if;

	select	count(*)
	into STRICT	qt_parcelas_w
	from	parcela
	where	cd_condicao_pagamento	= cd_condicao_pagamento_w;

	if	(qt_parcelas_w > 1 AND i = qt_parcelas_w) then
		vl_diferenca_round_w	:= (vl_comissao_ww - (qt_parcelas_w * vl_comissao_w));
		vl_comissao_w		:= vl_comissao_w + vl_diferenca_round_w;
	end if;

	begin
	select	cd_conta_financ_reembolso
	into STRICT	cd_conta_financ_w
	from	pls_parametros
	where	cd_estabelecimento = cd_estabelecimento_p;
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(185657,'CD_ESTABELECIMENTO_P='||CD_ESTABELECIMENTO_P);
		--'Problema na leitura dos parâmetros na função OPS - Gestão de Operadoras. [' || CD_ESTABELECIMENTO_P || '] #@#@');
	end;

	select	coalesce(cd_estab_financeiro, cd_estabelecimento)
	into STRICT	cd_estab_financeiro_w
	from	estabelecimento
	where	cd_estabelecimento	= cd_estabelecimento_p;

	select 	coalesce(max(cd_moeda_padrao),1),
		coalesce(max(ie_gerar_imposto_tit_rec),'N'),
		max(nr_seq_trans_fin_nf),
		max(nr_seq_trans_fin_baixa)
 	into STRICT 	cd_moeda_padrao_w,
		ie_gerar_imposto_w,
		nr_seq_trans_fin_nf_w,
		nr_seq_trans_fin_baixa_w
 	from 	parametro_contas_receber
 	where	cd_estabelecimento  = cd_estabelecimento_p;

	begin
	select	cd_tipo_taxa_juro,
		pr_juro_padrao,
		cd_tipo_taxa_multa,
		pr_multa_padrao,
		coalesce(ie_origem_titulo,3),
		nr_seq_conta_banco,
		coalesce(cd_tipo_portador_w,cd_tipo_portador),
		coalesce(cd_portador_w,cd_portador)
	into STRICT	cd_tipo_taxa_juros_plano_w,
		tx_juros_plano_w,
		cd_tipo_taxa_multa_plano_w,
		tx_multa_plano_w,
		ie_origem_titulo_plano_w,
		nr_seq_conta_banco_w,
		cd_tipo_portador_w,
		cd_portador_w
	from	pls_parametros
	where	cd_estabelecimento	= cd_estabelecimento_p;
	exception
		when no_data_found then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(185658);
		--'Cadastro de juros e multa não informados nos parâmetros do Plano de Saúde!');
	end;

	select	nextval('titulo_seq')
	into STRICT	nr_titulo_w
	;

	insert into titulo_receber(nr_titulo, cd_estabelecimento, dt_atualizacao,
		nm_usuario, dt_emissao, dt_vencimento,
		dt_pagamento_previsto, vl_titulo, vl_saldo_titulo,
		vl_saldo_juros,	vl_saldo_multa, cd_moeda,
		cd_portador, cd_tipo_portador, ie_situacao,
		ie_tipo_emissao_titulo, ie_origem_titulo, ie_tipo_titulo,
		ie_tipo_inclusao, cd_cgc, cd_banco,
		cd_agencia_bancaria, nr_bloqueto, dt_liquidacao,
		nr_lote_contabil, ds_observacao_titulo, dt_contabil,
		tx_juros, cd_tipo_taxa_juro, tx_multa,
		cd_tipo_taxa_multa, cd_estab_financeiro, nr_seq_trans_fin_contab,
		nr_seq_trans_fin_baixa, nm_usuario_orig, dt_inclusao,
		tx_desc_antecipacao, nr_seq_lote_empresa, nr_seq_conta_banco)
	values (nr_titulo_w, cd_estabelecimento_p, clock_timestamp(),
		nm_usuario_p, dt_emissao_w, dt_vencimento_w,
		dt_vencimento_w, vl_titulo_w,vl_vencimento_w,
		0, 0, cd_moeda_padrao_w,
		cd_portador_w, cd_tipo_portador_w, 1,
		ie_tipo_emissao_titulo_w, 5, 9,
		2, cd_cgc_w, null,
		null, null, null,
		null, substr(wheb_mensagem_pck.get_texto(303937),1,4000), clock_timestamp(),
		tx_juros_plano_w, cd_tipo_taxa_juros_plano_w, tx_multa_plano_w,
		cd_tipo_taxa_multa_plano_w, cd_estab_financeiro_w, nr_seq_trans_fin_nf_w,
		nr_seq_trans_fin_baixa_w, nm_usuario_p, clock_timestamp(),
		0, nr_seq_lote_repasse_p, nr_seq_conta_banco_w);

	if (ie_gerar_imposto_w = 'S') then
		CALL Gerar_Imposto_Tit_Rec(nr_titulo_w, nm_usuario_p);
	end if;

	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_seq_tit_liq_w
	from	titulo_receber_liq
	where	nr_titulo	= nr_titulo_w;

	CALL Baixa_Titulo_Receber(	cd_estabelecimento_p,
				6,
				nr_titulo_w,
				nr_seq_trans_fin_baixa_w,
				vl_comissao_w,
				clock_timestamp(),
				nm_usuario_p,
				0,
				null,
				null,
				0,
				0);

	CALL Atualizar_Saldo_Tit_Rec(nr_titulo_w,
				nm_usuario_p);
end loop;
close c01;


update	pls_desc_lote_comissao
set	nr_titulo	= nr_titulo_w,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p,
	ie_status	= 'D'
where	nr_sequencia	= nr_seq_lote_repasse_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_tit_pagar_repasse_df ( nr_seq_lote_repasse_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
