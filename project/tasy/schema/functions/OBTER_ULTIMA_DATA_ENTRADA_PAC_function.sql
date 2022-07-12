-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultima_data_entrada_pac (cd_pessoa_fisica_p text) RETURNS timestamp AS $body$
DECLARE

 
nr_Atendimento_w		bigint;	
dt_entrada_w			timestamp;
				
C01 CURSOR FOR 
	SELECT	dt_entrada 
	from	atendimento_paciente 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
	order by	dt_entrada;
				

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	dt_entrada_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;
 
return	dt_entrada_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultima_data_entrada_pac (cd_pessoa_fisica_p text) FROM PUBLIC;

