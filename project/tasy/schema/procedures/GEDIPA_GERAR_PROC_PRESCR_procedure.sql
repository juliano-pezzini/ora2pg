-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gedipa_gerar_proc_prescr ( cd_estabelecimento_p bigint, nr_prescricao_p text, nr_seq_processo_p bigint) AS $body$
DECLARE

 
nr_atendimento_w			bigint;
dt_horario_w				timestamp;
nr_seq_processo_w			bigint;
dt_inicio_w					timestamp;
dt_fim_w					timestamp;
nr_prescricao_w				bigint;
nr_seq_solucao_w			integer;
nr_etapa_w					smallint;
nr_seq_processo_agora_w		bigint;
cd_local_estoque_w			smallint;
cd_setor_prescr_w			bigint;
nr_seq_processo_nut_w		bigint;
nr_seq_material_w			bigint;
nr_seq_procedimento_w		bigint;
qt_procedimento_w			double precision;
cd_intervalo_w				varchar(7);
qt_etapas_w					bigint;
ie_trans_proc_gedipa_w		varchar(1);
ie_grava_log_gedipa_w		varchar(1);
ie_gerar_proc_frac_sol_w 	varchar(1);
ie_separar_proc_area_w		varchar(1);
nr_seq_area_prep_w			bigint;

ds_erro_w	varchar(1800);

 
c01 REFCURSOR;

 
c02 REFCURSOR;

 
c03 REFCURSOR;

 

BEGIN 
 
if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then 
 
	update 	prescr_mat_hor 
	set	nr_seq_processo  = NULL 
	where 	nr_seq_processo = nr_seq_processo_p;
	 
	 
	update 	adep_processo 
	set	ie_status_processo = 'C' 
	where 	nr_sequencia = nr_seq_processo_p;
	 
	commit;
	 
end if;
 
select	coalesce(max(ie_trans_proc_gedipa),'N'), 
		coalesce(max(ie_grava_log_gedipa),'S'), 
		coalesce(max(ie_gerar_proc_frac_sol),'N'), 
		coalesce(max(ie_gerar_processo_area),'N') 
into STRICT	ie_trans_proc_gedipa_w, 
		ie_grava_log_gedipa_w, 
		ie_gerar_proc_frac_sol_w, 
		ie_separar_proc_area_w 
from	parametros_farmacia 
where	cd_estabelecimento = coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);
 
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then 
	if (ie_trans_proc_gedipa_w = 'N') then 
		open c01 for 
		SELECT	a.nr_atendimento, 
				a.dt_horario, 
				a.cd_local_estoque, 
				a.cd_setor_prescr, 
				CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		from	setor_atendimento b, 
				adep_ged_pend_v a 
		where	a.cd_setor_prescr 			= b.cd_setor_atendimento 
		and		a.nr_prescricao 			= nr_prescricao_p 
		and		a.cd_estabelecimento		= cd_estabelecimento_p 
		and		a.ie_setor_processo_gedipa	= 'S' 
		and		coalesce(a.nr_seq_processo::text, '') = '' 
		and		gedipa_obter_gerar_proc(clock_timestamp() - interval '2 days', 'AP_LOTE', a.nr_seq_lote,ie_gedipa)	= 'S' 
		and		coalesce(a.ie_conferencia,'S') 	= 'S' 
		and		coalesce(a.ie_higienizacao,'S') 	= 'S' 
		and		coalesce(a.ie_preparo,'S') 		= 'S' 
		group by 
			a.nr_atendimento, a.dt_horario, a.cd_local_estoque, a.cd_setor_prescr, CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		order by 
			a.nr_atendimento, a.dt_horario;
	else 
		open c01 for 
		SELECT	a.nr_atendimento, 
				a.dt_horario, 
				a.cd_local_estoque, 
				a.cd_setor_prescr, 
				CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		from	setor_atendimento b, 
				adep_ged_pend_v a 
		where	a.cd_setor_prescr = b.cd_setor_atendimento 
		and		a.nr_prescricao = nr_prescricao_p 
		and		a.cd_estabelecimento		= cd_estabelecimento_p 
		and		a.ie_setor_processo_gedipa	= 'S' 
		and		gedipa_obter_gerar_proc_status(clock_timestamp() - interval '2 days', 'AP_LOTE', a.nr_seq_lote,ie_gedipa,a.nr_seq_processo, a.nr_seq_area_prep, null)	= 'S' 
		and		coalesce(a.ie_conferencia,'S') 	= 'S' 
		and		coalesce(a.ie_higienizacao,'S') 	= 'S' 
		and		coalesce(a.ie_preparo,'S') 		= 'S' 
		group by 
			a.nr_atendimento, a.dt_horario, a.cd_local_estoque, a.cd_setor_prescr, CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		order by 
			a.nr_atendimento, a.dt_horario;		
	end if;		
