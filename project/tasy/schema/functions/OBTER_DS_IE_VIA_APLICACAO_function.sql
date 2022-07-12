-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_ie_via_aplicacao (ie_via_aplicacao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w            varchar(255);


BEGIN

if (ie_via_aplicacao_p IS NOT NULL AND ie_via_aplicacao_p::text <> '') then

        select  max(ds_via_aplicacao)
        into STRICT    ds_retorno_w
        from    via_aplicacao
        where   ie_via_aplicacao = ie_via_aplicacao_p;

end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_ie_via_aplicacao (ie_via_aplicacao_p text) FROM PUBLIC;
