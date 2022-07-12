-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_resultado_glasgow ( qt_glasgow_p bigint, ie_escala_glasgow_p text default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(100);

/*
0 = Not testable
3 to 8 = Severe trauma
9 to 12 = Moderate trauma
13 to 15 = Mild Trauma
ie_escala_glasgow_p = Only for glasgow 2018 scale
*/
BEGIN
ds_retorno_w	:= null;
if (qt_glasgow_p between 3 and 8) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(309290);-- severe brain dysfunction / injury
elsif (qt_glasgow_p between 9 and 12) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(309291); -- moderate brain dysfunction / injury
elsif (qt_glasgow_p between 13 and 14) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(309293); -- mild brain dysfunction / injury
elsif (qt_glasgow_p	= 15) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(309294); -- normal
elsif (qt_glasgow_p <= 0 and ie_escala_glasgow_p is  not null ) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(1130847); --Not testable
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_resultado_glasgow ( qt_glasgow_p bigint, ie_escala_glasgow_p text default null) FROM PUBLIC;

