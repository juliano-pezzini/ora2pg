-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sismama_obter_se_laudo_pac (nr_sequencia_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w 		varchar(10);


BEGIN 
 
begin 
select	coalesce(max('S'),'N') 
into STRICT	ds_retorno_w 
from	sismama_atendimento a 
where	a.nr_sequencia 	= nr_sequencia_p 
and	a.nr_atendimento 	in (	SELECT	b.nr_atendimento 
				from	atendimento_paciente b 
				where	b.cd_pessoa_fisica = cd_pessoa_fisica_p);
exception 
	when others then 
	ds_retorno_w := 'N';
	end;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sismama_obter_se_laudo_pac (nr_sequencia_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

