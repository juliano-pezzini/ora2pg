-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_mp_dose_form ( cd_codigo_ifa_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(150);


BEGIN

	select max(ds_nome_amigavel)
	into STRICT ds_retorno_w	
	from forma_dosagem_ger
	where cd_codigo_ifa = cd_codigo_ifa_p;
   
return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_mp_dose_form ( cd_codigo_ifa_p text) FROM PUBLIC;

