-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_resul_baros ( qt_pontos_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(20);

BEGIN
if (qt_pontos_p <= 1) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308229); -- Incapaz
elsif (qt_pontos_p > 1) and (qt_pontos_p <= 3) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308230); -- Razoável
elsif (qt_pontos_p > 3) and (qt_pontos_p <= 5) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308231); -- Bom
elsif (qt_pontos_p > 5) and (qt_pontos_p <= 7) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308233); -- Muito bom
elsif (qt_pontos_p > 7) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308235); -- Excelente
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_resul_baros ( qt_pontos_p bigint) FROM PUBLIC;