else 
	if (ie_trans_proc_gedipa_w = 'N') then 
		open c01 for 
		SELECT	a.nr_atendimento, 
				a.dt_horario, 
				a.cd_local_estoque, 
				a.cd_setor_prescr, 
				CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		from	setor_atendimento b, 
			adep_ged_pend_v a 
		where	a.cd_setor_prescr = b.cd_setor_atendimento 
		and	a.nr_prescricao = nr_prescricao_p 
		and	a.ie_setor_processo_gedipa					= 'S' 
		and	coalesce(a.nr_seq_processo::text, '') = '' 
		and	gedipa_obter_gerar_proc(clock_timestamp() - interval '2 days', 'AP_LOTE', a.nr_seq_lote,ie_gedipa)	= 'S' 
		and	coalesce(a.ie_conferencia,'S') = 'S' 
		and	coalesce(a.ie_higienizacao,'S') = 'S' 
		and	coalesce(a.ie_preparo,'S') = 'S' 
		group by 
			a.nr_atendimento, a.dt_horario, a.cd_local_estoque, a.cd_setor_prescr, CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		order by 
			a.nr_atendimento, a.dt_horario;
	else 
		open c01 for 
		SELECT	a.nr_atendimento, 
			a.dt_horario, 
			a.cd_local_estoque, 
			a.cd_setor_prescr, 
			CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		from	setor_atendimento b, 
			adep_ged_pend_v a 
		where	a.cd_setor_prescr = b.cd_setor_atendimento 
		and	a.nr_prescricao = nr_prescricao_p 
		and	a.ie_setor_processo_gedipa					= 'S' 
		and	gedipa_obter_gerar_proc_status(clock_timestamp() - interval '2 days', 'AP_LOTE', a.nr_seq_lote,ie_gedipa,a.nr_seq_processo, a.nr_seq_area_prep, null)	= 'S' 
		and	coalesce(a.ie_conferencia,'S') = 'S' 
		and	coalesce(a.ie_higienizacao,'S') = 'S' 
		and	coalesce(a.ie_preparo,'S') = 'S' 
		group by 
			a.nr_atendimento, a.dt_horario, a.cd_local_estoque, a.cd_setor_prescr, CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		order by 
			a.nr_atendimento, a.dt_horario;
	 
	end if;
