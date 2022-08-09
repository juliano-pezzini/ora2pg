-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_insere_motivo_rep_mat_med ( nr_seq_solicitacao_p bigint, nr_seq_motivo_reprov_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	pls_solic_lib_mat_med
set	nr_seq_mot_reprov	= nr_seq_motivo_reprov_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_solicitacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_insere_motivo_rep_mat_med ( nr_seq_solicitacao_p bigint, nr_seq_motivo_reprov_p bigint, nm_usuario_p text) FROM PUBLIC;
