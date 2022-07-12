-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_faixa_etaria_rdc_unimed ( nr_numero_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p

C - Código
*/
ds_retorno_w		varchar(2);


BEGIN

if (ie_opcao_p = 'C') then
	if (nr_numero_p between 0 and 18) then
		ds_retorno_w	:= '1';
	elsif (nr_numero_p between 19 and 23) then
		ds_retorno_w	:= '2';
	elsif (nr_numero_p between 24 and 28) then
		ds_retorno_w	:= '3';
	elsif (nr_numero_p between 29 and 33) then
		ds_retorno_w	:= '4';
	elsif (nr_numero_p between 34 and 38) then
		ds_retorno_w	:= '5';
	elsif (nr_numero_p between 39 and 43) then
		ds_retorno_w	:= '6';
	elsif (nr_numero_p between 44 and 48) then
		ds_retorno_w	:= '7';
	elsif (nr_numero_p between 49 and 53) then
		ds_retorno_w	:= '8';
	elsif (nr_numero_p between 54 and 58) then
		ds_retorno_w	:= '9';
	elsif (nr_numero_p	>= 59) then
		ds_retorno_w	:= '10';
	end if;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_faixa_etaria_rdc_unimed ( nr_numero_p bigint, ie_opcao_p text) FROM PUBLIC;
