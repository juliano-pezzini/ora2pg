-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_escala_curb65 ( qt_score_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(100);


BEGIN

if (qt_score_p >= 0 and qt_score_p <= 1) then

	ds_retorno_w	:=  wheb_mensagem_pck.get_texto(309772); -- Low
elsif (qt_score_p = 2 ) then

	ds_retorno_w	:= wheb_mensagem_pck.get_texto(293930); -- Moderate
  elsif (qt_score_p >= 3 and qt_score_p <= 5) then

	ds_retorno_w	:= wheb_mensagem_pck.get_texto(1046944); -- High
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_escala_curb65 ( qt_score_p bigint) FROM PUBLIC;

