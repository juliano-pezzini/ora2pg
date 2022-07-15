-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_hor_prescr_dia ( nr_prescricao_p bigint, cd_intervalo_p text, dt_prim_horario_presc_p timestamp, dt_Hora_Inicio_p timestamp, nr_hora_validade_p bigint, cd_material_p bigint, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text, ds_horarios2_p INOUT text, ie_Solucao_p text, ds_dose_diferenciada_p text, qt_dia_prim_hor_p bigint, ie_exclui_hor_dd_zerados_p text default null, cd_procedimento_p bigint default null, ie_origem_proced_p bigint default null, nr_seq_proc_interno_p bigint default null) AS $body$
DECLARE


ds_hora_w					varchar(07);
ds_horarios_w				varchar(2000);
ds_horarios_fixo_w			varchar(2000);
ds_horario_mat_set_w			varchar(2000);
ds_prescricao_w				varchar(30);
ie_utiliza_quantidade_w		varchar(15);
qt_operacao_w				intervalo_prescricao.qt_operacao%type;
ie_operacao_w				varchar(1);
dt_primeiro_horario_w		timestamp;
ds_erro_w					varchar(2000);
ie_utiliza_mascara_w		varchar(1);
nr_Horas_intervalo_w		real;
if_cont_w					integer;
qt_doses_w					integer;
hr_prescricao_w				timestamp;
hr_dose_w					timestamp;
mascara_data_w				varchar(10);
ds_hora_aux_w				varchar(255);
ds_dose_w					varchar(255);
ds_horarios_aux_w			varchar(255);
nr_hora_validade_w			double precision;
nr_hora_prescr_w			smallint;
nr_hora_item_w				smallint;
dt_hora_validade_w			timestamp;
dt_validade_prescr_w		timestamp;
dt_prescricao_w				timestamp;
dt_medic_w					timestamp;
dt_horario_w				timestamp;
ds_dt_prescr_w				varchar(10);
qt_hora_intervalo_w			bigint;
k							integer;
qt_dia_adic_w				bigint := 0;
qt_pertence_w				bigint;
ie_dose_diferenciada_w		varchar(1);
dt_inicio_prescr_w			timestamp;
ie_controle_w				smallint	:= 0;
qt_min_intervalo_w			double precision;
ds_dose_diferenciada_w		varchar(255);
ie_virgula_w				varchar(1);
qt_min_intervalo_regra_w	bigint;
dt_prox_horario_w			timestamp;
dt_Hora_Inicio_w			timestamp;
cd_funcao_origem_w			prescr_medica.cd_funcao_origem%type;

c01 CURSOR FOR
SELECT	qt_min_intervalo
from	intervalo_minuto
where	cd_intervalo	= cd_intervalo_p
order by nr_seq_apres;
BEGIN												
qt_min_intervalo_w	:= (coalesce(qt_hora_intervalo_p,0) * 60) + coalesce(qt_min_intervalo_p,0);

select	dt_prescricao,
		to_char(coalesce(dt_inicio_prescr,dt_prescricao),'dd/mm/yyyy'),
		coalesce(dt_validade_prescr,dt_prescricao + nr_horas_validade/24),
		dt_inicio_prescr,
		nr_horas_validade,
		dt_primeiro_horario,
		cd_funcao_origem
into STRICT	dt_prescricao_w,
		ds_dt_prescr_w,
		dt_validade_prescr_w,
		dt_inicio_prescr_w,
		nr_hora_validade_w,
		dt_primeiro_horario_w,
		cd_funcao_origem_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

if (obter_funcao_ativa = 1113) and (nr_hora_validade_p > 0) then
	nr_hora_validade_w	:= coalesce(nr_hora_validade_p,nr_hora_validade_w);
end if;

