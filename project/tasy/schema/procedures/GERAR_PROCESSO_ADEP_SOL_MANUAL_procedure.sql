-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_processo_adep_sol_manual ( nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text, ie_somente_gedipa_p text, cd_funcao_origem_p bigint, ie_gedipa_p text, nr_seq_processo_p INOUT bigint, nr_seq_material_p bigint, nr_seq_procedimento_p bigint, ie_sup_oral_p text, nr_etapa_p bigint ) AS $body$
DECLARE


dt_horario_w		timestamp;
dt_hor_processo_w	timestamp;
nr_etapa_w		smallint := 1;
nr_seq_processo_w	bigint;
qt_etapas_w		bigint;
cd_estabelecimento_w	bigint;
ie_forma_apres_sol_w	varchar(5);
Ie_Separa_nutricao_w	varchar(5);
ie_local_estoque_proc_w	varchar(5);
ie_grava_log_rastr_w varchar(1);

c01 CURSOR FOR
SELECT	d.dt_horario
from	prescr_mat_hor d,
	prescr_material c,
	prescr_solucao b,
	prescr_medica a
where	d.nr_prescricao		= c.nr_prescricao
and	d.nr_seq_material	= c.nr_sequencia
and	d.nr_prescricao		= a.nr_prescricao
and	c.nr_prescricao		= b.nr_prescricao
and	c.nr_sequencia_solucao	= b.nr_seq_solucao
and	c.nr_prescricao		= a.nr_prescricao
and	b.nr_prescricao		= a.nr_prescricao
and	b.nr_seq_solucao	= nr_seq_solucao_p
and	a.nr_prescricao		= nr_prescricao_p
and	a.nr_atendimento	= nr_atendimento_p
and	((coalesce(dt_hor_processo_w::text, '') = '') or (d.dt_horario		= dt_hor_processo_w))
and	c.ie_agrupador		in (4,13)
and	coalesce(c.ie_suspenso,'N')	<> 'S'
and	coalesce(b.dt_suspensao::text, '') = ''
and	coalesce(a.dt_suspensao::text, '') = ''
and coalesce(d.dt_fim_horario::text, '') = ''
and coalesce(d.dt_inicio_horario::text, '') = ''
and coalesce(d.dt_interrupcao::text, '') = ''
and	Obter_se_horario_liberado(d.dt_lib_horario, d.dt_horario) = 'S'
group by d.dt_horario
order by d.dt_horario;
	
c02 CURSOR FOR
SELECT	d.dt_horario
from	prescr_mat_hor d,
	prescr_material c,	
	prescr_medica a
where	d.nr_prescricao		= c.nr_prescricao
and	d.nr_seq_material	= c.nr_sequencia
and	d.nr_prescricao		= a.nr_prescricao
and	c.nr_prescricao		= a.nr_prescricao
and	a.nr_prescricao		= nr_prescricao_p
and	a.nr_atendimento	= nr_atendimento_p
and	c.nr_sequencia		= nr_seq_material_p
and	c.ie_agrupador		= 8
and	coalesce(c.ie_suspenso,'N')	<> 'S'
and	coalesce(c.dt_suspensao::text, '') = ''
and	coalesce(a.dt_suspensao::text, '') = ''
and	Obter_se_horario_liberado(d.dt_lib_horario, d.dt_horario) = 'S'
group by d.dt_horario
order by d.dt_horario;
	
c03 CURSOR FOR
SELECT	coalesce(obter_ocorrencias_horarios_rep(c.ds_horarios),1) * coalesce(c.qt_procedimento,1)
from	prescr_procedimento c,	
	prescr_medica a
where	c.nr_prescricao		= a.nr_prescricao
and	a.nr_prescricao		= nr_prescricao_p
and	a.nr_atendimento	= nr_atendimento_p
and	c.nr_sequencia		= nr_seq_procedimento_p
and	coalesce(c.ie_suspenso,'N')	<> 'S'
and	coalesce(c.dt_suspensao::text, '') = ''
and	coalesce(a.dt_suspensao::text, '') = ''
--and	c.nr_seq_proc_interno is null
and	coalesce(c.nr_seq_exame::text, '') = ''
and	(c.nr_seq_solic_sangue IS NOT NULL AND c.nr_seq_solic_sangue::text <> '')
and	(c.nr_seq_derivado IS NOT NULL AND c.nr_seq_derivado::text <> '')
and	coalesce(c.nr_seq_exame_sangue::text, '') = ''
and	not exists (	SELECT	1
				from	adep_processo b
				where	b.nr_prescricao = a.nr_prescricao
				and	b.nr_seq_procedimento = c.nr_sequencia)
