-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cp_liberar_mens_meta_educ ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	update	pat_cp_ind_measure_eg
	set		dt_liberacao = clock_timestamp(),
			nm_usuario_lib = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cp_liberar_mens_meta_educ ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

