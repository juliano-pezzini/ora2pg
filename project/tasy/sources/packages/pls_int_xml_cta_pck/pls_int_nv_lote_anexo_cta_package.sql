-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_int_xml_cta_pck.pls_int_nv_lote_anexo_cta ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_lote_anex_cta_w		pls_util_cta_pck.t_number_table;
tb_cd_guia_w				pls_util_cta_pck.t_varchar2_table_20;
tb_cd_guia_referencia_w			pls_util_cta_pck.t_varchar2_table_20;
tb_cd_guia_prestador_w			pls_util_cta_pck.t_varchar2_table_20;
tb_cd_usuario_plano_w			pls_util_cta_pck.t_varchar2_table_50;
tb_nm_beneficiario_w			pls_util_cta_pck.t_varchar2_table_200;
tb_dt_autorizacao_w			pls_util_cta_pck.t_date_table;
tb_ds_observacao_w			pls_util_cta_pck.t_varchar2_table_4000;
tb_ds_justificativa_w			pls_util_cta_pck.t_varchar2_table_4000;
tb_ie_tipo_anexo_w			pls_util_cta_pck.t_varchar2_table_2;
tb_ie_sinais_doenca_period_w		pls_util_cta_pck.t_varchar2_table_1;
tb_ie_alter_tecido_mole_w		pls_util_cta_pck.t_varchar2_table_1;
tb_ie_origem_w				pls_util_cta_pck.t_varchar2_table_2;
tb_nr_seq_conta_imp_w			pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_w			pls_util_cta_pck.t_number_table;

C01 CURSOR(nr_seq_lote_protocolo_pc	pls_lote_protocolo_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_lote_anex_cta,
		a.cd_guia,
		a.cd_guia_referencia,
		a.cd_guia_prestador,
		a.cd_usuario_plano,
		a.nm_beneficiario,
		a.dt_autorizacao,
		a.ds_observacao,
		a.ds_justificativa,
		a.ie_tipo_anexo,
		a.ie_sinais_doenca_periodont,
		a.ie_alter_tecido_mole,
		a.ie_origem,
		a.nr_seq_conta_imp,
		(SELECT	max(x.nr_sequencia)
		from	pls_conta x
		where	x.nr_seq_imp = b.nr_sequencia) nr_seq_conta
	from	pls_protocolo_conta_imp c,
		pls_conta_imp b,
		pls_lote_anexo_cta_imp a
	where	c.nr_seq_lote_protocolo	= nr_seq_lote_protocolo_pc
	and	b.nr_seq_protocolo	= c.nr_sequencia
	and	a.nr_seq_conta_imp	= b.nr_sequencia;


BEGIN

open C01(nr_seq_lote_protocolo_p);
loop
	--Carregar as vari_veis conforme informa__es obtidas atrav_s do Cursor

	fetch C01 bulk collect into	tb_nr_seq_lote_anex_cta_w, tb_cd_guia_w,
					tb_cd_guia_referencia_w, tb_cd_guia_prestador_w,
					tb_cd_usuario_plano_w, tb_nm_beneficiario_w,
					tb_dt_autorizacao_w, tb_ds_observacao_w,
					tb_ds_justificativa_w, tb_ie_tipo_anexo_w,
					tb_ie_sinais_doenca_period_w, tb_ie_alter_tecido_mole_w,
					tb_ie_origem_w, tb_nr_seq_conta_imp_w,
					tb_nr_seq_conta_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_lote_anex_cta_w.count = 0;

	--Integrar as informa__es  da tabela  PLS_LOTE_ANEXO_CTA_IMP para a PLS_LOTE_ANEXO_CTA

	--Inseridas as informa__es correspondentes na tabela.

	--Os campos _IMP da PLS_LOTE_ANEXO_CTA tamb_m devem ser populados para consultas posteriores

	forall i in tb_nr_seq_lote_anex_cta_w.first..tb_nr_seq_lote_anex_cta_w.last
		insert	into pls_lote_anexo_cta(cd_guia, cd_guia_prestador,
			cd_guia_referencia, cd_usuario_plano,
			ds_justificativa, ds_observacao,
			dt_atualizacao, dt_atualizacao_nrec,
			ie_alter_tecido_mole, ie_origem,
			ie_sinais_doenca_periodont, ie_tipo_anexo,
			nm_usuario, nm_usuario_nrec,
			nr_seq_conta, nr_seq_conta_imp,
			nr_seq_imp, nr_sequencia
		) values (tb_cd_guia_w(i), tb_cd_guia_prestador_w(i),
			tb_cd_guia_referencia_w(i), tb_cd_usuario_plano_w(i),
			tb_ds_justificativa_w(i), tb_ds_observacao_w(i),
			clock_timestamp(), clock_timestamp(),
			tb_ie_alter_tecido_mole_w(i), tb_ie_origem_w(i),
			tb_ie_sinais_doenca_period_w(i), tb_ie_tipo_anexo_w(i),
			nm_usuario_p, nm_usuario_p,
			tb_nr_seq_conta_w(i), tb_nr_seq_conta_imp_w(i),
			tb_nr_seq_lote_anex_cta_w(i), nextval('pls_lote_anexo_cta_seq'));
	commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_int_xml_cta_pck.pls_int_nv_lote_anexo_cta ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