--dt_validade_prescr_w	:= dt_inicio_prescr_w + nr_hora_validade_w/24 - 1/86400; //Conforme conversado com o CALDAS esta linha estava apresentando dois horarios para o agora. O mesmo que solicitou que comenta-se a linha OS281090
dt_Hora_Inicio_w	:= coalesce(dt_Hora_Inicio_p, dt_primeiro_horario_w);
if (coalesce(dt_Hora_Inicio_p::text, '') = '') and (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '') and
	((dt_Hora_Inicio_p IS NOT NULL AND dt_Hora_Inicio_p::text <> '') or ((coalesce(dt_Hora_Inicio_p::text, '') = '') and (obter_se_somente_numero(ds_horarios_p) = 'S'))) and (ds_horarios_p <> 'ACM') and (ds_horarios_p <> 'SN') then
	if (position(':' in ds_horarios_p) > 0) then
		dt_Hora_Inicio_w := to_date(ds_dt_prescr_w ||' '||substr(ds_horarios_p,1,5) || ':00','dd/mm/yyyy hh24:mi:ss');
	else
		dt_Hora_Inicio_w := to_date(ds_dt_prescr_w ||' '||substr(ds_horarios_p,1,2) || ':00:00','dd/mm/yyyy hh24:mi:ss');
	end if;
