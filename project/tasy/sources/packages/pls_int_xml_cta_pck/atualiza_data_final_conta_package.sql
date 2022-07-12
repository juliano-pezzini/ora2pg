-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_int_xml_cta_pck.atualiza_data_final_conta ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;

C01 CURSOR(nr_seq_lote_protocolo_pc pls_lote_protocolo_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_protocolo_conta b,
		pls_conta a
	where	b.nr_seq_lote_conta	= nr_seq_lote_protocolo_pc
	and	a.nr_seq_protocolo	= b.nr_sequencia;


BEGIN

open C01(nr_seq_lote_protocolo_p);
loop
	fetch C01 bulk collect into 	tb_nr_sequencia_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_sequencia_w.count = 0;
	
	forall i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last
		update	pls_conta
		set	dt_fim_geracao_conta	= clock_timestamp(),
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= tb_nr_sequencia_w(i);
	commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_int_xml_cta_pck.atualiza_data_final_conta ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
