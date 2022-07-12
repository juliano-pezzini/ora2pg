-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_int_xml_cta_pck.pls_int_nv_face_dente ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_face_dente_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_item_imp_w	pls_util_cta_pck.t_number_table;
tb_cd_face_dente_w		pls_util_cta_pck.t_varchar2_table_1;
tb_nr_seq_conta_proc_w		pls_util_cta_pck.t_number_table;

C01 CURSOR(nr_seq_lote_protocolo_pc	pls_lote_protocolo_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_face_dente,
		a.nr_seq_conta_item nr_seq_conta_item_imp,
		a.cd_face_dente,
		(SELECT	max(x.nr_sequencia)
		from	pls_conta_proc_imp y,
			pls_conta_proc x
		where	x.nr_seq_imp = y.nr_sequencia
		and	y.nr_seq_item_conta = b.nr_sequencia) nr_seq_conta_proc
	from	pls_protocolo_conta_imp d,
		pls_conta_imp c,
		pls_conta_item_imp b,
		pls_item_face_dente_imp a
	where	d.nr_seq_lote_protocolo	= nr_seq_lote_protocolo_pc
	and	c.nr_seq_protocolo	= d.nr_sequencia
	and	b.nr_seq_conta		= c.nr_sequencia
	and	a.nr_seq_conta_item	= b.nr_sequencia;


BEGIN

open C01(nr_seq_lote_protocolo_p);
loop
	--Carregar as vari_veis conforme informa__es obtidas atrav_s do Cursor

	fetch C01 bulk collect into	tb_nr_seq_face_dente_w, tb_nr_seq_conta_item_imp_w,
					tb_cd_face_dente_w, tb_nr_seq_conta_proc_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_face_dente_w.count = 0;

	--Integrar as informa__es  da tabela  pls_decl_conta_vivo_imp para a PLS_CONTA_PROC_FACE_DENTE

	--Inseridas as informa__es correspondentes na tabela.

	--Os campos _IMP da PLS_CONTA_PROC_FACE_DENTE tamb_m devem ser populados para consultas posteriores

	forall i in tb_nr_seq_face_dente_w.first..tb_nr_seq_face_dente_w.last
		insert	into pls_conta_proc_face_dente(cd_face_dente, dt_atualizacao,
			dt_atualizacao_nrec, nm_usuario,
			nm_usuario_nrec, nr_seq_conta_proc,
			nr_sequencia, nr_seq_imp
		) values (tb_cd_face_dente_w(i), clock_timestamp(),
			clock_timestamp(), nm_usuario_p,
			nm_usuario_p, tb_nr_seq_conta_proc_w(i),
			nextval('pls_conta_proc_face_dente_seq'), tb_nr_seq_face_dente_w(i));
	commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_int_xml_cta_pck.pls_int_nv_face_dente ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
