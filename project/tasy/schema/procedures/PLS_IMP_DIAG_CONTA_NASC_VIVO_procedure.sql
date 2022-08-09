-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_diag_conta_nasc_vivo ( nr_seq_conta_p bigint, nr_declaracao_nasc_vivo_imp_p text, nm_usuario_p text) AS $body$
BEGIN

insert into pls_diagnostico_nasc_vivo(
	nr_sequencia,
        nm_usuario,
        dt_atualizacao,
        nm_usuario_nrec,
        dt_atualizacao_nrec,
	nr_seq_conta,
        nr_decl_nasc_vivo_imp)
values ( nextval('pls_diagnostico_nasc_vivo_seq'),
	nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
	clock_timestamp(),
	nr_seq_conta_p,
        nr_declaracao_nasc_vivo_imp_p);

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_diag_conta_nasc_vivo ( nr_seq_conta_p bigint, nr_declaracao_nasc_vivo_imp_p text, nm_usuario_p text) FROM PUBLIC;
