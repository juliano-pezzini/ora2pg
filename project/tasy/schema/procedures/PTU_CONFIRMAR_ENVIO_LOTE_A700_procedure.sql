-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_confirmar_envio_lote_a700 ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	PTU_LOTE_SERV_PRE_PGTO
set	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	DT_CONFIRMACAO		= clock_timestamp()
where	nr_sequencia		= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_confirmar_envio_lote_a700 ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

