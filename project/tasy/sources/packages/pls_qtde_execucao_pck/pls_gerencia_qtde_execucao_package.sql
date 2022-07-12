-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_qtde_execucao_pck.pls_gerencia_qtde_execucao ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, nr_seq_analise_P pls_conta.nr_seq_analise%type, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote_conta%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE



dados_conta_w			pls_via_acesso_pck.dados_conta;
dados_conta_proc_w		pls_via_acesso_pck.dados_conta_proc;
ie_recalcula_valorizacao_w	varchar(1);

--Cursor para varer por estrutura e não mais a nível de conta
C03 CURSOR(	nr_seq_conta_pc		pls_conta.nr_sequencia%type,
		nr_seq_analise_pc	pls_conta.nr_seq_analise%type,
		nr_seq_lote_conta_pc	pls_protocolo_conta.nr_seq_lote_conta%type)FOR
	SELECT	nr_seq_conta_princ
	from	pls_conta_v
	where	nr_sequencia	=  nr_seq_conta_pc
	and	ie_status	!= 'C'
	
union all

	SELECT	nr_seq_conta_princ
	from	pls_conta_v
	where	nr_seq_analise	= nr_seq_analise_pc
	and	ie_status	!= 'C'
	group by nr_seq_conta_princ
	
union all

	select	nr_seq_conta_princ
	from	pls_conta_v
	where	nr_seq_lote_conta	= nr_seq_lote_conta_pc
	and	ie_status	!= 'C'
	group by nr_seq_conta_princ;
BEGIN
-- são ações que acontecem dentro da análise de contas médicas
if (cd_acao_analise_p in (1, 2, 3, 4, 5)) then
	ie_recalcula_valorizacao_w := 'S';
else
	ie_recalcula_valorizacao_w := 'N';
end if;

for r_c03_w in C03(nr_seq_conta_p, nr_seq_analise_p, nr_seq_lote_conta_p ) loop
	begin
	--Busca apenas os dados genéricos da conta que serão comuns para todas as contas do atendimento
        select	a.cd_guia_referencia,
		a.cd_guia,
		a.nr_seq_segurado,
		a.ie_origem_conta,
		a.nr_seq_analise,
		a.nr_sequencia,
		a.nr_seq_grau_partic,
		a.nr_seq_prestador_exec
	into STRICT	dados_conta_w.cd_guia_referencia,
		dados_conta_w.cd_guia,
		dados_conta_w.nr_seq_segurado,
		dados_conta_w.ie_origem_conta,
		dados_conta_w.nr_seq_analise,
		dados_conta_w.nr_seq_conta,
		dados_conta_w.nr_seq_grau_partic,
		dados_conta_w.nr_seq_prestador
	from	pls_conta_v		a
	where	a.nr_sequencia	= r_c03_w.nr_seq_conta_princ;

	--Irá aplicar	 a quantidade de execução caso exista regra para a mesma em OPS - Regras e Critérios de Preço > Regras > Quantidade de execução > Simultâneo\Concorrente
	--Conforme o parametro ie_recalcula_valorizacao_w o cursor 2 será executado sobre a conta quando da consistência da mesma ou se a atualização irá ocorrer sobre toda a análise
	dados_conta_w.cd_medico_executor	:= null;
	CALL pls_qtde_execucao_pck.pls_aplicar_qtde_execucao(dados_conta_w, nm_usuario_p, cd_estabelecimento_P);

	end;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_qtde_execucao_pck.pls_gerencia_qtde_execucao ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, nr_seq_analise_P pls_conta.nr_seq_analise%type, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote_conta%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;