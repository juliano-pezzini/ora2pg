-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pac_agenda_dia (nr_seq_agenda_p bigint, ie_status_p text, ie_exibir_status_atend_p text default 'S') RETURNS varchar AS $body$
DECLARE


cd_agenda_w		bigint;
dt_agenda_w		timestamp;
cd_pessoa_fisica_w	varchar(10);
ie_agenda_dia_w	varchar(1);


BEGIN
ie_agenda_dia_w := 'N';
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (ie_status_p IS NOT NULL AND ie_status_p::text <> '') and (ie_status_p in ('A','O','AC','AD')) then
	/* obter paciente agenda*/

	select	max(dt_agenda),
		coalesce(max(cd_pessoa_fisica),'0')
	into STRICT	dt_agenda_w,
		cd_pessoa_fisica_w
	from	agenda_paciente
	where	nr_sequencia = nr_seq_agenda_p;

	/* obter agendas pac dia */

	if (dt_agenda_w IS NOT NULL AND dt_agenda_w::text <> '') and (cd_pessoa_fisica_w <> '0') then
		if (ie_status_p = 'A') then
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_agenda_dia_w
			from	agenda_paciente
			where	trunc(dt_agenda,'dd') = trunc(dt_agenda_w)
			and	ie_status_agenda = 'N'
			and	coalesce(dt_chegada::text, '') = ''
			and	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	nr_sequencia <> nr_seq_agenda_p;
		elsif (ie_status_p = 'O') then
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_agenda_dia_w
			from	agenda_paciente
			where	trunc(dt_agenda,'dd') = trunc(dt_agenda_w)
			and	ie_status_agenda = 'A'
			and	coalesce(dt_atendimento::text, '') = ''
			and	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	nr_sequencia <> nr_seq_agenda_p;
		elsif (ie_status_p = 'AC') then
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_agenda_dia_w
			from	agenda_paciente
			where	trunc(dt_agenda,'dd') = trunc(dt_agenda_w)
			and	ie_status_agenda = 'N'
			and	coalesce(dt_confirmacao::text, '') = ''
			and	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	nr_sequencia <> nr_seq_agenda_p;
		elsif (ie_status_p = 'AD') then
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_agenda_dia_w
			from	agenda_paciente
			where	trunc(dt_agenda,'dd') = trunc(dt_agenda_w)
			and	ie_status_agenda = 'O'
			and	ie_exibir_status_atend_p = 'S'
			and	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	nr_sequencia <> nr_seq_agenda_p;
		end if;
	end if;
end if;

return ie_agenda_dia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pac_agenda_dia (nr_seq_agenda_p bigint, ie_status_p text, ie_exibir_status_atend_p text default 'S') FROM PUBLIC;
