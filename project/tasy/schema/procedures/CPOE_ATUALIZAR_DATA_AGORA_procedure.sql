-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_atualizar_data_agora ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_cpoe_p bigint, ie_tipo_item_p text, dt_referencia_p timestamp, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, ie_reprogramar_inicio_p text default 'N') AS $body$
DECLARE


dt_fim_w				cpoe_material.dt_fim%type;

cd_intervalo_w			cpoe_material.cd_intervalo%type;
cd_material_w			cpoe_material.cd_material%type;
ie_urgencia_w			cpoe_material.ie_urgencia%type;
ds_horarios_w			cpoe_material.ds_horarios%type;

ds_horarios_ww			cpoe_material.ds_horarios%type;
ds_horarios_www			cpoe_material.ds_horarios%type;
ie_administracao_w		cpoe_material.ie_administracao%type;
dt_inicio_w				cpoe_material.dt_inicio%type;
nr_etapas_w				cpoe_material.nr_etapas%type;
ie_via_aplicacao_w		cpoe_material.ie_via_aplicacao%type:= null;
ds_dose_diferenciada_w	cpoe_material.ds_dose_diferenciada%type;
ie_evento_unico_w		cpoe_material.ie_evento_unico%type;
ie_controle_tempo_w		cpoe_material.ie_controle_tempo%type;
nr_seq_proc_interno_w	cpoe_procedimento.nr_seq_proc_interno%type;
nr_ocorrencia_w			prescr_material.nr_ocorrencia%type;
ie_continuo_w			cpoe_dieta.ie_continuo%type;
qt_hora_aplicacao_w		cpoe_dieta.qt_hora_aplicacao%type;
qt_hora_fase_w			cpoe_dieta.qt_hora_fase%type;
qt_tempo_pausa_w		cpoe_dieta.qt_tempo_pausa%type;
ie_duracao_w			cpoe_dieta.ie_duracao%type;
qt_hora_min_infusao_w	cpoe_hemoterapia.qt_hora_min_infusao%type;
ie_tipo_w				cpoe_hemoterapia.ie_tipo%type;
dt_referencia_w			timestamp;
ie_dose_adicional_w		varchar(10);
ie_retrogrado_w			varchar(1);
ie_tipo_dieta_w	        cpoe_dieta.ie_tipo_dieta%type;
qt_dias_adicionar_w		bigint := 0;
ie_copiar_rep_w			proc_interno.ie_copiar_rep%type;
ie_param8_cpoe_w			varchar(1);
ds_erro_w				varchar(4000);
qt_min_intervalo_w		intervalo_prescricao.qt_min_intervalo%type;
ie_operacao_w           intervalo_prescricao.ie_operacao%type;
nr_seq_material_proc_w 	cpoe_material.nr_sequencia%type;	
param_CPOE_24_w			varchar(1);
qt_tempo_aplic_w		cpoe_dieta.qt_tempo_aplic%type;
dt_fim_param_w			timestamp;
qt_tempo_aplic_param_w	double precision;
ie_oncologia_w			cpoe_material.ie_oncologia%type;
ie_param1562_cpoe_w		varchar(1);
ie_utilizar_acesso_gwt varchar(1);
hr_prim_horario_w2 			 varchar(5);
dt_ref_horario_w		cpoe_material.dt_fim%type;
hr_prim_horario_ww  varchar(5);

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	cpoe_material a
	where	a.nr_seq_procedimento = nr_seq_cpoe_p;

	procedure carregar_dados_intervalo(	cd_intervalo_p			intervalo_prescricao.cd_intervalo%type,
										qt_min_intervalo_p 	out	intervalo_prescricao.qt_min_intervalo%type,
										ie_operacao_p 		out	intervalo_prescricao.ie_operacao%type) is
	;
