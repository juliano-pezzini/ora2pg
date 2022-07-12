-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_cd_leiaute_ecd ( dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w				ctb_regra_sped.cd_versao%type;

BEGIN
if (dt_referencia_p >= to_date('01/01/2020','dd/mm/yyyy')) then
	begin
	ds_retorno_w := '9.0';
	end;
elsif (dt_referencia_p >= to_date('01/01/2019','dd/mm/yyyy')) then
	begin
	ds_retorno_w := '8.0';
	end;	
elsif (dt_referencia_p >= to_date('01/01/2018','dd/mm/yyyy')) then
	begin
	ds_retorno_w := '7.0';
	end;
elsif (dt_referencia_p >= to_date('01/01/2017','dd/mm/yyyy')) then
	begin
	ds_retorno_w := '6.0';
	end;
elsif (dt_referencia_p >= to_date('01/01/2016','dd/mm/yyyy')) then
	begin
	ds_retorno_w := '5.0';
	end;
elsif (dt_referencia_p >= to_date('01/01/2015','dd/mm/yyyy')) then
	begin
	ds_retorno_w := '4.0';
	end;
elsif (dt_referencia_p >= to_date('01/01/2014','dd/mm/yyyy')) then
	begin
	ds_retorno_w := '3.0';
	end;
elsif (dt_referencia_p >= to_date('01/01/2013','dd/mm/yyyy')) then
	begin
	ds_retorno_w := '2.0';
	end;
else
	begin
	ds_retorno_w := '1.0';
	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_cd_leiaute_ecd ( dt_referencia_p timestamp) FROM PUBLIC;

