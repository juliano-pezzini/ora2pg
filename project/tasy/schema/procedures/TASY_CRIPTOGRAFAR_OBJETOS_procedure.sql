-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_criptografar_objetos () AS $body$
DECLARE


qt_objeto_w     bigint;


BEGIN

select  count(*)
into STRICT    qt_objeto_w
from    user_objects
where   upper(object_name) = 'TASY_WRAPPED_OBJETOS'
and             upper(STATUS) = 'VALID';
begin

        if (qt_objeto_w > 0) then
                CALL exec_sql_dinamico('','begin tasy_wrapped_objetos; end;');
        else
                CALL Exec_Sql_Dinamico('Tasy', 'drop procedure tasy_wrapped_objetos'
);
				CALL Exec_Sql_Dinamico('Tasy', ' delete from objeto_sistema_param where nr_seq_objeto = 60296');
				CALL Exec_Sql_Dinamico('Tasy', ' delete from objeto_sistema where nr_sequencia = 60296');
				CALL Exec_Sql_Dinamico('Tasy', ' delete from tasy_versao.objeto_sistema_param where nr_seq_objeto = 60296');
				CALL Exec_Sql_Dinamico('Tasy', ' delete from tasy_versao.objeto_sistema where nr_sequencia = 60296');
        end if;
exception
        when others then
                CALL Exec_Sql_Dinamico('Tasy', 'drop procedure tasy_wrapped_objetos'
);
				CALL Exec_Sql_Dinamico('Tasy', ' delete from objeto_sistema_param where nr_seq_objeto = 60296');
				CALL Exec_Sql_Dinamico('Tasy', ' delete from objeto_sistema where nr_sequencia = 60296');
				CALL Exec_Sql_Dinamico('Tasy', ' delete from tasy_versao.objeto_sistema_param where nr_seq_objeto = 60296');
				CALL Exec_Sql_Dinamico('Tasy', ' delete from tasy_versao.objeto_sistema where nr_sequencia = 60296');
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_criptografar_objetos () FROM PUBLIC;
