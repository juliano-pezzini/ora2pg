-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_imp_arquivo ( nm_tabela_p text, nm_usuario_p text) AS $body$
DECLARE


ds_sql_w varchar(2000);
ds_parametros_w varchar(255);


BEGIN

ds_sql_w  := 'delete from ' || nm_tabela_p || ' where nm_usuario = :nm_usuario';
ds_parametros_w  := 'nm_usuario=' || nm_usuario_p;


CALL exec_sql_dinamico_bv( 'DELETE_IMP_ARQUIVO',
   ds_sql_w,
   ds_parametros_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_imp_arquivo ( nm_tabela_p text, nm_usuario_p text) FROM PUBLIC;
