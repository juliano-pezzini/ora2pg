-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_resumo_cobranca (ie_tipo_data_p text, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


dt_retorno_w	varchar(255);


BEGIN

if (ie_tipo_data_p =  '0') then
	dt_retorno_w := to_char(dt_referencia_p,'MM/YYYY');
elsif (ie_tipo_data_p =  '1')  then
	dt_retorno_w := to_char(dt_referencia_p,'YYYY');
elsif (ie_tipo_data_p =  '2')  then
	dt_retorno_w := to_char(dt_referencia_p,'MM/YYYY');
elsif (ie_tipo_data_p =  '3')  then
	dt_retorno_w := to_char(dt_referencia_p,'YYYY');
elsif (ie_tipo_data_p =  '4')  then
	dt_retorno_w := to_char(dt_referencia_p,'DD/MM/YYYY');
end if;


return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_resumo_cobranca (ie_tipo_data_p text, dt_referencia_p timestamp) FROM PUBLIC;

