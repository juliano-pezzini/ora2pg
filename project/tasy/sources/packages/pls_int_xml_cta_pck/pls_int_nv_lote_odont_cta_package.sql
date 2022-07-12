-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_int_xml_cta_pck.pls_int_nv_lote_odont_cta ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_lote_anexo_odont_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_anexo_cta_imp_w		pls_util_cta_pck.t_number_table;
tb_cd_dente_w				pls_util_cta_pck.t_varchar2_table_20;
tb_cd_situacao_inicial_w		pls_util_cta_pck.t_varchar2_table_20;
tb_nr_seq_lote_anexo_w			pls_util_cta_pck.t_number_table;

C01 CURSOR(nr_seq_lote_protocolo_pc	pls_lote_protocolo_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_lote_anexo_odont,
		a.nr_seq_anexo_cta_imp,
		a.cd_dente,
		a.cd_situacao_inicial,
		(SELECT	max(x.nr_sequencia)
		from	pls_lote_anexo_cta x
		where	x.nr_seq_imp = b.nr_sequencia) nr_seq_lote_anexo
	from	pls_protocolo_conta_imp d,
		pls_conta_imp c,
		pls_lote_anexo_cta_imp b,
		pls_lote_anexo_odo_cta_imp a
	where	d.nr_seq_lote_protocolo	= nr_seq_lote_protocolo_pc
	and	c.nr_seq_protocolo	= d.nr_sequencia
	and	b.nr_seq_conta_imp	= c.nr_sequencia
	and	a.nr_seq_anexo_cta_imp	= b.nr_sequencia;


BEGIN

open C01(nr_seq_lote_protocolo_p);
loop
	--Carregar as vari_veis conforme informa__es obtidas atrav_s do Cursor

	fetch C01 bulk collect into	tb_nr_seq_lote_anexo_odont_w, tb_nr_seq_anexo_cta_imp_w,
					tb_cd_dente_w, tb_cd_situacao_inicial_w,
					tb_nr_seq_lote_anexo_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_lote_anexo_odont_w.count = 0;

	--Integrar as informa__es  da tabela  PLS_LOTE_ANEXO_ODO_CTA_IMP para a PLS_LOTE_ANEXO_ODO_CTA

	--Inseridas as informa__es correspondentes na tabela.

	--Os campos _IMP da PLS_LOTE_ANEXO_ODO_CTA tamb_m devem ser populados para consultas posteriores

	forall i in tb_nr_seq_lote_anexo_odont_w.first..tb_nr_seq_lote_anexo_odont_w.last
		insert	into pls_lote_anexo_odo_cta(cd_dente, cd_situacao_inicial,
			dt_atualizacao, dt_atualizacao_nrec,
			nm_usuario, nm_usuario_nrec,
			nr_seq_anexo_cta_imp, nr_seq_imp,
			nr_sequencia, nr_seq_anexo_cta
		) values (tb_cd_dente_w(i), tb_cd_situacao_inicial_w(i),
			clock_timestamp(), clock_timestamp(),
			nm_usuario_p, nm_usuario_p,
			tb_nr_seq_anexo_cta_imp_w(i), tb_nr_seq_lote_anexo_odont_w(i),
			nextval('pls_lote_anexo_odo_cta_seq'), tb_nr_seq_lote_anexo_w(i));
	commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_int_xml_cta_pck.pls_int_nv_lote_odont_cta ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;