-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_diag_obito_nasc_conta ( nr_seq_conta_p bigint, nm_usuario_p text, ie_tipo_tabela_p text) AS $body$
DECLARE


tb_nr_sequencia_w		pls_util_cta_pck.t_number_table;
tb_nr_declaracao_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_doenca_w			pls_util_cta_pck.t_varchar2_table_10;
tb_ie_indicador_dorn_w		pls_util_cta_pck.t_varchar2_table_2;
tb_ds_diagnostico_w		pls_util_cta_pck.t_varchar2_table_4000;
tb_ie_classificacao_w		pls_util_cta_pck.t_varchar2_table_2;

c_cabecalho CURSOR(	nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		nr_seq_conta
	from	pls_conta_pos_cabecalho
	where	nr_seq_conta	= nr_seq_conta_pc;

c_diagnostico CURSOR(nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		cd_doenca,
		ds_diagnostico,
		ie_classificacao
	from	pls_diagnostico_conta_pos
	where	nr_seq_conta	= nr_seq_conta_pc;

c_obito CURSOR(nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		cd_doenca,
		nr_declaracao_obito,
		ie_indicador_dorn
	from	pls_diag_conta_obito_pos
	where	nr_seq_conta	= nr_seq_conta_pc;

c_nasc_vivo CURSOR(nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		nr_decl_nasc_vivo
	from	pls_diagnos_nasc_viv_pos
	where	nr_seq_conta	= nr_seq_conta_pc;

BEGIN

for r_c_cabecalho in c_cabecalho(nr_seq_conta_p) loop

	if (ie_tipo_tabela_p = 'DG') then

		delete	FROM pls_diagnostico_conta
		where	nr_seq_conta  = nr_seq_conta_p;

		Open c_diagnostico(r_c_cabecalho.nr_seq_conta);
		loop
			tb_nr_sequencia_w.delete;
			tb_cd_doenca_w.delete;
			tb_ds_diagnostico_w.delete;
			tb_ie_classificacao_w.delete;

			fetch c_diagnostico bulk collect into tb_nr_sequencia_w, tb_cd_doenca_w, tb_ds_diagnostico_w, tb_ie_classificacao_w
			limit pls_util_cta_pck.qt_registro_transacao_w;

			exit when tb_nr_sequencia_w.count = 0;

			forall j in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last

				insert	into	pls_diagnostico_conta(	cd_doenca, ds_diagnostico, dt_atualizacao,
						dt_atualizacao_nrec, ie_classificacao, nm_usuario,
						nm_usuario_nrec, nr_seq_conta, nr_sequencia)
				values (	tb_cd_doenca_w(j), tb_ds_diagnostico_w(j), clock_timestamp(),
						clock_timestamp(), tb_ie_classificacao_w(j), nm_usuario_p,
						nm_usuario_p, r_c_cabecalho.nr_seq_conta, nextval('pls_diagnostico_conta_seq'));

			commit;

		end loop;
		close c_diagnostico;

	elsif (ie_tipo_tabela_p = 'OB') then

		delete	FROM pls_diagnost_conta_obito
		where	nr_seq_conta  = nr_seq_conta_p;

		Open c_obito(r_c_cabecalho.nr_seq_conta);
		loop
			tb_nr_sequencia_w.delete;
			tb_cd_doenca_w.delete;
			tb_nr_declaracao_w.delete;
			tb_ie_indicador_dorn_w.delete;

			fetch c_obito bulk collect into tb_nr_sequencia_w, tb_cd_doenca_w, tb_nr_declaracao_w, tb_ie_indicador_dorn_w
			limit pls_util_cta_pck.qt_registro_transacao_w;

			exit when tb_nr_sequencia_w.count = 0;

			forall j in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last

				insert	into	pls_diagnost_conta_obito(	cd_doenca, dt_atualizacao, dt_atualizacao_nrec,
						ie_indicador_dorn, nm_usuario, nm_usuario_nrec,
						nr_declaracao_obito, nr_seq_conta, nr_sequencia)
				values (	tb_cd_doenca_w(j), clock_timestamp(), clock_timestamp(),
						tb_ie_indicador_dorn_w(j), nm_usuario_p, nm_usuario_p,
						tb_nr_declaracao_w(j), r_c_cabecalho.nr_seq_conta, nextval('pls_diagnost_conta_obito_seq'));

			commit;
		end loop;
		close c_obito;

	elsif (ie_tipo_tabela_p = 'NV') then

		delete	FROM pls_diagnostico_nasc_vivo
		where	nr_seq_conta  = nr_seq_conta_p;

		Open c_nasc_vivo(r_c_cabecalho.nr_seq_conta);
		loop
			tb_nr_sequencia_w.delete;
			tb_nr_declaracao_w.delete;

			fetch c_nasc_vivo bulk collect into tb_nr_sequencia_w, tb_nr_declaracao_w
			limit pls_util_cta_pck.qt_registro_transacao_w;

			exit when tb_nr_sequencia_w.count = 0;

			forall j in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last

				insert	into	pls_diagnostico_nasc_vivo(	dt_atualizacao, dt_atualizacao_nrec, nm_usuario,
						nm_usuario_nrec, nr_decl_nasc_vivo, nr_seq_conta,
						nr_sequencia)
				values (	clock_timestamp(), clock_timestamp(), nm_usuario_p,
						nm_usuario_p, tb_nr_declaracao_w(j), r_c_cabecalho.nr_seq_conta,
						nextval('pls_diagnostico_nasc_vivo_seq'));

			commit;
		end loop;
		close c_nasc_vivo;

	end if;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_diag_obito_nasc_conta ( nr_seq_conta_p bigint, nm_usuario_p text, ie_tipo_tabela_p text) FROM PUBLIC;

