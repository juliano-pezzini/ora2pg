-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_consistir_rozidio_exame ( nr_seq_item_p bigint, cd_medico_p text, dt_agenda_p timestamp, cd_agenda_p bigint, qt_dias_rodizio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text ) AS $body$
DECLARE

 
qt_prof_item_w		bigint;
qt_medico_w		bigint;
qt_medico_lib_w		bigint;
nm_medico_w		varchar(255);
cd_tipo_agenda_w	bigint;
ds_medico_w		varchar(255) := '';
nr_seq_proc_interno_w	bigint;
cd_medico_lib_w		varchar(10);
qt_livres_w			bigint;
	
--Consultas 
C01 CURSOR FOR 
	SELECT	distinct cd_pessoa_fisica, 
			substr(obter_nome_medico(cd_pessoa_fisica,'N'),1,255) 
	from	ageint_lib_usuario 
	where	nm_usuario		= nm_usuario_p 
	and		nr_seq_ageint_item 	= nr_seq_item_p 
	and		cd_agenda		= cd_agenda_p 
	and		cd_pessoa_fisica	<> cd_medico_p 
	and		Ageint_Obter_Se_Turno_Med_Rod(cd_pessoa_fisica, dt_agenda_p, cd_agenda_p, nm_usuario_p, nr_seq_medico_regra, cd_estabelecimento_p) = 'S' 
	order by 1;
	
--Exames	 
C02 CURSOR FOR 
	SELECT	distinct cd_pessoa_fisica, 
			substr(obter_nome_medico(cd_pessoa_fisica,'N'),1,255)			 
	from	ageint_lib_usuario 
	where	nm_usuario		= nm_usuario_p 
	and		nr_seq_ageint_item 	= nr_seq_item_p 
	--and	cd_agenda	 	= cd_agenda_p 
	and		cd_pessoa_fisica	<> cd_medico_p 
	and		Ageint_Obter_Se_Turno_Med_Rod(cd_pessoa_fisica, dt_agenda_p, cd_agenda_p, nm_usuario_p, nr_seq_medico_regra, cd_estabelecimento_p) = 'S' 
	order by 1;
	
	 

BEGIN 
 
if (coalesce(cd_agenda_p,0) > 0) then 
	select	max(cd_tipo_agenda) 
	into STRICT	cd_tipo_agenda_w 
	from	agenda 
	where	cd_agenda = cd_agenda_p;
end if;
 
select	count(*) 
into STRICT	qt_prof_item_w 
from	agenda_integrada_prof_item 
where	nr_seq_agenda_item = nr_seq_item_p;
 
select	max(nr_seq_proc_interno) 
into STRICT	nr_seq_proc_interno_w 
from	agenda_integrada_item 
where	nr_sequencia	= nr_seq_item_p;
 
 
if (qt_prof_item_w = 0) then	 
	if (coalesce(cd_tipo_agenda_w,2) = 2) then		 
		 
		select	count(*) + 1 
		into STRICT	qt_medico_w 
		from	agenda_paciente a, 
				agenda_integrada_item b, 
				agenda_medico c, 
				agenda	d 
		where	b.nr_seq_agenda_exame	= a.nr_sequencia 
		and		a.cd_medico_exec		= cd_medico_p 
		and		a.cd_medico_exec		= c.cd_medico 
		and		a.cd_agenda				= c.cd_agenda 
		and		a.cd_agenda				= d.cd_agenda 
		and		((a.nr_seq_proc_interno	= nr_seq_proc_interno_w) or (coalesce(nr_seq_proc_interno_w::text, '') = ''))		 
		--and	a.cd_agenda		= cd_agenda_p 
		and		coalesce(d.ie_rodizio_medico,'N') = 'S' 
		and		a.dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 86399/86400 
		and		(a.nm_paciente IS NOT NULL AND a.nm_paciente::text <> '') 
		and		a.ie_status_agenda not in ('C','F','B','L');				
		 
		open C02;
		loop 
		fetch C02 into	 
			cd_medico_lib_w, 
			nm_medico_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
						 
			select	count(*) 
			into STRICT	qt_medico_lib_w 
			from	agenda_paciente a, 
					agenda_integrada_item b, 
					agenda_medico c, 
					agenda d 
			where	b.nr_seq_agenda_exame	= a.nr_sequencia 
			and		a.cd_medico_exec	= cd_medico_lib_w 
			and		a.cd_medico_exec	= c.cd_medico 
			and		a.cd_agenda		= c.cd_agenda 
			and		a.cd_agenda		= d.cd_agenda 
			and		((a.nr_seq_proc_interno	= nr_seq_proc_interno_w) or (coalesce(nr_seq_proc_interno_w::text, '') = ''))			 
			--and	a.cd_agenda		= cd_agenda_p 
			and		coalesce(d.ie_rodizio_medico,'N') = 'S' 
			and		a.dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 86399/86400 
			and		(a.nm_paciente IS NOT NULL AND a.nm_paciente::text <> '') 
			and		a.ie_status_agenda not in ('C','F','B','L');
					 
			if	((qt_medico_w - qt_medico_lib_w) > qt_dias_rodizio_p)then 
				ds_medico_w	:= substr(ds_medico_w || nm_medico_w ||', ',1,255);
			end if;				
			 
			end;
		end loop;
		close C02;
	elsif (coalesce(cd_tipo_agenda_w,2) = 3) then 
		 
		select	count(*) + 1 
		into STRICT	qt_medico_w 
		from	agenda_consulta a, 
			agenda_integrada_item b, 
			agenda_medico c	 
		where	b.nr_seq_agenda_cons	= a.nr_sequencia 
		and	a.cd_medico_req		= cd_medico_p 
		and	a.cd_medico_req		= c.cd_medico 
		and	a.cd_agenda		= c.cd_agenda 
		and	a.cd_agenda		= cd_agenda_p 
		and	a.dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 86399/86400 
		and	(a.nm_paciente IS NOT NULL AND a.nm_paciente::text <> '') 
		and	a.ie_status_agenda not in ('C','F','B','L');
 
		open C01;
		loop 
		fetch C01 into	 
			cd_medico_lib_w, 
			nm_medico_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			 
			select	count(*) 
			into STRICT	qt_medico_lib_w 
			from	agenda_consulta a, 
				agenda_integrada_item b, 
				agenda_medico c	 
			where	b.nr_seq_agenda_cons	= a.nr_sequencia 
			and	a.cd_medico_req		= cd_medico_lib_w 
			and	a.cd_medico_req		= c.cd_medico 
			and	a.cd_agenda		= c.cd_agenda 
			and	a.cd_agenda		= cd_agenda_p 
			and	a.dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 86399/86400 
			and	(a.nm_paciente IS NOT NULL AND a.nm_paciente::text <> '') 
			and	a.ie_status_agenda not in ('C','F','B','L');
					 
			if	((qt_medico_w - qt_medico_lib_w) > qt_dias_rodizio_p) then 
				ds_medico_w	:= substr(ds_medico_w || nm_medico_w ||', ',1,255);
			end if;		
			end;
		end loop;
		close C01;
	end if;
end if;
 
commit;
 
ds_erro_p := substr(ds_medico_w,1,length(ds_medico_w)-2);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_consistir_rozidio_exame ( nr_seq_item_p bigint, cd_medico_p text, dt_agenda_p timestamp, cd_agenda_p bigint, qt_dias_rodizio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text ) FROM PUBLIC;

