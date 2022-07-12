-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_outro_usuario ( cd_agenda_p bigint, dt_agenda_p timestamp, nr_minuto_duracao_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


qt_marc_cons_w	bigint;
qt_marc_exame_w	bigint;
ds_retorno_w	varchar(1)	:= 'N';


BEGIN

select	count(*)
into STRICT	qt_marc_exame_w
FROM agenda_integrada_item c, ageint_marcacao_usuario a
LEFT OUTER JOIN agenda_paciente b ON (a.nr_seq_agenda = b.nr_sequencia)
WHERE a.cd_agenda = cd_agenda_p and a.nr_seq_Ageint_item	= c.nr_sequencia and c.ie_tipo_agendamento	= 'E'  and coalesce(b.ie_status_agenda,'L') <> 'C' and a.nm_usuario <> nm_usuario_p and (a.hr_agenda between dt_agenda_p and dt_agenda_p + (nr_minuto_duracao_p - 1) / 1440);


select	count(*)
into STRICT	qt_marc_cons_w
FROM agenda_integrada_item c, ageint_marcacao_usuario a
LEFT OUTER JOIN agenda_consulta b ON (a.nr_seq_agenda = b.nr_sequencia)
WHERE a.cd_agenda = cd_agenda_p and a.nr_seq_Ageint_item	= c.nr_sequencia and c.ie_tipo_agendamento	<> 'E'  and coalesce(b.ie_status_agenda,'L') <> 'C' and a.nm_usuario <> nm_usuario_p and (a.hr_agenda between dt_agenda_p and dt_agenda_p + (nr_minuto_duracao_p - 1) / 1440);

if (qt_marc_exame_w	> 0) or (qt_marc_cons_w		> 0) then
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_outro_usuario ( cd_agenda_p bigint, dt_agenda_p timestamp, nr_minuto_duracao_p bigint, nm_usuario_p text) FROM PUBLIC;
