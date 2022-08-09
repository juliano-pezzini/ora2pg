-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_alerta ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

UPDATE	Alerta_paciente
SET	dt_liberacao = clock_timestamp()
WHERE	nr_sequencia = nr_sequencia_p
and	coalesce(dt_liberacao::text, '') = '';

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_alerta ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
