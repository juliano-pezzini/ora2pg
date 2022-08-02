-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aceitar_valor_selec ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, ie_origem_p text, ie_opcao_p text, ie_tipo_valor_p text, nr_seq_grupo_atual_p pls_grupo_auditor.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/*Está rotina tem como fim buscar os itens selecionados da análise de contas médicas 
e atualizar o valor conforme o parâmetro passado para rotina 
 
ie_tipo_valor_p = 'A' aceita o valor apresentado 
ie_tipo_valor_p = 'P' aceita o valor processado 
ie_tipo_valor_p = 'M' aceita o melhor valor */
 
 
nr_seq_conta_w		pls_conta.nr_sequencia%type;
nr_seq_conta_proc_w	pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_w	pls_conta_mat.nr_sequencia%type;

/*buscar todos os itens selecionados na análise*/
	 
C01 CURSOR(nr_seq_analise_pw	pls_analise_conta.nr_sequencia%type) FOR 
	SELECT	a.nr_seq_w_item 
	from	w_pls_analise_selecao_item a 
	where	a.nr_seq_analise	= nr_seq_analise_pw 
	and	a.nm_usuario		= nm_usuario_p;

BEGIN 
 
for r_C01 in C01(nr_seq_analise_p) loop 
	begin 
	select	a.nr_seq_conta, 
		a.nr_seq_conta_proc, 
		a.nr_seq_conta_mat 
	into STRICT	nr_seq_conta_w, 
		nr_seq_conta_proc_w, 
		nr_seq_conta_mat_w 
	from	w_pls_analise_item a 
	where	a.nr_sequencia	= r_C01.nr_seq_w_item;
	exception 
	when others then 
		nr_seq_conta_w		:= null;
		nr_seq_conta_proc_w	:= null;
		nr_seq_conta_mat_w	:= null;
	end;
	 
	/*Tratamento para passar somente a sequencia específica*/
 
	if (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '')	then 
		nr_seq_conta_mat_w	:= null;
		nr_seq_conta_w		:= null;
	elsif (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '')	then 
		nr_seq_conta_proc_w	:= null;
		nr_seq_conta_w		:= null;
	end if;
 
	if ((nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') or 
		 (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') or 
		 (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> ''))	then 
		/*Chamada da rotina de aceitar o valor.*/
 
		CALL pls_conta_aceitar_valor(nr_seq_conta_w, nr_seq_conta_proc_w, nr_seq_conta_mat_w, 
					ie_opcao_p, ie_tipo_valor_p,cd_estabelecimento_p, 
					ie_origem_p, nm_usuario_p,nr_seq_analise_p, 
					nr_seq_grupo_atual_p);
	end if;
end loop;
 
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aceitar_valor_selec ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, ie_origem_p text, ie_opcao_p text, ie_tipo_valor_p text, nr_seq_grupo_atual_p pls_grupo_auditor.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

