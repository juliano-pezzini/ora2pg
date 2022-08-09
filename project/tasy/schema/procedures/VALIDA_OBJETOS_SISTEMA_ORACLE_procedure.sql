-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valida_objetos_sistema_oracle (thread bigint, owner text) AS $body$
BEGIN

  CALL exec_sql_dinamico('TASY', 'BEGIN SYS.UTL_RECOMP.recomp_parallel(' || thread || ',' || chr(39) || owner || chr(39) || '); END;');

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valida_objetos_sistema_oracle (thread bigint, owner text) FROM PUBLIC;
