-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_escala_sadd (qt_pontos_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255) := '';


BEGIN
if (qt_pontos_p >= 1) and (qt_pontos_p < 	10) then
	ds_retorno_w := wheb_mensagem_pck.get_texto(307934); -- Dependência leve
elsif (qt_pontos_p >= 10) and (qt_pontos_p < 	20) then
	ds_retorno_w := wheb_mensagem_pck.get_texto(307935); -- Dependência moderada
elsif (qt_pontos_p >= 20) and (qt_pontos_p <= 45) then
	ds_retorno_w := wheb_mensagem_pck.get_texto(307936); -- Dependência Grave
else
	ds_retorno_w := wheb_mensagem_pck.get_texto(307937); -- Sem dependência
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_escala_sadd (qt_pontos_p bigint) FROM PUBLIC;
