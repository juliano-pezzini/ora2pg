-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.atualiza_dados_null ( nr_seq_conta_p pls_conta.nr_sequencia%type) AS $body$
DECLARE


tb_sequencia_w	pls_util_cta_pck.t_number_table;

c01 CURSOR( nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	partic.nr_sequencia
	from	pls_conta_proc_v proc,
		pls_proc_participante partic
	where	proc.nr_seq_conta = nr_seq_conta_pc
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and	coalesce(partic.ie_status::text, '') = '';
	
c02 CURSOR( nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	partic.nr_sequencia
	from	pls_conta_proc_v proc,
		pls_proc_participante partic
	where	proc.nr_seq_conta = nr_seq_conta_pc
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and	coalesce(partic.ie_gerada_cta_honorario::text, '') = '';


BEGIN

-- atualiza os participantes que tenham o status nulo

open C01( nr_seq_conta_p );
loop
	tb_sequencia_w.delete;
	
	fetch C01 bulk collect into tb_sequencia_w
	limit current_setting('pls_cta_consistir_pck.qt_registro_transacao_w')::integer;
	
	exit when tb_sequencia_w.count = 0;
	
	-- manda para o banco

	forall i in tb_sequencia_w.first .. tb_sequencia_w.last
		
		update 	pls_proc_participante set
			ie_status = 'U'
		where 	nr_sequencia = tb_sequencia_w(i);
	commit;
	end loop;
close C01;

-- atualiza os participantes que tenham a informa__o de honor_rio nula

open C02( nr_seq_conta_p );
loop
	tb_sequencia_w.delete;
	
	fetch C02 bulk collect into tb_sequencia_w
	limit current_setting('pls_cta_consistir_pck.qt_registro_transacao_w')::integer;
	
	exit when tb_sequencia_w.count = 0;
	
	-- manda para o banco

	forall i in tb_sequencia_w.first .. tb_sequencia_w.last
		
		update 	pls_proc_participante set
			ie_gerada_cta_honorario = 'N'
		where 	nr_sequencia = tb_sequencia_w(i);
	commit;
	end loop;
close C02;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.atualiza_dados_null ( nr_seq_conta_p pls_conta.nr_sequencia%type) FROM PUBLIC;