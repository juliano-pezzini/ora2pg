-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_resultado (qt_pontucao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(50);


BEGIN
	if (qt_pontucao_p < 1 ) then
		ds_retorno_w := Wheb_mensagem_pck.get_texto(309663); --'Necessidade de tratamento ambulatorial';
	elsif (qt_pontucao_p < 3) then
		ds_retorno_w := Wheb_mensagem_pck.get_texto(309664); --'Necessidade de internação';
	elsif (qt_pontucao_p < 5) then
		ds_retorno_w := Wheb_mensagem_pck.get_texto(309665); --'Necessidade de internação urgente';
	end if;
	return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_resultado (qt_pontucao_p bigint) FROM PUBLIC;

