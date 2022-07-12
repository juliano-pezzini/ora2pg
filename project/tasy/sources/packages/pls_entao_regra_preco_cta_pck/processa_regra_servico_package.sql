-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_entao_regra_preco_cta_pck.processa_regra_servico ( ie_destino_regra_p text, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
nr_contador_w		integer;
	
tb_nr_seq_conta_proc_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_regra_entao_w	pls_util_cta_pck.t_number_table;
tb_vl_servico_w		pls_util_cta_pck.t_number_table;
tb_vl_ch_honorario_w	pls_util_cta_pck.t_number_table;
	
C01 CURSOR FOR
	SELECT	entao.cd_moeda,
		entao.cd_tabela_servico,
		entao.tx_ajuste,
		coalesce(entao.tx_ajuste_preco, 0) tx_ajuste_preco,
		coalesce(entao.vl_negociado, 0) vl_negociado,
		temp.nr_seq_conta_proc,
		temp.dt_procedimento_referencia,
		temp.ie_origem_proced,
		temp.cd_procedimento,
		temp.nr_seq_cp_comb_proc_entao
	from	pls_cp_cta_proc_tmp temp,
		pls_cp_cta_eserv entao
	where	entao.nr_sequencia = temp.nr_seq_cp_comb_proc_entao;
BEGIN

-- alimenta a tabela temporária com os dados necessários para identificar a regra então e fazer a valorização do item
CALL pls_entao_regra_preco_cta_pck.alimenta_tab_temp_serv(	ie_destino_regra_p, nr_seq_lote_conta_p, nr_seq_protocolo_p,
			nr_seq_lote_processo_p, nr_seq_conta_p, nr_seq_conta_proc_p,
			nr_seq_conta_mat_p, nr_seq_analise_p, cd_acao_analise_p, 
			cd_estabelecimento_p, nm_usuario_p);

-- pega todos os registros que foram inseridos na tabela temporária e 'encontra' o então respectivo
-- após salva o mesmo na tabela temporária
CALL pls_entao_regra_preco_cta_pck.define_regra_entao_serv();

-- faz a limpeza das tabelas de log, deletando todos os logs que existam com as sequencias dos 
-- materiais que foram incluidos na tabela temporária
nr_contador_w := 0;
for r_C01_w in C01 loop

	tb_nr_seq_conta_proc_w(nr_contador_w) := r_c01_w.nr_seq_conta_proc;
	
	-- se atingiu a quantidade faz o delete
	if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then
	
		SELECT * FROM pls_entao_regra_preco_cta_pck.delete_tabela_log_serv(	tb_nr_seq_conta_proc_w, nr_contador_w) INTO STRICT _ora2pg_r;
 	tb_nr_seq_conta_proc_w := _ora2pg_r.tb_nr_seq_conta_proc_p; nr_contador_w := _ora2pg_r.nr_contador_p;
	else
		nr_contador_w := nr_contador_w + 1;
	end if;
end loop;

-- se sobrou algo manda pro banco e limpa as variáveis
SELECT * FROM pls_entao_regra_preco_cta_pck.delete_tabela_log_serv(	tb_nr_seq_conta_proc_w, nr_contador_w) INTO STRICT _ora2pg_r;
 	tb_nr_seq_conta_proc_w := _ora2pg_r.tb_nr_seq_conta_proc_p; nr_contador_w := _ora2pg_r.nr_contador_p;

-- inicia as variáveis
SELECT * FROM pls_entao_regra_preco_cta_pck.atualiza_servico(	ie_destino_regra_p, nr_contador_w, tb_nr_seq_conta_proc_w, tb_nr_seq_regra_entao_w, tb_vl_servico_w, tb_vl_ch_honorario_w) INTO STRICT _ora2pg_r;
 nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_seq_conta_proc_w := _ora2pg_r.tb_nr_seq_conta_proc_p; tb_nr_seq_regra_entao_w := _ora2pg_r.tb_nr_seq_regra_entao_p; tb_vl_servico_w := _ora2pg_r.tb_vl_servico_p; tb_vl_ch_honorario_w := _ora2pg_r.tb_vl_ch_honorario_p;

-- percorre todos os itens com os itens das regras então
for r_C01_w in C01 loop

	tb_nr_seq_conta_proc_w(nr_contador_w) := r_C01_w.nr_seq_conta_proc;
	tb_nr_seq_regra_entao_w(nr_contador_w) := r_C01_w.nr_seq_cp_comb_proc_entao;

	CALL pls_entao_regra_preco_cta_pck.gerencia_log_serv(	'Início da valorização, vinculado ao então de sequencia ' || r_C01_w.nr_seq_cp_comb_proc_entao || '.',
				r_C01_w.nr_seq_conta_proc,
				null,
				ie_destino_regra_p,
				nm_usuario_p);

	-- obtem os valores dos serviços e aplica as taxas necessárias
	SELECT * FROM pls_entao_regra_preco_cta_pck.obter_valores_entao_servico(	ie_destino_regra_p, r_C01_w.cd_moeda, r_C01_w.cd_tabela_servico, r_C01_w.tx_ajuste, r_C01_w.tx_ajuste_preco, r_C01_w.vl_negociado, r_C01_w.dt_procedimento_referencia, r_C01_w.ie_origem_proced, r_C01_w.cd_procedimento, r_C01_w.nr_seq_conta_proc, cd_estabelecimento_p, nm_usuario_p, tb_vl_servico_w(nr_contador_w), tb_vl_ch_honorario_w(nr_contador_w)) INTO STRICT tb_vl_servico_w(nr_contador_w), tb_vl_ch_honorario_w(nr_contador_w);

	CALL pls_entao_regra_preco_cta_pck.gerencia_log_serv(	'Término da valorização.',
				r_C01_w.nr_seq_conta_proc,
				tb_vl_servico_w(nr_contador_w),
				ie_destino_regra_p,
				nm_usuario_p);

	-- se atingiu a quantidade manda pro banco
	if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then

		SELECT * FROM pls_entao_regra_preco_cta_pck.atualiza_servico(	ie_destino_regra_p, nr_contador_w, tb_nr_seq_conta_proc_w, tb_nr_seq_regra_entao_w, tb_vl_servico_w, tb_vl_ch_honorario_w) INTO STRICT _ora2pg_r;
 nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_seq_conta_proc_w := _ora2pg_r.tb_nr_seq_conta_proc_p; tb_nr_seq_regra_entao_w := _ora2pg_r.tb_nr_seq_regra_entao_p; tb_vl_servico_w := _ora2pg_r.tb_vl_servico_p; tb_vl_ch_honorario_w := _ora2pg_r.tb_vl_ch_honorario_p;
	else
		nr_contador_w := nr_contador_w + 1;
	end if;
end loop;

-- se sobrou algo manda pro banco
SELECT * FROM pls_entao_regra_preco_cta_pck.atualiza_servico(	ie_destino_regra_p, nr_contador_w, tb_nr_seq_conta_proc_w, tb_nr_seq_regra_entao_w, tb_vl_servico_w, tb_vl_ch_honorario_w) INTO STRICT _ora2pg_r;
 nr_contador_w := _ora2pg_r.nr_contador_p; tb_nr_seq_conta_proc_w := _ora2pg_r.tb_nr_seq_conta_proc_p; tb_nr_seq_regra_entao_w := _ora2pg_r.tb_nr_seq_regra_entao_p; tb_vl_servico_w := _ora2pg_r.tb_vl_servico_p; tb_vl_ch_honorario_w := _ora2pg_r.tb_vl_ch_honorario_p;

-- atualiza os logs de serviço caso tenha ficado algo sem atualizar
CALL pls_entao_regra_preco_cta_pck.atualizar_log_serv(nm_usuario_p, ie_destino_regra_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_entao_regra_preco_cta_pck.processa_regra_servico ( ie_destino_regra_p text, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
