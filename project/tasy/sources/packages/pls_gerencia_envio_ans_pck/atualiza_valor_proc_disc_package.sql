-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Procedure utilizada para atualizar os valores de procedimentos da discussao da contestao



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.atualiza_valor_proc_disc ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_pago_w		pls_monitor_tiss_proc_val.qt_liberado%type;
vl_recursado_w		pls_discussao_proc.vl_contestado%type;
vl_pago_w		pls_discussao_proc.vl_aceito%type;
vl_glosa_w		pls_discussao_proc.vl_negado%type;
nr_index_w		integer;
dados_proc_update_w	pls_gerencia_envio_ans_pck.dados_monitor_proc_update;

C01 CURSOR( nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type)FOR
	SELECT	a.nr_sequencia nr_seq_proc_val,
		b.dt_pagamento_recurso,
		a.nr_seq_conta_proc,
		a.nr_seq_disc_proc,
		a.nr_seq_conta_disc,
		b.nr_seq_conta
	from	pls_monitor_tiss_proc_val a,
		pls_monitor_tiss_cta_val b
	where	b.nr_sequencia 		= a.nr_seq_cta_val
	and	(a.nr_seq_disc_proc IS NOT NULL AND a.nr_seq_disc_proc::text <> '')
	and	b.nr_seq_lote_monitor 	= nr_seq_lote_pc;
BEGIN
--Inicia o contador

nr_index_w := 0;
--Abre o cursor de itens que so de discusso de contestao

for r_C01_w in C01(nr_seq_lote_p) loop
	--Sobteno dos valores de pagamento


	select	coalesce(a.vl_aceito,0),
		coalesce(a.vl_negado,0),
		coalesce(a.vl_contestado,0)
	into STRICT	vl_pago_w,
		vl_glosa_w,
		vl_recursado_w
	from	pls_discussao_proc	a
	where	a.nr_sequencia = r_c01_w.nr_seq_disc_proc;


	--Caso o valor pago for maior que zero o valor liberado ser fixo 1

	if (vl_pago_w > 0) then
		qt_pago_w := 1;
	else
		qt_pago_w := 0;
	end if;

	--Insere os dados no record para depois fazer o update

	dados_proc_update_w.nr_sequencia(nr_index_w)		:= r_C01_w.nr_seq_proc_val;
	dados_proc_update_w.qt_liberado(nr_index_w)		:= qt_pago_w;
	dados_proc_update_w.vl_procedimento(nr_index_w)		:= coalesce(vl_recursado_w,0);
	dados_proc_update_w.qt_procedimento(nr_index_w)		:= 1;
	dados_proc_update_w.vl_liberado(nr_index_w)		:= vl_pago_w;
	dados_proc_update_w.vl_glosa(nr_index_w)		:= vl_glosa_w;

	--Caso tenha alcanado a quantidade de registros, chama a procedure para realizar o forall e limpa as variveis

	--Caso no, incrementa o contador

	if (nr_index_w >= pls_util_pck.qt_registro_transacao_w) then
		CALL pls_gerencia_envio_ans_pck.atualizar_monit_tiss_proc_disc(dados_proc_update_w, nm_usuario_p);

		dados_proc_update_w := pls_gerencia_envio_ans_pck.limpar_type_dados_proc_update(dados_proc_update_w);

		nr_index_w := 0;
	else
		nr_index_w := nr_index_w + 1;
	end if;
end loop;
--Chama a procedure que realiza o forall pois caso enha restado algum registro ir fazer o update

CALL pls_gerencia_envio_ans_pck.atualizar_monit_tiss_proc_disc(dados_proc_update_w, nm_usuario_p);
--Limpa o record de update

dados_proc_update_w := pls_gerencia_envio_ans_pck.limpar_type_dados_proc_update(dados_proc_update_w);


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.atualiza_valor_proc_disc ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;