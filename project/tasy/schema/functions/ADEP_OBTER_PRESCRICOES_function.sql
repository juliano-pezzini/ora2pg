-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_prescricoes ( nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, nr_seq_proc_interno_p bigint, cd_intervalo_p text, qt_item_p bigint, ie_data_lib_proc_p text, ie_data_lib_prescr_p text, ie_exibe_suspensos_p text, dt_validade_p timestamp, cd_setor_paciente_p bigint, nr_seq_cpoe_p bigint) RETURNS varchar AS $body$
DECLARE


nr_prescricao_w		bigint;
nr_prescricoes_w	varchar(255) := '';

c01 CURSOR FOR
SELECT	a.nr_prescricao
from	prescr_medica a
where	a.nr_atendimento 	= nr_atendimento_p
and	a.dt_validade_prescr 	> dt_validade_p
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	coalesce(a.ie_hemodialise, 'N') <> 'R'
--and	a.dt_liberacao 		is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S'
and	exists (
	SELECT	1
	from	prescr_mat_hor c,
		prescr_material b
	where	c.nr_prescricao 		= b.nr_prescricao
	and	c.nr_seq_material 		= b.nr_sequencia
	and	b.nr_prescricao 		= a.nr_prescricao
	and	b.ie_agrupador 			= 1
	and	coalesce(c.ie_adep,'S') 		= 'S'
	and	coalesce(c.ie_situacao,'A')		= 'A'	
	and	b.cd_material 			= cd_item_p
	and	coalesce(b.cd_intervalo,'XPTO')	= coalesce(cd_intervalo_p,'XPTO')
	and	coalesce(b.qt_dose,1) 		= coalesce(qt_item_p,coalesce(b.qt_dose,1))
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	)
group by a.nr_prescricao
order by a.nr_prescricao;

c02 CURSOR FOR
SELECT	a.nr_prescricao
from	prescr_medica a
where	a.nr_atendimento 	= nr_atendimento_p
and	a.dt_validade_prescr 	> dt_validade_p
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	coalesce(a.ie_hemodialise, 'N') <> 'R'
--and	a.dt_liberacao 		is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S'
and	exists (
	SELECT	1
	from	prescr_mat_hor c,
		prescr_material b
	where	c.nr_prescricao 		= b.nr_prescricao
	and	c.nr_seq_material 		= b.nr_sequencia
	and	b.nr_prescricao 		= a.nr_prescricao
	and	b.ie_agrupador 			= 12
	and	coalesce(c.ie_adep,'S') 		= 'S'
	and	coalesce(c.ie_situacao,'A')		= 'A'	
	and	b.cd_material 			= cd_item_p
	and	coalesce(b.cd_intervalo,'XPTO')	= coalesce(cd_intervalo_p,'XPTO')
	and	coalesce(b.qt_dose,1) 		= coalesce(qt_item_p,coalesce(b.qt_dose,1))
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	)
group by
	a.nr_prescricao
order by
	a.nr_prescricao;

c03 CURSOR FOR
SELECT	a.nr_prescricao
from	prescr_medica a
where	a.nr_atendimento 	= nr_atendimento_p
and	a.dt_validade_prescr 	> dt_validade_p
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proc_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proc_p))::text <> '')
and	obter_se_exibir_adep_suspensos(a.dt_suspensao, ie_exibe_suspensos_p) = 'S'
and	coalesce(a.ie_hemodialise, 'N') <> 'R'
and	exists (
	SELECT	1
	from	prescr_proc_hor c,
		prescr_procedimento b
	where	c.nr_prescricao 		= b.nr_prescricao
	and	c.nr_seq_procedimento		= b.nr_sequencia
	and	b.nr_prescricao 		= a.nr_prescricao
	and	coalesce(b.nr_seq_proc_cpoe,0) 	= coalesce(nr_seq_cpoe_p,0)
	--and	nvl(c.ie_adep,'S') 		= 'S'
	and	coalesce(c.ie_situacao,'A')		= 'A'	
	and	b.cd_procedimento 		= cd_item_p
	and	coalesce(b.nr_seq_proc_interno,0) 	= coalesce(nr_seq_proc_interno_p,0)
	and	coalesce(b.cd_intervalo,'XPTO')	= coalesce(cd_intervalo_p,'XPTO')
	and	coalesce(b.qt_procedimento,1) 	= coalesce(qt_item_p,coalesce(b.qt_procedimento,1))
	and	coalesce(b.nr_seq_exame::text, '') = ''
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	)
group by
	a.nr_prescricao
order by
	a.nr_prescricao;

