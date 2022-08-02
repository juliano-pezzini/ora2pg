-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_ret_monitor ( cd_ans_p text, cd_versao_tiss_p text, dt_geracao_lote_p timestamp, dt_mes_competencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, nr_lote_p text, cd_glosa_p text, nm_arquivo_p text, qt_incluido_p bigint, qt_alterado_p bigint, qt_erros_p bigint, qt_excluido_p bigint, nr_seq_lote_monitor_ret_p INOUT text) AS $body$
DECLARE

					 
nr_seq_guia_ret_w 		pls_monitor_tiss_guia_ret.nr_sequencia%type;

BEGIN
 
nr_seq_guia_ret_w := PLS_GERENCIA_ENVIO_ANS_PCK.GERAR_LOTE_RET_MONITOR( 	cd_ans_p, cd_versao_tiss_p, dt_geracao_lote_p, dt_mes_competencia_p, nm_usuario_p, cd_estabelecimento_p, nr_lote_p, cd_glosa_p, nm_arquivo_p, qt_incluido_p, qt_alterado_p, qt_erros_p, qt_excluido_p, nr_seq_guia_ret_w);
 
nr_seq_lote_monitor_ret_p := nr_seq_guia_ret_w;
--commit; 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_ret_monitor ( cd_ans_p text, cd_versao_tiss_p text, dt_geracao_lote_p timestamp, dt_mes_competencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, nr_lote_p text, cd_glosa_p text, nm_arquivo_p text, qt_incluido_p bigint, qt_alterado_p bigint, qt_erros_p bigint, qt_excluido_p bigint, nr_seq_lote_monitor_ret_p INOUT text) FROM PUBLIC;