end if;
dt_medic_w		:= to_date(ds_dt_prescr_w ||' '||to_char(dt_Hora_Inicio_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');

if (to_char(dt_prim_horario_presc_p,'hh24:mi') > to_char(dt_Hora_Inicio_w,'hh24:mi')) and (qt_dia_prim_hor_p = 0)then
	dt_medic_w	:= dt_medic_w + 1;
else
	dt_medic_w	:= dt_medic_w + qt_dia_prim_hor_p;
end if;

if (length(cd_material_p) < 8) then  /*Edilson em 17/12/08 OS 121327 Para que nao seja feito para procedimentos*/
	nr_hora_validade_w	:= (dt_validade_prescr_w - dt_medic_w) * 24;
end if;

if (cd_funcao_origem_w = 2314) and (nr_hora_validade_w > 24) then
	nr_hora_validade_w := 24;
end if;

select	max(ds_horarios)
into STRICT	ds_horario_mat_set_w
from	intervalo_material
where	cd_intervalo	= cd_intervalo_p
and		cd_material	= cd_material_p;

if (coalesce(ds_horario_mat_set_w::text, '') = '') then

	select	max(ds_horarios)
	into STRICT	ds_horario_mat_set_w
	from	intervalo_setor
	where	cd_intervalo	= cd_intervalo_p
	and	cd_material	= cd_material_p;
	
end if;

select  coalesce(max(coalesce(ds_horario_mat_set_w, ds_horarios)),''),
		coalesce(max(ie_operacao),''),
		coalesce(max(qt_operacao),1),
		coalesce(max(ds_prescricao),''),
        coalesce(max(ie_dose_diferenciada),'N'),
		coalesce(max(ie_utiliza_quantidade),'N')
into STRICT	ds_horarios_w,
		ie_operacao_w,
		qt_operacao_w,
		ds_prescricao_w,
        ie_dose_diferenciada_w,
		ie_utiliza_quantidade_w
from	intervalo_prescricao
where	cd_intervalo = cd_intervalo_p;

if (ie_utiliza_quantidade_w = 'N') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	select	max(obter_se_intervalo_operacao(cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p, cd_intervalo_p))
	into STRICT	ie_utiliza_quantidade_w
	;
end if;	

if (to_char(dt_Hora_Inicio_w, 'mi') <> '00') or
	((coalesce(qt_min_intervalo_w,0) > 0) and (ie_operacao_w = 'X')) then
	Mascara_data_w 			:= 'hh24:mi';
else
	Mascara_data_w 			:= 'hh24';
end if;
begin
ds_dose_diferenciada_w	:= ds_dose_diferenciada_p;
qt_doses_w		:= 0;
if (ds_dose_diferenciada_p IS NOT NULL AND ds_dose_diferenciada_p::text <> '') and (ie_dose_diferenciada_w in ('O','P','S')) then

	if (ie_operacao_w	= 'V') then
		qt_hora_intervalo_w	:= (24 / qt_operacao_w);
	elsif (ie_operacao_w	= 'H') then
		qt_hora_intervalo_w	:= qt_operacao_w;
	elsif (ie_operacao_w	= 'X') then
		qt_hora_intervalo_w	:= (24 / qt_operacao_w);
	end if;
	if (ie_operacao_w	= 'V') then
		select	padroniza_horario(reordenar_horarios(dt_medic_w, ds_horarios_w)) || ' '
		into STRICT	ds_horarios_w
		;
	end if;
	
	if (ie_operacao_w	= 'F') or (ie_operacao_w	= 'V') or
		(ie_dose_diferenciada_w = 'S' AND ie_operacao_w	= 'X') then
		
		ds_horarios_p	:= '';
		if (nr_intervalo_p > qt_operacao_w) then
			qt_operacao_w	:= nr_intervalo_p;
		end if;

		ds_horarios_w		:= ds_horarios_w || ' ';
		ds_dose_diferenciada_w	:= tiss_substituir_string(ds_dose_diferenciada_w,',','') || '-';

		for	z in 1..qt_operacao_w loop
			ds_dose_w		:= substr(ds_dose_diferenciada_w, 1, position('-' in ds_dose_diferenciada_w) - 1);
			ds_dose_diferenciada_w	:= substr(ds_dose_diferenciada_w, position('-' in ds_dose_diferenciada_w) + 1, 255);
			ds_hora_aux_w		:= substr(ds_horarios_w, 1, position(' ' in ds_horarios_w) - 1);
			ds_horarios_w		:= substr(ds_horarios_w, position(' ' in ds_horarios_w) + 1, 255);

			if (somente_numero(ds_dose_w) > 0) or (coalesce(ie_exclui_hor_dd_zerados_p,'S') = 'N') then
				ds_horarios_aux_w := ds_horarios_aux_w || ds_hora_aux_w || ' ';
			end if;
		end loop;
		ds_horarios_w	:= ds_horarios_aux_w;
	else
		ds_horarios_w	:= '';
		hr_dose_w       := dt_Hora_Inicio_w;
		ie_virgula_w	:= 'N';
		if_cont_w	:= 0;
		ds_dose_diferenciada_w	:= tiss_substituir_string(ds_dose_diferenciada_w,',','') || '-';
		
		for	x in 1..length(ds_dose_diferenciada_w) loop
			if (substr(ds_dose_diferenciada_w, x, 1) = '-') then
				qt_doses_w	:= qt_doses_w + 1;
				ds_hora_w	:= to_char(hr_dose_w, Mascara_data_w);
				
				if (substr(ds_dose_diferenciada_w, x, 1) <> '0') or (coalesce(ie_exclui_hor_dd_zerados_p,'S') = 'N') then
					ds_horarios_w		:= ds_horarios_w || ds_hora_w || ' ';
				end if;
				
				hr_dose_w      		:= hr_dose_w + (qt_hora_intervalo_w / 24);
			end if;
		end loop;
		nr_intervalo_p			:= coalesce(qt_doses_w,0);
	end if;
elsif (ie_operacao_w = 'D') then
	nr_Intervalo_p		   	:= 1;
	if (coalesce(ds_horarios_w::text, '') = '') then
		if (to_char(dt_Hora_Inicio_w,'mi') = '00') then
			ds_horarios_w			:= to_char(dt_Hora_Inicio_w,'hh24');
		else
			ds_horarios_w			:= to_char(dt_Hora_Inicio_w,'hh24:mi');
		end if;
	else
		ds_horarios_w			:= ds_horarios_w;
	end if;
elsif (ie_operacao_w = 'M') then

	nr_Intervalo_p		:= 1;
	ds_horarios_w		:= to_char(dt_Hora_Inicio_w,'hh24:mi');
	dt_prox_horario_w	:= to_date(ds_dt_prescr_w ||' '||to_char(dt_Hora_Inicio_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	
	open C01;
	loop
	fetch C01 into	
		qt_min_intervalo_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		nr_Intervalo_p	:= nr_Intervalo_p + 1;
		dt_prox_horario_w := dt_prox_horario_w + (qt_min_intervalo_regra_w/1440);
		ds_horarios_w	:= ds_horarios_w || ' ' || to_char(dt_prox_horario_w,'hh24:mi');		
	end loop;
	close C01;
	
elsif (ie_operacao_w = 'F') and (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
	begin
    	nr_Intervalo_p		   	:= qt_operacao_w;
	end;
elsif (ie_operacao_w = 'V') and (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
	begin
	
	ie_utiliza_mascara_w	:= 'S';
	if (position(':' in ds_horarios_w) = 0) then
		ie_utiliza_mascara_w	:= 'N';
	end if;

	select	PADRONIZA_HORARIO_PRESCR(reordenar_horarios(dt_medic_w,ds_horarios_w), to_char(dt_inicio_prescr_w,'dd/mm/yyyy hh24:mi:ss')) || ' '
	into STRICT	ds_horarios_w
	;
	
	nr_Intervalo_p	:= 0;
	
	while	(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') LOOP
		begin
		select	position(' ' in ds_horarios_w)
		into STRICT	k
		;
		
		if (k > 1) and ((substr(ds_horarios_w, 1, k -1) IS NOT NULL AND (substr(ds_horarios_w, 1, k -1))::text <> '')) then
			begin
			ds_hora_w		:= substr(ds_horarios_w, 1, k-1);
			ds_hora_w		:= replace(ds_hora_w, ' ','');
			ds_horarios_w		:= substr(ds_horarios_w, k + 1, 2000);
			
			if (ie_controle_w = 0) and (ds_hora_w < to_char(dt_inicio_prescr_w,'hh24:mi')) then
				qt_dia_adic_w	:= 1;
			elsif (position('A' in ds_hora_w) > 0) and (qt_dia_adic_w = 0) then
				qt_dia_adic_w	:= 1;
			elsif (position('AA' in ds_hora_w) > 0) then
				qt_dia_adic_w	:= qt_dia_adic_w + 1;
			end if;
			ie_controle_w	:= 1;
			ds_hora_w	:= replace(ds_hora_w,'A','');
			ds_hora_w	:= replace(ds_hora_w,'A','');

			dt_horario_w	:= to_date(to_char(dt_inicio_prescr_w + qt_dia_adic_w,'dd/mm/yyyy')||' '||replace(ds_hora_w,'A','')||':00','dd/mm/yyyy hh24:mi:ss');
			
			select	count(*)
			into STRICT	qt_pertence_w
			
			where	dt_horario_w >= dt_medic_w
			and 	dt_horario_w < dt_validade_prescr_w;
			
			if (qt_pertence_w > 0) then
				begin
				if (ie_utiliza_mascara_w	= 'N') then
					ds_hora_w	:= substr(ds_hora_w,1,2);
				end if;
				ds_horarios_fixo_w	:= ds_horarios_fixo_w || ds_hora_w ||' ';
				nr_Intervalo_p		:= nr_Intervalo_p + 1;
				end;
			end if;

			end;
		elsif (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
			begin
			ds_horarios_w		:= '';
			end;
		end if;
		
		end;
	END LOOP;
	ds_horarios_w	:= ds_horarios_fixo_w;
	end;
else
    	begin
	if (nr_intervalo_p > 0) then
		if (ie_operacao_w = 'H') then
			nr_Horas_intervalo_w 	:= qt_operacao_w;
		else
			if (coalesce(ie_utiliza_quantidade_w,'N') = 'N') then
				nr_Horas_intervalo_w 	:= Trunc(nr_Hora_validade_w / nr_intervalo_p);
			else
				nr_Horas_intervalo_w	:= nr_intervalo_p;
			end if;
		end if;
    	elsif (ie_operacao_w = 'H') then
        	begin
        	nr_Horas_intervalo_w    := qt_operacao_w;
        	nr_Intervalo_p          := CEIL(nr_Hora_validade_w / nr_Horas_intervalo_w);
        	end;
    	elsif (ie_operacao_w = 'X') then
        	begin
		if (coalesce(ie_utiliza_quantidade_w,'N') = 'N') then
			nr_Intervalo_p		:= Ceil(nr_Hora_validade_w / (24 / qt_operacao_w));
		else
			nr_Intervalo_p	:= qt_operacao_w;
		end if;
        	nr_Horas_intervalo_w   	:= floor(24/qt_operacao_w);
		if (coalesce(qt_min_intervalo_w,0) > 0) and (nr_Horas_intervalo_w >= floor(dividir(qt_min_intervalo_w,60))) then
			nr_Horas_intervalo_w	:= qt_min_intervalo_w / 60;
		end if;
		
		if (nr_intervalo_p = 0) or (coalesce(nr_intervalo_p::text, '') = '') then
			nr_intervalo_p := 1;
		end if;
        	end;
    	else
        	begin
        	nr_Intervalo_p         	:= 1;
        	nr_Horas_intervalo_w   	:= 0;
        	end;
	end if;

	ds_horarios_w			:= '';
	hr_prescricao_w            	:= dt_Hora_Inicio_w;

	for i in 1.. nr_intervalo_p LOOP
	    	begin
	    	ds_hora_w		:= to_char(hr_prescricao_w, Mascara_data_w);
		ds_horarios_w		:= ds_horarios_w || ds_hora_w || ' ';
		hr_prescricao_w      	:= hr_prescricao_w + (nr_Horas_intervalo_w / 24);
		end;
	end loop;
	end;
end if;

/*tratamento para verificar se esta na validade*/

if (ds_dose_diferenciada_p IS NOT NULL AND ds_dose_diferenciada_p::text <> '') and (ie_dose_diferenciada_w in ('O','P','S')) and (ie_operacao_w	= 'V') then
	begin

	select	padroniza_horario(reordenar_horarios(dt_medic_w, ds_horarios_w)) || ' '
	into STRICT	ds_horarios_w
	;

	nr_Intervalo_p	:= 0;
	
	while	(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') LOOP
		begin
		select	position(' ' in ds_horarios_w)
		into STRICT	k
		;		
		if (k > 1) and ((substr(ds_horarios_w, 1, k -1) IS NOT NULL AND (substr(ds_horarios_w, 1, k -1))::text <> '')) then
			begin
			ds_hora_w		:= substr(ds_horarios_w, 1, k-1);
			ds_hora_w		:= replace(ds_hora_w, ' ','');
			ds_horarios_w		:= substr(ds_horarios_w, k + 1, 2000);
			
			if (ie_controle_w = 0) and (ds_hora_w < to_char(dt_inicio_prescr_w,'hh24:mi')) then
				qt_dia_adic_w	:= 1;
			elsif (position('A' in ds_hora_w) > 0) and (qt_dia_adic_w = 0) then
				qt_dia_adic_w	:= 1;
			elsif (position('AA' in ds_hora_w) > 0) then
				qt_dia_adic_w	:= qt_dia_adic_w + 1;
			end if;
			ie_controle_w	:= 1;
			ds_hora_w	:= replace(ds_hora_w,'A','');
			ds_hora_w	:= replace(ds_hora_w,'A','');

			dt_horario_w	:= to_date(to_char(dt_inicio_prescr_w + qt_dia_adic_w,'dd/mm/yyyy')||' '||replace(ds_hora_w,'A','')||':00','dd/mm/yyyy hh24:mi:ss');
			
			select	count(*)
			into STRICT	qt_pertence_w
			
			where	dt_horario_w >= dt_medic_w
			and 	dt_horario_w < dt_validade_prescr_w;

			if (qt_pertence_w > 0) then
				begin
				ds_horarios_fixo_w	:= ds_horarios_fixo_w || ds_hora_w ||' ';
				nr_Intervalo_p		:= nr_Intervalo_p + 1;
				end;
			end if;

			end;
		elsif (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
			begin
			ds_horarios_w		:= '';
			end;
		end if;
		
		end;
	END LOOP;
	ds_horarios_w	:= ds_horarios_fixo_w;
	end;
end if;

if (nr_Intervalo_p = 0)  then
    	nr_Intervalo_p			:= 1;
end if;

if (nr_intervalo_p = 1) and (ds_prescricao_w in ('ACM', 'SN')) then
	begin
     	ds_horarios_p 			:= substr(ds_prescricao_w,1,254);
	ds_horarios2_p			:= substr(ds_prescricao_w,255,255);
	end;
else
	begin
	ds_horarios_p			:= coalesce(substr(ds_horarios_w,1,254), ds_horarios_p);
	ds_horarios2_p			:= coalesce(substr(ds_horarios_w,255,255), ds_horarios2_p);
	end;
end if;

if (nr_intervalo_p < 0) then
	nr_intervalo_p	:= 0;
end if;

if (nr_intervalo_p = 0) or (coalesce(nr_intervalo_p::text, '') = '') then
	nr_intervalo_p := 1;
end if;
exception when others then
	ds_erro_w	:= sqlerrm;
end;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_hor_prescr_dia ( nr_prescricao_p bigint, cd_intervalo_p text, dt_prim_horario_presc_p timestamp, dt_Hora_Inicio_p timestamp, nr_hora_validade_p bigint, cd_material_p bigint, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text, ds_horarios2_p INOUT text, ie_Solucao_p text, ds_dose_diferenciada_p text, qt_dia_prim_hor_p bigint, ie_exclui_hor_dd_zerados_p text default null, cd_procedimento_p bigint default null, ie_origem_proced_p bigint default null, nr_seq_proc_interno_p bigint default null) FROM PUBLIC;

