-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eliminar_tabela_dinamica_gp (nm_tabela_p text) AS $body$
DECLARE


ds_comando_drop_w	varchar(100)	:= '';


BEGIN
if (nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '') then
	ds_comando_drop_w	:= (' drop table ' || nm_tabela_p);
	CALL exec_sql_dinamico('TASY', ds_comando_drop_w);
end if;

COMMIT;
END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eliminar_tabela_dinamica_gp (nm_tabela_p text) FROM PUBLIC;

