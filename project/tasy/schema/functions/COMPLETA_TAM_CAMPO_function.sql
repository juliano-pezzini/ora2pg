-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION completa_tam_campo (ds_campo_p text, ds_completa_p text, qt_tam_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000);
i			integer	:= 1;


BEGIN

ds_retorno_w		:= ds_campo_p;

for	i in length(ds_retorno_w) + 1 .. qt_tam_p loop
	ds_retorno_w	:= ds_retorno_w || ds_completa_p;
end loop;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION completa_tam_campo (ds_campo_p text, ds_completa_p text, qt_tam_p bigint) FROM PUBLIC;

