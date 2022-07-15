-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_regra_qtd_med_espec (nr_seq_item_p bigint, cd_medico_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

 
				   
cd_especialidade_w	integer;
cd_medico_w		varchar(10);
nr_seq_grupo_selec_w	bigint;
qt_prof_item_w		bigint;
qt_medico_w		bigint;
qt_medico_lib_w		bigint;
nr_seq_regra_qtd_w	bigint;
qt_dif_maxima_w		bigint;
nm_medico_w		varchar(255);

ds_medico_w		varchar(255) := '';

cd_medico_lib_w		varchar(10);

qt_dias_w		bigint;
nr_seq_medico_regra_w	bigint;
nr_seq_grupo_w		bigint;
	
C01 CURSOR FOR 
	SELECT	distinct a.cd_pessoa_fisica, 
		substr(obter_nome_medico(a.cd_pessoa_fisica,'N'),1,255) 
	FROM ageint_lib_usuario a, agenda_medico b
LEFT OUTER JOIN ageint_medico_regra c ON (b.nr_seq_medico_Regra = c.nr_sequencia)
WHERE a.nm_usuario		= nm_usuario_p and a.nr_seq_ageint_item 	= nr_seq_item_p and a.cd_pessoa_fisica	<> cd_medico_p and a.cd_agenda		= b.cd_agenda and a.cd_pessoa_fisica	= b.cd_medico  and c.nr_seq_grupo		= nr_seq_grupo_w and exists (SELECT	1 
			from 	ageint_horarios_usuario x 
			where 	x.cd_agenda = a.cd_agenda 
			and 	x.cd_pessoa_fisica = b.cd_medico 
			and	x.cd_pessoa_fisica <> cd_medico_p 
			and	x.ie_status_agenda = 'L' 
			and	x.hr_agenda between trunc(dt_agenda_p - qt_dias_w) and trunc(dt_agenda_p + qt_dias_w) + 86399/86400 
			and	x.nm_usuario = nm_usuario_p) order by 1;
	
C02 CURSOR FOR 
	SELECT	distinct a.cd_pessoa_fisica, 
		substr(obter_nome_medico(a.cd_pessoa_fisica,'N'),1,255) 
	from	ageint_lib_usuario a 
	where	a.nm_usuario		= nm_usuario_p 
	and	a.nr_seq_ageint_item 	= nr_seq_item_p 
	and	a.cd_pessoa_fisica	<> cd_medico_p 
	and	exists (SELECT	1 
			from 	ageint_horarios_usuario x 
			where 	x.cd_agenda = a.cd_agenda 
			and 	x.cd_pessoa_fisica = a.cd_pessoa_fisica 
			and	x.cd_pessoa_fisica <> cd_medico_p 
			and	x.ie_status_agenda = 'L' 
			and	x.hr_agenda between trunc(dt_agenda_p - qt_dias_w) and trunc(dt_agenda_p + qt_dias_w) + 86399/86400 
			and	x.nm_usuario = nm_usuario_p) 
	order by 1;
	

BEGIN 
 
qt_dias_w := Obter_Param_Usuario(869, 141, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_dias_w);
 
select	max(cd_especialidade), 
	max(cd_medico), 
	max(nr_seq_grupo_selec) 
into STRICT	cd_especialidade_w, 
	cd_medico_w, 
	nr_seq_grupo_selec_w 
from	agenda_integrada_item 
where	nr_sequencia = nr_seq_item_p;
 
select	max(a.nr_seq_medico_regra), 
	max(b.nr_Seq_grupo) 
into STRICT	nr_seq_medico_regra_w, 
	nr_seq_grupo_w 
from	agenda_medico a, 
	ageint_medico_regra b 
where	a.cd_agenda		= cd_agenda_p 
and	a.cd_medico		= cd_medico_p 
and	a.nr_seq_medico_Regra	= b.nr_sequencia;
 
select	count(*) 
into STRICT	qt_prof_item_w 
from	agenda_integrada_prof_item 
where	nr_seq_agenda_item = nr_seq_item_p;
 
if	(((cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') or (nr_seq_grupo_w IS NOT NULL AND nr_seq_grupo_w::text <> '')) and 
	((cd_medico_w IS NOT NULL AND cd_medico_w::text <> '') or (qt_prof_item_w = 0))) then	 
	 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_regra_qtd_w 
	from	ageint_regra_qtd_espec 
	where	coalesce(cd_especialidade,cd_especialidade_w) 	= cd_especialidade_w 
	and	nr_seq_grupo_medico				= nr_seq_grupo_w 
	and	cd_estabelecimento				= cd_estabelecimento_p;
	 
	if (nr_seq_regra_qtd_w > 0) then 
	 
		select	max(qt_dif_maxima) 
		into STRICT	qt_dif_maxima_w 
		from	ageint_regra_qtd_espec 
		where	nr_sequencia	= nr_seq_regra_qtd_w;
	 
		select	count(*) + 1 
		into STRICT	qt_medico_w 
		FROM agenda_integrada_item b, agenda_consulta a, agenda_medico c
LEFT OUTER JOIN ageint_medico_regra d ON (c.nr_seq_medico_Regra = d.nr_sequencia)
WHERE b.nr_seq_agenda_cons	= a.nr_sequencia and a.cd_medico_req		= cd_medico_p and a.cd_medico_req		= c.cd_medico and a.cd_Agenda		= c.cd_agenda  and d.nr_seq_grupo		= nr_seq_grupo_w --and	nvl(d.nr_seq_grupo, nr_seq_grupo_w)		= nr_seq_grupo_w 
  and a.dt_agenda between trunc(dt_agenda_p - qt_dias_w) and trunc(dt_agenda_p + qt_dias_w) + 86399/86400 and (a.nm_paciente IS NOT NULL AND a.nm_paciente::text <> '') and a.ie_status_agenda not in ('C','F','B','L');
			 
		open C01;
		loop 
		fetch C01 into	 
			cd_medico_lib_w, 
			nm_medico_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			 
			select	count(*) 
			into STRICT	qt_medico_lib_w 
			FROM agenda_integrada_item b, agenda_consulta a, agenda_medico c
LEFT OUTER JOIN ageint_medico_regra d ON (c.nr_seq_medico_Regra = d.nr_sequencia)
WHERE b.nr_seq_agenda_cons	= a.nr_sequencia and a.cd_medico_req		= cd_medico_lib_w and a.cd_medico_req		= c.cd_medico and a.cd_Agenda		= c.cd_agenda  and d.nr_seq_grupo		= nr_seq_grupo_w and a.dt_agenda between trunc(dt_agenda_p - qt_dias_w) and trunc(dt_agenda_p + qt_dias_w) + 86399/86400 and (a.nm_paciente IS NOT NULL AND a.nm_paciente::text <> '') and a.ie_status_agenda not in ('C','F','B','L');
			 
			if	((qt_medico_w - qt_medico_lib_w) > qt_dif_maxima_w) then 
				ds_medico_w	:= substr(ds_medico_w || nm_medico_w ||', ',1,255);
			end if;
			 
			end;
		end loop;
		close C01;
	else 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_regra_qtd_w 
		from	ageint_regra_qtd_espec 
		where	coalesce(cd_especialidade,cd_especialidade_w) 	= cd_especialidade_w 
		and	cd_estabelecimento				= cd_estabelecimento_p;
		 
		if (nr_seq_regra_qtd_w > 0) then 
		 
			select	max(qt_dif_maxima) 
			into STRICT	qt_dif_maxima_w 
			from	ageint_regra_qtd_espec 
			where	nr_sequencia	= nr_seq_regra_qtd_w;
		 
			select	count(*) + 1 
			into STRICT	qt_medico_w 
			from	agenda_consulta a, 
				agenda_integrada_item b 
			where	b.nr_seq_agenda_cons	= a.nr_sequencia 
			and	a.cd_medico_req		= cd_medico_p 
			and	a.dt_agenda between trunc(dt_agenda_p - qt_dias_w) and trunc(dt_agenda_p + qt_dias_w) + 86399/86400 
			and	(a.nm_paciente IS NOT NULL AND a.nm_paciente::text <> '') 
			and	a.ie_status_agenda not in ('C','F','B','L');
		 
			open C02;
			loop 
			fetch C02 into	 
				cd_medico_lib_w, 
				nm_medico_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin 
				 
				select	count(*) 
				into STRICT	qt_medico_lib_w 
				from	agenda_consulta a, 
					agenda_integrada_item b 
				where	b.nr_seq_agenda_cons	= a.nr_sequencia 
				and	a.cd_medico_req		= cd_medico_lib_w 
				and	a.dt_agenda between trunc(dt_agenda_p - qt_dias_w) and trunc(dt_agenda_p + qt_dias_w) + 86399/86400 
				and	(a.nm_paciente IS NOT NULL AND a.nm_paciente::text <> '') 
				and	a.ie_status_agenda not in ('C','F','B','L');
				 
				if	((qt_medico_w - qt_medico_lib_w) > qt_dif_maxima_w) then 
					ds_medico_w	:= substr(ds_medico_w || nm_medico_w ||', ',1,255);
				end if;
				 
				end;
			end loop;
			close C02;
		end if;
	end if;
	 
end if;
 
ds_erro_p := substr(ds_medico_w,1,length(ds_medico_w)-2);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_regra_qtd_med_espec (nr_seq_item_p bigint, cd_medico_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

