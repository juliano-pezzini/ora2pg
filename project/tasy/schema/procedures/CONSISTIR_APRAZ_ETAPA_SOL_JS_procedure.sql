-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_apraz_etapa_sol_js ( ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, dt_inicio_p timestamp, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text, ie_somente_gedipa_p text, cd_funcao_origem_p bigint, ie_gedipa_p text, nr_seq_etapa_p bigint, ie_gera_kit_sol_acm_p text, ds_erro_p INOUT text) AS $body$
DECLARE

		 
ds_erro_w				varchar(2000);
dt_horario_w			timestamp;
qt_material_horario_w	bigint;
cd_setor_pac_w			prescr_medica.cd_setor_atendimento%type;
dt_validade_prescr_w	timestamp;
dt_inicio_prescr_w		timestamp;
cd_intervalo_w			intervalo_prescricao.cd_intervalo%type;
nr_horas_val_w			bigint;
qt_min_intervalo_w		bigint;
ie_consistir_acm_w		varchar(1);
cd_estabelecimento_w	prescr_medica.cd_estabelecimento%type;
ie_acm_intervalo_w		varchar(1);
ie_sn_intervalo_w		varchar(1);
qt_hor_int_w			bigint;
varie_permite_apraz_w	varchar(1);
ie_permite_aprazar_w	varchar(1);
nr_atendimento_w		prescr_medica.nr_atendimento%type;
qt_interv_w				bigint;
qt_hor_inv_w			bigint;


