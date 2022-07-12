-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultimo_proc_agenda_cir ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_procedimento_w	varchar(254);


BEGIN

select	max(substr(obter_exame_agenda(cd_procedimento, ie_origem_proced, nr_seq_proc_interno),1,240))
into STRICT	ds_procedimento_w
from	agenda_paciente
where	to_date(to_char(dt_agenda,'dd/mm/yyyy')|| ' ' ||to_char(hr_inicio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') =
	(SELECT max(to_date(to_char(dt_agenda,'dd/mm/yyyy')|| ' ' ||to_char(hr_inicio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
	from 	agenda_paciente
	where	nr_atendimento = nr_atendimento_p
	and (cd_procedimento IS NOT NULL AND cd_procedimento::text <> ''))
and	nr_atendimento = nr_atendimento_p;

return	ds_procedimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultimo_proc_agenda_cir ( nr_atendimento_p bigint) FROM PUBLIC;
