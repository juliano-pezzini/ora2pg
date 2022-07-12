-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_initcap_var_classe_java (nm_classe_p text) RETURNS varchar AS $body$
DECLARE


nm_classe_w	varchar(2000);


BEGIN
if (nm_classe_p IS NOT NULL AND nm_classe_p::text <> '') then
	begin
	nm_classe_w := lower(substr(nm_classe_p,1,1)) || substr(nm_classe_p,2,length(nm_classe_p));
	end;
end if;
return nm_classe_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_initcap_var_classe_java (nm_classe_p text) FROM PUBLIC;