c04 CURSOR FOR
SELECT	a.nr_prescricao
from	prescr_medica a
where	a.nr_atendimento 	= nr_atendimento_p
and	a.dt_validade_prescr 	> dt_validade_p
and	coalesce(a.ie_adep,'S') 	= 'S'
and	coalesce(a.ie_hemodialise, 'N') <> 'R'
and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proc_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proc_p))::text <> '')
and	obter_se_exibir_adep_suspensos(a.dt_suspensao, ie_exibe_suspensos_p) = 'S'
and	exists (
	SELECT	1
	from	prescr_proc_hor c,
		prescr_procedimento b
	where	c.nr_prescricao 		= b.nr_prescricao
	and	c.nr_seq_procedimento		= b.nr_sequencia
	and	b.nr_prescricao 		= a.nr_prescricao
	--and	nvl(c.ie_adep,'S') 		= 'S'
	and	coalesce(c.ie_situacao,'A')		= 'A'	
	and	b.cd_procedimento 		= cd_item_p
	and	coalesce(b.nr_seq_proc_interno,0) 	= coalesce(nr_seq_proc_interno_p,0)
	and	coalesce(b.nr_seq_proc_cpoe,0) 	= coalesce(nr_seq_cpoe_p,0)
	and	coalesce(b.cd_intervalo,'XPTO')	= coalesce(cd_intervalo_p,'XPTO')
	and	coalesce(b.qt_procedimento,1) 	= coalesce(qt_item_p,coalesce(b.qt_procedimento,1))
	and	(b.nr_seq_exame IS NOT NULL AND b.nr_seq_exame::text <> '')
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'	
	)
group by
	a.nr_prescricao
order by
	a.nr_prescricao;	
	
c05 CURSOR FOR
SELECT	a.nr_prescricao
from	prescr_medica a
where	a.nr_atendimento 	= nr_atendimento_p
and	a.dt_validade_prescr 	> dt_validade_p
and	coalesce(a.ie_hemodialise, 'N') <> 'R'
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
--and	a.dt_liberacao		is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S'
and	exists (
	SELECT	1
	from	prescr_rec_hor c,
		prescr_recomendacao b
	where	c.nr_prescricao 					= b.nr_prescricao
	and	c.nr_seq_recomendacao					= b.nr_sequencia
	and	b.nr_prescricao 					= a.nr_prescricao
	--and	nvl(c.ie_adep,'S') 		= 'S'
	and	coalesce(c.ie_situacao,'A')					= 'A'	
	and	coalesce(to_char(b.cd_recomendacao),b.ds_recomendacao)	= cd_item_p
	and	coalesce(b.cd_intervalo,'XPTO')				= coalesce(cd_intervalo_p,'XPTO')
	and	coalesce(b.qt_recomendacao,1) 				= coalesce(qt_item_p,coalesce(b.qt_recomendacao,1))
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	)
group by
	a.nr_prescricao
order by
	a.nr_prescricao;
	
c06 CURSOR FOR
SELECT	a.nr_sequencia
from	pe_prescricao a
where	a.nr_atendimento	= nr_atendimento_p
and	a.dt_validade_prescr	> dt_validade_p
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	exists (
	SELECT	1
	from	pe_prescr_proc_hor c,
		pe_prescr_proc b
	where	c.nr_seq_pe_proc		= b.nr_sequencia
	and	c.nr_seq_pe_prescr		= b.nr_seq_prescr
	and	b.nr_seq_prescr 		= a.nr_sequencia
	and	coalesce(c.ie_situacao,'A')		= 'A'
	and	coalesce(b.ie_adep,'N') 		in ('S','M')	
	and	b.nr_seq_proc 			= cd_item_p
	and	coalesce(b.cd_intervalo,'XPTO')	= coalesce(cd_intervalo_p,'XPTO')
	)
group by
	a.nr_sequencia
order by
	a.nr_sequencia;
	
c07 CURSOR FOR
SELECT	a.nr_prescricao
from	prescr_medica a
where	a.nr_atendimento 	= nr_atendimento_p
and	a.dt_validade_prescr 	> dt_validade_p
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
--and	a.dt_liberacao 		is not null
and	coalesce(a.ie_hemodialise, 'N') <> 'R'
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S'
and	exists (
	SELECT	1
	from	prescr_mat_hor c,
		prescr_material b
	where	c.nr_prescricao 		= b.nr_prescricao
	and	c.nr_seq_material 		= b.nr_sequencia
	and	b.nr_prescricao 		= a.nr_prescricao
	and	b.ie_agrupador 			= 2
	and	coalesce(c.ie_adep,'S') 		= 'S'
	and	coalesce(c.ie_situacao,'A')		= 'A'	
	and	b.cd_material 			= cd_item_p
	and	coalesce(b.cd_intervalo,'XPTO')	= coalesce(cd_intervalo_p,'XPTO')
	and	coalesce(b.qt_dose,1) 		= coalesce(qt_item_p,coalesce(b.qt_dose,1))
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	)
group by
	a.nr_prescricao
