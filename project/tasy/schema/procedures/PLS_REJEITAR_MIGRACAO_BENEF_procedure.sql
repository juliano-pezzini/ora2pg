-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_rejeitar_migracao_benef ( nr_seq_migracao_benef_p pls_migracao_beneficiario.nr_sequencia%type, nr_seq_motivo_rejeicao_p pls_migracao_beneficiario.nr_seq_motivo_rejeicao%type, ds_observacao_p pls_migracao_beneficiario.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

update	pls_migracao_beneficiario
set	nr_seq_motivo_rejeicao 	= nr_seq_motivo_rejeicao_p,
	ie_status		= 3,
	ds_observacao		= substr(ds_observacao_p, 1, 2000),
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia 		= nr_seq_migracao_benef_p;

CALL pls_gerar_comunic_externo_web(nr_seq_migracao_benef_p, '9', nm_usuario_p);

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rejeitar_migracao_benef ( nr_seq_migracao_benef_p pls_migracao_beneficiario.nr_sequencia%type, nr_seq_motivo_rejeicao_p pls_migracao_beneficiario.nr_seq_motivo_rejeicao%type, ds_observacao_p pls_migracao_beneficiario.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

