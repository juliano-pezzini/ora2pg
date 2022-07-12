-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_pac_acesso_pep ( cd_paciente_p text, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

				 
ie_paciente_alta_w	varchar(5);


BEGIN 
 
 
if (nr_atendimento_p > 0) then 
	 
	begin 
	 
	select coalesce(max('AB'),'AL') 
	into STRICT	ie_paciente_alta_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p 
	and	coalesce(dt_alta::text, '') = '';
	exception 
		when others then 
		ie_paciente_alta_w	:= 'AL';
		end;
	 
	 
else 
	ie_paciente_alta_w := 'AL';
end if;
 
if (obter_se_paciente_obito(cd_paciente_p)	<> 'N') then 
	ie_paciente_alta_w	:= 'AM';
end if;
 
 
return	ie_paciente_alta_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_pac_acesso_pep ( cd_paciente_p text, nr_atendimento_p bigint) FROM PUBLIC;

