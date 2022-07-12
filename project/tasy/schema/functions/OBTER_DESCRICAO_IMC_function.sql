-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_imc ( qt_imc_p bigint) RETURNS varchar AS $body$
DECLARE


ds_imc_w	varchar(400);

BEGIN
	if (qt_imc_p < 16.1)then
	ds_imc_w := Wheb_mensagem_pck.get_texto(309014); --'Magreza grau III';
	elsif (qt_imc_p > 16) and (qt_imc_p < 17)then
	ds_imc_w := Wheb_mensagem_pck.get_texto(309015); --'Magreza grau II';
	elsif (qt_imc_p > 17) and (qt_imc_p < 18.5)then
	ds_imc_w := Wheb_mensagem_pck.get_texto(309016); --'Magreza grau I';
	elsif (qt_imc_p > 18.4) and (qt_imc_p < 25)then
	ds_imc_w := Wheb_mensagem_pck.get_texto(309018); --'Eutrofia';
	elsif (qt_imc_p > 24.9) and (qt_imc_p < 30)then
	ds_imc_w := Wheb_mensagem_pck.get_texto(309138); --'Pré-obeso';
	elsif (qt_imc_p > 29.9) and (qt_imc_p < 35)then
	ds_imc_w := Wheb_mensagem_pck.get_texto(309020); --'Obseidade grau I';
	elsif (qt_imc_p > 34.9) and (qt_imc_p < 40)then
	ds_imc_w := Wheb_mensagem_pck.get_texto(309021); --'Obseidade grau II';
	elsif (qt_imc_p > 39.9)then
	ds_imc_w := Wheb_mensagem_pck.get_texto(309022); --'Obseidade grau III';
	end if;

return	ds_imc_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_imc ( qt_imc_p bigint) FROM PUBLIC;

