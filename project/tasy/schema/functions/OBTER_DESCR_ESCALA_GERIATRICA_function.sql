-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descr_escala_geriatrica ( qt_pontuacao_p bigint) RETURNS varchar AS $body$
DECLARE

ds_pontucacao_w	varchar(255);
qt_pontuacao_w	bigint;

BEGIN

if (qt_pontuacao_p >= 0) and (qt_pontuacao_p <= 4) then
	ds_pontucacao_w := wheb_mensagem_pck.get_texto(308215); -- Normal
elsif (qt_pontuacao_p >= 5) and (qt_pontuacao_p <= 8) then
	ds_pontucacao_w := wheb_mensagem_pck.get_texto(308217); -- Leve
elsif (qt_pontuacao_p >= 9) and (qt_pontuacao_p <= 11) then
	ds_pontucacao_w := wheb_mensagem_pck.get_texto(308220); -- Moderado
elsif (qt_pontuacao_p >= 12) and (qt_pontuacao_p <= 15) then
	ds_pontucacao_w := wheb_mensagem_pck.get_texto(308222); -- Grave
end if;

return	ds_pontucacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descr_escala_geriatrica ( qt_pontuacao_p bigint) FROM PUBLIC;
