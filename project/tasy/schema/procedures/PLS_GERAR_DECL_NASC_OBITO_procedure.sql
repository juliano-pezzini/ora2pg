-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_decl_nasc_obito ( cd_cid_obito_p pls_diagnost_conta_obito.cd_doenca%type, nr_declara_obito_p pls_diagnost_conta_obito.nr_declaracao_obito%type, nr_declara_vivo_p pls_diagnostico_nasc_vivo.nr_decl_nasc_vivo%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_indicador_dorn_p pls_diagnost_conta_obito.ie_indicador_dorn%type default null) AS $body$
BEGIN
if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	-- Verificar se e uma declaracao de obito ou de nascimento
	if ((cd_cid_obito_p IS NOT NULL AND cd_cid_obito_p::text <> '') or (nr_declara_obito_p IS NOT NULL AND nr_declara_obito_p::text <> '')) then
		insert into pls_diagnost_conta_obito(nr_sequencia, nm_usuario, nm_usuario_nrec,
			dt_atualizacao, dt_atualizacao_nrec, ie_indicador_dorn_imp,
			ie_indicador_dorn, nr_declaracao_obito, nr_declaracao_obito_imp,
			nr_seq_conta, nm_tabela, nm_tabela_imp, cd_doenca, cd_doenca_imp)
		values (nextval('pls_diagnost_conta_obito_seq'),nm_usuario_p,nm_usuario_p,
			clock_timestamp(),clock_timestamp(),null,
			ie_indicador_dorn_p,nr_declara_obito_p,nr_declara_obito_p,
			nr_seq_conta_p,null,null,cd_cid_obito_p,cd_cid_obito_p);
	else
		insert into pls_diagnostico_nasc_vivo(nr_sequencia, nm_usuario, nm_usuario_nrec,
			dt_atualizacao, dt_atualizacao_nrec, ie_indicador_dorn_imp,
			nr_seq_conta,nr_decl_nasc_vivo,nr_decl_nasc_vivo_imp,
			ie_indicador_dorn)
		values (nextval('pls_diagnostico_nasc_vivo_seq'),nm_usuario_p,nm_usuario_p,
			clock_timestamp(),clock_timestamp(),null,
			nr_seq_conta_p,nr_declara_vivo_p,nr_declara_vivo_p,
			ie_indicador_dorn_p);
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_decl_nasc_obito ( cd_cid_obito_p pls_diagnost_conta_obito.cd_doenca%type, nr_declara_obito_p pls_diagnost_conta_obito.nr_declaracao_obito%type, nr_declara_vivo_p pls_diagnostico_nasc_vivo.nr_decl_nasc_vivo%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_indicador_dorn_p pls_diagnost_conta_obito.ie_indicador_dorn%type default null) FROM PUBLIC;
