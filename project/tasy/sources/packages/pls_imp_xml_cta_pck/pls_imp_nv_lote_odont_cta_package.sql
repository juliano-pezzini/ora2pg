-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_xml_cta_pck.pls_imp_nv_lote_odont_cta ( nr_seq_anexo_cta_p pls_lote_anexo_odo_cta_imp.nr_seq_anexo_cta_imp%type, cd_dente_p pls_lote_anexo_odo_cta_imp.cd_dente%type, cd_situacao_inicial_p pls_lote_anexo_odo_cta_imp.cd_situacao_inicial%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

-- anexo da conta medica

insert 	into pls_lote_anexo_odo_cta_imp(
	nr_sequencia, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_anexo_cta_imp,
	cd_dente, cd_situacao_inicial
) values (
	nextval('pls_lote_anexo_odo_cta_imp_seq'), clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, nr_seq_anexo_cta_p,
	cd_dente_p, cd_situacao_inicial_p
);

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_xml_cta_pck.pls_imp_nv_lote_odont_cta ( nr_seq_anexo_cta_p pls_lote_anexo_odo_cta_imp.nr_seq_anexo_cta_imp%type, cd_dente_p pls_lote_anexo_odo_cta_imp.cd_dente%type, cd_situacao_inicial_p pls_lote_anexo_odo_cta_imp.cd_situacao_inicial%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;