BEGIN
		select	max(qt_min_intervalo),
				max(ie_operacao)
		into STRICT	qt_min_intervalo_p,
				ie_operacao_p				
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_p;
	end;
	
	function obter_proxima_hora_cheia
		return;
	begin
	
		dt_retorno_w := to_date(to_char(dt_referencia_p,'dd/mm/yyyy') || ' ' || to_char(to_date(Obter_prox_hora_cheia(dt_referencia_p),'hh24:mi:ss'),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
		
		if (trunc(dt_retorno_w,'mi') < trunc(clock_timestamp(),'mi')) and (to_char(dt_retorno_w,'hh24:mi') = '00:00') and (to_char(clock_timestamp(),'hh24') = '23') and (to_char(dt_referencia_p,'hh24') = '23') then
			dt_retorno_w := dt_retorno_w + 1;
		end if;
	
		return;
	end;
	
	
	function get_horario_intervalo
		return;
	begin
	
		if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
			hr_prim_horario_w :=  CPOE_Obter_primeiro_horario(nr_atendimento_p, cd_intervalo_w, cd_material_w, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_pessoa_fisica_p, ie_via_aplicacao_w);			
			
			if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then			
				return;
			end if;
		end if;

		return;
	
	end;
	
	procedure controla_urgencia is
	begin
		if (ie_urgencia_w IS NOT NULL AND ie_urgencia_w::text <> '') then
			dt_referencia_w := trunc(dt_referencia_p,'mi') + (ie_urgencia_w)::numeric /1440;
		elsif (ie_reprogramar_inicio_p = 'S') then
			dt_referencia_w := trunc(dt_referencia_p,'mi') + 1/1440;
		else 		
			dt_referencia_w :=   get_horario_intervalo;
			
			if (dt_referencia_w < clock_timestamp()) then
				dt_referencia_w :=  obter_proxima_hora_cheia;
			end if;
			
		end if;
		
	end;
	
begin

ie_utilizar_acesso_gwt := obter_param_usuario(2314, 5, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_utilizar_acesso_gwt);

if (ie_tipo_item_p = 'M' or ie_tipo_item_p = 'MA') then

	select	max(cd_intervalo),
			max(cd_material),
			max(dt_inicio),
			max(dt_fim),
			0,
			max(ie_urgencia),
			max(ie_dose_adicional),
			max(coalesce(ie_retrogrado,'N')),
			max(nr_etapas),
			max(ie_controle_tempo),
			max(ie_via_aplicacao),
			max(ds_horarios),
			max(ie_administracao),
			max(ie_evento_unico),
			max(ds_dose_diferenciada),
			max(hr_prim_horario)
	into STRICT	cd_intervalo_w,
			cd_material_w,
			dt_inicio_w,
			dt_fim_w,
			nr_ocorrencia_w,
			ie_urgencia_w,
			ie_dose_adicional_w,
			ie_retrogrado_w,
			nr_etapas_w,
			ie_controle_tempo_w,
			ie_via_aplicacao_w,
			ds_horarios_www,
			ie_administracao_w,
			ie_evento_unico_w,
			ds_dose_diferenciada_w,
			hr_prim_horario_ww
	from	cpoe_material
	where	nr_sequencia = nr_seq_cpoe_p;

	carregar_dados_intervalo(cd_intervalo_w, qt_min_intervalo_w, ie_operacao_w);

	if (coalesce(ie_retrogrado_w,'N') <> 'S') then
	
		controla_urgencia;
		
		if (coalesce(dt_referencia_w::text, '') = '') then			
			CALL gravar_log_tasy(10007,
			substr('cpoe_atualizar_data_agora line 168 dt_referencia_w is null - '
							||' dt_referencia_w:'||to_char(dt_referencia_w, 'dd/mm/yyyy hh24:mi:ss')							
							||' dt_referencia_p: ' || to_char(dt_referencia_p, 'dd/mm/yyyy hh24:mi:ss')
							||' dt_inicio_w: ' || dt_inicio_w
							||' ie_reprogramar_inicio_p: ' || ie_reprogramar_inicio_p														
							||' ds_horarios_w: ' || ds_horarios_w
							||' ds_horarios_ww: ' || ds_horarios_ww
							||' ds_horarios_www: '|| ds_horarios_www
							||' cd_material_w:'||cd_material_w
							||' nm_usuario_p: ' || nm_usuario_p
							||' qt_min_intervalo_w: ' || qt_min_intervalo_w
							|| 'ie_administracao_w: ' || ie_administracao_w
							||' nr_atendimento_p: '||nr_atendimento_p
							||' cd_intervalo_w:'||cd_intervalo_w
							||' nr_ocorrencia_w: ' || nr_ocorrencia_w
							||' cd_estabelecimento_p: ' || cd_estabelecimento_p
							||' cd_perfil_p: ' || cd_perfil_p
							||' ie_urgencia_w: ' || ie_urgencia_w
							||' ie_dose_adicional_w: ' || ie_dose_adicional_w
							||' ie_retrogrado_w: ' || ie_retrogrado_w
							||' nr_etapas_w: ' || nr_etapas_w
							||' ie_controle_tempo_w: ' || ie_controle_tempo_w
							||' ie_via_aplicacao_w: ' || ie_via_aplicacao_w
							||' ie_evento_unico_w: ' || ie_evento_unico_w
							||' ds_dose_diferenciada_w: ' || ds_dose_diferenciada_w
							||' dt_fim_w:'||to_char(dt_fim_w, 'dd/mm/yyyy hh24:mi:ss')
							,1,2000), nm_usuario_p);
	
		end if;
		
		if (ie_controle_tempo_w = 'S') and (coalesce(cd_intervalo_w::text, '') = '') then
			nr_ocorrencia_w := nr_etapas_w;
		end if;

		if (coalesce(obter_funcao_ativa, 2314) = 252 and coalesce(ie_urgencia_w, 'N') <> 'S') then
			if (obter_se_prescr_reaprazar(nr_seq_cpoe_p, nr_atendimento_p, cd_pessoa_fisica_p, dt_referencia_w) = 'S') then
				dt_referencia_w := to_date(obter_data_prescr_reaprazar(nr_seq_cpoe_p, nr_atendimento_p, cd_pessoa_fisica_p, null), 'dd/mm/yyyy hh24:mi:ss');
			end if;
		end if;

		cpoe_calcular_horario_prescr( nr_atendimento_p,cd_intervalo_w,cd_material_w,dt_referencia_w,
									  0,qt_min_intervalo_w,nr_ocorrencia_w,ds_horarios_w,
									  ds_horarios_ww,nm_usuario_p,cd_estabelecimento_p,cd_perfil_p,
									  ds_dose_diferenciada_w,null, null, null,
									  null, ceil((coalesce(dt_fim_w, dt_referencia_w + 1) - dt_referencia_w)*24) );
									
		ds_horarios_w := ds_horarios_w||ds_horarios_ww;
		
  	    dt_ref_horario_w  := dt_referencia_w;
		if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '')  and (ds_horarios_www <> ds_horarios_w) and (ie_reprogramar_inicio_p = 'N') and (coalesce(ie_urgencia_w::text, '') = '') then
			
			hr_prim_horario_w2 := Obter_prim_DsHorarios(ds_horarios_w);

			if (hr_prim_horario_ww IS NOT NULL AND hr_prim_horario_ww::text <> '') and (hr_prim_horario_w2 <> '  :  ') and (hr_prim_horario_w2 <> hr_prim_horario_ww) then
									
				dt_ref_horario_w := to_date(to_char(dt_referencia_p,'dd/mm/yyyy') || ' ' || hr_prim_horario_w2,'dd/mm/yyyy hh24:mi:ss');
			elsif (coalesce(dt_ref_horario_w::text, '') = '') then
				dt_ref_horario_w := trunc(dt_referencia_p,'mi') + 1/1440;
			end if;
			
			if (dt_ref_horario_w < clock_timestamp()) then
				dt_ref_horario_w := dt_ref_horario_w + 1;
			end if;
			
		end if;

		if (coalesce(ds_horarios_w::text, '') = '') and (ie_administracao_w = 'P') then
			CALL gravar_log_tasy(10007,
			substr('cpoe_atualizar_data_agora line 143 - '
							|| 'ie_administracao_w: ' || ie_administracao_w
							||' nr_atendimento_p: '||nr_atendimento_p
							||' cd_intervalo_w:'||cd_intervalo_w
							||' cd_material_w:'||cd_material_w
							||' dt_referencia_w:'||to_char(dt_referencia_w, 'dd/mm/yyyy hh24:mi:ss')
							||' qt_min_intervalo_w: ' || qt_min_intervalo_w
							||' nr_ocorrencia_w: ' || nr_ocorrencia_w
							||' ds_horarios_w: ' || ds_horarios_w
							||' ds_horarios_ww: ' || ds_horarios_ww
							||' ds_horarios_www: '|| ds_horarios_www
							||' nm_usuario_p: ' || nm_usuario_p
							||' cd_estabelecimento_p: ' || cd_estabelecimento_p
							||' cd_perfil_p: ' || cd_perfil_p
							||' dt_fim_w:'||to_char(dt_fim_w, 'dd/mm/yyyy hh24:mi:ss')
							||' dt_ref_horario_w:'||to_char(dt_ref_horario_w, 'dd/mm/yyyy hh24:mi:ss')
							,1,2000), nm_usuario_p);

			ds_horarios_w	:= ds_horarios_www;
			dt_referencia_w := dt_inicio_w;
		elsif ((ie_urgencia_w IS NOT NULL AND ie_urgencia_w::text <> '') and coalesce(ie_evento_unico_w, 'N') = 'S'  and ds_horarios_w <> to_char(dt_referencia_w,'hh24:mi')) then
			CALL gravar_log_tasy(10007,
				substr('cpoe_atualizar_data_agora line 169 - '
								||' nr_seq_cpoe_p: ' || nr_seq_cpoe_p
								||' ie_administracao_w: ' || ie_administracao_w
								||' nr_atendimento_p: '||nr_atendimento_p
								||' cd_intervalo_w:'||cd_intervalo_w
								||' cd_material_w:'||cd_material_w
								||' dt_referencia_w:'||to_char(dt_referencia_w, 'dd/mm/yyyy hh24:mi:ss')
								||' qt_min_intervalo_w: ' || qt_min_intervalo_w
								||' nr_ocorrencia_w: ' || nr_ocorrencia_w
								||' ds_horarios_w: ' || ds_horarios_w
								||' ds_horarios_ww: ' || ds_horarios_ww
								||' padroniza_horario_prescr: ' || replace(padroniza_horario_prescr(ds_horarios_w, NULL) , 'A','')
								||' ds_horarios_www: '|| ds_horarios_www
								||' nm_usuario_p: ' || nm_usuario_p
								||' cd_estabelecimento_p: ' || cd_estabelecimento_p
								||' cd_perfil_p: ' || cd_perfil_p
								||' dt_fim_w:'||to_char(dt_fim_w, 'dd/mm/yyyy hh24:mi:ss')								
								||' dt_ref_horario_w:'||to_char(dt_ref_horario_w, 'dd/mm/yyyy hh24:mi:ss')
								,1,2000), nm_usuario_p);								
		end if;
		
		begin
			ds_horarios_w := cpoe_padroniza_horario(ds_horarios_w);
		exception
		when others then
			ds_erro_w  := to_char(sqlerrm);
			CALL gravar_log_tasy(10007,
						substr('cpoe_atualizar_data_agora line 191 - '
										||' nr_seq_cpoe_p: ' || nr_seq_cpoe_p
										||' ie_administracao_w: ' || ie_administracao_w
										||' nr_atendimento_p: '||nr_atendimento_p
										||' cd_intervalo_w:'||cd_intervalo_w
										||' cd_material_w:'||cd_material_w
										||' dt_referencia_w:'||to_char(dt_referencia_w, 'dd/mm/yyyy hh24:mi:ss')
										||' qt_min_intervalo_w: ' || qt_min_intervalo_w
										||' nr_ocorrencia_w: ' || nr_ocorrencia_w
										||' ds_horarios_w: ' || ds_horarios_w
										||' ds_horarios_ww: ' || ds_horarios_ww
										||' ds_horarios_www: '|| ds_horarios_www
										||' nm_usuario_p: ' || nm_usuario_p
										||' cd_estabelecimento_p: ' || cd_estabelecimento_p
										||' cd_perfil_p: ' || cd_perfil_p
										||' dt_fim_w:'||to_char(dt_fim_w, 'dd/mm/yyyy hh24:mi:ss')		
										||' dt_ref_horario_w:'||to_char(dt_ref_horario_w, 'dd/mm/yyyy hh24:mi:ss')
										|| obter_desc_expressao(504115) || ds_erro_w
									,1,2000), nm_usuario_p);
			ds_horarios_w := null;
		end;
			
		if ((coalesce(ds_horarios_w::text, '') = '') or (ds_horarios_w = '')) then
			CALL gravar_log_tasy(10007,
				substr('cpoe_atualizar_data_agora line 193 - '
								||' nr_seq_cpoe_p: ' || nr_seq_cpoe_p
								||' ie_administracao_w: ' || ie_administracao_w
								||' nr_atendimento_p: '||nr_atendimento_p
								||' cd_intervalo_w:'||cd_intervalo_w
								||' cd_material_w:'||cd_material_w
								||' dt_referencia_w:'||to_char(dt_referencia_w, 'dd/mm/yyyy hh24:mi:ss')
								||' qt_min_intervalo_w: ' || qt_min_intervalo_w
								||' nr_ocorrencia_w: ' || nr_ocorrencia_w
								||' ds_horarios_w: ' || ds_horarios_w
								||' ds_horarios_ww: ' || ds_horarios_ww
								||' padroniza_horario_prescr: ' || replace(padroniza_horario_prescr(ds_horarios_w, NULL) , 'A','')
								||' ds_horarios_www: '|| ds_horarios_www
								||' nm_usuario_p: ' || nm_usuario_p
								||' cd_estabelecimento_p: ' || cd_estabelecimento_p
								||' cd_perfil_p: ' || cd_perfil_p
								||' dt_ref_horario_w:'||to_char(dt_ref_horario_w, 'dd/mm/yyyy hh24:mi:ss')
								||' dt_fim_w:'||to_char(dt_fim_w, 'dd/mm/yyyy hh24:mi:ss')
								,1,2000), nm_usuario_p);		
		
		end if;
		
		if ( ie_administracao_w <> 'P' )then
			ds_horarios_w := null;
		end if;
		
		if (ie_operacao_w = 'F') then -- FIXO
		
			update	cpoe_material
			set	dt_inicio = dt_inicio + 1					
			where	nr_sequencia = nr_seq_cpoe_p;		
		
		else
		
		
			update	cpoe_material
			set		dt_fim	= CASE WHEN ie_duracao='P' THEN (dt_ref_horario_w + (Obter_Min_Entre_Datas(dt_inicio, dt_fim,1)/1440)) - 1/86000  ELSE null END ,
					dt_inicio = dt_ref_horario_w,
					dt_adm_adicional = CASE WHEN ie_dose_adicional_w='S' THEN  dt_ref_horario_w  ELSE null END ,
					hr_prim_horario = to_char(dt_ref_horario_w,'hh24:mi'),
					ds_horarios = coalesce(ds_horarios_w, ds_horarios)
			where	nr_sequencia = nr_seq_cpoe_p;
		
		end if;
		
		
	end if;
	
	
elsif (ie_tipo_item_p = 'P') then

	select	max(nr_seq_proc_interno),
			max(cd_intervalo),
			max(dt_fim),
			max(ie_urgencia),
			max(coalesce(ie_retrogrado,'N')),
			max(ie_duracao),
			max(ie_administracao),
			max(ie_evento_unico)
	into STRICT	nr_seq_proc_interno_w,
			cd_intervalo_w,
			dt_fim_w,
			ie_urgencia_w,
			ie_retrogrado_w,
			ie_duracao_w,
			ie_administracao_w,
			ie_evento_unico_w
	from	cpoe_procedimento
	where	nr_sequencia = nr_seq_cpoe_p;

	if (coalesce(ie_retrogrado_w,'N') <> 'S') then
	
		carregar_dados_intervalo(cd_intervalo_w, qt_min_intervalo_w, ie_operacao_w);

		controla_urgencia;
		
		if (obter_se_eh_cig(nr_seq_proc_interno_w) = 'S') then
			nr_ocorrencia_w := 1;
		end if;

		cpoe_calcular_horario_prescr(	nr_atendimento_p, cd_intervalo_w, null, dt_referencia_w,
										0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, 
										ds_horarios_ww, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, 
										null, null, null, null, 
										nr_seq_proc_interno_w, ceil((coalesce(dt_fim_w, dt_referencia_w + 1) - dt_referencia_w)*24) );

		ds_horarios_w := ds_horarios_w||ds_horarios_ww;
		
		select	coalesce(max(ie_copiar_rep),'S')
		into STRICT	ie_copiar_rep_w
		from	proc_interno
		where	nr_sequencia = nr_seq_proc_interno_w;
		
		if (ie_duracao_w  = 'P') then
			if (position('A' in CPOE_Padroniza_horario_prescr(ds_horarios_w,dt_referencia_w)) > 0 ) then
				qt_dias_adicionar_w := 1;
			end if;   	
			
			select	coalesce(max(a.ie_oncologia), 'N')
			into STRICT 	ie_oncologia_w
			from 	cpoe_material a
			where 	a.nr_sequencia = nr_seq_cpoe_p;
			if (ie_oncologia_w = 'S') then
			
				if (position('A' in CPOE_Padroniza_horario_prescr(ds_horarios_w, dt_referencia_w)) = 0 ) then
					
					ie_param1562_cpoe_w := obter_param_usuario(281, 1562, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_param1562_cpoe_w);
					
					if (ie_param1562_cpoe_w = 'F') then
						dt_fim_w := fim_dia(dt_referencia_w);
					end if;
				end if;
			else	
				ie_param8_cpoe_w := obter_param_usuario(2314, 8, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_param8_cpoe_w);
				
				if (ie_param8_cpoe_w = 'F') and
					((ie_copiar_rep_w = 'C') or (ie_evento_unico_w = 'S')) then
					dt_fim_w := fim_dia(dt_referencia_w + qt_dias_adicionar_w);
				else
					dt_fim_w := (dt_referencia_w + 1) - 1/1440;
				end if;
            end if;
		end if;

		if ( ie_administracao_w <> 'P' )then
			ds_horarios_w := null;
		end if;
		
		update	cpoe_procedimento
		set		dt_fim	= CASE WHEN ie_duracao='P' THEN dt_fim_w  ELSE null END ,
				dt_inicio = dt_referencia_w,
				hr_prim_horario = to_char(dt_referencia_w,'hh24:mi'),
				dt_prev_execucao = dt_referencia_w,
				ds_horarios = ds_horarios_w
		where	nr_sequencia = nr_seq_cpoe_p;

		open c01;
		loop
		fetch c01 into
			nr_seq_material_proc_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		
			update	cpoe_material
			set		dt_fim	= CASE WHEN ie_duracao='P' THEN dt_fim_w  ELSE null END ,
					dt_inicio = dt_referencia_w,
					hr_prim_horario = to_char(dt_referencia_w,'hh24:mi'),
					ds_horarios = ds_horarios_w
			where	nr_sequencia = nr_seq_material_proc_w;
			
		end loop;
		close c01;
		
		CALL cpoe_atual_data_ago_mat_assoc( nr_atendimento_p, nr_seq_cpoe_p, dt_referencia_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p);
	
	end if;
	
elsif (ie_tipo_item_p = 'N') then

	select	max(cd_material),
			max(cd_intervalo),
			CASE WHEN max(ie_continuo)='C' THEN 'S'  ELSE 'N' END ,
			coalesce(max(qt_hora_aplicacao),0),
			max(qt_hora_fase),
			max(qt_tempo_pausa),
			max(ie_duracao),
			max(dt_fim),
			max(ie_urgencia),
			max(coalesce(ie_retrogrado,'N')),
			max(ie_tipo_dieta),
			0,
			max(ie_administracao),
			max(qt_tempo_aplic)
	into STRICT	cd_material_w,
			cd_intervalo_w,
			ie_continuo_w,
			qt_hora_aplicacao_w,
			qt_hora_fase_w,
			qt_tempo_pausa_w,
			ie_duracao_w,
			dt_fim_w,
			ie_urgencia_w,
			ie_retrogrado_w,
			ie_tipo_dieta_w,
			nr_ocorrencia_w,
			ie_administracao_w,
			qt_tempo_aplic_w
	from	cpoe_dieta
	where	nr_sequencia = nr_seq_cpoe_p;

	carregar_dados_intervalo(cd_intervalo_w, qt_min_intervalo_w, ie_operacao_w);

	if (coalesce(ie_retrogrado_w,'N') <> 'S') then

		controla_urgencia;
		
		if (ie_tipo_dieta_w = 'E') then
		
			param_CPOE_24_w := Obter_Param_Usuario(2314, 24, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, param_CPOE_24_w);
			
			if (ie_continuo_w = 'S' AND param_CPOE_24_w = 'S') then
				qt_tempo_aplic_param_w := dividir(obter_minutos_hora(coalesce(qt_tempo_aplic_w, '24:00')), 60);
				dt_fim_param_w := dt_fim_w;
			else
				if (qt_hora_aplicacao_w > 0) then
					qt_tempo_aplic_param_w := qt_hora_aplicacao_w;
				else
					qt_tempo_aplic_param_w := dividir(obter_minutos_hora(coalesce(qt_tempo_aplic_w, '24:00')), 60);
				end if;

				dt_fim_param_w := coalesce(dt_fim_w, dt_referencia_w + 1);
			end if;
			
			SELECT * FROM CPOE_Calcula_horarios_enteral(
				nm_usuario_p, dt_referencia_w, ie_continuo_w, nr_ocorrencia_w, cd_intervalo_w, qt_tempo_aplic_param_w, coalesce(obter_minutos_hora(qt_hora_fase_w),0)/60, qt_tempo_pausa_w, 'N', ie_duracao_w, dt_fim_param_w, ie_utilizar_acesso_gwt, nr_atendimento_p, cd_estabelecimento_p, cd_perfil_p) INTO STRICT nr_ocorrencia_w, ds_horarios_w;
		else

			cpoe_calcular_horario_prescr( nr_atendimento_p,cd_intervalo_w,null,dt_referencia_w,
							 0,qt_min_intervalo_w,nr_ocorrencia_w,ds_horarios_w,
							 ds_horarios_ww,nm_usuario_p,cd_estabelecimento_p,cd_perfil_p,
							 null,null, null, null,
							 null, ceil((coalesce(dt_fim_w, dt_referencia_w + 1) - dt_referencia_w)*24) );

		end if;
		
		if ( ie_administracao_w <> 'P' )then
			ds_horarios_w := null;
		end if;
		
		if (ie_operacao_w = 'F') then -- FIXO
		
			update	cpoe_dieta
			set	dt_inicio = dt_inicio + 1					
			where	nr_sequencia = nr_seq_cpoe_p;
		
		else
		
			update	cpoe_dieta
			set		dt_fim	= CASE WHEN ie_duracao='P' THEN (dt_referencia_w + (Obter_Min_Entre_Datas(dt_inicio, dt_fim,1)/1440)) - 1/86000  ELSE null END ,
					dt_inicio = dt_referencia_w,
					hr_prim_horario = to_char(dt_referencia_w,'hh24:mi'),
					ds_horarios = ds_horarios_w
			where	nr_sequencia = nr_seq_cpoe_p;
		
		end if;
		
		
	
	end if;

elsif (ie_tipo_item_p = 'G') then

	select	max(cd_intervalo),
			max(dt_fim),
			max(qt_hora_fase),
			max(coalesce(ie_retrogrado,'N')),
			max(ie_urgencia),
			max(ie_administracao)
	into STRICT	cd_intervalo_w,
			dt_fim_w,
			qt_hora_fase_w,
			ie_retrogrado_w,
			ie_urgencia_w,
			ie_administracao_w
	from	cpoe_gasoterapia
	where	nr_sequencia = nr_seq_cpoe_p;

	if (coalesce(ie_retrogrado_w,'N') <> 'S') then			
	
		carregar_dados_intervalo(cd_intervalo_w, qt_min_intervalo_w, ie_operacao_w);

		controla_urgencia;

		cpoe_calcular_horario_prescr( nr_atendimento_p,cd_intervalo_w,null,dt_referencia_w,
									  0,qt_min_intervalo_w,nr_ocorrencia_w,ds_horarios_w,
									  ds_horarios_ww,nm_usuario_p,cd_estabelecimento_p,cd_perfil_p,
									  null,null, null, null,
									  null, ceil((coalesce(dt_fim_w, dt_referencia_w + 1) - dt_referencia_w)*24) );
		ds_horarios_w := ds_horarios_w||ds_horarios_ww;
		ds_horarios_w := cpoe_obter_etapas_formatadas(ds_horarios_w, cd_intervalo_w, qt_hora_fase_w);

		if ( ie_administracao_w <> 'P' )then
			ds_horarios_w := null;
		end if;
		
		update	cpoe_gasoterapia
		set		dt_fim	= CASE WHEN ie_duracao='P' THEN (dt_referencia_w + (Obter_Min_Entre_Datas(dt_inicio, dt_fim,1)/1440)) - 1/86000  ELSE null END ,
				dt_inicio = dt_referencia_w,
				hr_prim_horario = to_char(dt_referencia_w,'hh24:mi'),
				dt_prev_execucao = dt_referencia_w,
				ds_horarios = ds_horarios_w
		where	nr_sequencia = nr_seq_cpoe_p;

	end if;	

elsif (ie_tipo_item_p = 'R') then

	select	max(cd_intervalo),
			max(dt_fim),
			max(ie_urgencia),
			max(coalesce(ie_retrogrado,'N')),
			max(ie_administracao)
	into STRICT	cd_intervalo_w,
			dt_fim_w,
			ie_urgencia_w,
			ie_retrogrado_w,
			ie_administracao_w
	from	cpoe_recomendacao
	where	nr_sequencia = nr_seq_cpoe_p;

	if (coalesce(ie_retrogrado_w,'N') <> 'S') then
	
		controla_urgencia;

		cpoe_calcular_horario_prescr( nr_atendimento_p,cd_intervalo_w,null,dt_referencia_w,
									  0,qt_min_intervalo_w,nr_ocorrencia_w,ds_horarios_w,
									  ds_horarios_ww,nm_usuario_p,cd_estabelecimento_p,cd_perfil_p,
									  null,null, null, null,
									  null, ceil((coalesce(dt_fim_w, dt_referencia_w + 1) - dt_referencia_w)*24));
									
		ds_horarios_w := ds_horarios_w||ds_horarios_ww;

		if ( ie_administracao_w <> 'P' )then
			ds_horarios_w := null;
		end if;
		
		update	cpoe_recomendacao
		set		dt_fim	= CASE WHEN ie_duracao='P' THEN (dt_referencia_w + (Obter_Min_Entre_Datas(dt_inicio, dt_fim,1)/1440)) - 1/86000  ELSE null END ,
				dt_inicio = dt_referencia_w,
				hr_prim_horario = to_char(dt_referencia_w,'hh24:mi'),
				ds_horarios = ds_horarios_w
		where	nr_sequencia = nr_seq_cpoe_p;
		
	end if;		

elsif (ie_tipo_item_p = 'H') then

	select	max(coalesce(qt_hora_min_infusao, '24:00')),
			max(ie_urgencia),
			max(dt_fim),
			max(cd_intervalo),
			max(ds_horarios),
			max(coalesce(ie_retrogrado,'N'))
	into STRICT	qt_hora_min_infusao_w,
			ie_urgencia_w,
			dt_fim_w,
			cd_intervalo_w,
			ds_horarios_w,
			ie_retrogrado_w
	from	cpoe_hemoterapia
	where	nr_sequencia = nr_seq_cpoe_p;

	if (coalesce(ie_retrogrado_w,'N') <> 'S') then
	
		if (ie_urgencia_w IS NOT NULL AND ie_urgencia_w::text <> '') then --Programada (programada para determinado dia e hora)
			dt_referencia_w := dt_referencia_P;
		elsif (ie_reprogramar_inicio_p = 'S') then
			dt_referencia_w := trunc(dt_referencia_p,'mi') + 1/1440;
		else
			dt_referencia_w :=  obter_proxima_hora_cheia;
		end if;

		dt_fim_w := (dt_referencia_w + 1) - 1/1440;

		if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then

			carregar_dados_intervalo(cd_intervalo_w, qt_min_intervalo_w, ie_operacao_w);

			cpoe_calcular_horario_prescr( nr_atendimento_p,cd_intervalo_w,null,dt_referencia_w,
								  0,qt_min_intervalo_w,nr_ocorrencia_w,ds_horarios_w,
								  ds_horarios_ww,nm_usuario_p,cd_estabelecimento_p,cd_perfil_p,
								  null,null, null, null,
								  null, ceil((coalesce(dt_fim_w, dt_referencia_w + 1) - dt_referencia_w)*24));
		end if;

		update	cpoe_hemoterapia
		set		dt_programada = dt_referencia_w,
				dt_fim = dt_fim_w,
				ds_horarios = ds_horarios_w
		where	nr_sequencia = nr_seq_cpoe_p;

		CALL cpoe_atual_data_ago_mats_hemo( nr_atendimento_p, nr_seq_cpoe_p, dt_referencia_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p);

	end if;	

elsif (ie_tipo_item_p = 'DI' or ie_tipo_item_p = 'DP') then
	
	select	max(coalesce(ie_retrogrado,'N'))
	into STRICT	ie_retrogrado_w
	from 	cpoe_dialise
	where	nr_sequencia = nr_seq_cpoe_p;
	
	if (coalesce(ie_retrogrado_w,'N') <> 'S') then
	
		if (ie_reprogramar_inicio_p = 'S') then
			dt_referencia_w := trunc(dt_referencia_p,'mi') + 1/1440;		
		else
			dt_referencia_w :=  obter_proxima_hora_cheia;
		end if;

		update	cpoe_dialise
		set		dt_fim	= CASE WHEN ie_duracao='P' THEN (dt_referencia_w + (Obter_Min_Entre_Datas(dt_inicio, dt_fim,1)/1440)) - 1/86000  ELSE null END ,
				dt_inicio = dt_referencia_w
		where	nr_sequencia = nr_seq_cpoe_p;
		
	end if;
	
end if;

commit;


exception
when others then
	CALL gravar_log_cpoe(substr('CPOE_ATUALIZAR_DATA_AGORA: '
			|| ' nr_atendimento_p: ' || nr_atendimento_p
			|| ' nr_seq_cpoe_p: ' || nr_seq_cpoe_p
			|| ' ie_tipo_item_p: ' || ie_tipo_item_p
			|| ' dt_referencia_p: ' || to_char(dt_referencia_p, 'dd/mm/yyyy hh24:mi:ss')
			|| ' cd_estabelecimento_p: ' || cd_estabelecimento_p
			|| ' cd_perfil_p: ' || cd_perfil_p
			|| ' nm_usuario_p: ' || nm_usuario_p
			|| ' cd_pessoa_fisica_p: ' || cd_pessoa_fisica_p
			|| ' ie_reprogramar_inicio_p: ' || ie_reprogramar_inicio_p ,1,2000),
			nr_atendimento_p, ie_tipo_item_p, nr_seq_cpoe_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_atualizar_data_agora ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_cpoe_p bigint, ie_tipo_item_p text, dt_referencia_p timestamp, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, ie_reprogramar_inicio_p text default 'N') FROM PUBLIC;

