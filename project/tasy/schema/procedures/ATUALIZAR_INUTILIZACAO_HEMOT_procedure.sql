-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_inutilizacao_hemot ( dt_fechamento_p timestamp, nr_seq_inutilizacao_p bigint) AS $body$
BEGIN

update	san_inutilizacao
set	dt_fechamento	= dt_fechamento_p
where	nr_sequencia	= nr_seq_inutilizacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_inutilizacao_hemot ( dt_fechamento_p timestamp, nr_seq_inutilizacao_p bigint) FROM PUBLIC;
