-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE suspender_hor_item_prescr (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_tabela_p text, nm_usuario_p text, ie_gerar_evento_p text default 'S', ie_suspender_apos_agora_p text default 'N') AS $body$
DECLARE

				   
nr_seq_horario_w	bigint;
ie_suspendeu_hor_w	boolean;

 
c01 REFCURSOR;

C02 CURSOR FOR  --Solução 
SELECT	nr_sequencia 
from	prescr_mat_hor 
where	nr_prescricao = nr_prescricao_p 
and	nr_seq_solucao = nr_sequencia_p 
and	coalesce(dt_fim_horario::text, '') = '' 
and	coalesce(dt_suspensao::text, '') = '';

C03 CURSOR FOR  --Procedimentos 
SELECT	nr_sequencia 
from	prescr_proc_hor 
where	nr_prescricao = nr_prescricao_p 
and	nr_seq_procedimento = nr_sequencia_p 
and	coalesce(dt_fim_horario::text, '') = '' 
and	coalesce(dt_suspensao::text, '') = '';

c04 CURSOR FOR  --Dieta Oral 
SELECT	a.nr_sequencia 
from	prescr_dieta b, 
	prescr_dieta_hor a 
where	a.nr_prescricao = b.nr_prescricao 
and	a.nr_seq_dieta = b.nr_sequencia 
and	coalesce(a.dt_suspensao::text, '') = '' 
and	coalesce(a.dt_fim_horario::text, '') = '' 
and	a.nr_prescricao	= nr_prescricao_p 
and	a.nr_seq_dieta	= nr_sequencia_p 
and	Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S';

C05 CURSOR FOR  --Hemoterapia 
SELECT	b.nr_sequencia 
from	prescr_procedimento a, 
	prescr_proc_hor b 
where	a.nr_prescricao = b.nr_prescricao 
and	b.nr_seq_procedimento = a.nr_sequencia 
and	a.nr_prescricao = nr_prescricao_p 
and	a.nr_sequencia	= nr_sequencia_p 
and	(a.nr_seq_derivado IS NOT NULL AND a.nr_seq_derivado::text <> '') 
and	coalesce(b.dt_fim_horario::text, '') = '' 
and	coalesce(b.dt_suspensao::text, '') = '';

C06 CURSOR FOR  -- Gasoterapia 
SELECT	b.nr_sequencia 
from	prescr_gasoterapia a, 
		prescr_gasoterapia_hor b 
where	a.nr_prescricao = b.nr_prescricao 
and		b.nr_seq_gasoterapia = a.nr_sequencia 
and		a.nr_prescricao = nr_prescricao_p 
and		a.nr_sequencia	= nr_sequencia_p 
and		coalesce(b.dt_fim_horario::text, '') = '' 
and		coalesce(b.dt_suspensao::text, '') = '';

C07 CURSOR FOR  -- Diálise 
SELECT	b.nr_sequencia 
from	hd_prescricao a, 
		prescr_mat_hor b, 
		prescr_solucao c 
where	a.nr_prescricao = b.nr_prescricao 
and		b.nr_seq_solucao = c.nr_seq_solucao 
and   c.nr_seq_dialise = a.nr_sequencia 
and		a.nr_prescricao = nr_prescricao_p 
and		a.nr_sequencia	= nr_sequencia_p 
and		coalesce(b.dt_fim_horario::text, '') = '' 
and		coalesce(b.dt_suspensao::text, '') = '';

C08 CURSOR FOR  -- NPT 
SELECT	b.nr_sequencia 
from	nut_paciente a, 
		nut_paciente_hor b 
where	a.nr_sequencia = b.nr_seq_nut_pac 
and		a.nr_prescricao = nr_prescricao_p 
and		a.nr_sequencia	= nr_sequencia_p 
and		coalesce(b.dt_fim_horario::text, '') = '' 
and		coalesce(b.dt_suspensao::text, '') = '';


BEGIN 
 
ie_suspendeu_hor_w := false;
 
if (nm_tabela_p = 'PRESCR_MATERIAL') then 
	if (coalesce(ie_suspender_apos_agora_p,'N') = 'S') then 
		open 	c01 for 
		SELECT	b.nr_sequencia 
		from	prescr_material a, 
				prescr_mat_hor b 
		where	a.nr_prescricao = b.nr_prescricao 
		and		a.nr_sequencia = b.nr_seq_material 
		and		a.nr_prescricao = nr_prescricao_p 
		and		a.nr_sequencia = nr_sequencia_p 
		and		coalesce(b.dt_fim_horario::text, '') = '' 
		and		coalesce(b.dt_suspensao::text, '') = '' 
		and		b.dt_horario > clock_timestamp();
	else 
		open 	c01 for 
		SELECT	b.nr_sequencia 
		from	prescr_material a, 
				prescr_mat_hor b 
		where	a.nr_prescricao = b.nr_prescricao 
		and		a.nr_sequencia = b.nr_seq_material 
		and		a.nr_prescricao = nr_prescricao_p 
		and		a.nr_sequencia = nr_sequencia_p 
		and		coalesce(b.dt_fim_horario::text, '') = '' 
		and		coalesce(b.dt_suspensao::text, '') = '';	
	end if;
 
	loop 
	fetch c01 into	 
		nr_seq_horario_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		CALL suspender_prescr_mat_hor(nr_seq_horario_w, nm_usuario_p, 0, null, null,null);
	end loop;
	close c01;
