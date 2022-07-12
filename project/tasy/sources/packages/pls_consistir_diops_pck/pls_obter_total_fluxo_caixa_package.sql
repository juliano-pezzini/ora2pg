-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_consistir_diops_pck.pls_obter_total_fluxo_caixa ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint, vl_operacional_p INOUT bigint, vl_investimento_p INOUT bigint, vl_financiamento_p INOUT bigint) AS $body$
BEGIN
	
	select	sum(coalesce(CASE WHEN a.ie_tipo_atividade='O' THEN a.vl_fluxo  ELSE 0 END ,0) * CASE WHEN a.ie_acao_conta='SB' THEN -1  ELSE 1 END ) vl_operacional,
		sum(coalesce(CASE WHEN a.ie_tipo_atividade='I' THEN a.vl_fluxo  ELSE 0 END ,0) * CASE WHEN a.ie_acao_conta='SB' THEN -1  ELSE 1 END ) vl_investimento,
		sum(coalesce(CASE WHEN a.ie_tipo_atividade='F' THEN a.vl_fluxo  ELSE 0 END ,0) * CASE WHEN a.ie_acao_conta='SB' THEN -1  ELSE 1 END ) vl_financiamento
	into STRICT	vl_operacional_p,
		vl_investimento_p,
		vl_financiamento_p
	from	diops_fin_fluxo_caixa a
	where	a.nr_seq_periodo	= nr_seq_periodo_p;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_diops_pck.pls_obter_total_fluxo_caixa ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint, vl_operacional_p INOUT bigint, vl_investimento_p INOUT bigint, vl_financiamento_p INOUT bigint) FROM PUBLIC;