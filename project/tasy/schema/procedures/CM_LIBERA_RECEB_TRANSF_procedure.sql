-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_libera_receb_transf ( nr_seq_lote_transf_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	cm_lote_transferencia
set	dt_lib_receb = clock_timestamp(),
	nm_usuario_receb = nm_usuario_p
where	nr_sequencia = nr_seq_lote_transf_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_libera_receb_transf ( nr_seq_lote_transf_p bigint, nm_usuario_p text) FROM PUBLIC;

