-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_agendamento ( nr_seq_agenda_p bigint) RETURNS timestamp AS $body$
DECLARE

 
dt_agendamento_w	timestamp;


BEGIN 
 
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then 
 
	select	hr_inicio 
	into STRICT	dt_agendamento_w 
	from	agenda_paciente 
	where	nr_sequencia = nr_seq_agenda_p 
	and	obter_tipo_agenda(cd_agenda) = 1;
 
end if;
 
return dt_agendamento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_agendamento ( nr_seq_agenda_p bigint) FROM PUBLIC;

