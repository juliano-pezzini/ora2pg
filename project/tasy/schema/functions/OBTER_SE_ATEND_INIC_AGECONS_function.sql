-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_inic_agecons ( nr_atendimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

			 
ds_retorno_w		varchar(10) := 'N';			
qt_agenda_w		bigint;
cd_agenda_w		bigint;
dt_consulta_agenda_w	timestamp;
dt_atendido_w		timestamp;


BEGIN 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
 
	select	count(*) 
	into STRICT	qt_agenda_w 
	from	agenda_consulta a 
	where	a.nr_atendimento = nr_atendimento_p;
	 
	if (qt_agenda_w > 0) then 
		begin 
		 
		select 	max(a.cd_agenda), 
			max(a.dt_consulta), 
			max(a.dt_atendido)			 
		into STRICT	cd_agenda_w, 
			dt_consulta_agenda_w, 
			dt_atendido_w 
		from	agenda_consulta a, 
			agenda b 
		where	nr_atendimento = nr_atendimento_p 
		and	a.cd_agenda = b.cd_agenda 
		and	dt_agenda = (SELECT min(dt_agenda) from agenda_consulta where nr_atendimento = nr_atendimento_p and coalesce(dt_atendido::text, '') = '') 
		and	coalesce(dt_atendido::text, '') = '';
		--and	b.cd_pessoa_fisica = Obter_Pf_Usuario(nm_usuario_p,'C'); 
 
		if (cd_agenda_w > 0) then 
			ds_retorno_w := 'S';
		end if;
		 
		end;
	end if;
 
end if;
 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_inic_agecons ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
