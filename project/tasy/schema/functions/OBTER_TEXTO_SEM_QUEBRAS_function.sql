-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_texto_sem_quebras (ds_comando_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);


BEGIN
ds_retorno_w := upper(replace(replace(replace(replace(ds_comando_p,' ',''),chr(13),''),chr(10),''),chr(9),''));

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_texto_sem_quebras (ds_comando_p text) FROM PUBLIC;

