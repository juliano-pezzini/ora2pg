-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_pri_letra_maiusculo ( ds_texto_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (ds_texto_p IS NOT NULL AND ds_texto_p::text <> '') then

ds_retorno_w	:= ds_texto_p;
ds_retorno_w	:= substr(upper(ds_retorno_w),1,1) || substr(lower(ds_retorno_w),2,255);

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_pri_letra_maiusculo ( ds_texto_p text) FROM PUBLIC;
