-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estadia_paciente (nr_seq_episodio_p bigint ) RETURNS bigint AS $body$
DECLARE

 
qt_estadia_paciente_w		bigint := 0;

nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
dt_entrada_w				atendimento_paciente.dt_entrada%type;
dt_alta_w					atendimento_paciente.dt_alta%type;

dt_episodio_w				episodio_paciente.dt_episodio%type;
				

BEGIN 
 
select	max(nr_atendimento) 
into STRICT	nr_atendimento_w 
from	atendimento_paciente a 
where  a.nr_seq_episodio = nr_seq_episodio_p;
 
if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
 
	select	trunc(dt_entrada), 
			trunc(coalesce(dt_alta, clock_timestamp())) 
	into STRICT	dt_entrada_w, 
			dt_alta_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_w;
 
 
	qt_estadia_paciente_w := (dt_alta_w - dt_entrada_w);
 
end if;
 
return	qt_estadia_paciente_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estadia_paciente (nr_seq_episodio_p bigint ) FROM PUBLIC;

