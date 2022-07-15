-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_liberar_sessao (nm_usuario_p text) AS $body$
BEGIN
CALL exec_sql_dinamico(nm_usuario_p,'truncate table w_adep_t');
CALL exec_sql_dinamico(nm_usuario_p,'truncate table w_adep_horarios_t');
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_liberar_sessao (nm_usuario_p text) FROM PUBLIC;

