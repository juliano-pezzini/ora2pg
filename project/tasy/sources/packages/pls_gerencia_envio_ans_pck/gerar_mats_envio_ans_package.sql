-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Procedure utilizada para inserir ou alterar os materiais de uma conta que esta no lote



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.gerar_mats_envio_ans ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


nr_seq_processo_w	pls_monitor_tempo_lote.nr_sequencia%type;

BEGIN


nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Selecionando materiais para o lote', 'I', nm_usuario_p, nr_seq_processo_w);
-- seleciona os procedimentos que sero utilizadas no lote e alimenta os mesmos na tabela pls_monitor_tiss_proc_val

CALL pls_gerencia_envio_ans_pck.selecionar_mat_lote(	nr_seq_lote_p, nm_usuario_p);
nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Removendo itens que correspondem a pacote pelo A500', 'I', nm_usuario_p, nr_seq_processo_w);
-- Removendo itens que correspondem a pacote pelo A500. Itens cujo valor foi apresentado com zero e sao apenas informativos

CALL pls_gerencia_envio_ans_pck.desconsidera_itens_pac_a500( 	nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p, 'M');
nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Populando dados adicionais dos materiais selecionados', 'I', nm_usuario_p, nr_seq_processo_w);
-- popula os dados adicionais dos campos que foram selecionados anteriormente

CALL pls_gerencia_envio_ans_pck.popula_dados_adic_mat_lote( 	nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Populando valores pagos dos fornecedores de materiais selecionados', 'I', nm_usuario_p, nr_seq_processo_w);
-- popula os dados do fornecedor

CALL pls_gerencia_envio_ans_pck.popula_vl_pago_fornec_mat_lote( 	nr_seq_lote_p);
nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Atualiza os valores apresentados pelos valores de recalculo quando o item for de rede prpria', 'I', nm_usuario_p, nr_seq_processo_w);
-- altera o vl_apresentado pelo vl_recalculo da pls_conta_proc_regra na pls_monitor_tiss_proc_val quando for rede propria

CALL pls_gerencia_envio_ans_pck.atualiza_vl_apres_rede_propria( 	nr_seq_lote_p, 'M');
nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Atualiza valores de materiais do recurso de glosa', 'I', nm_usuario_p, nr_seq_processo_w);
-- popula os dados adicionais dos campos que foram selecionados anteriormente

CALL pls_gerencia_envio_ans_pck.atualiza_valor_mat_rec( 	nr_seq_lote_p, nm_usuario_p);
nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Atualiza valores de materiais da discussao da contestao', 'I', nm_usuario_p, nr_seq_processo_w);
-- popula os dados adicionais dos campos que foram selecionados anteriormente

CALL pls_gerencia_envio_ans_pck.atualiza_valor_mat_disc( 	nr_seq_lote_p, nm_usuario_p);
nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.gerar_mats_envio_ans ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