end if;
 
if (nm_tabela_p = 'PRESCR_SOLUCAO') then 
	open C02;
	loop 
	fetch C02 into	 
		nr_seq_horario_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		CALL suspender_prescr_mat_hor(nr_seq_horario_w, nm_usuario_p, 0, null, null,null);
		ie_suspendeu_hor_w := true;
	end loop;
	close C02;
	 
	if (ie_suspendeu_hor_w) then 
		update	prescr_solucao 
		set 	ie_horario_susp = 'S' 
		where 	nr_prescricao = nr_prescricao_p 
		and 	nr_seq_solucao = nr_sequencia_p;
	end if;
	 
	ie_suspendeu_hor_w := false;
 
end if;
	 
if (nm_tabela_p = 'PRESCR_PROCEDIMENTO') then 
	open C03;
	loop 
	fetch C03 into	 
		nr_seq_horario_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		CALL suspender_prescr_proc_hor(nr_seq_horario_w, nm_usuario_p);
	end loop;
	close C03;
	 
	open C05;
	loop 
	fetch C05 into	 
		nr_seq_horario_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		CALL suspender_prescr_proc_hor(nr_seq_horario_w, nm_usuario_p);
		ie_suspendeu_hor_w := true;
	end loop;
	close C05;
	 
	if (ie_suspendeu_hor_w) then 
		update	PRESCR_SOLIC_BCO_SANGUE 
		set 	ie_horario_susp = 'S' 
		where 	nr_prescricao = nr_prescricao_p 
		and 	nr_sequencia = nr_sequencia_p;
	end if;
	 
	ie_suspendeu_hor_w := false;
	 
end if;
 
if (nm_tabela_p = 'PRESCR_DIETA') then 
	open C04;
	loop 
	fetch C04 into	 
		nr_seq_horario_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
	 
		update	prescr_dieta_hor 
		set	dt_suspensao 	= clock_timestamp(), 
			nm_usuario_susp = nm_usuario_p 
		where	nr_prescricao = nr_prescricao_p 
		and	nr_sequencia = nr_seq_horario_w;
		 
		update	prescr_dieta 
		set	ie_horario_susp	= 'S' 
		where	nr_prescricao	= nr_prescricao_p 
		and	nr_sequencia	= nr_sequencia_p;
		 
	end loop;
	close C04;
end if;
 
if (nm_tabela_p = 'PRESCR_GASOTERAPIA') then 
	open C06;
	loop 
	fetch C06 into	 
		nr_seq_horario_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
	 
		CALL suspender_prescr_gas_hor(nr_prescricao_p, nr_sequencia_p, nr_seq_horario_w, nm_usuario_p);
	 
		ie_suspendeu_hor_w := true;
		 
	end loop;
	close C06;
	 
	if (ie_suspendeu_hor_w) then 
	 
		update	prescr_gasoterapia 
		set 	ie_horario_susp = 'S' 
		where 	nr_prescricao = nr_prescricao_p 
		and 	nr_sequencia = nr_sequencia_p;
		 
	end if;
	 
	ie_suspendeu_hor_w := false;
	 
end if;
 
if (nm_tabela_p = 'HD_PRESCRICAO') then 
	open C07;
	loop 
	fetch C07 into	 
		nr_seq_horario_w;
	EXIT WHEN NOT FOUND; /* apply on C07 */
	 
		CALL suspender_prescr_proc_hor(nr_seq_horario_w, nm_usuario_p);
		ie_suspendeu_hor_w := true;
		 
	end loop;
	close C07;
	 
	if (ie_suspendeu_hor_w) then 
	 
		update	HD_PRESCRICAO 
		set 	ie_horario_susp = 'S' 
		where 	nr_prescricao = nr_prescricao_p 
		and 	nr_sequencia = nr_sequencia_p;
		 
	end if;
	 
	ie_suspendeu_hor_w := false;
	 
end if;
 
if (nm_tabela_p = 'NUT_PACIENTE') then 
	open C08;
	loop 
	fetch C08 into	 
		nr_seq_horario_w;
	EXIT WHEN NOT FOUND; /* apply on C08 */
	 
		update	nut_paciente_hor 
		set	dt_suspensao 	= clock_timestamp(), 
			nm_usuario_susp = nm_usuario_p 
		where	nr_sequencia = nr_seq_horario_w;
		 
		update	nut_paciente 
		set	ie_suspenso	= 'S' 
		where	nr_prescricao	= nr_prescricao_p 
		and	nr_sequencia	= nr_sequencia_p;
		 
	end loop;
	close C08;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE suspender_hor_item_prescr (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_tabela_p text, nm_usuario_p text, ie_gerar_evento_p text default 'S', ie_suspender_apos_agora_p text default 'N') FROM PUBLIC;
