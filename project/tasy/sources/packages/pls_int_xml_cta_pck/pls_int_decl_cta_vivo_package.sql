-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_int_xml_cta_pck.pls_int_decl_cta_vivo ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_diag_vivo_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_imp_w		pls_util_cta_pck.t_number_table;
tb_nr_declaracao_w		pls_util_cta_pck.t_varchar2_table_15;
tb_ie_indicador_dorn_w		pls_util_cta_pck.t_varchar2_table_1;
tb_nr_seq_conta_w		pls_util_cta_pck.t_number_table;

C01 CURSOR(nr_seq_lote_protocolo_pc	pls_lote_protocolo_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_diag_vivo,
		a.nr_seq_conta nr_seq_conta_imp,
		a.nr_declaracao,
		a.ie_indicador_dorn,
		(SELECT	max(x.nr_sequencia)
		from	pls_conta x
		where	x.nr_seq_imp	= b.nr_sequencia) nr_seq_conta
	from	pls_protocolo_conta_imp c,
		pls_conta_imp b,
		pls_decl_conta_vivo_imp a
	where	c.nr_seq_lote_protocolo	= nr_seq_lote_protocolo_pc
	and	b.nr_seq_protocolo	= c.nr_sequencia
	and	a.nr_seq_conta		= b.nr_sequencia;


BEGIN

open C01(nr_seq_lote_protocolo_p);
loop
	--Carregar as vari_veis conforme informa__es obtidas atrav_s do Cursor

	fetch C01 bulk collect into	tb_nr_seq_diag_vivo_w, tb_nr_seq_conta_imp_w,
					tb_nr_declaracao_w, tb_ie_indicador_dorn_w,
					tb_nr_seq_conta_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_diag_vivo_w.count = 0;

	--Integrar as informa__es  da tabela  pls_decl_conta_vivo_imp para a PLS_DIAGNOSTICO_NASC_VIVO

	--Inseridas as informa__es correspondentes na tabela.

	--Os campos _IMP da PLS_DIAGNOSTICO_NASC_VIVO tamb_m devem ser populados para consultas posteriores

	forall i in tb_nr_seq_diag_vivo_w.first..tb_nr_seq_diag_vivo_w.last
		insert	into pls_diagnostico_nasc_vivo(dt_atualizacao, dt_atualizacao_nrec,
			ie_indicador_dorn, ie_indicador_dorn_imp,
			nm_usuario, nm_usuario_nrec,
			nr_decl_nasc_vivo, nr_decl_nasc_vivo_imp,
			nr_seq_conta, nr_seq_imp,
			nr_sequencia
		) values (clock_timestamp(), clock_timestamp(),
			tb_ie_indicador_dorn_w(i), tb_ie_indicador_dorn_w(i),
			nm_usuario_p, nm_usuario_p,
			tb_nr_declaracao_w(i), tb_nr_declaracao_w(i),
			tb_nr_seq_conta_w(i), tb_nr_seq_diag_vivo_w(i),
			nextval('pls_diagnostico_nasc_vivo_seq'));
	commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_int_xml_cta_pck.pls_int_decl_cta_vivo ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;