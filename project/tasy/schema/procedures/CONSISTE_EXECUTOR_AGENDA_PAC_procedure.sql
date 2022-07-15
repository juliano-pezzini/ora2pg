-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_executor_agenda_pac (nr_seq_agenda_p bigint, cd_medico_exec_p text, ds_consistencia_p INOUT text) AS $body$
DECLARE

 
ds_consistencia_w	varchar(255) := '';
dt_agenda_pac_w		timestamp;
dt_agenda_final_w	timestamp;
cd_medico_exec_w	varchar(10);
cd_agenda_w		bigint;
qt_agenda_w		integer;
qt_bloqueio_w		integer;
qt_bloq_w		integer;
qt_livre_inicial_w	integer;
qt_livre_final_w	integer;
qt_dia_semana_w		varchar(10);
hr_inicial_w		varchar(20);
hr_final_w		varchar(20);
hr_inicial_turno_w	varchar(20);
hr_final_turno_w	varchar(20);
ie_ordem_w		bigint;
cd_agenda_exame_w	bigint;
ie_consiste_agecons_w	varchar(01);
cd_estabelecimento_w	bigint;
nm_usuario_w		varchar(15);

 
c01 CURSOR FOR	 
	SELECT	1, 
		to_char(hr_inicial, 'hh24:mi:ss'), 
		to_char(hr_final, 'hh24:mi:ss') 
	from	agenda_turno 
	where	cd_agenda	= cd_agenda_w 
	and	ie_dia_semana	= 9 
	
union
 
	SELECT	9, 
		to_char(hr_inicial, 'hh24:mi:ss'), 
		to_char(hr_final, 'hh24:mi:ss') 
	from	agenda_turno 
	where	cd_agenda	= cd_agenda_w 
	and	ie_dia_semana	= qt_dia_semana_w 
	order by 1;	
 

BEGIN 
 
select	max(to_date(to_char(a.dt_agenda, 'dd/mm/yyyy') || ' ' || 
		to_char(a.hr_inicio, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')), 
	max(to_date(to_char(a.dt_agenda, 'dd/mm/yyyy') || ' ' || 
		to_char(a.hr_inicio + a.nr_minuto_duracao/1440, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')), 
	max(a.cd_agenda), 
	max(b.cd_estabelecimento), 
	max(a.nm_usuario) 
into STRICT	dt_agenda_pac_w, 
	dt_agenda_final_w, 
	cd_agenda_exame_w, 
	cd_estabelecimento_w, 
	nm_usuario_w 
from	agenda b, agenda_paciente a 
where	a.nr_sequencia	= nr_seq_agenda_p 
and	a.cd_agenda	= b.cd_agenda;
 
 
select	coalesce(max(obter_valor_param_usuario(39, 97, obter_perfil_ativo, nm_usuario_w, cd_estabelecimento_w)), 'S') 
into STRICT	ie_consiste_agecons_w
;
 
 
if (cd_medico_exec_p IS NOT NULL AND cd_medico_exec_p::text <> '') and (ie_consiste_agecons_w = 'S') then 
	begin 
 
	select	coalesce(max(cd_agenda),0) 
	into STRICT	cd_agenda_w 
	from	agenda 
	where	cd_pessoa_fisica	= cd_medico_exec_p 
	and	cd_tipo_agenda		= 3;
 
 
	if (cd_agenda_w > 0) then 
		begin 
 
		select	count(*) 
		into STRICT	qt_bloq_w 
		from	agenda_bloqueio 
		where	cd_agenda	= cd_agenda_exame_w 
		and	dt_inicial >= dt_agenda_pac_w 
		and 	dt_inicial <= dt_agenda_final_w;
 
 
		if (qt_bloq_w > 0) then 
			ds_consistencia_w	:= Wheb_mensagem_pck.get_texto(306362); -- 'Existem agendas bloqueadas nesse horário!'; 
		end if;
 
 
		select	count(*) 
		into STRICT	qt_agenda_w 
		from	agenda_consulta 
		where	cd_agenda	= cd_agenda_w 
		and	dt_agenda between dt_agenda_pac_w and dt_agenda_final_w - 86400/86399 
		and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '');
 
 
		if (qt_agenda_w > 0) then 
			ds_consistencia_w	:= Wheb_mensagem_pck.get_texto(306363); -- 'Existe uma agenda marcada para este médico neste horário!'; 
		end if;
 
		select	count(*) 
		into STRICT	qt_bloqueio_w 
		from	agenda_consulta 
		where	cd_agenda	= cd_agenda_w 
		and	dt_agenda between dt_agenda_pac_w and dt_agenda_final_w 
		and	ie_status_agenda	= 'B';
 
		if (qt_bloqueio_w > 0) then 
			ds_consistencia_w	:= Wheb_mensagem_pck.get_texto(306364); -- 'Existe uma agenda bloqueada para este médico neste horário!'; 
		end if;
 
 
		select	pkg_date_utils.get_WeekDay(dt_agenda_pac_w), 
			to_char(dt_agenda_pac_w, 'hh24:mi:ss'), 
			to_char(dt_agenda_final_w, 'hh24:mi:ss') 
		into STRICT	qt_dia_semana_w, 
			hr_inicial_w, 
			hr_final_w 
		;		
 
		open	c01;
		loop 
		fetch	c01 into 
			ie_ordem_w, 
			hr_inicial_turno_w, 
			hr_final_turno_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */	
			begin					 
 
			qt_livre_inicial_w	:= 0;
			qt_livre_final_w	:= 0;
 
			end;
		end loop;
		close c01;
 
		if (hr_inicial_w > hr_inicial_turno_w) and (hr_inicial_w < hr_final_turno_w) then 
			qt_livre_inicial_w	:= 1;
		end if;
		 
 
		if (hr_final_w > hr_inicial_turno_w) and (hr_final_w < hr_final_turno_w) then 
			qt_livre_final_w	:= 1;
		end if;
 
		if (qt_livre_inicial_w = 1) or (qt_livre_final_w = 1) then 
			ds_consistencia_w	:= Wheb_mensagem_pck.get_texto(306366); -- 'O horário selecionado está no turno da agenda consulta!'; 
		end if;
 
 
		end;
	end if;
 
	end;
end if;
 
ds_consistencia_p	:= ds_consistencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_executor_agenda_pac (nr_seq_agenda_p bigint, cd_medico_exec_p text, ds_consistencia_p INOUT text) FROM PUBLIC;