end if;
 
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then 
	if (ie_trans_proc_gedipa_w = 'N') then	 
		open c02 for 
		SELECT	a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario 
		from	setor_atendimento e, 
			prescr_solucao b, 
			prescr_material d, 
			prescr_medica a, 
			prescr_mat_hor c 
		where	e.cd_setor_atendimento						= a.cd_setor_atendimento 
		and	d.nr_prescricao							= a.nr_prescricao 
		and	d.nr_sequencia_solucao						= b.nr_seq_solucao 
		and	d.nr_sequencia							= c.nr_seq_material 
		and	d.nr_prescricao							= c.nr_prescricao 
		and	c.nr_prescricao							= a.nr_prescricao 
		and	b.nr_prescricao							= a.nr_prescricao 
		and	((coalesce(b.ie_acm,'N')						<> 'S') or (coalesce(b.IE_ETAPA_ESPECIAL,'N')					= 'S')) 
		and	coalesce(b.ie_se_necessario,'N')					<> 'S' 
		and 	b.nr_prescricao 						= nr_prescricao_p 
		and	c.ie_agrupador							in (4,13) 
		and	d.ie_agrupador							in (4,13) 
		and	coalesce(c.nr_seq_processo::text, '') = '' 
		and	obter_se_setor_processo_gedipa(a.cd_setor_atendimento) 		= 'S' 
		and	gedipa_obter_gerar_proc(clock_timestamp() - interval '2 days', 'AP_LOTE', c.nr_seq_lote,ie_gedipa)	= 'S' 
		and	a.cd_estabelecimento						= cd_estabelecimento_p 
		and	(c.dt_lib_horario IS NOT NULL AND c.dt_lib_horario::text <> '') 
		group by 
			a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario 
		order by 
			a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario;
	else 
		open c02 for 
		SELECT	a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario 
		from	setor_atendimento e, 
			prescr_solucao b, 
			prescr_material d, 
			prescr_medica a, 
			prescr_mat_hor c 
		where	e.cd_setor_atendimento						= a.cd_setor_atendimento 
		and	d.nr_prescricao							= a.nr_prescricao 
		and	d.nr_sequencia_solucao						= b.nr_seq_solucao 
		and	d.nr_sequencia							= c.nr_seq_material 
		and	d.nr_prescricao							= c.nr_prescricao 
		and	c.nr_prescricao							= a.nr_prescricao 
		and	b.nr_prescricao							= a.nr_prescricao 
		and	((coalesce(b.ie_acm,'N')						<> 'S') or (coalesce(b.IE_ETAPA_ESPECIAL,'N')					= 'S')) 
		and	coalesce(b.ie_se_necessario,'N')					<> 'S' 
		and 	b.nr_prescricao 						= nr_prescricao_p 
		and	c.ie_agrupador							in (4,13) 
		and	d.ie_agrupador							in (4,13) 
		and	obter_se_setor_processo_gedipa(a.cd_setor_atendimento) 		= 'S' 
		and	gedipa_obter_gerar_proc_status(clock_timestamp() - interval '2 days', 'AP_LOTE', c.nr_seq_lote,ie_gedipa,c.nr_seq_processo, c.nr_seq_area_prep, null)	= 'S' 
		and	a.cd_estabelecimento						= cd_estabelecimento_p 
		and	(c.dt_lib_horario IS NOT NULL AND c.dt_lib_horario::text <> '') 
		group by 
			a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario 
		order by 
			a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario;		
	end if;
