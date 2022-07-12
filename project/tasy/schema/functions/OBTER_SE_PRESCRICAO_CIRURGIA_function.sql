-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prescricao_cirurgia ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_agenda_w		prescr_medica.nr_seq_agenda%type;
ie_cirurgia_w		varchar(1);


BEGIN

if (coalesce(nr_prescricao_p,0) > 0) then
	select	coalesce(max('S'),'N')
	into STRICT	ie_cirurgia_w
	from 	cirurgia
	where	nr_prescricao = nr_prescricao_p;
	
	if (ie_cirurgia_w	= 'N') then
	
		select	max(nr_seq_agenda)
		into STRICT	nr_seq_agenda_w
		from	prescr_medica
		where	nr_prescricao	= nr_prescricao_p;
		
		if (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
			
			select	coalesce(max('S'),'N')
			into STRICT	ie_cirurgia_w
			from	agenda a,
					agenda_paciente b
			where	a.cd_agenda = b.cd_agenda
			and		b.nr_sequencia = nr_seq_agenda_w
			and		a.cd_tipo_agenda = 1;

		end if;
	end if;
end if;

return	ie_cirurgia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prescricao_cirurgia ( nr_prescricao_p bigint) FROM PUBLIC;
