-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE clear_result_import_conv_ext ( nm_usuario_p w_result_import_conversao.nm_usuario%type, ie_sistema_externo_p w_result_import_conversao.ie_sistema_externo%type ) AS $body$
BEGIN

    delete from w_result_import_conversao where upper(nm_usuario) = upper(nm_usuario_p) and upper(ie_sistema_externo) = upper(ie_sistema_externo_p);
    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE clear_result_import_conv_ext ( nm_usuario_p w_result_import_conversao.nm_usuario%type, ie_sistema_externo_p w_result_import_conversao.ie_sistema_externo%type ) FROM PUBLIC;

