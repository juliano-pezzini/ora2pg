-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horas_minutos (qt_minutos_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(60);


BEGIN

ds_retorno_w := trim(both replace(to_char(floor(dividir(qt_minutos_p,60)),'999,999,900'),',','.')) || ':' || substr(to_char(mod(qt_minutos_p,60),'00'),2,2);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION obter_horas_minutos (qt_minutos_p bigint) FROM PUBLIC;