group by c.ds_horarios,
	c.qt_procedimento;	
	
c04 CURSOR FOR
SELECT	d.dt_horario
from	prescr_mat_hor d,
	prescr_material c,	
	prescr_medica a
where	d.nr_prescricao		= c.nr_prescricao
and	d.nr_seq_material	= c.nr_sequencia
and	d.nr_prescricao		= a.nr_prescricao
and	c.nr_prescricao		= a.nr_prescricao
and	a.nr_prescricao		= nr_prescricao_p
and	a.nr_atendimento	= nr_atendimento_p
and	c.nr_sequencia		= nr_seq_material_p
and	c.ie_agrupador		= 12
and	coalesce(c.ie_suspenso,'N')	<> 'S'
and	coalesce(c.dt_suspensao::text, '') = ''
and	coalesce(a.dt_suspensao::text, '') = ''
and	Obter_se_horario_liberado(d.dt_lib_horario, d.dt_horario) = 'S'
group by d.dt_horario
order by d.dt_horario;
	
c07 CURSOR FOR
SELECT	d.dt_horario
from	prescr_mat_hor d,
	prescr_material c,	
	prescr_medica a
where	d.nr_prescricao		= c.nr_prescricao
and	d.nr_seq_material	= c.nr_sequencia
and	d.nr_prescricao		= a.nr_prescricao
and	c.nr_prescricao		= a.nr_prescricao
and	a.nr_prescricao		= nr_prescricao_p
and	a.nr_atendimento	= nr_atendimento_p
and	c.nr_sequencia		= nr_seq_material_p
and	c.ie_agrupador		= 8
AND	Ie_Separa_nutricao_w = 'S'
and	coalesce(c.ie_suspenso,'N')	<> 'S'
and	coalesce(c.dt_suspensao::text, '') = ''
and	coalesce(a.dt_suspensao::text, '') = ''
and	Obter_se_horario_liberado(d.dt_lib_horario, d.dt_horario) = 'S'
group by d.dt_horario
order by d.dt_horario;
	
BEGIN

ie_grava_log_rastr_w := obter_rastreabilidade_adep(nr_prescricao_p, 'GP');

if (ie_grava_log_rastr_w = 'S') then
    CALL adep_gerar_log_rastr('{'||chr(10)||
        '"cd_funcao_origem_p" : "'||cd_funcao_origem_p||'",'||chr(10)||
        '"ie_gedipa_p" : "'||ie_gedipa_p||'",'||chr(10)||
        '"ie_somente_gedipa_p" : "'||ie_somente_gedipa_p||'",'||chr(10)||
        '"ie_sup_oral_p" : "'||ie_sup_oral_p||'",'||chr(10)||
        '"nm_usuario_p" : "'||nm_usuario_p||'",'||chr(10)||
        '"nr_atendimento_p" : "'||nr_atendimento_p||'",'||chr(10)||
        '"nr_etapa_p" : "'||nr_etapa_p||'",'||chr(10)||
        '"nr_prescricao_p" : "'||nr_prescricao_p||'",'||chr(10)||
        '"nr_seq_material_p" : "'||nr_seq_material_p||'",'||chr(10)||
        '"nr_seq_procedimento_p" : "'||nr_seq_procedimento_p||'",'||chr(10)||
        '"nr_seq_processo_p" : "'||nr_seq_processo_p||'",'||chr(10)||
        '"nr_seq_solucao_p" : "'||nr_seq_solucao_p||'"}', wheb_usuario_pck.get_ie_commit);
