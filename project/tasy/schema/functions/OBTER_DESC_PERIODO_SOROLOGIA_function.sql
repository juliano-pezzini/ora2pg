-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_periodo_sorologia (ie_periodo_p text) RETURNS varchar AS $body$
DECLARE

ds_periodo_w	varchar(255);

BEGIN
if (ie_periodo_p = '1') then
	ds_periodo_w := Wheb_mensagem_pck.get_texto(1091213);
elsif (ie_periodo_p = '2') then
	ds_periodo_w := Wheb_mensagem_pck.get_texto(1091215);
elsif (ie_periodo_p = '3') then
	ds_periodo_w := Wheb_mensagem_pck.get_texto(1091216);
elsif (ie_periodo_p = 'P') then
	ds_periodo_w := Wheb_mensagem_pck.get_texto(1091218);
end if;


return	ds_periodo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_periodo_sorologia (ie_periodo_p text) FROM PUBLIC;

