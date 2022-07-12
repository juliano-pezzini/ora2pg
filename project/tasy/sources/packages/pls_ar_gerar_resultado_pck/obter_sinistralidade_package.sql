-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ar_gerar_resultado_pck.obter_sinistralidade ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_contrato_principal_p pls_contrato.nr_contrato_principal%type, nr_seq_grupo_relac_p pls_grupo_contrato.nr_sequencia%type, nr_seq_canal_venda_p pls_vendedor.nr_sequencia%type, dt_inicial_p timestamp, dt_fim_p timestamp, ie_remido_sinist_reaj_p pls_parametros.ie_remido_sinistralidade_reaj%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, tx_sinistralidade_p INOUT bigint, tx_resultado_p INOUT bigint, vl_receita_p INOUT bigint, vl_custo_p INOUT bigint) AS $body$
DECLARE


vl_resultado_receita_w		double precision;
vl_resultado_despesa_w		double precision;
tx_sinistralidade_w		double precision;
tx_resultado_w			pls_prog_reaj_coletivo.tx_resultado_grupo%type;
ie_remido_sinist_reaj_w		pls_parametros.ie_remido_sinistralidade_reaj%type;


BEGIN

if (ie_remido_sinist_reaj_p IS NOT NULL AND ie_remido_sinist_reaj_p::text <> '') then
	ie_remido_sinist_reaj_w	:= ie_remido_sinist_reaj_p;
else
	select	coalesce(max(ie_remido_sinistralidade_reaj), 'N')
	into STRICT	ie_remido_sinist_reaj_w
	from	pls_parametros
	where	cd_estabelecimento = cd_estabelecimento_p;
end if;