end if;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (coalesce(nr_seq_material_p::text, '') = '') and (coalesce(nr_seq_procedimento_p::text, '') = '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	prescr_medica
	where	nr_prescricao	= nr_prescricao_p;
	
	SELECT	coalesce(MAX(ie_local_estoque_proc),'P'),
		coalesce(max(ie_separa_nutricao),'N')
	INTO STRICT	ie_local_estoque_proc_w,
		ie_separa_nutricao_w
	FROM	parametros_farmacia
	WHERE	cd_estabelecimento	= cd_estabelecimento_w;
	
	ie_forma_apres_sol_w := Obter_Param_Usuario(1113, 241, obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_w, ie_forma_apres_sol_w);
	
	if	((ie_forma_apres_sol_w = 'H') or (nr_etapa_p > 1)) then
	
		select	max(d.dt_horario)
		into STRICT	dt_hor_processo_w
		from	prescr_mat_hor d
		where	d.nr_seq_solucao	= nr_seq_solucao_p
		and		d.nr_prescricao		= nr_prescricao_p
		and		d.nr_etapa_sol		= nr_etapa_p
		and		coalesce(d.dt_suspensao::text, '') = ''
		and		Obter_se_horario_liberado(d.dt_lib_horario, d.dt_horario) = 'S';
		
		nr_etapa_w	:= nr_etapa_p;
	
	end if;

    if (ie_grava_log_rastr_w = 'S') then
        CALL adep_gerar_log_rastr('{'||chr(10)||
            '"dt_hor_processo_w" : "'||to_char(dt_hor_processo_w, 'dd/mm/yyyy hh24:mi:ss')||'",'||chr(10)||
            '"nr_atendimento_p" : "'||nr_atendimento_p||'",'||chr(10)||
            '"nr_prescricao_p" : "'||nr_prescricao_p||'",'||chr(10)||
            '"nr_seq_solucao_p" : "'||nr_seq_solucao_p||'"}', wheb_usuario_pck.get_ie_commit);
    end if;
	
	open c01;
	loop
	fetch c01 into
		dt_horario_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		CALL adep_gerar_area_prep(nr_prescricao_p, null, nm_usuario_p);		
		
		nr_seq_processo_w := gerar_processo_adep_sol(nr_atendimento_p, nr_prescricao_p, nr_seq_solucao_p, nr_etapa_w, dt_horario_w, nm_usuario_p, nr_seq_processo_w, ie_somente_gedipa_p, cd_funcao_origem_p, 'GPASM', ie_gedipa_p, null, null);
		
		update	prescr_mat_hor a
		set	a.nr_seq_processo	= nr_seq_processo_w
		where	a.nr_prescricao		= nr_prescricao_p
		and	a.dt_horario		= dt_horario_w
		and	a.ie_agrupador		in (4,13)
		and 	exists (
				SELECT	1
				from	prescr_material b
				where	b.nr_prescricao		= a.nr_prescricao
				and	b.nr_sequencia		= a.nr_seq_material
				and	b.ie_agrupador		in (4,13)
				and	b.nr_sequencia_solucao	= nr_seq_solucao_p);
				
		CALL atual_proc_area_kit_comp_sol(nr_seq_processo_w, nr_prescricao_p, nr_seq_solucao_p, dt_horario_w, null,'N');
		
		if (ie_gedipa_p = 'S') then
			begin
			CALL gerar_frac_proc_sol(nr_seq_processo_w, nr_prescricao_p, nr_seq_solucao_p, 'S', nm_usuario_p, null,'N');
			end;
		end if;
		
		nr_etapa_w	:= nr_etapa_w + 1;
		end;
	end loop;
	close c01;
	end;
	
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (coalesce(nr_seq_solucao_p::text, '') = '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') and (coalesce(ie_sup_oral_p,'N') = 'N') and (coalesce(nr_seq_procedimento_p::text, '') = '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then	
	begin
	
    if (ie_grava_log_rastr_w = 'S') then
        CALL adep_gerar_log_rastr('{'||chr(10)||
            '"Ie_Separa_nutricao_w" : "'||Ie_Separa_nutricao_w||'",'||chr(10)||
            '"nr_atendimento_p" : "'||nr_atendimento_p||'",'||chr(10)||
            '"nr_prescricao_p" : "'||nr_prescricao_p||'",'||chr(10)||
            '"nr_seq_material_p" : "'||nr_seq_material_p||'"}', wheb_usuario_pck.get_ie_commit);
    end if;

	open c07;
	loop
	fetch c07 into dt_horario_w;
	EXIT WHEN NOT FOUND; /* apply on c07 */
		begin
		
		CALL adep_gerar_area_prep(nr_prescricao_p, null, nm_usuario_p);		
		nr_seq_processo_w := gerar_processo_adep_sol(nr_atendimento_p, nr_prescricao_p, null, nr_etapa_w, dt_horario_w, nm_usuario_p, nr_seq_processo_w, ie_somente_gedipa_p, cd_funcao_origem_p, 'GPASM', ie_gedipa_p, nr_seq_material_p, null);
		
		update	prescr_mat_hor a
		set	a.nr_seq_processo	= nr_seq_processo_w
		where	a.nr_prescricao		= nr_prescricao_p
		and	a.dt_horario		= dt_horario_w
		and	a.ie_agrupador		= 12
		and 	exists (
				SELECT	1
				from	prescr_material b
				where	b.nr_prescricao		= a.nr_prescricao
				and	b.nr_sequencia		= a.nr_seq_material
				and	b.ie_agrupador		= 12
				and	b.nr_sequencia	= nr_seq_material_p);
				
		CALL atual_proc_area_kit_comp_sol(nr_seq_processo_w, nr_prescricao_p, null, dt_horario_w, nr_seq_material_p,ie_sup_oral_p);
		
		if (ie_gedipa_p = 'S') then
			begin
			CALL gerar_frac_proc_sol(nr_seq_processo_w, nr_prescricao_p, null, 'S', nm_usuario_p, nr_seq_material_p,ie_sup_oral_p);
			end;
		end if;
		
		nr_etapa_w	:= nr_etapa_w + 1;
		end;
	end loop;
	close c07;

    if (ie_grava_log_rastr_w = 'S') then
        CALL adep_gerar_log_rastr('{'||chr(10)||
            '"nr_atendimento_p" : "'||nr_atendimento_p||'",'||chr(10)||
            '"nr_prescricao_p" : "'||nr_prescricao_p||'",'||chr(10)||
            '"nr_seq_material_p" : "'||nr_seq_material_p||'"}', wheb_usuario_pck.get_ie_commit);
    end if;
	
	open c02;
	loop
	fetch c02 into dt_horario_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		
		CALL adep_gerar_area_prep(nr_prescricao_p, null, nm_usuario_p);
		
		nr_seq_processo_w := gerar_processo_adep_sol(nr_atendimento_p, nr_prescricao_p, null, nr_etapa_w, dt_horario_w, nm_usuario_p, nr_seq_processo_w, ie_somente_gedipa_p, cd_funcao_origem_p, 'GPASM', ie_gedipa_p, nr_seq_material_p, null);
		
		update	prescr_mat_hor a
		set	a.nr_seq_processo	= nr_seq_processo_w
		where	a.nr_prescricao		= nr_prescricao_p
		and	a.dt_horario		= dt_horario_w
		and	a.ie_agrupador		= 8
		and 	exists (
				SELECT	1
				from	prescr_material b
				where	b.nr_prescricao		= a.nr_prescricao
				and	b.nr_sequencia		= a.nr_seq_material
				and	b.ie_agrupador		= 8
				and	b.nr_sequencia	= nr_seq_material_p);
				
		CALL atual_proc_area_kit_comp_sol(nr_seq_processo_w, nr_prescricao_p, null, dt_horario_w, nr_seq_material_p,'N');
		
		if (ie_gedipa_p = 'S') then
			begin
			CALL gerar_frac_proc_sol(nr_seq_processo_w, nr_prescricao_p, null, 'S', nm_usuario_p, nr_seq_material_p,'N');
			end;
		end if;
		
		nr_etapa_w	:= nr_etapa_w + 1;
		end;
	end loop;
	close c02;
	
	end;
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (coalesce(nr_seq_solucao_p::text, '') = '') and (coalesce(nr_seq_material_p::text, '') = '') and (nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then	
	begin

    if (ie_grava_log_rastr_w = 'S') then
        CALL adep_gerar_log_rastr('{'||chr(10)||
            '"nr_atendimento_p" : "'||nr_atendimento_p||'",'||chr(10)||
            '"nr_prescricao_p" : "'||nr_prescricao_p||'",'||chr(10)||
            '"nr_seq_procedimento_p" : "'||nr_seq_procedimento_p||'"}', wheb_usuario_pck.get_ie_commit);
    end if;
	
	open c03;
	loop
	fetch c03 into
		qt_etapas_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		
		for i in 1..qt_etapas_w loop
			begin
			
			nr_seq_processo_w := gerar_processo_adep_sol(nr_atendimento_p, nr_prescricao_p, null, nr_etapa_w, dt_horario_w, nm_usuario_p, nr_seq_processo_w, ie_somente_gedipa_p, cd_funcao_origem_p, 'GPASM', ie_gedipa_p, null, nr_seq_procedimento_p);
		
			/*
			update	prescr_proc_hor a
			set	a.nr_seq_processo	= nr_seq_processo_w
			where	a.nr_prescricao		= nr_prescricao_p
			and	a.dt_horario		= dt_horario_w		
			and 	exists (
					select	1
					from	prescr_procedimento b
					where	b.nr_prescricao		= a.nr_prescricao
					and	b.nr_sequencia		= a.nr_seq_procedimento				
					and	b.nr_sequencia		= nr_seq_procedimento_p
					and	b.nr_seq_proc_interno is null
					and	b.nr_seq_exame is null
					and	b.nr_seq_solic_sangue is not null
					and	b.nr_seq_derivado is not null
					and	b.nr_seq_exame_sangue is null);
					
			atual_proc_area_kit_comp_sol(nr_seq_processo_w, nr_prescricao_p, null, dt_horario_w, nr_seq_material_p);
			
			if	(ie_gedipa_p = 'S') then
				begin
				gerar_frac_proc_sol(nr_seq_processo_w, nr_prescricao_p, null, 'S', nm_usuario_p, nr_seq_material_p);
				end;
			end if;*/
			nr_etapa_w	:= nr_etapa_w + 1;
			
			end;
		end loop;
		
		end;
	end loop;
	close c03;
	
	end;
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (coalesce(nr_seq_solucao_p::text, '') = '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') and (coalesce(nr_seq_procedimento_p::text, '') = '') and (coalesce(ie_sup_oral_p,'N') = 'S') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then	
	begin

    if (ie_grava_log_rastr_w = 'S') then
        CALL adep_gerar_log_rastr('{'||chr(10)||
            '"nr_atendimento_p" : "'||nr_atendimento_p||'",'||chr(10)||
            '"nr_prescricao_p" : "'||nr_prescricao_p||'",'||chr(10)||
            '"nr_seq_material_p" : "'||nr_seq_material_p||'"}', wheb_usuario_pck.get_ie_commit);
    end if;

	open c04;
	loop
	fetch c04 into dt_horario_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
		begin
		
		CALL adep_gerar_area_prep(nr_prescricao_p, null, nm_usuario_p);
		
		nr_seq_processo_w := gerar_processo_adep_sol(nr_atendimento_p, nr_prescricao_p, null, nr_etapa_w, dt_horario_w, nm_usuario_p, nr_seq_processo_w, ie_somente_gedipa_p, cd_funcao_origem_p, 'GPASM', ie_gedipa_p, nr_seq_material_p, null);
		
		update	prescr_mat_hor a
		set	a.nr_seq_processo	= nr_seq_processo_w
		where	a.nr_prescricao		= nr_prescricao_p
		and	a.dt_horario		= dt_horario_w
		and	a.ie_agrupador		= 12
		and 	exists (
				SELECT	1
				from	prescr_material b
				where	b.nr_prescricao		= a.nr_prescricao
				and	b.nr_sequencia		= a.nr_seq_material
				and	b.ie_agrupador		= 12
				and	b.nr_sequencia	= nr_seq_material_p);
				
		CALL atual_proc_area_kit_comp_sol(nr_seq_processo_w, nr_prescricao_p, null, dt_horario_w, nr_seq_material_p,ie_sup_oral_p);
		
		if (ie_gedipa_p = 'S') then
			begin
			CALL gerar_frac_proc_sol(nr_seq_processo_w, nr_prescricao_p, null, 'S', nm_usuario_p, nr_seq_material_p,ie_sup_oral_p);
			end;
		end if;
		
		nr_etapa_w	:= nr_etapa_w + 1;
		end;
	end loop;
	close c04;
	
	end;

end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_processo_adep_sol_manual ( nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text, ie_somente_gedipa_p text, cd_funcao_origem_p bigint, ie_gedipa_p text, nr_seq_processo_p INOUT bigint, nr_seq_material_p bigint, nr_seq_procedimento_p bigint, ie_sup_oral_p text, nr_etapa_p bigint ) FROM PUBLIC;

