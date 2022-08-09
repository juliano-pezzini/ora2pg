-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_prot_proc_exame ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_protocolo_p bigint, nr_seq_protocolo_p bigint, nr_seq_item_p bigint, nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_prescritor_p text, cd_paciente_p text, qt_idade_dia_p bigint, qt_idade_mes_p bigint, qt_idade_ano_p bigint, qt_peso_p bigint, cd_medico_atend_p text, cd_setor_atendimento_p bigint, nr_seq_agrupamento_p bigint, cd_convenio_p bigint, ie_tipo_convenio_p bigint, cd_categoria_convenio_p text, cd_plano_convenio_p text, nr_seq_item_gerado_p INOUT cpoe_procedimento.nr_sequencia%type, nr_seq_pend_pac_acao_p bigint default null, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, ie_oncologia_p text default 'N', nr_seq_conclusao_apae_p bigint default null, dt_fim_presc_p timestamp default null, dt_inicio_presc_p timestamp default null, ie_futuro_p text default 'N', nr_seq_contraste_p bigint default null, ie_gerar_setor_pa_p text default 'N', nr_seq_cpoe_rp_p cpoe_rp.nr_sequencia%type default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) AS $body$
DECLARE


ds_stack_w				log_cpoe.ds_stack%type;
ds_log_cpoe_w			log_cpoe.ds_log%type;
nr_seq_proc_w			protocolo_medic_proc.nr_sequencia%type;
cd_procedimento_w		procedimento.cd_procedimento%type;
cd_procedimento_aux_w	procedimento.cd_procedimento%type;
ie_origem_proced_w		procedimento.ie_origem_proced%type;
ie_origem_proced_aux_w	procedimento.ie_origem_proced%type;
qt_procedimento_w		prescr_procedimento.qt_procedimento%type;
ds_observacao_w			prescr_procedimento.ds_observacao%type;
ds_material_especial_w	prescr_procedimento.ds_material_especial%type;
ie_lado_w				prescr_procedimento.ie_lado%type;
qt_hora_intervalo_w		prescr_procedimento.qt_hora_intervalo%type;
qt_min_intervalo_w		prescr_procedimento.qt_min_intervalo%type;
ds_justificativa_w		prescr_procedimento.ds_justificativa%type;
cd_intervalo_w			intervalo_prescricao.cd_intervalo%type;
cd_intervalo_agora_w	intervalo_prescricao.cd_intervalo%type;
cd_interv_padrao_proc_w	intervalo_prescricao.cd_intervalo%type;
ie_dose_unica_cpoe_w	intervalo_prescricao.ie_dose_unica_cpoe%type;
ie_interv_agora_w       intervalo_prescricao.ie_agora%type;
cd_setor_exclusivo_w	setor_atendimento.cd_setor_atendimento%type;
cd_setor_atend_aux_w	setor_atendimento.cd_setor_atendimento%type;
cd_material_exame_w		material_exame_lab.cd_material_exame%type;
nr_seq_exame_w			exame_laboratorio.nr_seq_exame%type;
nr_seq_proc_interno_w	proc_interno.nr_sequencia%type;
nr_seq_proc_int_aux_w	proc_interno.nr_sequencia%type;
ie_copiar_rep_w			proc_interno.ie_copiar_rep%type;
nr_seq_exame_lab_w		proc_interno.nr_seq_exame_lab%type;
dt_fim_w				cpoe_procedimento.dt_fim%type;
ie_duracao_w			cpoe_procedimento.ie_duracao%type;
ie_evento_unico_w		cpoe_procedimento.ie_evento_unico%type;
cd_medico_exec_w		cpoe_procedimento.cd_medico_exec%type;
cd_setor_entrega_w		cpoe_procedimento.cd_setor_entrega%type;
nr_seq_prot_glic_w		pep_protocolo_glicemia.nr_sequencia%type;
ie_previsao_proced_w	protocolo_medic_proc.ie_horario%type;
ie_prescr_alta_agora_w	varchar(1);
ie_se_necessario_w		char(1);
qt_dias_adicionar_w		bigint := 0;
ie_acm_w				char(1);
ie_urgencia_w			char(1);
ie_urgencia_proc_w		char(1);
ie_situacao_w			char(1);
ie_admin_proc_w			char(1);
hr_prim_horario_w		char(5);
ds_horarios_w			varchar(4000);
ds_horarios_aux_w		varchar(4000);
ds_horarios_padrao_w	varchar(4000);
dt_prev_exec_base_w		timestamp;
dt_prescricao_w			timestamp;
dt_prev_execucao_w		timestamp;
dt_inicio_prescr_w		timestamp;
dt_primeiro_horario_w	timestamp;
dt_validade_prescr_w	timestamp;
ds_erro_w				varchar(4000);
ds_mat_adic_proc_w		varchar(20);
nr_ocorrencia_w			double precision;
ie_param8_cpoe_w		varchar(1);
ie_obter_dados_exames_lab_rep		varchar(20);
nr_seq_topografia_w		protocolo_medic_proc.nr_seq_topografia%type;
ds_dado_clinico_w		protocolo_medic_proc.ds_dado_clinico%type;
nr_seq_contraste_w		protocolo_medic_proc.nr_seq_contraste%type;
ie_exibe_w				intervalo_prescricao.CD_INTERVALO%type;
ie_urgencia_ww			cpoe_procedimento.ie_urgencia%type;
ds_observacao_contraste_w proc_interno_contraste.ds_observacao%type;
ie_amostra_w			protocolo_medic_proc.ie_amostra%type;
cd_setor_atendimento_w	setor_atendimento.cd_setor_atendimento%type;
ie_Gera_Setor_PrescrProc_w	varchar(1);
ie_operacao_intervalo_w varchar(1);

