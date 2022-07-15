-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_audit_qt_dias ( dt_prev_retorno_p timestamp, nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
BEGIN
update	lote_audit_recurso
set	dt_prev_retorno = dt_prev_retorno_p
where	nr_sequencia = nr_seq_lote_p;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_audit_qt_dias ( dt_prev_retorno_p timestamp, nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

