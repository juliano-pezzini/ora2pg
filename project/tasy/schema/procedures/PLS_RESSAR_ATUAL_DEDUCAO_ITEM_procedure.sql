-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ressar_atual_deducao_item (nr_seq_processo_p pls_processo_procedimento.nr_sequencia%type, pr_deducao_p pls_processo_procedimento.pr_deducao%type, nr_seq_conta_pedido_p pls_proc_conta_pedido.nr_sequencia%type, ie_opcao_p text, vl_ressarcido_p INOUT pls_processo_procedimento.vl_ressarcido%type) AS $body$
DECLARE

/*
ie_opcao_p
	AM - Ação de menu 'Informar dedução do item' da pasta 'Ressarcimento > Contas > Conta > Procedimento'
	APIA - 'AfterPost' da pasta 'Ressarcimento > Contas > Impugnação'
	APIN - 'AfterPost' da pasta 'Ressarcimento > Contas > Impugnação (Nova)'
*/
nr_seq_conta_w		pls_processo_conta.nr_sequencia%type;
vl_ressarcido_w		pls_processo_procedimento.vl_ressarcido%type;


BEGIN
if	(ie_opcao_p = 'AM') then -- ie_opcao_p = AM - Ação de menu 'Informar dedução do item' da pasta 'Ressarcimento > Contas > Conta > Procedimento'
	update	pls_processo_procedimento
	set	pr_deducao = pr_deducao_p,
		vl_ressarcido = vl_procedimento - ((vl_procedimento / 100) * pr_deducao_p)
	where	nr_sequencia = nr_seq_processo_p;

	select	max(nr_seq_conta)
	into STRICT	nr_seq_conta_w
	from	pls_processo_procedimento
	where	nr_sequencia = nr_seq_processo_p;

	select	coalesce(sum(vl_ressarcido),0)
	into STRICT	vl_ressarcido_w
	from	pls_processo_procedimento
	where	nr_seq_conta = nr_seq_conta_w;

	update	pls_proc_conta_pedido
	set	vl_pedido = vl_ressarcido_w
	where	/*ie_tipo_pedido in ('R','RA') -- "R = Retificação do valor a ser ressarcido" ou "RA = Anulação da identificação ou subsidiariamente a retificação do valor a ser ressarcido"
	and	*/
nr_seq_proc_conta = nr_seq_conta_w;

	update	pls_formulario
	set	vl_pedido = vl_ressarcido_w
	where	/*ie_tipo_pedido in ('R','RA') -- "R = Retificação do valor a ser ressarcido" ou "RA = Anulação da identificação ou subsidiariamente a retificação do valor a ser ressarcido"
	and	*/
nr_seq_conta = nr_seq_conta_w;

	commit;

elsif	(ie_opcao_p = 'APIA') then -- ie_opcao_p = "APIA - 'AfterPost' da pasta 'Ressarcimento > Contas > Impugnação'"
	select	max(nr_seq_proc_conta)
	into STRICT	nr_seq_conta_w
	from	pls_proc_conta_pedido
	where	nr_sequencia = nr_seq_conta_pedido_p;

	select	coalesce(sum(vl_ressarcido),0)
	into STRICT	vl_ressarcido_w
	from	pls_processo_procedimento
	where	nr_seq_conta = nr_seq_conta_w;

	vl_ressarcido_p := vl_ressarcido_w;

elsif	(ie_opcao_p = 'APIN') then -- ie_opcao_p = "APIN - 'AfterPost' da pasta 'Ressarcimento > Contas > Impugnação (Nova)'"
	select	max(nr_seq_conta)
	into STRICT	nr_seq_conta_w
	from	pls_formulario
	where	nr_sequencia = nr_seq_conta_pedido_p;

	select	coalesce(sum(vl_ressarcido),0)
	into STRICT	vl_ressarcido_w
	from	pls_processo_procedimento
	where	nr_seq_conta = nr_seq_conta_w;

	vl_ressarcido_p := vl_ressarcido_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ressar_atual_deducao_item (nr_seq_processo_p pls_processo_procedimento.nr_sequencia%type, pr_deducao_p pls_processo_procedimento.pr_deducao%type, nr_seq_conta_pedido_p pls_proc_conta_pedido.nr_sequencia%type, ie_opcao_p text, vl_ressarcido_p INOUT pls_processo_procedimento.vl_ressarcido%type) FROM PUBLIC;
