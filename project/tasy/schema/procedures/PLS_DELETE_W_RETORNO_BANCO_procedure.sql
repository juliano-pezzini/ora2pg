-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_delete_w_retorno_banco ( nm_usuario_p w_retorno_banco.nm_usuario%type ) AS $body$
BEGIN
	delete from w_retorno_banco where nm_usuario = nm_usuario_p;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_delete_w_retorno_banco ( nm_usuario_p w_retorno_banco.nm_usuario%type ) FROM PUBLIC;
