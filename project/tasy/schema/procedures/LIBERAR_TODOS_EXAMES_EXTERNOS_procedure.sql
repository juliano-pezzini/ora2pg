-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_todos_exames_externos ( nm_usuario_p text, nr_seq_resultado_p bigint) AS $body$
BEGIN

update Exame_Lab_Resultado
set dt_liberacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where nr_seq_resultado = nr_seq_resultado_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_todos_exames_externos ( nm_usuario_p text, nr_seq_resultado_p bigint) FROM PUBLIC;