else 
	if (ie_trans_proc_gedipa_w = 'N') then	 
		open c02 for 
		SELECT	a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario 
		from	setor_atendimento e, 
			prescr_solucao b, 
			prescr_material d, 
			prescr_medica a, 
			prescr_mat_hor c 
		where	e.cd_setor_atendimento						= a.cd_setor_atendimento 
		and	d.nr_prescricao							= a.nr_prescricao 
		and	d.nr_sequencia_solucao						= b.nr_seq_solucao 
		and	d.nr_sequencia							= c.nr_seq_material 
		and	d.nr_prescricao							= c.nr_prescricao 
		and	c.nr_prescricao							= a.nr_prescricao 
		and	b.nr_prescricao							= a.nr_prescricao 
		and	((coalesce(b.ie_acm,'N')						<> 'S') or (coalesce(b.IE_ETAPA_ESPECIAL,'N')					= 'S')) 
		and	coalesce(b.ie_se_necessario,'N')					<> 'S' 
		and 	b.nr_prescricao 						= nr_prescricao_p 
		and	c.ie_agrupador							in (4,13) 
		and	d.ie_agrupador							in (4,13) 
		and	coalesce(c.nr_seq_processo::text, '') = '' 
		and	obter_se_setor_processo_gedipa(a.cd_setor_atendimento) 		= 'S' 
		and	gedipa_obter_gerar_proc(clock_timestamp() - interval '2 days', 'AP_LOTE', c.nr_seq_lote,ie_gedipa)	= 'S' 
		and	(c.dt_lib_horario IS NOT NULL AND c.dt_lib_horario::text <> '') 
		group by 
			a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario 
		order by 
			a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario;
	else 
		open c02 for 
		SELECT	a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario 
		from	setor_atendimento e, 
			prescr_solucao b, 
			prescr_material d, 
			prescr_medica a, 
			prescr_mat_hor c 
		where	e.cd_setor_atendimento						= a.cd_setor_atendimento 
		and	d.nr_prescricao							= a.nr_prescricao 
		and	d.nr_sequencia_solucao						= b.nr_seq_solucao 
		and	d.nr_sequencia							= c.nr_seq_material 
		and	d.nr_prescricao							= c.nr_prescricao 
		and	c.nr_prescricao							= a.nr_prescricao 
		and	b.nr_prescricao							= a.nr_prescricao 
		and	((coalesce(b.ie_acm,'N')						<> 'S') or (coalesce(b.IE_ETAPA_ESPECIAL,'N')					= 'S')) 
		and	coalesce(b.ie_se_necessario,'N')					<> 'S' 
		and	c.ie_agrupador							in (4,13) 
		and	d.ie_agrupador							in (4,13) 
		and	coalesce(c.nr_seq_processo::text, '') = '' 
		and 	b.nr_prescricao 						= nr_prescricao_p 
		and	obter_se_setor_processo_gedipa(a.cd_setor_atendimento) 		= 'S' 
		and	gedipa_obter_gerar_proc_status(clock_timestamp() - interval '2 days', 'AP_LOTE', c.nr_seq_lote,ie_gedipa,c.nr_seq_processo, c.nr_seq_area_prep, null)	= 'S' 
		and	(c.dt_lib_horario IS NOT NULL AND c.dt_lib_horario::text <> '') 
		group by 
			a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario 
		order by 
			a.nr_atendimento, 
			b.nr_prescricao, 
			b.nr_seq_solucao, 
			c.dt_horario;
	end if;
end if;
 
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then 
	if (ie_trans_proc_gedipa_w = 'N') then	 
		open c03 for 
		SELECT	a.nr_atendimento, 
				a.dt_horario, 
				a.cd_local_estoque, 
				a.cd_setor_prescr, 
				CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		from	setor_atendimento b, 
				adep_ged_pend_v a 
		where	a.cd_setor_prescr 	= b.cd_setor_atendimento 
		and	a.nr_prescricao 	= nr_prescricao_p 
		and	a.cd_estabelecimento						= cd_estabelecimento_p 
		and	a.ie_setor_processo_gedipa					= 'S' 
		and	coalesce(a.nr_seq_processo::text, '') = '' 
		and	gedipa_obter_gerar_proc(clock_timestamp() - interval '2 days', 'AP_LOTE', a.nr_seq_lote,ie_gedipa)	= 'S' 
		AND	((coalesce(a.ie_conferencia,'S') = 'N') OR (coalesce(a.ie_higienizacao,'S') = 'N') OR (coalesce(a.ie_preparo,'S') = 'N')) 
		group by 
			a.nr_atendimento, a.dt_horario, a.cd_local_estoque, a.cd_setor_prescr, CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		order by 
			a.nr_atendimento, a.dt_horario;
	else 
		open c03 for 
		SELECT	a.nr_atendimento, 
				a.dt_horario, 
				a.cd_local_estoque, 
				a.cd_setor_prescr, 
				CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		from	setor_atendimento b, 
				adep_ged_pend_v a 
		where	a.cd_setor_prescr = b.cd_setor_atendimento 
		and	a.nr_prescricao = nr_prescricao_p 
		and	a.cd_estabelecimento						= cd_estabelecimento_p 
		and	a.ie_setor_processo_gedipa					= 'S' 
		and	gedipa_obter_gerar_proc_status(clock_timestamp() - interval '2 days', 'AP_LOTE', a.nr_seq_lote,ie_gedipa,a.nr_seq_processo, a.nr_seq_area_prep, null)	= 'S' 
		AND	((coalesce(a.ie_conferencia,'S') = 'N') OR (coalesce(a.ie_higienizacao,'S') = 'N') OR (coalesce(a.ie_preparo,'S') = 'N')) 
		group by 
			a.nr_atendimento, a.dt_horario, a.cd_local_estoque, a.cd_setor_prescr, CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		order by 
			a.nr_atendimento, a.dt_horario;
	end if;
