-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_status_solucao ( nr_prescricao_p bigint, dt_inicio_prescr_p timestamp, nm_usuario_p text, cd_funcao_origem_p bigint, nr_horas_validade_p bigint) AS $body$
DECLARE

qt_registro_w			bigint;
dt_inicio_prescr_w		timestamp;
nr_seq_solucao_w		integer;
hr_prim_horario_w		varchar(5);
ie_acm_w				varchar(1);
ie_se_necessario_w		varchar(1);
dt_inicio_solucao_w		timestamp;
ie_urgencia_w			varchar(1);
ie_etapa_especial_w		varchar(1);
qt_volume_w				double precision;
nr_seq_nut_pac_w		bigint;
ie_data_status_w		varchar(1);
dt_status_w				timestamp;
nr_seq_dialise_cpoe_w 	prescr_solucao.nr_seq_dialise_cpoe%type;
dt_inicio_w				cpoe_dialise.dt_inicio%type;

qt_volume_adep_w		prescr_solucao.qt_volume%type;

c01 CURSOR FOR
SELECT	nr_seq_solucao,
	hr_prim_horario,
	coalesce(ie_acm,'N'),
	coalesce(ie_se_necessario,'N'),
	coalesce(ie_urgencia,'N'),
	coalesce(ie_etapa_especial,'N'),
	nr_seq_dialise_cpoe
from	prescr_solucao
where	nr_prescricao = nr_prescricao_p
order by
	nr_seq_solucao;

c02 CURSOR FOR
SELECT	nr_sequencia,
	hr_prim_horario,
	coalesce(ie_acm,'N'),
	coalesce(ie_se_necessario,'N'),
	coalesce(ie_urgencia,'N')
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and	ie_agrupador = 8
order by
	nr_sequencia;
	
C03 CURSOR FOR
	SELECT 	nr_sequencia,
		hr_prim_horario
	from	nut_pac
	where	nr_prescricao	= nr_prescricao_p;

BEGIN

