-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eis_registro_hospitalar_cancer (ie_parametro_p text) RETURNS bigint AS $body$
DECLARE

			 
ds_retorno_w	varchar(20);	
 
/* 
 18 -> <= 18 
19-> >= 19 
M -> ie_sexo = 'M' 
F-> ie_sexo = 'F' 
 
*/
		 
 

BEGIN 
 
if (ie_parametro_p IS NOT NULL AND ie_parametro_p::text <> '') then 
 
	if (ie_parametro_p = '18') then 
		SELECT 	COUNT(NR_SEQ) 
		into STRICT 	ds_retorno_w 
		FROM 	can_registro_hosp_cancer_v 
		WHERE 	qt_idade <= 18;
	elsif (ie_parametro_p = '19') then 
		SELECT 	COUNT(NR_SEQ) 
		into STRICT 	ds_retorno_w 
		FROM 	can_registro_hosp_cancer_v 
		WHERE 	qt_idade >= 19;
	elsif (ie_parametro_p = 'M') then 
		SELECT 	COUNT(NR_SEQ) 
		into STRICT 	ds_retorno_w 
		FROM 	can_registro_hosp_cancer_v 
		WHERE 	ie_sexo = 'M';
	elsif (ie_parametro_p = 'F') then	 
		SELECT 	COUNT(NR_SEQ) 
		into STRICT 	ds_retorno_w 
		FROM 	can_registro_hosp_cancer_v 
		WHERE 	ie_sexo = 'F';
	else 
		SELECT 	COUNT(NR_SEQ) 
		into STRICT 	ds_retorno_w 
		FROM 	can_registro_hosp_cancer_v;
	end if;
end if;
 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_registro_hospitalar_cancer (ie_parametro_p text) FROM PUBLIC;
