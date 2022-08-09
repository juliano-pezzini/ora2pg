-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_agenda_consulta () AS $body$
BEGIN
update	agenda_lista_espera
set	nr_seq_agecons  = NULL
where	nr_seq_agecons in (
		SELECT	a.nr_sequencia
		from	agenda_consulta a
		where	a.dt_agenda < clock_timestamp()
		and	a.ie_status_agenda = 'L'
		and	not exists (
				SELECT	1
				from	prescr_medica b
				where	a.nr_sequencia = b.nr_seq_agecons));

delete	from agenda_consulta a
where	a.dt_agenda < clock_timestamp()
and	a.ie_status_agenda = 'L'
and	not exists (
		SELECT	1
		from	prescr_medica b
		where	a.nr_sequencia = b.nr_seq_agecons);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_agenda_consulta () FROM PUBLIC;
