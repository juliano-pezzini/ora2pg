-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_consiste_data_laudo_apac ( cd_pessoa_fisica_p text, cd_procedimento_solic_p bigint) RETURNS varchar AS $body$
DECLARE

 
qt_reg_laudo_w	integer	:= 0;
ds_retorno_w	varchar(1)	:= 'N';


BEGIN 
 
select	count(*) 
into STRICT	qt_reg_laudo_w 
from	atendimento_paciente		b, 
	sus_laudo_paciente		a 
where	a.nr_atendimento		= b.nr_atendimento 
and	b.cd_pessoa_fisica		= cd_pessoa_fisica_p 
and	clock_timestamp() between a.dt_inicio_val_apac and a.dt_fim_val_apac;
 
if (qt_reg_laudo_w > 0) then 
	begin 
	select	count(*) 
	into STRICT	qt_reg_laudo_w 
	from	atendimento_paciente		b, 
		sus_laudo_paciente		a 
	where	a.nr_atendimento		= b.nr_atendimento 
	and	b.cd_pessoa_fisica		= cd_pessoa_fisica_p 
	and	a.cd_procedimento_solic		= cd_procedimento_solic_p 
	and	exists (SELECT 	1 
			from	sus_procedimento p 
			where	p.cd_procedimento = a.cd_procedimento_solic 
			and	p.ie_origem_proced = a.ie_origem_proced) 
	and	clock_timestamp() between a.dt_inicio_val_apac and a.dt_fim_val_apac;
	 
	if (qt_reg_laudo_w	> 0) then 
		ds_retorno_w	:= 'S';	
	end if;	
	end;
end if;
 
return	ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_consiste_data_laudo_apac ( cd_pessoa_fisica_p text, cd_procedimento_solic_p bigint) FROM PUBLIC;
