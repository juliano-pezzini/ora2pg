-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_obs_turno (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
nr_seq_horario_w	bigint;
nr_seq_esp_w	bigint;


BEGIN

select	max(nr_seq_horario),
	max(nr_seq_esp)
into STRICT	nr_seq_horario_w,
	nr_seq_esp_w
from	agenda_paciente
where	nr_sequencia = nr_seq_agenda_p;

if (nr_seq_horario_w IS NOT NULL AND nr_seq_horario_w::text <> '') then
	select	substr(max(ds_observacao),1,255)
	into STRICT	ds_retorno_w
	from	agenda_horario
	where	nr_sequencia = nr_seq_horario_w;
elsif (nr_seq_esp_w IS NOT NULL AND nr_seq_esp_w::text <> '') then
	select	substr(max(ds_observacao),1,255)
	into STRICT	ds_retorno_w
	from	agenda_horario_esp
	where	nr_sequencia = nr_seq_esp_w;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_obs_turno (nr_seq_agenda_p bigint) FROM PUBLIC;

