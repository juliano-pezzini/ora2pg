-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mantem_duracao_agenda (cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_agenda_p timestamp, nr_min_duracao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_manter_duracao_w	varchar(1) := 'N';


BEGIN
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (nr_min_duracao_p IS NOT NULL AND nr_min_duracao_p::text <> '') then
	select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_manter_duracao_w
	from	agenda_paciente
	where	cd_agenda = cd_agenda_p
	and	ie_status_agenda not in ('C','L','LF')
	--and	hr_inicio between dt_agenda_p and dt_agenda_p + nr_min_duracao_p / 1440;
	and	trunc(dt_agenda,'dd') = trunc(dt_agenda_p,'dd')
	and	hr_inicio > dt_agenda_p
	and	dt_agenda_p + nr_min_duracao_p / 1440 > hr_inicio;
end if;

return ie_manter_duracao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mantem_duracao_agenda (cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_agenda_p timestamp, nr_min_duracao_p bigint) FROM PUBLIC;

