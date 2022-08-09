-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_boletim_informativo (nr_sequencia_p bigint) AS $body$
BEGIN

update	atendimento_boletim
set	dt_liberacao = clock_timestamp()
where	nr_sequencia = nr_sequencia_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_boletim_informativo (nr_sequencia_p bigint) FROM PUBLIC;
