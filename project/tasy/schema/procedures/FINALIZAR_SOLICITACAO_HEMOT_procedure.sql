-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE finalizar_solicitacao_hemot ( nr_seq_solicitacao_p bigint, dt_fechamento_p timestamp) AS $body$
BEGIN

update	san_solicitacao
set	dt_fechamento	= coalesce(dt_fechamento_p,clock_timestamp())
where	nr_sequencia	= nr_seq_solicitacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE finalizar_solicitacao_hemot ( nr_seq_solicitacao_p bigint, dt_fechamento_p timestamp) FROM PUBLIC;

