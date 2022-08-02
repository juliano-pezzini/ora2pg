-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_pp_cta_gerar_lote_pag ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 
nr_seq_log_etapa_w	pls_pp_lote_log_etapa.nr_sequencia%type;
ds_stack_w  		varchar(4000);
ds_msg_processo_w	varchar(2000);


BEGIN 
 
begin 
	-- coloca com status em processamento 
	CALL pls_pp_lote_pagamento_pck.atualiza_dados_trabalho_lote(	nr_seq_lote_p, nm_usuario_p);
 
	-- Faz o carregamento de parâmetros gerais e armazena em variáveis globais da package pls_pp_lote_pagamento_pck 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(391541); -- Lendo parâmetros de configuração 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lote_pagamento_pck.carrega_parametros(nr_seq_lote_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz algumas verificações quanto a poder realizar a geração do lote 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(391542); -- Validando se o lote pode ser gerado 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lote_pagamento_pck.valida_se_pode_gerar_lote(nr_seq_lote_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- alimenta a tabela temporária pls_pp_prestador_tmp com todos os prestadores da base e seus 
	-- respectivos dados complementares (matriz, situação cooperado, etc.) 
	-- a idéia é utilizar esta tabela em vários processos futuros dentro da geração do lote 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(391545); -- Selecionando os prestadores que poderão fazer parte do lote 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lote_pagamento_pck.alimenta_prestadores_tab_temp(pls_pp_lote_pagamento_pck.dt_referencia_lote_fim_w);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz a seleção de todas as contas/itens que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(391546); -- Selecionando a produção médica dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_filtro_prod_medica_pck.gerencia_selecao_prod_medica(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz a seleção de todas as contas/itens do recurso de glosa que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(459146); -- Selecionando os recursos de glosa dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_filtro_rec_glosa_pck.gerencia_selecao_rec_glosa(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- armazena todos os prestadores/eventos que podem fazer parte do lote na tabela pls_pp_lote_prest_event 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(441498); -- Selecionando prestadores e eventos que podem fazer parte do lote 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_filtro_ocor_fin_pck.gerencia_selecao_ocor_fin(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz a seleção de todos os lançamentos programados de provento com valor fixo que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(397930); -- Selecionando os lançamentos programados de provento com valor fixo dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lanc_programado_pck.gerar_lancamento_programado(nr_seq_lote_p, 'P', 'FIXO', 'N', nm_usuario_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz a seleção de todos os adiantamentos pagos que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(415702); -- Selecionando os adiantamentos pagos dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_tit_pag_rec_pck.gerencia_adiantamento_pago(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	 
	-- Faz a seleção de todos os descontos de discussão dos prestadores e periodo do pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(990374); -- Selecionando os descontos de discussão 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_desc_const_disc_pck.gerencia_eventos_desc_disc(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	 
	 
	-- Faz a seleção de todos os títulos a pagar que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(440699); -- Selecionando os títulos a pagar dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_tit_pag_rec_pck.gerencia_titulo_pagar(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz a seleção de todos os títulos a receber que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(442082); -- Selecionando os títulos a receber dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_tit_pag_rec_pck.gerencia_titulo_receber(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Processamento de dados de lotes de retenção anteriores 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(456824); -- Verificando se existem valores pendentes no lote de fechamento 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lote_retencao_pck.gerar_valores_retencao_pgto(nr_seq_lote_p, nm_usuario_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz a seleção de todos os lançamentos programados de provento com valor por regra que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(398012); -- Selecionando os lançamentos programados de provento com valor por regra dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lanc_programado_pck.gerar_lancamento_programado(nr_seq_lote_p, 'P', 'REGRA', 'N', nm_usuario_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz a seleção de todos os lançamentos programados de desconto com valor fixo que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(398014); -- Selecionando os lançamentos programados de desconto com valor fixo dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lanc_programado_pck.gerar_lancamento_programado(nr_seq_lote_p, 'D', 'FIXO', 'N', nm_usuario_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz a seleção de todos os lançamentos programados de desconto com valor por regra que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(398013); -- Selecionando os lançamentos programados de desconto com valor por regra dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lanc_programado_pck.gerar_lancamento_programado(nr_seq_lote_p, 'D', 'REGRA', 'N', nm_usuario_p, cd_estabelecimento_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz a seleção dos eventos de apropriação conforme os filtros cadastrados no período 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(452342); -- Selecionando os registros de apropriação para este pagamento 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_apropriacao_pck.gerencia_selecao_apropriacao(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz um agrupamento por evento e prestador de todas as contas/itens que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(393061); -- Finalizando agrupamento de eventos dos prestadores 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lote_pagamento_pck.gerar_prestador_evento_lote(nr_seq_lote_p, nm_usuario_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Faz um agrupamento por prestador de todas as contas/itens que devem fazer parte do lote de pagamento de produção 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(393062); -- Finalizando agrupando de prestadores do lote 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lote_pagamento_pck.gerar_prestador_lote(nr_seq_lote_p, nm_usuario_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
	-- Define o lote de pagamento como gerado 
	ds_msg_processo_w := wheb_mensagem_pck.get_texto(403679); -- Finalizando geração do lote de pagamento 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'I', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p);
	CALL pls_pp_lote_pagamento_pck.atualiza_dados_ger_lote_pgto(nr_seq_lote_p, 'S', nm_usuario_p);
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(null, null, 'F', null, nr_seq_log_etapa_w, 'G', nm_usuario_p);
 
exception 
when others then 
	-- limpa os dados de pagamento 
	-- para gerar novamente só desfazendo a geração do anterior 
	CALL pls_pp_lote_pagamento_pck.atualiza_dados_ger_lote_pgto(nr_seq_lote_p, 'N', nm_usuario_p);
 
	ds_stack_w := dbms_utility.format_call_stack || pls_util_pck.enter_w || 
		   dbms_utility.format_error_backtrace || pls_util_pck.enter_w || 
		   sqlerrm;
	-- grava log se deu erro 
	nr_seq_log_etapa_w := pls_pp_lote_pagamento_pck.grava_tempo_execucao(nr_seq_lote_p, null, 'E', ds_msg_processo_w, nr_seq_log_etapa_w, 'G', nm_usuario_p, ds_stack_w);
end;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_cta_gerar_lote_pag ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

