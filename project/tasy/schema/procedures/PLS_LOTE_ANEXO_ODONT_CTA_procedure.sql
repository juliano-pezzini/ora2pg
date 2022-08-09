-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lote_anexo_odont_cta ( dt_atualizacao_p timestamp, nr_seq_anexo_cta_imp_p pls_lote_anexo_odo_cta_imp.nr_seq_anexo_cta_imp%type, cd_dente_p pls_lote_anexo_odo_cta_imp.cd_dente%type, cd_situacao_inicial_p pls_lote_anexo_odo_cta_imp.cd_situacao_inicial%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

if 	(cd_dente_p IS NOT NULL AND cd_dente_p::text <> '' AND nr_seq_anexo_cta_imp_p IS NOT NULL AND nr_seq_anexo_cta_imp_p::text <> '') then

	insert 	into pls_lote_anexo_odo_cta_imp(
		nr_sequencia, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_anexo_cta_imp,
		cd_dente, cd_situacao_inicial
	) values (
		nextval('pls_lote_anexo_odo_cta_imp_seq'), clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, nr_seq_anexo_cta_imp_p,
		cd_dente_p, cd_situacao_inicial_p);

	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lote_anexo_odont_cta ( dt_atualizacao_p timestamp, nr_seq_anexo_cta_imp_p pls_lote_anexo_odo_cta_imp.nr_seq_anexo_cta_imp%type, cd_dente_p pls_lote_anexo_odo_cta_imp.cd_dente%type, cd_situacao_inicial_p pls_lote_anexo_odo_cta_imp.cd_situacao_inicial%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
