-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_retencao_pck.gerencia_vinculo_pagamento ( nr_seq_lote_p pls_pp_lr_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_lr_trib_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_vl_trib_w	pls_util_cta_pck.t_number_table;

c01 CURSOR(	nr_seq_lote_pc		pls_pp_lr_lote.nr_sequencia%type,
		dt_competencia_pc	timestamp) FOR
	SELECT	a.nr_sequencia nr_seq_lr_trib_pessoa,
		b.nr_sequencia nr_seq_vl_trib_pessoa
	from	pls_pp_lr_trib_pessoa a,
		pls_pp_valor_trib_pessoa b
	where	a.nr_seq_lote_ret = nr_seq_lote_pc
	and	b.dt_competencia = dt_competencia_pc
	and	b.cd_pessoa_fisica = a.cd_pessoa_fisica
	and	b.cd_tributo = a.cd_tributo;


BEGIN
-- realiza o vínculo entre o registro gerado no lote de fechamento e os registros correspondentes nos
-- lotes de pagamento do mesmo período
open c01(nr_seq_lote_p, current_setting('pls_pp_lote_retencao_pck.dt_mes_competencia_lote_w')::pls_pp_lr_lote.dt_mes_competencia%type);
loop
	fetch c01 bulk collect into tb_nr_seq_lr_trib_w, tb_nr_seq_vl_trib_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_lr_trib_w.count = 0;
	
	forall i in tb_nr_seq_lr_trib_w.first..tb_nr_seq_lr_trib_w.last
		update	pls_pp_valor_trib_pessoa
		set	nr_seq_lr_trib_pessoa = tb_nr_seq_lr_trib_w(i),
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_sequencia = tb_nr_seq_vl_trib_w(i);
	commit;
end loop;
close c01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_retencao_pck.gerencia_vinculo_pagamento ( nr_seq_lote_p pls_pp_lr_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
