-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION dpc_pkg.get_number_times_control (nr_atendimento_p atendimento_paciente.nr_atendimento%type ) RETURNS bigint AS $body$
DECLARE

		
cd_pessoa_fisica_w	atendimento_paciente.cd_pessoa_fisica%type;	
dt_entrada_w		atendimento_paciente.dt_entrada%type;
qt_number_times_w	bigint;
qt_aux_w		bigint;


BEGIN
qt_number_times_w := 0;

select 	cd_pessoa_fisica,
	dt_entrada
into STRICT	cd_pessoa_fisica_w,
	dt_entrada_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p;


--Verify if there is more than one encounter in the same day for this patient
select 	count(1)
into STRICT	qt_aux_w
from   	atendimento_paciente
where   cd_pessoa_fisica = cd_pessoa_fisica_w
and    	nr_atendimento <> nr_atendimento_p
and    	trunc(dt_entrada,'dd') = trunc(dt_entrada_w,'dd');

--If there is more than one encounter for this patient in the same day, verify what is the encounter in this day (1,2,3)
if (qt_aux_w > 0) then
	begin
	/*
	Example: Patient (person code: 5640010, encounter: 3449098) has 3 encounters in the same day 03/Mar/2021 of the current encounter:
	Encounter  Entry date and time                           result
	3449097 - 03/03/2021 08:12:43  will return 0+1 = 1
	3449098 - 03/03/2021 08:24:06  will return 1+1 = 2
	3448918 - 03/03/2021 09:05:15   will return 2+1 = 3
	*/
	select 	count(1)
	into STRICT	qt_aux_w
	from   	atendimento_paciente
	where  	cd_pessoa_fisica = cd_pessoa_fisica_w
	and    	nr_atendimento <> nr_atendimento_p
	and    	dt_entrada < dt_entrada_w
	and    	trunc(dt_entrada,'dd') = trunc(dt_entrada_w,'dd');
	
	qt_number_times_w := qt_aux_w + 1;
	end;
end if;

return qt_number_times_w;
end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dpc_pkg.get_number_times_control (nr_atendimento_p atendimento_paciente.nr_atendimento%type ) FROM PUBLIC;