c01 CURSOR FOR
SELECT	a.nr_seq_proc,
		a.cd_procedimento,
		a.qt_procedimento,
		a.ds_observacao,
		a.ie_origem_proced,
		coalesce(a.cd_intervalo, cd_interv_padrao_proc_w),
		a.cd_setor_atendimento,
		a.cd_material_exame,
		a.nr_seq_exame,
		coalesce(a.ie_se_necessario,'N'),
		coalesce(a.ie_acm,'N'),
		coalesce(a.ie_urgencia,'N'),
		a.hr_prim_horario,
		a.ds_material_especial,
		a.nr_seq_proc_interno,
		a.ie_lado,
		coalesce(a.qt_min_intervalo,0),
		a.nr_seq_prot_glic,
		a.ie_horario,
		a.ds_justificativa,
		coalesce(a.ie_duracao,'C'),
		a.nr_seq_topografia,
		a.ds_dado_clinico,
		coalesce(nr_seq_contraste_p, a.nr_seq_contraste),
		ie_amostra
from	protocolo_medic_proc a
where	((coalesce(a.nr_seq_exame::text, '') = '') or
		 exists (	SELECT	1
					from	exame_laboratorio z
					where	z.nr_seq_exame = a.nr_seq_exame
					and		z.ie_solicitacao = 'S' ))
and		coalesce(a.nr_seq_solic_bs::text, '') = ''
and		(a.nr_seq_proc_interno IS NOT NULL AND a.nr_seq_proc_interno::text <> '')
and		a.cd_protocolo = cd_protocolo_p
and		a.nr_sequencia = nr_seq_protocolo_p
and		a.nr_seq_proc = coalesce(nr_seq_item_p,a.nr_seq_proc)
order by a.nr_seq_apres;


BEGIN

ie_param8_cpoe_w := obter_param_usuario(2314, 8, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_param8_cpoe_w);
ie_prescr_alta_agora_w := obter_param_usuario(924, 409, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_prescr_alta_agora_w);
ie_Gera_Setor_PrescrProc_w := Obter_Param_Usuario(924, 493, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_Gera_Setor_PrescrProc_w);
dt_prev_exec_base_w		:= trunc(clock_timestamp(),'hh24') + 1/24;
dt_prescricao_w			:= clock_timestamp();
dt_inicio_prescr_w		:= clock_timestamp();
dt_validade_prescr_w	:= dt_inicio_prescr_w + 24;

cd_interv_padrao_proc_w	:= obter_interv_prescr_padrao( cd_estabelecimento_p );

