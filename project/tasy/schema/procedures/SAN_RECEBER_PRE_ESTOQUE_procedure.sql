-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_receber_pre_estoque ( nr_seq_producao_p bigint, nr_seq_local_armazenamento_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	san_producao
set	nm_usuario_recebimento	= nm_usuario_p,
	nm_usuario 		= nm_usuario_p,
	dt_recebimento		= clock_timestamp(),
	dt_atualizacao		= clock_timestamp(),
	nr_seq_armazenamento	= nr_seq_local_armazenamento_p
where	nr_sequencia = nr_seq_producao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_receber_pre_estoque ( nr_seq_producao_p bigint, nr_seq_local_armazenamento_p bigint, nm_usuario_p text) FROM PUBLIC;

