-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/*-----------------------------------------------------------------Indicadores - IDGA---------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE pls_indicadores_idss_pck.pls_gerar_indicador_idga ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

	if (cd_indicador_p = 'IDGA1') then -- Taxa de Sessões de Hemodiálise Crônica por Beneficiário
			CALL pls_indicadores_idss_pck.pls_indic_sessao_hemod_croni( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDGA2') then -- Taxa de Consultas Médicas Ambulatoriais com Generalista por Idosos
			CALL pls_indicadores_idss_pck.pls_indic_tx_cons_medic_ambu( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDGA4') then -- Taxa de Primeira Consulta ao Dentista no ano por Beneficiário
			CALL pls_indicadores_idss_pck.pls_indic_prim_cons_dentista( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (cd_indicador_p = 'IDGA8') then -- Índice de efetiva comercialização de planos individuais (BÔNUS até 10%)
			CALL pls_indicadores_idss_pck.pls_obter_ind_efetiva_comerc( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	elsif (coalesce(cd_indicador_p,'0') = '0') then -- Caso não selecionou nenhum Indicador
			CALL pls_indicadores_idss_pck.pls_gerar_indc_idga_full( cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, nm_usuario_p);
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_indicadores_idss_pck.pls_gerar_indicador_idga ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;