-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE devolucao_adiantamento ( dt_devolucao_p text, cd_motivo_devolucao_p bigint, nm_usuario_p text, nr_seq_cheque_p bigint) AS $body$
BEGIN


update	cheque_cr
set	dt_devolucao	= dt_devolucao_p,
	cd_motivo_devolucao	= cd_motivo_devolucao_p,
	nm_usuario_devolucao	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_seq_cheque	= nr_seq_cheque_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE devolucao_adiantamento ( dt_devolucao_p text, cd_motivo_devolucao_p bigint, nm_usuario_p text, nr_seq_cheque_p bigint) FROM PUBLIC;

