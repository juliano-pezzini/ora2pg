-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_grupo_desenvolvimento (nr_grupo_desenv_p bigint) RETURNS varchar AS $body$
DECLARE

	
ds_grupo_desenvolvimento_w	varchar(255);
sql_w varchar(500);	

BEGIN
if (nr_grupo_desenv_p IS NOT NULL AND nr_grupo_desenv_p::text <> '') then
	begin
    sql_w := 'select max(Substr(Obter_Desc_Expressao(Cd_Exp_Grupo, Ds_Grupo), 1, 255)) from CORP.GRUPO_DESENVOLVIMENTO@whebl01_dbcorp x  where x.nr_sequencia = :nr_grupo_desenv_p';
		EXECUTE sql_w into STRICT ds_grupo_desenvolvimento_w using nr_grupo_desenv_p;
	exception
	when program_error then
         ds_grupo_desenvolvimento_w := null;
        when others then
          null;
	end;
end if;

return ds_grupo_desenvolvimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_grupo_desenvolvimento (nr_grupo_desenv_p bigint) FROM PUBLIC;
