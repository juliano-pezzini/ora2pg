-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_programacao_reajuste_pck.alterar_periodo_analise ( nr_seq_programacao_p pls_prog_reaj_coletivo.nr_sequencia%type, dt_inicio_analise_p timestamp, dt_fim_analise_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

nr_seq_contrato_w	pls_prog_reaj_coletivo.nr_seq_contrato%type;
nr_seq_grupo_relac_w	pls_prog_reaj_coletivo.nr_seq_grupo_relac%type;
tx_sinistralidade_w	pls_prog_reaj_coletivo.tx_sinistralidade%type;
vl_receita_w		pls_prog_reaj_coletivo.vl_receita%type;
vl_custo_w		pls_prog_reaj_coletivo.vl_despesas%type;
tx_resultado_w		pls_prog_reaj_coletivo.tx_resultado_grupo%type;

tx_sinistralidade_grupo_w pls_prog_reaj_coletivo.tx_sinistralidade_grupo%type;
vl_receita_grupo_w	pls_prog_reaj_coletivo.vl_receita_grupo%type;
vl_custo_grupo_w	pls_prog_reaj_coletivo.vl_despesas_grupo%type;

dt_inicio_analise_w	pls_prog_reaj_coletivo.dt_inicio_analise%type;
dt_fim_analise_w	pls_prog_reaj_coletivo.dt_fim_analise%type;
ds_historico_w		varchar(4000);


BEGIN
if (dt_inicio_analise_p IS NOT NULL AND dt_inicio_analise_p::text <> '') and (dt_fim_analise_p IS NOT NULL AND dt_fim_analise_p::text <> '') then
	select	nr_seq_contrato,
		nr_seq_grupo_relac,
		dt_inicio_analise,
		dt_fim_analise
	into STRICT	nr_seq_contrato_w,
		nr_seq_grupo_relac_w,
		dt_inicio_analise_w,
		dt_fim_analise_w
	from	pls_prog_reaj_coletivo
	where	nr_sequencia	= nr_seq_programacao_p;
	
	SELECT * FROM pls_ar_gerar_resultado_pck.obter_sinistralidade(nr_seq_contrato_w, null, null, null, dt_inicio_analise_p, dt_fim_analise_p, null, cd_estabelecimento_p, tx_sinistralidade_w, tx_resultado_w, vl_receita_w, vl_custo_w) INTO STRICT tx_sinistralidade_w, tx_resultado_w, vl_receita_w, vl_custo_w;
	
	SELECT * FROM pls_ar_gerar_resultado_pck.obter_sinistralidade(null, null, nr_seq_grupo_relac_w, null, dt_inicio_analise_p, dt_fim_analise_p, null, cd_estabelecimento_p, tx_sinistralidade_grupo_w, tx_resultado_w, vl_receita_grupo_w, vl_custo_grupo_w) INTO STRICT tx_sinistralidade_grupo_w, tx_resultado_w, vl_receita_grupo_w, vl_custo_grupo_w;
	
	update	pls_prog_reaj_coletivo
	set	tx_sinistralidade	= tx_sinistralidade_w,
		vl_receita		= vl_receita_w,
		vl_despesas		= vl_custo_w,
		tx_sinistralidade_grupo	= tx_sinistralidade_grupo_w,
		vl_receita_grupo	= vl_receita_grupo_w,
		vl_despesas_grupo	= vl_custo_grupo_w,
		dt_inicio_analise	= dt_inicio_analise_p,
		dt_fim_analise		= dt_fim_analise_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_programacao_p;
	
	ds_historico_w	:= wheb_mensagem_pck.get_texto(1127854,'DT_INICIO=' || to_char(dt_inicio_analise_p,'dd/mm/yyyy') || ';DT_FIM=' || to_char(dt_fim_analise_p,'dd/mm/yyyy') ||
				    ';DT_INICIO_ANT=' || to_char(dt_inicio_analise_w,'dd/mm/yyyy') || ';DT_FIM_ANT=' || to_char(dt_fim_analise_w,'dd/mm/yyyy'));
	CALL pls_programacao_reajuste_pck.gravar_historico_sistema(nr_seq_programacao_p,ds_historico_w,nm_usuario_p,cd_estabelecimento_p);
	
	commit;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_programacao_reajuste_pck.alterar_periodo_analise ( nr_seq_programacao_p pls_prog_reaj_coletivo.nr_sequencia%type, dt_inicio_analise_p timestamp, dt_fim_analise_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;