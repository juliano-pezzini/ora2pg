-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_mig_benef_resc ( dt_rescisao_p timestamp, dt_migracao_p timestamp, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

			 
qt_dias_rescisao_mig_w		bigint;


BEGIN 
 
if (coalesce(dt_rescisao_p::text, '') = '') then 
	return 'S';
else 
	select	coalesce(max(qt_dias_rescisao_mig),0) 
	into STRICT	qt_dias_rescisao_mig_w 
	from	pls_parametros 
	where	cd_estabelecimento = cd_estabelecimento_p;
	 
	if 	((dt_rescisao_p IS NOT NULL AND dt_rescisao_p::text <> '') and ((trunc(dt_rescisao_p,'dd') + qt_dias_rescisao_mig_w) >= trunc(dt_migracao_p,'dd'))) then 
		return 'S';
	else 
		return 'N';
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_mig_benef_resc ( dt_rescisao_p timestamp, dt_migracao_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;
