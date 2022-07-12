-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*
Padrão para passagem de parâmetros extra (ds_param_extra_processo_p) :
	processo=14,ie_opcao_a=X,ie_opcao_b=1;processo=17,ie_opcao_d=12/12/2014,ie_opcao_b=9
No caso acima, serão passados padrões extra para os processos 14 e 17
*/
CREATE OR REPLACE PROCEDURE pls_cta_processo_pck.executa_processo ( nr_seq_lote_conta_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, ds_lista_processo_p pls_cta_log_exec.ds_lista_processo%type, ds_param_extra_processo_p pls_cta_log_exec.ds_param_extra_processo%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_log_exec_p INOUT pls_cta_log_exec.nr_sequencia%type) AS $body$
DECLARE


cd_processo_w		pls_cta_processo.cd_processo%type;
nm_processo_w		pls_cta_processo.nm_processo%type;
nr_seq_log_exec_desc_w	pls_cta_log_exec_desc.nr_sequencia%type;



c_processo CURSOR(ds_lista_processo_pc text) FOR
	SELECT	a.nr_sequencia,
		a.cd_processo,
		a.nr_ordem, a.nm_processo
	from	pls_cta_processo  a
	where  	a.cd_processo in (SELECT	x.nr_valor_number
				  from		table(pls_util_pck.converter_lista_valores(ds_lista_processo_pc, ',')) x)
	and	a.ie_situacao = 'A'
	-- para não pegar os processos pai, que são usados como agrupadores
	and	(a.nr_seq_processo_pai IS NOT NULL AND a.nr_seq_processo_pai::text <> '')
	order by a.nr_ordem;

BEGIN

-- grava os dados pertinentes ao início do processo e retorna o sequencial criado para a variável nr_seq_log_exec_p
nr_seq_log_exec_p := pls_cta_processo_pck.registra_processo(	nr_seq_lote_conta_p, nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_proc_partic_p, nr_seq_conta_mat_p, cd_acao_analise_p, ds_lista_processo_p, ds_param_extra_processo_p, nm_usuario_p, cd_estabelecimento_p, 'INICIO_PROCESSO', nr_seq_analise_p, nr_seq_log_exec_p);

begin

	-- busca os processos que foram solicitados para a execução
	for r_c_processo_w in c_processo(ds_lista_processo_p) loop

		-- essas variáveis foram criadas apenas para poder passar de parâmetro para a procedure que trata exceções
		cd_processo_w := r_c_processo_w.cd_processo;
		nm_processo_w := r_c_processo_w.nm_processo;

		-- registra o início de execução do processo
		nr_seq_log_exec_desc_w := pls_cta_processo_pck.registra_processo_detalhe(	nr_seq_log_exec_p, cd_processo_w, 'INICIO_PROCESSO', nm_usuario_p, nr_seq_log_exec_desc_w);


		-- executa o processo em questão de acordo com as suas particularidades
		CALL pls_cta_processo_pck.gerencia_chamada_processo(	nr_seq_lote_conta_p, nr_seq_protocolo_p, nr_seq_lote_processo_p,
						nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_proc_partic_p,
						nr_seq_conta_mat_p, cd_acao_analise_p, cd_processo_w,
						ds_param_extra_processo_p, nm_usuario_p, cd_estabelecimento_p,
						nr_seq_analise_p);

		-- registra a data de fim de execução do processo
		nr_seq_log_exec_desc_w := pls_cta_processo_pck.registra_processo_detalhe(	null, null, 'FIM_PROCESSO', nm_usuario_p, nr_seq_log_exec_desc_w);
	end loop;

exception
when others then
	-- registro o erro
	CALL pls_cta_processo_pck.trata_erro_processo(	nr_seq_log_exec_p, cd_processo_w, nm_processo_w, nm_usuario_p);
end;

-- atualiza a data de fim do processo
nr_seq_log_exec_p := pls_cta_processo_pck.registra_processo(	null, null, null, null, null, null, null, null, null, null, nm_usuario_p, cd_estabelecimento_p, 'FIM_PROCESSO', null, nr_seq_log_exec_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_processo_pck.executa_processo ( nr_seq_lote_conta_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, ds_lista_processo_p pls_cta_log_exec.ds_lista_processo%type, ds_param_extra_processo_p pls_cta_log_exec.ds_param_extra_processo%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_log_exec_p INOUT pls_cta_log_exec.nr_sequencia%type) FROM PUBLIC;