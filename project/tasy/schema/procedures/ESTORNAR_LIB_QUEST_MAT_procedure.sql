-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_lib_quest_mat ( nm_usuario_p text, nr_sequencia_p bigint ) AS $body$
BEGIN

update 	mat_aval_quest
set 	dt_liberacao  = NULL,
	nm_usuario_lib  = NULL
where 	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_lib_quest_mat ( nm_usuario_p text, nr_sequencia_p bigint ) FROM PUBLIC;

