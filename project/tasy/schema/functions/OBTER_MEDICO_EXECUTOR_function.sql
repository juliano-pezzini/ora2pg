-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_executor (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

		
nm_medico_w		varchar(255) := null;	
ds_retorno_w		varchar(255);
cd_medico_agenda_w	bigint;
		
C01 CURSOR FOR
	SELECT	obter_nome_medico(a.cd_medico_exec,'N')
	from	prescr_procedimento a,
		prescr_medica b
	where	b.nr_atendimento = nr_atendimento_p
	and	a.nr_prescricao  = b.nr_prescricao
	and	(a.cd_medico_exec IS NOT NULL AND a.cd_medico_exec::text <> '');


BEGIN

open C01;
loop
fetch C01 into	
	nm_medico_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	ds_retorno_w  := nm_medico_w;
	
	end;
end loop;
close C01;

if (coalesce(nm_medico_w::text, '') = '') then

	select	coalesce(max(cd_medico_exec),0)
	into STRICT	cd_medico_agenda_w
	from 	agenda_paciente
	where	nr_atendimento  = nr_atendimento_p
	and	cd_agenda   = 2;
	
	if (cd_medico_agenda_w > 0 ) then
		
		select obter_nome_medico(cd_medico_agenda_w, 'N')
		into STRICT	nm_medico_w
		;
		
	end if;


end if;

ds_retorno_w := nm_medico_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_executor (nr_atendimento_p bigint) FROM PUBLIC;