else 
	if (ie_trans_proc_gedipa_w = 'N') then	 
		open c03 for 
		SELECT	a.nr_atendimento, 
				a.dt_horario, 
				a.cd_local_estoque, 
				a.cd_setor_prescr, 
				CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		from	setor_atendimento b, 
			adep_ged_pend_v a 
		where	a.cd_setor_prescr = b.cd_setor_atendimento 
		and	a.nr_prescricao = nr_prescricao_p 
		and	a.ie_setor_processo_gedipa					= 'S' 
		and	coalesce(a.nr_seq_processo::text, '') = '' 
		and	gedipa_obter_gerar_proc(clock_timestamp() - interval '2 days', 'AP_LOTE', a.nr_seq_lote,ie_gedipa)	= 'S' 
		AND	((coalesce(a.ie_conferencia,'S') = 'N') OR (coalesce(a.ie_higienizacao,'S') = 'N') OR (coalesce(a.ie_preparo,'S') = 'N')) 
		group by 
			a.nr_atendimento, a.dt_horario, a.cd_local_estoque, a.cd_setor_prescr, CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		order by 
			a.nr_atendimento, a.dt_horario;
	else 
		open c03 for 
		SELECT	a.nr_atendimento, 
				a.dt_horario, 
				a.cd_local_estoque, 
				a.cd_setor_prescr, 
				CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		from	setor_atendimento b, 
				adep_ged_pend_v a 
		where	a.cd_setor_prescr = b.cd_setor_atendimento 
		and	a.ie_setor_processo_gedipa					= 'S' 
		and	a.nr_prescricao = nr_prescricao_p 
		and	gedipa_obter_gerar_proc_status(clock_timestamp() - interval '2 days', 'AP_LOTE', a.nr_seq_lote,ie_gedipa,a.nr_seq_processo, a.nr_seq_area_prep, null)	= 'S' 
		AND	((coalesce(a.ie_conferencia,'S') = 'N') OR (coalesce(a.ie_higienizacao,'S') = 'N') OR (coalesce(a.ie_preparo,'S') = 'N')) 
		group by 
			a.nr_atendimento, a.dt_horario, a.cd_local_estoque, a.cd_setor_prescr, CASE WHEN ie_separar_proc_area_w='S' THEN a.nr_seq_area_prep  ELSE null END  
		order by 
			a.nr_atendimento, a.dt_horario;
	end if;
end if;
 
loop 
fetch c01 into 
	nr_atendimento_w, 
	dt_horario_w, 
	cd_local_estoque_w, 
	cd_setor_prescr_w, 
	nr_seq_area_prep_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	SELECT * FROM gerar_processo_adep(nr_atendimento_w, dt_horario_w, 'Job', nr_seq_processo_w, 'S', null, 'GGP', 'S', 'S', nr_seq_processo_agora_w, cd_local_estoque_w, cd_setor_prescr_w, 'N', nr_seq_processo_nut_w, nr_seq_area_prep_w) INTO STRICT nr_seq_processo_w, nr_seq_processo_agora_w, nr_seq_processo_nut_w;
	 
	CALL gerar_fracionamento_processo(nr_seq_processo_w, 'Job');
	if (coalesce(nr_seq_processo_nut_w,0) > 0) then 
		CALL gerar_fracionamento_processo(nr_seq_processo_nut_w, 'Job');
	end if;
	 
	CALL gerar_fracionamento_processo(nr_seq_processo_agora_w, 'Job');
 
	end;
