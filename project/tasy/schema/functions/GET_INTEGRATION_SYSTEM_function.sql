-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_integration_system () RETURNS varchar AS $body$
DECLARE


cd_integration_system_w		eclipse_parameters.cd_integration_system%type;


BEGIN

	select 	coalesce(max(cd_integration_system), 0) as integration_system
	into STRICT 	cd_integration_system_w
	from 	eclipse_parameters
	where cd_estabelecimento = obter_estabelecimento_ativo;

return cd_integration_system_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_integration_system () FROM PUBLIC;
