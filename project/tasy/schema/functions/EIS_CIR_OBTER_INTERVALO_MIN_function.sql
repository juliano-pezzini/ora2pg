-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eis_cir_obter_intervalo_min ( qt_minuto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(100);


BEGIN

if ((substr(to_char(qt_minuto_p),length(to_char(qt_minuto_p)),1))::numeric  < 6) and (qt_minuto_p > 0) and (qt_minuto_p < 99995) then
	select	lpad(substr(to_char(qt_minuto_p),1,length(to_char(qt_minuto_p))-1) || '0',5,'0') || ' - ' ||
		lpad(substr(to_char(qt_minuto_p),1,length(to_char(qt_minuto_p))-1) || '5',5,'0')
	into STRICT	ds_retorno_w
	;
elsif (qt_minuto_p > 0) and (qt_minuto_p < 99995) then
	select	lpad(substr(to_char(qt_minuto_p),1,length(to_char(qt_minuto_p))-1) || '6',5,'0') || ' - ' ||
		lpad(to_char((substr(to_char(qt_minuto_p),1,length(to_char(qt_minuto_p))-1) || '6')::numeric  + 4),5,'0')
	into STRICT	ds_retorno_w
	;
--elsif	(qt_minuto_p = 0) then
--	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308384); -- Menos que 1
--elsif	(qt_minuto_p < 0) then
--	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308385); -- Menores de 0
elsif (qt_minuto_p > 99995) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308386); --  Maiores de 99995
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_cir_obter_intervalo_min ( qt_minuto_p bigint) FROM PUBLIC;

