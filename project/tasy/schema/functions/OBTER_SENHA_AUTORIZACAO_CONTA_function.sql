-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_senha_autorizacao_conta (nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE

			 
cd_autorizacao_w	varchar(20);
nr_atendimento_w	bigint;
cd_senha_w		varchar(20);
			

BEGIN 
 
if (coalesce(nr_interno_conta_p,0) > 0) then 
 
	select	max(cd_autorizacao), 
		max(nr_atendimento) 
	into STRICT	cd_autorizacao_w, 
		nr_atendimento_w 
	from	conta_paciente 
	where	nr_interno_conta = nr_interno_conta_p;
	 
	if (cd_autorizacao_w IS NOT NULL AND cd_autorizacao_w::text <> '') then 
		 
		select	max(cd_senha) 
		into STRICT	cd_senha_w 
		from	autorizacao_convenio 
		where	cd_autorizacao = cd_autorizacao_w 
		and	nr_atendimento = nr_atendimento_w;
		 
	end if;
 
end if;
 
return	cd_senha_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_senha_autorizacao_conta (nr_interno_conta_p bigint) FROM PUBLIC;