end loop;
close c01;
 
--open c02; 
loop 
fetch c02 into	nr_atendimento_w, 
		nr_prescricao_w, 
		nr_seq_solucao_w, 
		dt_horario_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin 
	select	coalesce(max(nr_etapa),0)+1 
	into STRICT	nr_etapa_w 
	from	adep_processo 
	where	nr_atendimento	= nr_atendimento_w 
	and	nr_prescricao	= nr_prescricao_w 
	and	nr_seq_solucao	= nr_seq_solucao_w;
	 
	nr_seq_processo_w := gerar_processo_adep_sol(nr_atendimento_w, nr_prescricao_w, nr_seq_solucao_w, nr_etapa_w, dt_horario_w, 'Job', nr_seq_processo_w, 'S', null, 'GGP', 'S', null, null);
 
	update	prescr_mat_hor a 
	set	a.nr_seq_processo	= nr_seq_processo_w 
	where	a.nr_prescricao	= nr_prescricao_w 
	and	a.dt_horario	= dt_horario_w 
	and	a.ie_agrupador	in (4,13) 
	and 	exists ( 
			SELECT	1 
			from	prescr_material b 
			where	b.nr_prescricao		= a.nr_prescricao 
			and	b.nr_sequencia		= a.nr_seq_material 
			and	b.ie_agrupador		in (4,13) 
			and	b.nr_sequencia_solucao	= nr_seq_solucao_w);
 
	if (ie_gerar_proc_frac_sol_w = 'S') then 
		update	prescr_mat_hor a 
		set	a.nr_seq_processo	= nr_seq_processo_w 
		where	a.nr_prescricao	= nr_prescricao_w 
		and	a.dt_horario	= dt_horario_w 
		and 	exists ( 
				SELECT	1 
				from	prescr_material b 
				where	b.nr_prescricao		= a.nr_prescricao 
				and	b.nr_sequencia		= a.nr_seq_material 
				and	b.nr_seq_kit		= nr_seq_solucao_w);
	end if;
	CALL atual_proc_area_kit_comp_sol(nr_seq_processo_w, nr_prescricao_w, nr_seq_solucao_w, dt_horario_w, null,'N');
	 
	CALL gerar_frac_proc_sol(nr_seq_processo_w, nr_prescricao_w, nr_seq_solucao_w, 'N', 'Job',null,'N');
	 
	end;
end loop;
close c02;
 
--open c03; 
loop 
fetch c03 into 
	nr_atendimento_w, 
	dt_horario_w, 
	cd_local_estoque_w, 
	cd_setor_prescr_w, 
	nr_seq_area_prep_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin 
	 
	SELECT * FROM gerar_processo_adep(nr_atendimento_w, dt_horario_w, 'Job', nr_seq_processo_w, 'S', null, 'GGP', 'S', 'S', nr_seq_processo_agora_w, cd_local_estoque_w, cd_setor_prescr_w, 'S', nr_seq_processo_nut_w, nr_seq_area_prep_w) INTO STRICT nr_seq_processo_w, nr_seq_processo_agora_w, nr_seq_processo_nut_w;
	CALL gerar_fracionamento_processo(nr_seq_processo_w, 'Job');
 
	if (coalesce(nr_seq_processo_nut_w,0) > 0) then 
		CALL gerar_fracionamento_processo(nr_seq_processo_nut_w, 'Job');
	end if;
	 
	CALL gerar_fracionamento_processo(nr_seq_processo_agora_w, 'Job');
	end;
end loop;
close c03;
exception 
when others then 
	ds_erro_w	:= substr(SQLERRM(SQLSTATE),1,1800);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gedipa_gerar_proc_prescr ( cd_estabelecimento_p bigint, nr_prescricao_p text, nr_seq_processo_p bigint) FROM PUBLIC;

