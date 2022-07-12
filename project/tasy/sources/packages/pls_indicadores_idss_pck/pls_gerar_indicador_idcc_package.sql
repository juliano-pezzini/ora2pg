-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*-----------------------------------------------------------------Indicadores - IDCC---------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE pls_indicadores_idss_pck.pls_gerar_indicador_idcc ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

	if (cd_indicador_p = 'IDCC1') then -- Margem de Lucro Líquida (MLL)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_mll( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC2') then -- Retorno sobre o Patrimônio Líquido (ROE)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_roe( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC3') then -- Percentual de Despesas Assistenciais em relação às Receitas de Contraprestações (DM)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_dm( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC4') then -- Percentual de Despesas Administrativas em relação às Receitas de Contraprestações (DA)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_da( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC5') then -- Percentual de Despesa Comercial em relação à Receita de Contraprestações (DC)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_dc( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC6') then -- Percentual de Despesas Operacionais em relação às Receitas Operacionais
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_do( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC7') then -- Índice de Resultado Financeiro (IRF)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_irf( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC8') then -- Liquidez Corrente (LC)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_lc( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC9') then -- Capital de terceiros sobre o Capital próprio (CT/CP)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_ctcp( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC10') then -- Prazo Médio de Recebimento de Contraprestações (PMRC)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_pmrc( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDCC11') then -- Prazo Médio de Pagamento de Eventos (PMPE)
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_pmpe( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (coalesce(cd_indicador_p,'0') = '0') then -- Caso não selecionou nenhum Indicador
			CALL pls_indicadores_idss_pck.pls_gerar_indicador_full( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_indicadores_idss_pck.pls_gerar_indicador_idcc ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
