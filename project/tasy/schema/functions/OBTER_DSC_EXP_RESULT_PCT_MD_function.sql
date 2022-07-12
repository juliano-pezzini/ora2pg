-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dsc_exp_result_pct_md (qt_pct_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w   varchar(255);

BEGIN

if (qt_pct_p < 70) then
	ds_retorno_w 	:=  obter_desc_expressao(492459);
elsif (qt_pct_p between 70 and 80) then	
	ds_retorno_w 	:=  obter_desc_expressao(488186);
elsif (qt_pct_p between 80 and 90) then	
	ds_retorno_w 	:=  obter_desc_expressao(488185);
elsif (qt_pct_p between 90 and 110) then	
	ds_retorno_w 	:= obter_desc_expressao(347463);
elsif (qt_pct_p between 110 and 120) then	
	ds_retorno_w 	:= obter_desc_expressao(488188);
elsif (qt_pct_p > 120) then	
	ds_retorno_w 	:= obter_desc_expressao(294557);
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dsc_exp_result_pct_md (qt_pct_p bigint) FROM PUBLIC;