ie_data_status_w := Obter_Param_Usuario( 924, 777, obter_perfil_ativo, nm_usuario_p, 0, ie_data_status_w);

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	begin
	dt_inicio_prescr_w	:= dt_inicio_prescr_p;
	open c01;
	loop
	fetch c01 into	nr_seq_solucao_w,
			hr_prim_horario_w,
			ie_acm_w,
			ie_se_necessario_w,
			ie_urgencia_w,
			ie_etapa_especial_w,
			nr_seq_dialise_cpoe_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		if	(ie_acm_w = 'N' AND ie_se_necessario_w = 'N') or (ie_etapa_especial_w = 'S') then
			begin
			
			if (cd_funcao_origem_p = 2314) then
			
				select 	max(dt_inicio)
				into STRICT	dt_inicio_w
				from 	cpoe_dialise
				where 	nr_sequencia = nr_seq_dialise_cpoe_w;
				
				if (dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> '') and (dt_inicio_w between dt_inicio_prescr_w and dt_inicio_prescr_w + nr_horas_validade_p/24) then
					dt_inicio_solucao_w := dt_inicio_w;
				else
					dt_inicio_solucao_w := dt_inicio_prescr_w;
				end if;
			elsif (ie_urgencia_w = 'S') and (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') and (hr_prim_horario_w <> '  :  ') then
				begin
				dt_inicio_solucao_w	:= ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(hr_prim_horario_w || ':' || to_char(clock_timestamp(),'ss'));
				END;
			elsif (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') and (hr_prim_horario_w <> '  :  ') then
				begin
				dt_inicio_solucao_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_prescr_w, hr_prim_horario_w || ':' || to_char(dt_inicio_prescr_w,'ss'));
				if (dt_inicio_solucao_w < dt_inicio_prescr_p) and (coalesce(ie_etapa_especial_w,'N') = 'N') then
					begin
					dt_inicio_solucao_w	:= dt_inicio_solucao_w + 1;
					end;
				end if;
				end;
			else
				begin
				dt_inicio_solucao_w	:= dt_inicio_prescr_w;
				end;
			end if;
			
			select	sum(coalesce(qt_solucao,0))
			into STRICT	qt_volume_adep_w
			from	prescr_material
			where	nr_prescricao			= nr_prescricao_p
			and		nr_sequencia_solucao	= nr_seq_solucao_w;

			update	prescr_solucao
			set		ie_status	= 'N',
					dt_status	= dt_inicio_solucao_w,
					qt_volume_adep	= CASE WHEN coalesce(qt_volume,0)=0 THEN  qt_volume_adep_w  ELSE qt_volume END
			where	nr_prescricao	= nr_prescricao_p
			and		nr_seq_solucao	= nr_seq_solucao_w
			and		coalesce(ie_status, 'P') = 'P';
			
			end;
		else
			begin
						
			select	sum(coalesce(qt_solucao,0))
			into STRICT	qt_volume_adep_w
			from	prescr_material
			where	nr_prescricao			= nr_prescricao_p
			and		nr_sequencia_solucao	= nr_seq_solucao_w;
			
			update	prescr_solucao
			set		ie_status	= 'N',
					dt_status	 = NULL,
					qt_volume_adep	= CASE WHEN coalesce(qt_volume,0)=0 THEN  qt_volume_adep_w  ELSE qt_volume END
			where	nr_prescricao	= nr_prescricao_p
			and		nr_seq_solucao	= nr_seq_solucao_w
			and		coalesce(ie_status, 'P') = 'P';
			
			end;
		end if;
		end;
	end loop;
	close c01;

	open c02;
	loop
	fetch c02 into	nr_seq_solucao_w,
			hr_prim_horario_w,
			ie_acm_w,
			ie_se_necessario_w,
			ie_urgencia_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		if (ie_acm_w = 'N') and (ie_se_necessario_w = 'N') then
			begin
			if (ie_urgencia_w = 'S') and (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') and (hr_prim_horario_w <> '  :  ') then
				begin
				dt_inicio_solucao_w	:= ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(hr_prim_horario_w || ':' || to_char(clock_timestamp(),'ss'));
				end;
			elsif (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') and (hr_prim_horario_w <> '  :  ') then
				begin
				dt_inicio_solucao_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_prescr_w, hr_prim_horario_w || ':' || to_char(dt_inicio_prescr_w,'ss'));
				if (dt_inicio_solucao_w < dt_inicio_prescr_p) then
					begin
					dt_inicio_solucao_w	:= dt_inicio_solucao_w + 1;
					end;
				end if;
				end;
			else
				begin
				dt_inicio_solucao_w	:= dt_inicio_prescr_w;
				end;
			end if;
			update	prescr_material
			set	ie_status	= 'N',
				dt_status	= dt_inicio_solucao_w,
				qt_volume_adep	= qt_dose
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_seq_solucao_w
			and	ie_agrupador	= 8
			and		coalesce(ie_status, 'P') = 'P';
			
			end;
		else
			begin
			if (ie_data_status_w	= 'S') then
				dt_status_w := dt_inicio_prescr_w;
			end if;
			
			update	prescr_material
			set	ie_status	= 'N',
				dt_status	= dt_status_w,
				qt_volume_adep	= qt_dose
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_seq_solucao_w
			and	ie_agrupador	= 8
			and		coalesce(ie_status, 'P') = 'P';
			
			end;
		end if;
		end;
	end loop;
	close c02;

	select	count(*)
	into STRICT	qt_registro_w
	from	prescr_procedimento
	where	nr_prescricao = nr_prescricao_p
	and	(nr_seq_solic_sangue IS NOT NULL AND nr_seq_solic_sangue::text <> '');
	--and	nr_seq_derivado is not null;     para gerar para as solicitacoes de teste e outras solicitacoes
	if (qt_registro_w > 0) then
		begin
		update	prescr_procedimento
		set	ie_status		= 'N',
			dt_status 		= dt_inicio_prescr_w,
			qt_volume_adep		= dividir(coalesce(qt_vol_hemocomp, (obter_volume_hemocomponente(nr_seq_derivado,'V'))::numeric ),qt_procedimento)
		where	nr_prescricao		= nr_prescricao_p
		and	(nr_seq_solic_sangue IS NOT NULL AND nr_seq_solic_sangue::text <> '');
		--and	nr_seq_derivado is not null;     para gerar para as solicitacoes de teste e outras solicitacoes
		end;
	end if;

	select	count(*)
	into STRICT	qt_registro_w
	from	nut_paciente
	where	nr_prescricao = nr_prescricao_p;

	if (qt_registro_w > 0) then
		begin
		update	nut_paciente
		set	ie_status	= 'N',
			dt_status 	= dt_inicio_prescr_w,
			qt_volume_adep	= obter_vol_nut_pac_fase(nr_sequencia,1)
		where	nr_prescricao	= nr_prescricao_p;
				
		end;
	end if;

	select	count(*)
	into STRICT	qt_registro_w
	from	nut_pac
	where	nr_prescricao = nr_prescricao_p;

	if (qt_registro_w > 0) then
		begin
		
		open C03;
		loop
		fetch C03 into	
			nr_seq_nut_pac_w,
			hr_prim_horario_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') and (hr_prim_horario_w <> '  :  ') then
				begin
				dt_inicio_solucao_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_prescr_w, hr_prim_horario_w || ':' || to_char(dt_inicio_prescr_w,'ss'));
				if (dt_inicio_solucao_w < dt_inicio_prescr_p)  then
					begin
					dt_inicio_solucao_w	:= dt_inicio_solucao_w + 1;
					end;
				end if;
				end;
			else
				begin
				dt_inicio_solucao_w	:= dt_inicio_prescr_w;
				end;
			end if;
			
			qt_volume_w :=	coalesce(obter_volume_nut_pac_neo(nr_seq_nut_pac_w),0);
				
			if (qt_volume_w = 0) then
				select	sum(qt_volume)
				into STRICT 	qt_volume_w
				from	nut_pac_elem_mat
				where	nr_seq_nut_pac = nr_seq_nut_pac_w;	
			end if;
			
			update	nut_pac
			set	ie_status	= 'N',
				dt_status 	= dt_inicio_solucao_w,
				qt_volume_adep	= qt_volume_w
			where	nr_sequencia	= nr_seq_nut_pac_w;			
			
			end;
		end loop;
		close C03;
		
		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_status_solucao ( nr_prescricao_p bigint, dt_inicio_prescr_p timestamp, nm_usuario_p text, cd_funcao_origem_p bigint, nr_horas_validade_p bigint) FROM PUBLIC;
