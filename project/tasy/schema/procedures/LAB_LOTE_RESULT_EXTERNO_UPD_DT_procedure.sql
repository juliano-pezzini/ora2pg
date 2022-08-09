-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_lote_result_externo_upd_dt (nr_sequencia_p bigint, dt_envio_p timestamp) AS $body$
BEGIN

update 	lab_lote_result_externo
set 	dt_envio = dt_envio_p
where 	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_lote_result_externo_upd_dt (nr_sequencia_p bigint, dt_envio_p timestamp) FROM PUBLIC;
