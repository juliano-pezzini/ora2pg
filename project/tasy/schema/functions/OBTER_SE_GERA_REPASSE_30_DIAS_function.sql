-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gera_repasse_30_dias (nr_seq_procedimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
cd_medico_executor_w	varchar(10);				
nr_atendimento_w	bigint;
nr_atendimento_ant_w	bigint;
dt_entrada_w		timestamp;
ds_retorno_w		integer;
cd_pessoa_fisica_w	varchar(10);

BEGIN
/*	0 - Gera repasse 
	1 - Não gera 
*/
 
ds_retorno_w	:= 0;
			 
select 	max(a.cd_medico_executor), 
	max(a.nr_atendimento), 
	max(b.cd_pessoa_fisica) 
into STRICT	cd_medico_executor_w, 
	nr_atendimento_w, 
	cd_pessoa_fisica_w 
from 	procedimento_paciente a, 
	conta_paciente c, 
	atendimento_paciente b 
where	a.nr_interno_conta = c.nr_interno_conta 
and	c.nr_atendimento = b.nr_atendimento 
and 	a.nr_sequencia = nr_seq_procedimento_p;
 
 
if (nr_atendimento_w > 0) then 
	 
	select 	max(a.nr_atendimento) 
	into STRICT 	nr_atendimento_ant_w 
	from 	procedimento_paciente a, 
		conta_paciente c, 
		atendimento_paciente b 
	where	a.nr_interno_conta = c.nr_interno_conta 
	and	c.nr_atendimento = b.nr_atendimento 
	and 	a.cd_medico_executor = cd_medico_executor_w 
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	a.nr_atendimento < nr_atendimento_w;
	 
	if (nr_atendimento_ant_w > 0) then 
	 
		select 	coalesce(dt_entrada, clock_timestamp()) 
		into STRICT	dt_entrada_w 
		from	atendimento_paciente 
		where 	nr_atendimento = nr_atendimento_ant_w;
		 
		if ((dt_entrada_w) >= (clock_timestamp() - interval '30 days')) then 
		 
			ds_retorno_w	:= 1;	
			 
		end if;
	 
	end if;
 
 
end if;
 
return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gera_repasse_30_dias (nr_seq_procedimento_p bigint) FROM PUBLIC;
