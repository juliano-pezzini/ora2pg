-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultima_agenda_pf ( nr_seq_agenda_p bigint, cd_tipo_agenda_p bigint) RETURNS bigint AS $body$
DECLARE


dt_agenda_w	timestamp;
nr_sequencia_w	bigint;


BEGIN

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (cd_tipo_agenda_p IS NOT NULL AND cd_tipo_agenda_p::text <> '') then
	if (cd_tipo_agenda_p = 3) then
		/* Obter dados agenda atual */

		select	dt_agenda
		into STRICT	dt_agenda_w
		from	agenda_consulta
		where	nr_sequencia = nr_seq_agenda_p;

		/* Obter último agendamento */

		select	coalesce(max(b.nr_sequencia),0)
		into STRICT	nr_sequencia_w
		from	agenda_consulta b
		where	b.ie_status_agenda = 'E'
		and	b.dt_agenda < dt_agenda_w;

	elsif (cd_tipo_agenda_p = 2) then
		/* Obter dados agenda atual */

		select	hr_inicio
		into STRICT	dt_agenda_w
		from	agenda_paciente
		where	nr_sequencia = nr_seq_agenda_p;

		/* Obter último agendamento */

		select	coalesce(max(b.nr_sequencia),0)
		into STRICT	nr_sequencia_w
		from	agenda_paciente b
		where	b.ie_status_agenda = 'E'
		and	b.dt_agenda < dt_agenda_w;
	end if;
end if;

return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultima_agenda_pf ( nr_seq_agenda_p bigint, cd_tipo_agenda_p bigint) FROM PUBLIC;

