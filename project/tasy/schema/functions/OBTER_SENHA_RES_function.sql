-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_senha_res () RETURNS varchar AS $body$
DECLARE


DS_RETORNO_W		varchar(200);


BEGIN

    DS_RETORNO_W := 'unmsjrp'||'7@$'||'&';

RETURN DS_RETORNO_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_senha_res () FROM PUBLIC;

