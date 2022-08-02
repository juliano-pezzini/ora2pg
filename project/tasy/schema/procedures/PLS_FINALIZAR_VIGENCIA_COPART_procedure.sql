-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_finalizar_vigencia_copart ( nr_seq_regra_p bigint, dt_fim_vigencia_p timestamp, nm_usuario_p text) AS $body$
BEGIN

update	pls_regra_copartic
set	dt_fim_vigencia = dt_fim_vigencia_p,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_regra_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_finalizar_vigencia_copart ( nr_seq_regra_p bigint, dt_fim_vigencia_p timestamp, nm_usuario_p text) FROM PUBLIC;