open c01;
loop
fetch c01 into
	nr_seq_proc_w,
	cd_procedimento_w,
	qt_procedimento_w,
	ds_observacao_w,
	ie_origem_proced_w,
	cd_intervalo_w,
	cd_setor_exclusivo_w,
	cd_material_exame_w,
	nr_seq_exame_w,
	ie_se_necessario_w,
	ie_acm_w,
	ie_urgencia_proc_w,
	hr_prim_horario_w,
	ds_material_especial_w,
	nr_seq_proc_interno_w,
	ie_lado_w,
	qt_min_intervalo_w,
	nr_seq_prot_glic_w,
	ie_previsao_proced_w,
	ds_justificativa_w,
	ie_duracao_w,
	nr_seq_topografia_w,
	ds_dado_clinico_w,
	nr_seq_contraste_w,
	ie_amostra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	cd_setor_atendimento_w	:= cd_setor_atendimento_p;
	
  if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then

	select max(b.ds_observacao) 
	into STRICT ds_observacao_contraste_w
	from proc_interno a,
		proc_interno_contraste b
	where a.nr_sequencia = nr_seq_proc_interno_w
	and a.nr_sequencia = b.nr_seq_proc_interno
	and a.ie_iodo = 'S';
	
  end if;

  if ((ds_observacao_contraste_w IS NOT NULL AND ds_observacao_contraste_w::text <> '') or ds_observacao_contraste_w <> '') then
	if ((ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') or ds_observacao_w <> '') then
		ds_observacao_w := ds_observacao_w||' '||ds_observacao_contraste_w;
	else
		ds_observacao_w := ds_observacao_contraste_w;
	end if;
  end if;
	
	dt_fim_w := null;
	SELECT * FROM Obter_Proc_Tab_Interno( nr_seq_proc_interno_w, 0, 0, 0, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;

	if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then
		begin
			select distinct
					cd_procedimento,
					ie_origem_proced
			into STRICT	cd_procedimento_aux_w,
					ie_origem_proced_aux_w
			from	exame_lab_convenio
			where	nr_seq_exame = nr_seq_exame_w
			and		cd_convenio	= cd_convenio_p;
		exception when others then
			cd_procedimento_aux_w	:= null;
			ie_origem_proced_aux_w	:= null;
		end;

		cd_procedimento_w	:= coalesce(cd_procedimento_aux_w,cd_procedimento_w);
		ie_origem_proced_w	:= coalesce(ie_origem_proced_aux_w,ie_origem_proced_w);
	end if;

	select	coalesce(max(ie_situacao),'A')
	into STRICT	ie_situacao_w
	from	procedimento
	where	cd_procedimento		= cd_procedimento_w
	and		ie_origem_proced	= ie_origem_proced_w;

	if (ie_situacao_w = 'I') then
		return;
	else
		select	coalesce(max(ie_situacao),'A'),
				coalesce(max(ie_copiar_rep),'S'),
				max(nr_seq_exame_lab)
		into STRICT	ie_situacao_w,
				ie_copiar_rep_w,
				nr_seq_exame_lab_w
		from	proc_interno
		where	nr_sequencia	= nr_seq_proc_interno_w;

		if (ie_situacao_w = 'I') then
			return;
		end if;
	end if;

	if (coalesce(cd_procedimento_w::text, '') = '') then
		SELECT * FROM obter_exame_lab_convenio(	nr_seq_exame_w, cd_convenio_p, cd_categoria_convenio_p, ie_tipo_atendimento_p, cd_estabelecimento_p, ie_tipo_convenio_p, nr_seq_proc_interno_w, cd_material_exame_w, cd_plano_convenio_p, cd_setor_atend_aux_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_int_aux_w) INTO STRICT cd_setor_atend_aux_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_int_aux_w;

	end if;

	begin
		select	coalesce(cd_setor_exclusivo,cd_setor_exclusivo_w)
		into STRICT	cd_setor_exclusivo_w
		from	procedimento
		where	cd_procedimento		= cd_procedimento_w
		and		ie_origem_proced	= ie_origem_proced_w;
	exception when others then
		cd_setor_exclusivo_w := cd_setor_exclusivo_w;
	end;

	if (coalesce(cd_setor_exclusivo_w::text, '') = '') then
		if (obter_se_gerar_setor_rotina( cd_estabelecimento_p, 924, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w, nr_seq_exame_w, cd_setor_atendimento_w, nm_usuario_p ) = 'S') then
			cd_setor_exclusivo_w	:= obter_setor_atend_proc( cd_estabelecimento_p, cd_procedimento_w, ie_origem_proced_w, null, cd_setor_atendimento_w, nm_usuario_p, nr_seq_proc_interno_w, nr_atendimento_p );
		end if;

		if (coalesce(cd_setor_exclusivo_w::text, '') = '') and (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then
			cd_setor_exclusivo_w	:= obter_setor_atend_proc_lab( cd_estabelecimento_p, cd_procedimento_w, ie_origem_proced_w, null, cd_setor_atendimento_w, null, nr_seq_exame_w );
		end if;
	end if;

	if ((cd_setor_exclusivo_w IS NOT NULL AND cd_setor_exclusivo_w::text <> '') and (ie_gerar_setor_pa_p = 'S') and (ie_Gera_Setor_PrescrProc_w = 'S') and (obter_se_setor_exec(cd_setor_exclusivo_w, cd_estabelecimento_p, cd_procedimento_w,ie_origem_proced_w, nr_seq_proc_interno_w) = 'S')) then
		cd_setor_atendimento_w := cd_setor_exclusivo_w;
	end if;
	
	ds_horarios_w 	:= '';

	dt_prev_execucao_w	:= null;
	dt_primeiro_horario_w	:= Obter_data_prev_exec( dt_prescricao_w, dt_prev_exec_base_w, obter_setor_atendimento(nr_atendimento_p), 0, 'A' );	
	
	if	((coalesce(ie_urgencia_proc_w, 'N') <> 'S') and coalesce(obter_se_marca_agora(cpoe_obter_setor_atend_prescr(nr_atendimento_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p)),'N') = 'S') then
		cd_intervalo_agora_w := cpoe_busca_intervalo_agora(nr_atendimento_p,'P',cd_estabelecimento_p,cd_perfil_p, nm_usuario_p);
		
		if (cd_intervalo_agora_w IS NOT NULL AND cd_intervalo_agora_w::text <> '') then
			cd_intervalo_w := cd_intervalo_agora_w;
			ie_urgencia_proc_w := 'S';
		end if;
	end if;	

	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		select	max(ie_dose_unica_cpoe),
                coalesce(max(ie_agora),'N')
		into STRICT	ie_dose_unica_cpoe_w,
                ie_interv_agora_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;
		
		if (coalesce(ie_dose_unica_cpoe_w, 'N') = 'S') then        
        
			ie_duracao_w := 'P';
			ie_evento_unico_w 	:= 'S';
							
			ie_se_necessario_w 	:= 'N';
			ie_acm_w			:= 'N';

            if ie_interv_agora_w = 'S' then
                ie_urgencia_proc_w 	:= 'S';
            end if;
		end if;
	end if;

	if (dt_inicio_presc_p IS NOT NULL AND dt_inicio_presc_p::text <> '') then
    	dt_prev_execucao_w := dt_inicio_presc_p;
  	end if;

	if	((ie_urgencia_proc_w = 'S') and (coalesce(dt_inicio_presc_p::text, '') = '')) then
		dt_prev_execucao_w	:= clock_timestamp();

		dt_primeiro_horario_w	:= clock_timestamp();
		cd_intervalo_w	:= coalesce(obter_interv_acm_sn_agora_lib( cd_estabelecimento_p, 1, 2, 'P', cd_procedimento_w, cd_intervalo_w, 0, ie_origem_proced_w, nr_seq_proc_interno_w ), cd_intervalo_w);
		
	-- Verificar se procedimento cadastrado com especificacao para a data prevista
	elsif	((ie_previsao_proced_w IS NOT NULL AND ie_previsao_proced_w::text <> '') and (coalesce(dt_inicio_presc_p::text, '') = '')) then
		---- Data da prescricao (DP)
		if (ie_previsao_proced_w = 'DP') then
			dt_primeiro_horario_w := dt_prescricao_w;
			dt_prev_execucao_w := dt_prescricao_w;
		
		---- 2 horas apos a prescricao (2h)		
		elsif (ie_previsao_proced_w = '2h') then
			dt_primeiro_horario_w := dt_prescricao_w + 2/24;
			dt_prev_execucao_w := dt_prescricao_w + 2/24;

		---- 3 horas apos a prescricao (3h)
		elsif (ie_previsao_proced_w = '3h') then
			dt_primeiro_horario_w := dt_prescricao_w + 3/24;
			dt_prev_execucao_w := dt_prescricao_w + 3/24;

		---- 6 horas apos a prescricao (6h)
		elsif (ie_previsao_proced_w = '6h') then
			dt_primeiro_horario_w := dt_prescricao_w + 6/24;
			dt_prev_execucao_w := dt_prescricao_w + 6/24;
		
		---- 9 horas apos a prescricao (9h)
		elsif (ie_previsao_proced_w = '9h') then
			dt_primeiro_horario_w := dt_prescricao_w + 9/24;
			dt_prev_execucao_w := dt_prescricao_w + 9/24;
		end if;		
    else if ((dt_primeiro_horario_w IS NOT NULL AND dt_primeiro_horario_w::text <> '') and (coalesce(dt_inicio_presc_p::text, '') = '')) then
        dt_prev_execucao_w := dt_primeiro_horario_w;
    end if;
	end if;

	dt_prev_execucao_w	:= coalesce(dt_prev_execucao_w, dt_prev_exec_base_w);
	
	select	max(ie_operacao)
	into STRICT		ie_operacao_intervalo_w
	from		intervalo_prescricao
	where	cd_intervalo = cd_intervalo_w;
	
	if ((coalesce(dt_inicio_presc_p::text, '') = '') and (coalesce(ie_urgencia_proc_w, 'N') = 'N')) then
	
		if (cpoe_obter_hor_setor_ps(nm_usuario_p, cd_estabelecimento_p, nr_atendimento_p, cd_perfil_p, cd_intervalo_w) = 'S') then

			dt_prev_execucao_w := clock_timestamp();
			ie_urgencia_ww := '0';
		elsif ((ie_operacao_intervalo_w = 'F') or (ie_operacao_intervalo_w = 'V')
        	  or (coalesce(ie_previsao_proced_w::text, '') = '')) then
		
			hr_prim_horario_w := substr(cpoe_obter_primeiro_horario(nr_atendimento_p, cd_intervalo_w, null, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_paciente_p),1,5);

			if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
				dt_prev_execucao_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prev_execucao_w, hr_prim_horario_w);
			end if;

			if (dt_prev_execucao_w < clock_timestamp()) then
				dt_prev_execucao_w := dt_prev_execucao_w + 1;
			end if;
		end if;
	end if;

	nr_ocorrencia_w	:= 0;

	if (obter_ctrl_glic_proc(nr_seq_proc_interno_w) = 'CIG') then
		nr_ocorrencia_w	:= 1;
		ds_horarios_w 	:= to_char(dt_prev_execucao_w,'hh24:mi');
	else	
		-- Conforme definicao junto aos analistas Talitha e Rafael Caldas

		--  nao sera utilizado o campo de operacoes de itens ACM/SN existente no cadastro dos intervalos, somente o campo de operacoes padrao (QT_OPERACAO)
		SELECT * FROM cpoe_calcular_horario_prescr(	nr_atendimento_p, cd_intervalo_w, null, dt_prev_execucao_w, qt_hora_intervalo_w, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null, null, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
		ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;
	end if;

	ie_admin_proc_w	:= 'P';
    hr_prim_horario_w :=  to_char(dt_prev_execucao_w,'hh24:mi');

	if (ie_urgencia_proc_w = 'S') then
		ie_urgencia_w		:= '0';
		ie_se_necessario_w	:= 'N';
		ie_acm_w			:= 'N';
	else
		ie_urgencia_w	:= null;
		if (ie_se_necessario_w = 'S') then
			ie_acm_w		:= 'N';
			ie_admin_proc_w	:= 'N';
			ds_horarios_w	:= '';
			hr_prim_horario_w := '';
		elsif (ie_acm_w = 'S') then
			ie_se_necessario_w	:= 'N';
			ie_admin_proc_w		:= 'C';
			ds_horarios_w		:= '';
			hr_prim_horario_w := '';
		end if;
	end if;
	
  ie_obter_dados_exames_lab_rep := obter_dados_exame_lab_rep(
	cd_perfil_p,
    0,
    cd_setor_atendimento_w,
    nr_seq_exame_w,
    cd_estabelecimento_p,
    'N'
  );

  if ( ie_obter_dados_exames_lab_rep = 'V' ) then
    cd_material_exame_w := '';
  elsif ( ie_obter_dados_exames_lab_rep = 'PL' ) then
    select max(cd_material_exame)
		into STRICT cd_material_exame_w
		from material_exame_lab b,
			exame_lab_material a
		where a.nr_seq_material = b.nr_sequencia
		and a.nr_seq_exame      = nr_seq_exame_w
		and a.ie_situacao       = 'A'
		and coalesce(obter_se_mat_exam_estab(cd_estabelecimento_p,a.nr_seq_exame,a.nr_seq_material),'S') = 'S'
		and ie_prioridade       =
			(SELECT min(ie_prioridade)
			from exame_lab_material x
			where nr_seq_exame = nr_seq_exame_w
			and x.ie_situacao  = 'A');
  else
	select	max(b.cd_material_exame)
	into STRICT	cd_material_exame_w
	from	material_exame_lab b,
			exame_lab_material a
	where	a.nr_seq_material 	= b.nr_sequencia
	and		a.nr_seq_exame 		= nr_seq_exame_lab_w
	and		a.ie_situacao 		= 'A'
	and		b.cd_material_exame	= coalesce(cd_material_exame_w, b.cd_material_exame);
  end if;

	select	nextval('cpoe_procedimento_seq')
	into STRICT	nr_seq_item_gerado_p
	;

	if (ie_copiar_rep_w = 'C') then
		ie_duracao_w := 'P';
	end if;
	
	if (ie_duracao_w = 'P') then
	
		if (position('A' in CPOE_Padroniza_horario_prescr(ds_horarios_w,dt_prev_execucao_w)) > 0 ) then
			qt_dias_adicionar_w := 1;
		end if;   	
		
		if (ie_param8_cpoe_w = 'F') then
			dt_fim_w := fim_dia(dt_prev_execucao_w + qt_dias_adicionar_w);
		else
			dt_fim_w := (dt_prev_execucao_w + 1) - 1/1440;
		end if;
		
	end if;

	if (dt_fim_presc_p IS NOT NULL AND dt_fim_presc_p::text <> '') then
    	dt_fim_w := dt_fim_presc_p;
		ie_duracao_w := 'P';
	end if;
	
	if (coalesce(ie_prescr_alta_agora_w,'N') = 'S') and (coalesce(ie_item_alta_p,'N') = 'S')	then	

		ie_urgencia_w := 0;		

		select	max(qt_min_intervalo)
		into STRICT	qt_min_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;

		SELECT * FROM cpoe_calcular_horario_prescr(nr_atendimento_p, cd_intervalo_w, null, clock_timestamp(), 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;

		ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;

		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);

		dt_prev_execucao_w	:= ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(hr_prim_horario_w);

		if (dt_prev_execucao_w < clock_timestamp()) then

			dt_prev_execucao_w := dt_prev_execucao_w + 1;

		end if;	
	end if;
	
	if (ie_retrogrado_p = 'S' or ie_futuro_p = 'S') then -- retrograde/backward/future item
		dt_prev_execucao_w := dt_inicio_p;
		
		if (position('A' in CPOE_Padroniza_horario_prescr(ds_horarios_w,dt_prev_execucao_w)) > 0 ) then
			qt_dias_adicionar_w := 1;
		end if;   	
		
		if (ie_param8_cpoe_w = 'F') then
			dt_fim_w := fim_dia(dt_prev_execucao_w + qt_dias_adicionar_w);
		else
			dt_fim_w := (dt_prev_execucao_w + 1) - 1/1440;
		end if;
		
		ie_urgencia_w	:= null;	
		ie_urgencia_ww	:= null;
		ie_duracao_w	:= 'P';	
		nr_ocorrencia_w	:= 0;	
		ds_horarios_w	:= '';
		ds_horarios_aux_w	:= '';

		select	max(qt_min_intervalo)
		into STRICT	qt_min_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;

		SELECT * FROM cpoe_calcular_horario_prescr(	nr_atendimento_p, cd_intervalo_w, null, dt_prev_execucao_w, 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null, null, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;

		ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;

		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
	end if;
	
	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '')then
	-- esse select deve ser o mesmo que ata ativando o lookup de intervalo, qualquer alteracao aqui deve ser replicada para o looup e vice-versa
			SELECT coalesce(MAX(cd_intervalo),'N')
			INTO STRICT ie_exibe_w
			FROM intervalo_prescricao
			WHERE 	cd_intervalo = cd_intervalo_w
			AND 	ie_situacao = 'A'
			and	Obter_se_intervalo(cd_intervalo_w,'P') = 'S'
			and	cpoe_obter_se_exibe_interv(NR_ATENDIMENTO_P, cd_estabelecimento_p,CD_INTERVALO_W, cd_perfil_p, nm_usuario_p) = 'S'
			and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p))
			and	((coalesce(ie_so_retrograda,'N') = 'N') or (coalesce(ie_retrogrado_p,'N') = 'N'))
			and ((ie_admin_proc_w = 'P') OR (ie_admin_proc_w = 'C' and coalesce(ie_acm,'N') = 'S') OR (ie_admin_proc_w = 'N' and coalesce(ie_se_necessario,'N') = 'S'));
			
			if (ie_exibe_w = 'N')then
				cd_intervalo_w := null;
			end if;
	end if;
		
	if (coalesce(cd_intervalo_w::text, '') = '')  or (cd_intervalo_w = '') then
		ds_horarios_w	:= '';
	end if;
	
	cd_medico_exec_w  := obter_medico_exec_cpoe(cd_protocolo_p, nr_seq_protocolo_p, nr_seq_proc_w, null, null, nr_seq_proc_interno_w);
	cd_setor_entrega_w := obter_setor_entrega_proc(cd_procedimento_w, nr_seq_proc_interno_w);

	insert into cpoe_procedimento(
		nr_sequencia,
		qt_procedimento,
		ds_horarios,
		ds_observacao,
		dt_atualizacao, --
		nm_usuario,
		cd_intervalo,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_urgencia, --
		dt_prev_execucao,
		cd_material_exame,
		ds_material_especial,
		nr_atendimento,
		ie_se_necessario, --
		ie_acm,
		nr_ocorrencia,
		nr_seq_proc_interno,
		ie_lado,
		nr_seq_topografia,
		nr_seq_prot_glic, --
		ie_duracao,
		ie_periodo,
		dt_inicio,
		dt_fim,
		ds_justificativa, --
		hr_prim_horario,
		dt_liberacao,
		ie_administracao,
		ie_evento_unico,
		nr_seq_cpoe_anterior,
		cd_perfil_ativo,
		cd_pessoa_fisica,
		cd_funcao_origem,
		nr_seq_pend_pac_acao,
		nr_seq_transcricao,
		ie_item_alta,
		ie_prescritor_aux,
		cd_medico,
		ie_retrogrado,
		ie_futuro,
		nr_seq_pepo,
		nr_cirurgia,
		nr_cirurgia_patologia,
		nr_seq_agenda,
		ie_oncologia,
		nr_seq_conclusao_apae,
		cd_protocolo,
		nr_seq_protocolo,
		ie_forma_geracao,
		ds_dado_clinico,
		nr_seq_contraste ,
		ie_amostra,
		cd_setor_atendimento,
		cd_medico_exec,
		cd_setor_entrega,
		nr_seq_cpoe_order_unit)
	values (
		nr_seq_item_gerado_p,
		qt_procedimento_w,
		ds_horarios_w,
		ds_observacao_w,
		clock_timestamp(), --
		nm_usuario_p,
		cd_intervalo_w,
		clock_timestamp(),
		nm_usuario_p,
		coalesce(ie_urgencia_w,ie_urgencia_ww), --
		dt_prev_execucao_w,
		cd_material_exame_w,
		ds_material_especial_w,
		nr_atendimento_p,
		ie_se_necessario_w, --
		ie_acm_w,
		nr_ocorrencia_w,
		nr_seq_proc_interno_w,
		ie_lado_w,
		nr_seq_topografia_w,
		nr_seq_prot_glic_w, --
		ie_duracao_w,
		null,
		dt_prev_execucao_w,
		dt_fim_w,
		ds_justificativa_w, --
		hr_prim_horario_w,
		null,
		ie_admin_proc_w,
		ie_evento_unico_w,
		null,
		cd_perfil_p,
		cd_paciente_p,
		2314,
		nr_seq_pend_pac_acao_p,
		nr_seq_transcricao_p,
		ie_item_alta_p,
		ie_prescritor_aux_p,
		cd_medico_p,
		ie_retrogrado_p,
		ie_futuro_p,
		nr_seq_pepo_p,
		nr_cirurgia_p,
		nr_cirurgia_patologia_p,
		nr_seq_agenda_p,
		ie_oncologia_p,
		nr_seq_conclusao_apae_p,
		cd_protocolo_p,
		nr_seq_protocolo_p,
		'P',
		ds_dado_clinico_w,
		coalesce(nr_seq_contraste_p, nr_seq_contraste_w) ,
		ie_amostra_w,
		cd_setor_atendimento_w,
		cd_medico_exec_w,
		CASE WHEN cd_setor_entrega_w=0 THEN null  ELSE cd_setor_entrega_w END ,
		nr_seq_cpoe_order_unit_p);

  CALL cpoe_copy_order_unit_fields(nr_seq_item_gerado_p,'P', nr_seq_cpoe_order_unit_p);

	commit;
	
  CALL cpoe_consis_proced_insert(nr_seq_item_gerado_p,nm_usuario_p);

	if (nr_seq_prot_glic_w IS NOT NULL AND nr_seq_prot_glic_w::text <> '') then
		CALL cpoe_gerar_proc_glic( nr_seq_item_gerado_p, nr_seq_prot_glic_w, nm_usuario_p, nr_atendimento_p, cd_paciente_p);
		CALL cpoe_gerar_proc_glic_assoc(nr_atendimento_p,nr_seq_item_gerado_p,nr_seq_prot_glic_w,nm_usuario_p);
	end if;

	
	ds_mat_adic_proc_w	:= 'X';

	ds_mat_adic_proc_w := CPOE_gerar_prot_mat_assoc_proc(	nr_atendimento_p, nr_seq_item_gerado_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_protocolo_p, nr_seq_protocolo_p, nr_seq_proc_w, cd_setor_atendimento_w, nr_seq_agrupamento_p, cd_paciente_p, qt_idade_dia_p, qt_idade_mes_p, qt_idade_ano_p, qt_peso_p, cd_prescritor_p, dt_prev_execucao_w, cd_intervalo_w, ds_horarios_w, nr_ocorrencia_w, ie_admin_proc_w, ie_urgencia_proc_w, ie_acm_w, ie_se_necessario_w, ds_mat_adic_proc_w, nr_seq_cpoe_rp_p, nr_seq_cpoe_order_unit_p );
									
	if (ds_mat_adic_proc_w = '1,2,3,4,5,6,7') then	
		ds_mat_adic_proc_w := CPOE_Gerar_med_mat_assoc(	nr_atendimento_p, nr_seq_item_gerado_p, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_paciente_p, qt_idade_dia_p, qt_idade_mes_p, qt_idade_ano_p, cd_setor_atendimento_w, ie_tipo_atendimento_p, cd_convenio_p, cd_medico_atend_p, dt_prev_execucao_w, cd_intervalo_w, ie_urgencia_proc_w, qt_hora_intervalo_w, qt_min_intervalo_w, ds_horarios_w, nr_ocorrencia_w, ds_mat_adic_proc_w, nr_seq_contraste_w, nr_seq_cpoe_order_unit_p);
	end if;

    CALL cpoe_gerar_plano_protocolo(nr_atendimento_p, dt_fim_presc_p, nr_seq_item_gerado_p, nm_usuario_p, 'P');

	CALL cpoe_gerar_prescr_proc_assoc(nr_seq_item_gerado_p, nm_usuario_p, cd_estabelecimento_p);
	
	CALL CPOE_Gerar_Exame_Lab_Dep(nr_seq_item_gerado_p, nr_atendimento_p, cd_estabelecimento_p, cd_setor_atendimento_w, '10,', nm_usuario_p, null, null);

	CALL cpoe_utils_pck.set_list_itens(nr_seq_item_gerado_p, 'P');
	exception
	when others then
		ds_erro_w	:= substr(sqlerrm(SQLSTATE),1,255);
	end;
end loop;
close c01;

commit;

exception
   when others then
	rollback;

	ds_stack_w	:= substr(dbms_utility.format_call_stack,1,2000);
	ds_log_cpoe_w := substr('CPOE_GERAR_PROT_PROC_EXAME '
		|| chr(13) || ' - cd_estabelecimento_p: ' || cd_estabelecimento_p
		|| chr(13) || ' - cd_perfil_p: ' || cd_perfil_p
		|| chr(13) || ' - nm_usuario_p: ' || nm_usuario_p
		|| chr(13) || ' - cd_protocolo_p: ' || cd_protocolo_p
		|| chr(13) || ' - nr_seq_protocolo_p: ' || nr_seq_protocolo_p
		|| chr(13) || ' - nr_seq_item_p: ' || nr_seq_item_p
		|| chr(13) || ' - nr_atendimento_p: ' || nr_atendimento_p
		|| chr(13) || ' - ie_tipo_atendimento_p: ' || ie_tipo_atendimento_p
		|| chr(13) || ' - cd_prescritor_p: ' || cd_prescritor_p
		|| chr(13) || ' - cd_paciente_p: ' || cd_paciente_p
		|| chr(13) || ' - qt_idade_dia_p: ' || qt_idade_dia_p
		|| chr(13) || ' - qt_idade_mes_p: ' || qt_idade_mes_p
		|| chr(13) || ' - qt_idade_ano_p: ' || qt_idade_ano_p
		|| chr(13) || ' - qt_peso_p: ' || qt_peso_p
		|| chr(13) || ' - cd_medico_atend_p: ' || cd_medico_atend_p
		|| chr(13) || ' - cd_setor_atendimento_w: ' || cd_setor_atendimento_w
		|| chr(13) || ' - nr_seq_agrupamento_p: ' || nr_seq_agrupamento_p
		|| chr(13) || ' - cd_convenio_p: ' || cd_convenio_p
		|| chr(13) || ' - ie_tipo_convenio_p: ' || ie_tipo_convenio_p
		|| chr(13) || ' - cd_categoria_convenio_p: ' || cd_categoria_convenio_p
		|| chr(13) || ' - cd_plano_convenio_p: ' || cd_plano_convenio_p
		|| chr(13) || ' - nr_seq_item_gerado_p: ' || nr_seq_item_gerado_p
		|| chr(13) || ' - nr_seq_pend_pac_acao_p: ' || nr_seq_pend_pac_acao_p
		|| chr(13) || ' - nr_seq_transcricao_p: ' || nr_seq_transcricao_p
		|| chr(13) || ' - ie_item_alta_p: ' || ie_item_alta_p
		|| chr(13) || ' - ie_prescritor_aux_p: ' || ie_prescritor_aux_p
		|| chr(13) || ' - cd_medico_p: ' || cd_medico_p
		|| chr(13) || ' - ie_retrogrado_p: ' || ie_retrogrado_p
		|| chr(13) || ' - ie_futuro_p: ' || ie_futuro_p
		|| chr(13) || ' - dt_inicio_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_inicio_p,'timestamp',ESTABLISHMENT_TIMEZONE_UTILS.gettimezone)
		|| chr(13) || ' - nr_seq_pepo_p: ' || nr_seq_pepo_p
		|| chr(13) || ' - nr_cirurgia_p: ' || nr_cirurgia_p
		|| chr(13) || ' - nr_cirurgia_patologia_p: ' || nr_cirurgia_patologia_p
		|| chr(13) || ' - nr_seq_agenda_p: ' || nr_seq_agenda_p
		|| chr(13) || ' - ie_oncologia_p: ' || ie_oncologia_p
		|| chr(13) || ' - nr_seq_conclusao_apae_p: ' || nr_seq_conclusao_apae_p
		|| chr(13) || ' - dt_fim_presc_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_fim_presc_p,'timestamp',ESTABLISHMENT_TIMEZONE_UTILS.gettimezone)
		|| chr(13) || ' - dt_inicio_presc_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_inicio_presc_p,'timestamp',ESTABLISHMENT_TIMEZONE_UTILS.gettimezone)
		|| chr(13) || ' - ERRO: ' || sqlerrm
		|| chr(13) || ' - FUNCAO('||to_char(obter_funcao_ativa)||'); PERFIL('||to_char(obter_perfil_ativo)||')',1,2000);
		
	insert into log_cpoe(
		nr_sequencia,
		nr_atendimento, 
		dt_atualizacao, 
		nm_usuario, 
		ds_log, 
		ds_stack) 
	values (
		nextval('log_cpoe_seq'), 
		nr_atendimento_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		ds_log_cpoe_w, 
		ds_stack_w);
		
	commit;

	CALL wheb_mensagem_pck.exibir_mensagem_abort(sqlerrm);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_prot_proc_exame ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_protocolo_p bigint, nr_seq_protocolo_p bigint, nr_seq_item_p bigint, nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_prescritor_p text, cd_paciente_p text, qt_idade_dia_p bigint, qt_idade_mes_p bigint, qt_idade_ano_p bigint, qt_peso_p bigint, cd_medico_atend_p text, cd_setor_atendimento_p bigint, nr_seq_agrupamento_p bigint, cd_convenio_p bigint, ie_tipo_convenio_p bigint, cd_categoria_convenio_p text, cd_plano_convenio_p text, nr_seq_item_gerado_p INOUT cpoe_procedimento.nr_sequencia%type, nr_seq_pend_pac_acao_p bigint default null, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, ie_oncologia_p text default 'N', nr_seq_conclusao_apae_p bigint default null, dt_fim_presc_p timestamp default null, dt_inicio_presc_p timestamp default null, ie_futuro_p text default 'N', nr_seq_contraste_p bigint default null, ie_gerar_setor_pa_p text default 'N', nr_seq_cpoe_rp_p cpoe_rp.nr_sequencia%type default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) FROM PUBLIC;