BEGIN 
--Usado somente no Java e no PDA 
 
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (dt_inicio_p IS NOT NULL AND dt_inicio_p::text <> '') and (nr_seq_etapa_p IS NOT NULL AND nr_seq_etapa_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	 
	select	max(cd_estabelecimento), 
			max(nr_atendimento) 
	into STRICT	cd_estabelecimento_w, 
			nr_atendimento_w 
	from	prescr_medica 
	where	nr_prescricao = nr_prescricao_p;	
	 
	CALL Wheb_assist_pck.set_informacoes_usuario(cd_estabelecimento_w, obter_perfil_ativo, nm_usuario_p);	
	ie_consistir_acm_w		:= Wheb_assist_pck.obterParametroFuncao(1113,194);
	varie_permite_apraz_w	:= Wheb_assist_pck.obterParametroFuncao(1113,489);
	ie_permite_aprazar_w	:= Wheb_assist_pck.obterParametroFuncao(1113,271);
 
	/* Tratamento novo solicitado pelo hospital Marcio Cunha */
	 
	 
	--Validade da prescrição 
	cd_setor_pac_w		:= Obter_Unidade_Atendimento(nr_atendimento_w, 'IA', 'CS');
	 
	select	count(*) 
	into STRICT	qt_hor_inv_w 
	from	prescr_medica a where		dt_inicio_p between a.dt_inicio_prescr and a.dt_validade_prescr	 
	and		a.nr_prescricao = nr_prescricao_p 
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and		obter_se_exibir_rep_adep_setor(cd_setor_pac_w,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'	 
	and		a.nr_atendimento = nr_atendimento_w LIMIT 1;
 
	if (qt_hor_inv_w = 0) then 
	 
		select	max(dt_validade_prescr), 
				min(dt_inicio_prescr) 
		into STRICT	dt_validade_prescr_w, 
				dt_inicio_prescr_w 
		from	prescr_medica where		nr_prescricao = nr_prescricao_p 
		and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
		and		obter_se_exibir_rep_adep_setor(cd_setor_pac_w,cd_setor_atendimento,coalesce(ie_adep,'S')) = 'S'		 
		and		nr_atendimento = nr_atendimento_w LIMIT 1;
		 
		if	((ie_permite_aprazar_w = 'T') or (ie_permite_aprazar_w = 'S')) and (dt_inicio_p < dt_inicio_prescr_w) then 
			ds_erro_w := null;
		else 
			/*ds_consistencia_w := 'O horário informado está fora do período de validade das prescrições vigentes deste item, favor verificar. ' || chr(13) || 
						'Validade mínima: ' || to_char(dt_inicio_prescr_w, 'dd/mm/yyyy hh24:mi:ss') || chr(13) || 
						'Validade máxima: ' || to_char(dt_validade_prescr_w, 'dd/mm/yyyy hh24:mi:ss'); */
 
			ds_erro_w := wheb_mensagem_pck.get_texto(294663, 'VALMINIMA='||to_char(dt_inicio_prescr_w, 'dd/mm/yyyy hh24:mi:ss')||';VALMAX='||to_char(dt_validade_prescr_w, 'dd/mm/yyyy hh24:mi:ss'));
		end if;
	end if;	
	-- Fim validade da prescrição. 
	 
	select	max(cd_intervalo) 
	into STRICT	cd_intervalo_w 
	from	prescr_solucao 
	where	nr_prescricao = nr_prescricao_p 
	and		nr_seq_solucao = nr_seq_solucao_p;	
	 
	select	coalesce(max(ie_acm),'N'), 
			coalesce(max(ie_se_necessario),'N') 
	into STRICT	ie_acm_intervalo_w, 
			ie_sn_intervalo_w 
	from	intervalo_prescricao where		cd_intervalo = cd_intervalo_w LIMIT 1;
	 
	--Consistir invervalo	 
	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then 
	 
		/* obter horas validade prescrição */
 
		if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then 
			select	max(nr_horas_validade) 
			into STRICT	nr_horas_val_w 
			from	prescr_medica where		nr_prescricao = nr_prescricao_p LIMIT 1;	
		end if;
	 
		/* obter ocorrência intervalo */
 
		qt_interv_w := obter_ocorrencia_intervalo(cd_intervalo_w,nr_horas_val_w,'H');
		 
		select 	coalesce(qt_min_intervalo,0) 
		into STRICT	qt_min_intervalo_w 
		from	intervalo_prescricao where		cd_intervalo = cd_intervalo_w LIMIT 1;
		 
		if (qt_min_intervalo_w = 0) then 
			begin 
			 
			select	count(*) 
			into STRICT	qt_hor_int_w 
			from	prescr_mat_hor a, 
					prescr_solucao b, 
					prescr_medica c 
			where	a.nr_prescricao					= b.nr_prescricao 
			and		a.nr_seq_solucao 				= b.nr_seq_solucao 
			and		a.nr_prescricao					= c.nr_prescricao 
			and		b.nr_prescricao					= c.nr_prescricao 
			and		a.ie_agrupador 					= 4 
			and		a.dt_horario					< dt_inicio_p 
			and		a.dt_horario					> dt_inicio_p - qt_interv_w / 24 
			and		coalesce(a.ie_horario_especial,'N')	= 'N' 
			--and		nvl(a.ie_adep,'S')				= 'S' 
			and		coalesce(a.dt_suspensao::text, '') = '' 
			and		coalesce(b.dt_suspensao::text, '') = '' 
			and		coalesce(a.ie_dose_especial,'N')		= 'N' 
			and		coalesce(a.ie_situacao,'A') 			= 'A' 
			and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S' 
			and		(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')			 
			and		c.nr_atendimento = nr_atendimento_w 
			and		(((ie_consistir_acm_w = 'S') and 
					 (((coalesce(b.ie_acm, 'N')		= 'S') and (ie_acm_intervalo_w		= 'N')) or 
					  ((coalesce(b.ie_se_necessario, 'N') = 'S') and (ie_sn_intervalo_w		 = 'N')))) or 
					 ((coalesce(b.ie_acm, 'N') = 'N') and (coalesce(b.ie_se_necessario, 'N') = 'N')));
				 
			end;
		else 
			begin 
			/* verificar horários anteriores x intervalo */
 
			 
			select	count(*) 
			into STRICT	qt_hor_int_w 
			from	prescr_mat_hor a, 
					prescr_solucao b, 
					prescr_medica c 
			where	a.nr_prescricao					= b.nr_prescricao 
			and		a.nr_seq_solucao 				= b.nr_seq_solucao 
			and		a.nr_prescricao					= c.nr_prescricao 
			and		b.nr_prescricao					= c.nr_prescricao 
			and		a.ie_agrupador 					= 4 
			and		a.dt_horario					< dt_inicio_p 
			and		a.dt_horario					> dt_inicio_p - qt_min_intervalo_w / 1440 
			and		coalesce(a.ie_horario_especial,'N')	= 'N' 
			--and		nvl(a.ie_adep,'S')				= 'S' 
			and		coalesce(a.dt_suspensao::text, '') = '' 
			and		coalesce(b.dt_suspensao::text, '') = '' 
			and		coalesce(a.ie_dose_especial,'N')		= 'N' 
			and		coalesce(a.ie_situacao,'A') 			= 'A' 
			and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S' 
			and		(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')			 
			and		c.nr_atendimento = nr_atendimento_w 
			and		(((ie_consistir_acm_w = 'S') and 
					 (((coalesce(b.ie_acm, 'N')		= 'S') and (ie_acm_intervalo_w		= 'N')) or 
					  ((coalesce(b.ie_se_necessario, 'N') = 'S') and (ie_sn_intervalo_w		 = 'N')))) or 
					 ((coalesce(b.ie_acm, 'N') = 'N') and (coalesce(b.ie_se_necessario, 'N') = 'N')));
						 
			end;
		end if;		
		 
		if (qt_hor_int_w > 0) and (varie_permite_apraz_w <> 'S') then			 
			--ds_consistencia_w := 'O horário informado não está de acordo com o intervalo previsto para este item, favor verificar.'; 
			ds_erro_w := wheb_mensagem_pck.get_texto(294665,null);
		end if;
		 
		if (qt_min_intervalo_w = 0) then 
			begin 
			/* verificar horários posteriores x intervalo */
 
			 
			select	count(*) 
			into STRICT	qt_hor_int_w 
			from	prescr_mat_hor a, 
					prescr_solucao b, 
					prescr_medica c 
			where	a.nr_prescricao					= b.nr_prescricao 
			and		a.nr_seq_solucao 				= b.nr_seq_solucao 
			and		a.nr_prescricao					= c.nr_prescricao 
			and		b.nr_prescricao					= c.nr_prescricao 
			and		a.ie_agrupador 					= 4 
			and		a.dt_horario					> dt_inicio_p 
			and		a.dt_horario					< dt_inicio_p + qt_interv_w / 24 
			and		coalesce(a.ie_horario_especial,'N')	= 'N' 
			--and		nvl(a.ie_adep,'S')				= 'S' 
			and		coalesce(a.dt_suspensao::text, '') = '' 
			and		coalesce(b.dt_suspensao::text, '') = '' 
			and		coalesce(a.ie_dose_especial,'N')		= 'N' 
			and		coalesce(a.ie_situacao,'A') 			= 'A' 
			and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S' 
			and		(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')			 
			and		c.nr_atendimento = nr_atendimento_w 
			and		(((ie_consistir_acm_w = 'S') and 
					 (((coalesce(b.ie_acm, 'N')		= 'S') and (ie_acm_intervalo_w		= 'N')) or 
					  ((coalesce(b.ie_se_necessario, 'N') = 'S') and (ie_sn_intervalo_w		 = 'N')))) or 
					 ((coalesce(b.ie_acm, 'N') = 'N') and (coalesce(b.ie_se_necessario, 'N') = 'N')));
			 
			end;
		else 
			begin 
			/* verificar horários posteriores x intervalo */
 
			 
			select	count(*) 
			into STRICT	qt_hor_int_w 
			from	prescr_mat_hor a, 
					prescr_solucao b, 
					prescr_medica c 
			where	a.nr_prescricao					= b.nr_prescricao 
			and		a.nr_seq_solucao 				= b.nr_seq_solucao 
			and		a.nr_prescricao					= c.nr_prescricao 
			and		b.nr_prescricao					= c.nr_prescricao 
			and		a.ie_agrupador 					= 4 
			and		a.dt_horario					> dt_inicio_p 
			and		a.dt_horario					< dt_inicio_p + qt_min_intervalo_w / 1440 
			and		coalesce(a.ie_horario_especial,'N')	= 'N' 
			--and		nvl(a.ie_adep,'S')				= 'S' 
			and		coalesce(a.dt_suspensao::text, '') = '' 
			and		coalesce(b.dt_suspensao::text, '') = '' 
			and		coalesce(a.ie_dose_especial,'N')		= 'N' 
			and		coalesce(a.ie_situacao,'A') 			= 'A' 
			and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S' 
			and		(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')			 
			and		c.nr_atendimento = nr_atendimento_w 
			and		(((ie_consistir_acm_w = 'S') and 
					 (((coalesce(b.ie_acm, 'N')		= 'S') and (ie_acm_intervalo_w		= 'N')) or 
					  ((coalesce(b.ie_se_necessario, 'N') = 'S') and (ie_sn_intervalo_w		 = 'N')))) or 
					 ((coalesce(b.ie_acm, 'N') = 'N') and (coalesce(b.ie_se_necessario, 'N') = 'N')));
						 
			end;
		end if;
		 
		if (qt_hor_int_w > 0) and (varie_permite_apraz_w <> 'S') then 
			--ds_consistencia_w := 'O horário informado não está de acordo com o intervalo previsto para este item, favor verificar.'; 
			ds_erro_w := wheb_mensagem_pck.get_texto(294665,null);
		end if;		
		 
	end if;	
	-- Consistir intervalo 
	 
	/* Fim tratamentos novos MC*/
 
		 
	dt_horario_w 		:= to_date(to_char(dt_inicio_p,'dd/mm/yyyy hh24:mi') || ':00','dd/mm/yyyy hh24:mi:ss');
	 
	select	count(*) 
	into STRICT	qt_material_horario_w 
	from	prescr_solucao b, 
			prescr_mat_hor c 
	where	c.nr_seq_solucao = b.nr_seq_solucao 
	and		c.nr_prescricao = b.nr_prescricao 
	and		b.nr_prescricao = nr_prescricao_p 
	and		coalesce(c.ie_horario_especial,'N') <> 'S' 
	and		b.nr_seq_solucao = nr_seq_solucao_p 
	and 	c.dt_horario = dt_horario_w;
	 
	if (qt_material_horario_w > 0) then 
		ds_erro_w := wheb_mensagem_pck.get_texto(281862,null);
	end if;
end if;
 
ds_erro_p := ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_apraz_etapa_sol_js ( ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, dt_inicio_p timestamp, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text, ie_somente_gedipa_p text, cd_funcao_origem_p bigint, ie_gedipa_p text, nr_seq_etapa_p bigint, ie_gera_kit_sol_acm_p text, ds_erro_p INOUT text) FROM PUBLIC;
