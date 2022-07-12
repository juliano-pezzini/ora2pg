-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_indicadores_idss_pck.pls_indic_tx_exam_hemog_glic ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

	PERFORM set_config('pls_indicadores_idss_pck.vl_total_w', pls_indicadores_idss_pck.pls_indic_soma_num_den(cd_grupo_p, cd_indicador_p, dt_referencia_p, cd_estabelecimento_p, 'QT_MEDIA', 'A', 'HG'), false);

	insert into pls_indic_dados(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_grupo,
					cd_indicador,
					dt_competencia,
					vl_indicador)
			values (nextval('pls_indic_dados_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_grupo_p,
					cd_indicador_p,
					dt_referencia_p,
					current_setting('pls_indicadores_idss_pck.vl_total_w')::bigint);

	commit;

	PERFORM set_config('pls_indicadores_idss_pck.vl_div_w', 0, false);
	PERFORM set_config('pls_indicadores_idss_pck.vl_total_w', 0, false);

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_indicadores_idss_pck.pls_indic_tx_exam_hemog_glic ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