if (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then
	if (ie_remido_sinist_reaj_w = 'N') then
		select	coalesce(sum(vl_total_receita),0),
			coalesce(sum(vl_custo_assitencial),0),
			coalesce((dividir_sem_round(sum(vl_custo_assitencial),sum(vl_total_receita)) * 100),0) tx_sinistralidade,
			dividir_sem_round(sum(vl_total_receita) - sum(vl_custo_assitencial) - sum(vl_total_despesa), sum(vl_total_receita))*100 tx_resultado
		into STRICT	vl_resultado_receita_w,
			vl_resultado_despesa_w,
			tx_sinistralidade_w,
			tx_resultado_w
		from	pls_analise_resultado_v
		where	nr_seq_contrato	= nr_seq_contrato_p
		and	dt_competencia between dt_inicial_p and dt_fim_p;
	else
		select	coalesce(sum(vl_total_receita),0),
			coalesce(sum(vl_custo_assitencial),0),
			coalesce((dividir_sem_round(sum(vl_custo_assitencial),sum(vl_total_receita)) * 100),0) tx_sinistralidade,
			dividir_sem_round(sum(vl_total_receita) - sum(vl_custo_assitencial) - sum(vl_total_despesa), sum(vl_total_receita))*100 tx_resultado
		into STRICT	vl_resultado_receita_w,
			vl_resultado_despesa_w,
			tx_sinistralidade_w,
			tx_resultado_w
		from	pls_analise_resultado_v
		where	nr_seq_contrato	= nr_seq_contrato_p
		and	dt_competencia between dt_inicial_p and dt_fim_p
		and	pls_obter_se_benef_remido(nr_seq_segurado,clock_timestamp()) = 'N';
	end if;
elsif (nr_seq_grupo_relac_p IS NOT NULL AND nr_seq_grupo_relac_p::text <> '') then
	if (ie_remido_sinist_reaj_w = 'N') then
		select	coalesce(sum(a.vl_total_receita),0),
			coalesce(sum(a.vl_custo_assitencial),0),
			coalesce((dividir_sem_round(sum(a.vl_custo_assitencial),sum(a.vl_total_receita)) * 100),0) tx_sinistralidade,
			dividir_sem_round(sum(a.vl_total_receita) - sum(a.vl_custo_assitencial) - sum(a.vl_total_despesa), sum(a.vl_total_receita))*100 tx_resultado
		into STRICT	vl_resultado_receita_w,
			vl_resultado_despesa_w,
			tx_sinistralidade_w,
			tx_resultado_w
		from	pls_analise_resultado_v a,
			pls_contrato_grupo b
		where	a.nr_seq_contrato	= b.nr_seq_contrato
		and	b.nr_seq_grupo		= nr_seq_grupo_relac_p
		and	a.dt_competencia between dt_inicial_p and dt_fim_p;
	else
		select	coalesce(sum(a.vl_total_receita),0),
			coalesce(sum(a.vl_custo_assitencial),0),
			coalesce((dividir_sem_round(sum(a.vl_custo_assitencial),sum(a.vl_total_receita)) * 100),0) tx_sinistralidade,
			dividir_sem_round(sum(a.vl_total_receita) - sum(a.vl_custo_assitencial) - sum(a.vl_total_despesa), sum(a.vl_total_receita))*100 tx_resultado
		into STRICT	vl_resultado_receita_w,
			vl_resultado_despesa_w,
			tx_sinistralidade_w,
			tx_resultado_w
		from	pls_analise_resultado_v a,
			pls_contrato_grupo b
		where	a.nr_seq_contrato	= b.nr_seq_contrato
		and	b.nr_seq_grupo		= nr_seq_grupo_relac_p
		and	a.dt_competencia between dt_inicial_p and dt_fim_p
		and	pls_obter_se_benef_remido(a.nr_seq_segurado,clock_timestamp()) = 'N';
	end if;
elsif (nr_seq_contrato_principal_p IS NOT NULL AND nr_seq_contrato_principal_p::text <> '') then
	if (ie_remido_sinist_reaj_w = 'N') then
		select	coalesce(sum(a.vl_total_receita),0),
			coalesce(sum(a.vl_custo_assitencial),0),
			coalesce((dividir_sem_round(sum(a.vl_custo_assitencial),sum(a.vl_total_receita)) * 100),0) tx_sinistralidade,
			dividir_sem_round(sum(a.vl_total_receita) - sum(a.vl_custo_assitencial) - sum(a.vl_total_despesa), sum(a.vl_total_receita))*100 tx_resultado
		into STRICT	vl_resultado_receita_w,
			vl_resultado_despesa_w,
			tx_sinistralidade_w,
			tx_resultado_w
		from	pls_analise_resultado_v a,
			pls_contrato b
		where	b.nr_sequencia 		= a.nr_seq_contrato
		and	((b.nr_sequencia 	= nr_seq_contrato_principal_p) or (b.nr_contrato_principal = nr_seq_contrato_principal_p))
		and	a.dt_competencia between dt_inicial_p and dt_fim_p;
	else
		select	coalesce(sum(a.vl_total_receita),0),
			coalesce(sum(a.vl_custo_assitencial),0),
			coalesce((dividir_sem_round(sum(a.vl_custo_assitencial),sum(a.vl_total_receita)) * 100),0) tx_sinistralidade,
			dividir_sem_round(sum(a.vl_total_receita) - sum(a.vl_custo_assitencial) - sum(a.vl_total_despesa), sum(a.vl_total_receita))*100 tx_resultado
		into STRICT	vl_resultado_receita_w,
			vl_resultado_despesa_w,
			tx_sinistralidade_w,
			tx_resultado_w
		from	pls_analise_resultado_v a,
			pls_contrato b
		where	b.nr_sequencia 		= a.nr_seq_contrato
		and	((b.nr_sequencia 	= nr_seq_contrato_principal_p) or (b.nr_contrato_principal = nr_seq_contrato_principal_p))
		and	a.dt_competencia between dt_inicial_p and dt_fim_p
		and	pls_obter_se_benef_remido(a.nr_seq_segurado,clock_timestamp()) = 'N';
	end if;
elsif (nr_seq_canal_venda_p IS NOT NULL AND nr_seq_canal_venda_p::text <> '') then
	if (ie_remido_sinist_reaj_w = 'N') then
		select	coalesce(sum(a.vl_total_receita),0),
			coalesce(sum(a.vl_custo_assitencial),0),
			coalesce((dividir_sem_round(sum(a.vl_custo_assitencial),sum(a.vl_total_receita)) * 100),0) tx_sinistralidade,
			dividir_sem_round(sum(a.vl_total_receita) - sum(a.vl_custo_assitencial) - sum(a.vl_total_despesa), sum(a.vl_total_receita))*100 tx_resultado
		into STRICT	vl_resultado_receita_w,
			vl_resultado_despesa_w,
			tx_sinistralidade_w,
			tx_resultado_w
		from	pls_analise_resultado_v a,
			pls_segurado b
		where	b.nr_sequencia 		= a.nr_seq_segurado
		and	b.nr_seq_vendedor_canal = nr_seq_canal_venda_p
		and	a.dt_competencia between dt_inicial_p and dt_fim_p;
	else
		select	coalesce(sum(a.vl_total_receita),0),
			coalesce(sum(a.vl_custo_assitencial),0),
			coalesce((dividir_sem_round(sum(a.vl_custo_assitencial),sum(a.vl_total_receita)) * 100),0) tx_sinistralidade,
			dividir_sem_round(sum(a.vl_total_receita) - sum(a.vl_custo_assitencial) - sum(a.vl_total_despesa), sum(a.vl_total_receita))*100 tx_resultado
		into STRICT	vl_resultado_receita_w,
			vl_resultado_despesa_w,
			tx_sinistralidade_w,
			tx_resultado_w
		from	pls_analise_resultado_v a,
			pls_segurado b
		where	b.nr_sequencia 		= a.nr_seq_segurado
		and	b.nr_seq_vendedor_canal = nr_seq_canal_venda_p
		and	a.dt_competencia between dt_inicial_p and dt_fim_p
		and	pls_obter_se_benef_remido(a.nr_seq_segurado,clock_timestamp()) = 'N';
	end if;	
end if;

if (vl_resultado_receita_w = 0) and (vl_resultado_despesa_w > 0) then
	tx_sinistralidade_w	:= 100;
elsif (vl_resultado_receita_w > 0) and (vl_resultado_despesa_w = 0) then
	tx_sinistralidade_w	:= 0;
end if;

tx_sinistralidade_p	:= coalesce(tx_sinistralidade_w,0);
tx_resultado_p		:= coalesce(tx_resultado_w,0);
vl_receita_p		:= coalesce(vl_resultado_receita_w,0);
vl_custo_p		:= coalesce(vl_resultado_despesa_w,0);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ar_gerar_resultado_pck.obter_sinistralidade ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_contrato_principal_p pls_contrato.nr_contrato_principal%type, nr_seq_grupo_relac_p pls_grupo_contrato.nr_sequencia%type, nr_seq_canal_venda_p pls_vendedor.nr_sequencia%type, dt_inicial_p timestamp, dt_fim_p timestamp, ie_remido_sinist_reaj_p pls_parametros.ie_remido_sinistralidade_reaj%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, tx_sinistralidade_p INOUT bigint, tx_resultado_p INOUT bigint, vl_receita_p INOUT bigint, vl_custo_p INOUT bigint) FROM PUBLIC;