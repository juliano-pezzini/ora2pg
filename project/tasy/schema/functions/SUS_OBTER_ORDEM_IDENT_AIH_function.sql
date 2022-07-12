-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_ordem_ident_aih (ie_identificacao_p text) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	smallint;


BEGIN

if (ie_identificacao_p = '01') then
	vl_retorno_w := 1;
elsif (ie_identificacao_p = '05') then
	vl_retorno_w := 2;
elsif (ie_identificacao_p = '03') then
	vl_retorno_w := 3;
elsif (ie_identificacao_p = '04') then
	vl_retorno_w := 4;
elsif (ie_identificacao_p = '07') then
	vl_retorno_w := 5;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_ordem_ident_aih (ie_identificacao_p text) FROM PUBLIC;

