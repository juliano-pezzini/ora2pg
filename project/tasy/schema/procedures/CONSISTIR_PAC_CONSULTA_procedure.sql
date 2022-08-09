-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_pac_consulta ( cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_agenda_p timestamp, nr_seq_consulta_p INOUT bigint) AS $body$
DECLARE


nr_seq_agenda_w		agenda_consulta.nr_sequencia%type := 0;


BEGIN

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') then
	begin
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_agenda_w
	from	agenda_consulta
	where	trunc(dt_agenda,'dd') = trunc(dt_agenda_p)
	and	cd_agenda = cd_agenda_p
	and	ie_status_agenda = 'O'
	and	(dt_consulta IS NOT NULL AND dt_consulta::text <> '')
	and	(nr_atendimento IS NOT NULL AND nr_atendimento::text <> '')
	and	nr_sequencia <> nr_seq_agenda_p;
	
	end;	
end if;

if (nr_seq_agenda_w > 0) then
	nr_seq_consulta_p	:= nr_seq_agenda_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_pac_consulta ( cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_agenda_p timestamp, nr_seq_consulta_p INOUT bigint) FROM PUBLIC;