order by
	a.nr_prescricao;
	

BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') and (cd_item_p IS NOT NULL AND cd_item_p::text <> '') and (dt_validade_p IS NOT NULL AND dt_validade_p::text <> '') then
	begin
	if (ie_tipo_item_p = 'M') then
		begin
		open c01;
		loop
		fetch c01 into nr_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			if (coalesce(nr_prescricoes_w::text, '') = '') then				
				nr_prescricoes_w	:= nr_prescricao_w;
			elsif (length(nr_prescricoes_w || ',' || nr_prescricao_w) <= 255 ) then
				nr_prescricoes_w	:= nr_prescricoes_w || ',' || nr_prescricao_w;
			end if;
			end;
		end loop;
		close c01;
		end;
	elsif (ie_tipo_item_p = 'S') then
		begin
		open c02;
		loop
		fetch c02 into nr_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			if (coalesce(nr_prescricoes_w::text, '') = '') then				
				nr_prescricoes_w	:= nr_prescricao_w;
			elsif (length(nr_prescricoes_w || ',' || nr_prescricao_w) <= 255 ) then
				nr_prescricoes_w	:= nr_prescricoes_w || ',' || nr_prescricao_w;
			end if;
			end;
		end loop;
		close c02;
		end;
	
	elsif (ie_tipo_item_p in ('P','G','C')) then
		begin
		open c03;
		loop
		fetch c03 into nr_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			if (coalesce(nr_prescricoes_w::text, '') = '') then				
				nr_prescricoes_w	:= nr_prescricao_w;
			elsif (length(nr_prescricoes_w || ',' || nr_prescricao_w) <= 255 ) then
				nr_prescricoes_w	:= nr_prescricoes_w || ',' || nr_prescricao_w;
			end if;
			end;
		end loop;
		close c03;
		end;
		
	elsif (ie_tipo_item_p = 'L') then
		begin
		open c04;
		loop
		fetch c04 into nr_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */
			begin
			if (coalesce(nr_prescricoes_w::text, '') = '') then				
				nr_prescricoes_w	:= nr_prescricao_w;
			elsif (length(nr_prescricoes_w || ',' || nr_prescricao_w) <= 255 ) then
				nr_prescricoes_w	:= nr_prescricoes_w || ',' || nr_prescricao_w;
			end if;
			end;
		end loop;
		close c04;
		end;
		
	elsif (ie_tipo_item_p = 'R') then
		begin
		open c05;
		loop
		fetch c05 into nr_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on c05 */
			begin
			if (coalesce(nr_prescricoes_w::text, '') = '') then				
				nr_prescricoes_w	:= nr_prescricao_w;
			elsif (length(nr_prescricoes_w || ',' || nr_prescricao_w) <= 255 ) then
				nr_prescricoes_w	:= nr_prescricoes_w || ',' || nr_prescricao_w;
			end if;
			end;
		end loop;
		close c05;
		end;
		
	elsif (ie_tipo_item_p = 'E') then
		begin
		open c06;
		loop
		fetch c06 into nr_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on c06 */
			begin
			if (coalesce(nr_prescricoes_w::text, '') = '') then				
				nr_prescricoes_w	:= nr_prescricao_w;
			elsif (length(nr_prescricoes_w || ',' || nr_prescricao_w) <= 255 ) then
				nr_prescricoes_w	:= nr_prescricoes_w || ',' || nr_prescricao_w;
			end if;
			end;
		end loop;
		close c06;
		end;		
		
	elsif (ie_tipo_item_p = 'MAT') then
		begin
		open c07;
		loop
		fetch c07 into nr_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on c07 */
			begin
			if (coalesce(nr_prescricoes_w::text, '') = '') then				
				nr_prescricoes_w	:= nr_prescricao_w;
			elsif (length(nr_prescricoes_w || ',' || nr_prescricao_w) <= 255 ) then
				nr_prescricoes_w	:= nr_prescricoes_w || ',' || nr_prescricao_w;
			end if;
			end;
		end loop;
		close c07;
		end;				
	end if;	
	end;
end if;
return  nr_prescricoes_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_prescricoes ( nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, nr_seq_proc_interno_p bigint, cd_intervalo_p text, qt_item_p bigint, ie_data_lib_proc_p text, ie_data_lib_prescr_p text, ie_exibe_suspensos_p text, dt_validade_p timestamp, cd_setor_paciente_p bigint, nr_seq_cpoe_p bigint) FROM PUBLIC;

