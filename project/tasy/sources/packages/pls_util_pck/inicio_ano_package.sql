-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_util_pck.inicio_ano ( dt_parametro_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w	timestamp;


BEGIN
-- tenta concatenar dia 01/01 com o ano
begin

dt_retorno_w := to_date('01/01/' || to_char(dt_parametro_p, 'yyyy'), 'dd/mm/yyyy');

exception
when others then
	dt_retorno_w := null;
end;

return dt_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_util_pck.inicio_ano ( dt_parametro_p timestamp) FROM PUBLIC;
