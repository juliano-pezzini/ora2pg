-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_prot_suplementar ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_protocolo_p protocolo_medic_material.cd_protocolo%type, nr_seq_protocolo_p protocolo_medic_material.nr_sequencia%type, nr_seq_item_p protocolo_medic_material.nr_seq_material%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_item_gerado_p INOUT cpoe_dieta.nr_sequencia%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_pend_pac_acao_p gqa_pend_pac_acao.nr_sequencia%type default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, nr_seq_transcricao_p bigint default null, nr_seq_conclusao_apae_p bigint default null, ie_forma_geracao_p text default null, dt_fim_presc_p timestamp default null, dt_inicio_presc_p timestamp default null, ie_futuro_p text default 'N', nr_seq_cpoe_rp_p cpoe_rp.nr_sequencia%type default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) AS $body$
DECLARE


ds_stack_w				log_cpoe.ds_stack%type;
ds_log_cpoe_w			log_cpoe.ds_log%type;
cd_material_w			protocolo_medic_material.cd_material%type;
cd_unidade_medida_w		protocolo_medic_material.cd_unidade_medida%type;
qt_dose_w				protocolo_medic_material.qt_dose%type;
ie_bomba_infusao_w		protocolo_medic_material.ie_bomba_infusao%type;
hr_prim_horario_w		protocolo_medic_material.hr_prim_horario%type;
qt_vel_infusao_w		protocolo_medic_material.qt_vel_infusao%type;
cd_intervalo_w			protocolo_medic_material.cd_intervalo%type;
cd_intervalo_agora_w	protocolo_medic_material.cd_intervalo%type;
ie_via_aplicacao_w		protocolo_medic_material.ie_via_aplicacao%type;
ie_duracao_w			protocolo_medic_material.ie_duracao%type;
qt_hora_infusao_w		protocolo_medic_material.qt_hora_aplicacao%type;
qt_minuto_infusao_w		protocolo_medic_material.qt_minuto_aplicacao%type;

dt_inicio_w				cpoe_dieta.dt_inicio%type;
nr_ocorrencia_w			cpoe_dieta.nr_ocorrencia%type;	
ds_horarios_w			cpoe_dieta.ds_horarios%type;	
ds_horarios_aux_w		cpoe_dieta.ds_horarios%type;	
nr_etapas_w				cpoe_dieta.nr_ocorrencia%type;
ie_referencia_w			cpoe_dieta.ie_referencia%type;
dt_fim_w				cpoe_dieta.dt_fim%type;
qt_tempo_aplic_w		cpoe_dieta.qt_tempo_aplic%type;
ie_evento_unico_w		cpoe_dieta.ie_evento_unico%type;

ie_prescr_alta_agora_w	varchar(1);
ie_urgencia_w			char(1):=null;

ie_exibe_w				intervalo_prescricao.cd_intervalo%type;
qt_min_intervalo_w		intervalo_prescricao.qt_min_intervalo%type;
ie_dose_unica_cpoe_w	intervalo_prescricao.ie_dose_unica_cpoe%type;
ie_check_tipo_interv_w			varchar(1);
ie_acm_w 				cpoe_dieta.ie_acm%type;
ie_se_necessario_w 			cpoe_dieta.ie_se_necessario%type;
ie_acm_ww 				cpoe_dieta.ie_acm%type;
ie_se_necessario_ww 			cpoe_dieta.ie_se_necessario%type;
ie_administracao_w			cpoe_dieta.ie_administracao%type;
ds_observacao_w				cpoe_dieta.ds_observacao%type;

c01 CURSOR FOR
SELECT	a.cd_material,
		a.cd_unidade_medida,
		a.qt_dose,
		a.ie_bomba_infusao ,
		a.hr_prim_horario,
		a.qt_vel_infusao,
		a.cd_intervalo,
		a.ie_via_aplicacao,
		coalesce(a.ie_duracao,'C'),
		a.qt_hora_aplicacao,
		a.qt_minuto_aplicacao,
		coalesce(a.ie_se_necessario,'N'),
		coalesce(a.ie_acm,'N'),
		ds_recomendacao
from 	protocolo_medic_material a
where	a.cd_protocolo = cd_protocolo_p
and		a.nr_sequencia = nr_seq_protocolo_p
and		a.ie_agrupador = 12
and		a.nr_seq_material = coalesce(nr_seq_item_p,a.nr_seq_material)
order by 	nr_seq_material;
		

BEGIN
ie_prescr_alta_agora_w := obter_param_usuario(924, 409, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_prescr_alta_agora_w);
ie_check_tipo_interv_w := obter_param_usuario(924, 809, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_check_tipo_interv_w);

open c01;
loop
fetch c01 into
	cd_material_w,
	cd_unidade_medida_w,
	qt_dose_w,
	ie_bomba_infusao_w,
	hr_prim_horario_w,
	qt_vel_infusao_w,
	cd_intervalo_w,
	ie_via_aplicacao_w,
	ie_duracao_w,
	qt_hora_infusao_w,
	qt_minuto_infusao_w,
	ie_se_necessario_w,
	ie_acm_w,
	ds_observacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	qt_tempo_aplic_w := null;
	
	
	ie_administracao_w := 'P';
	
	if (ie_se_necessario_w = 'S') then
		ie_administracao_w := 'N';
	elsif (ie_acm_w = 'S') then
		ie_administracao_w := 'C';
	end if;
	
	if (qt_hora_infusao_w IS NOT NULL AND qt_hora_infusao_w::text <> '') then
		if (qt_hora_infusao_w < 10) then
			qt_tempo_aplic_w := '0' || qt_hora_infusao_w;
		else
			qt_tempo_aplic_w := qt_hora_infusao_w;
		end if;
	end if;
	
	if (qt_minuto_infusao_w IS NOT NULL AND qt_minuto_infusao_w::text <> '') and (coalesce(qt_tempo_aplic_w::text, '') = '') then
		if (qt_minuto_infusao_w < 10) then
			qt_tempo_aplic_w := qt_tempo_aplic_w || ':0' || qt_minuto_infusao_w;
		else
			qt_tempo_aplic_w := qt_tempo_aplic_w || ':' || qt_minuto_infusao_w;
		end if;
	elsif (qt_tempo_aplic_w IS NOT NULL AND qt_tempo_aplic_w::text <> '') then
		qt_tempo_aplic_w := qt_tempo_aplic_w || ':00';
	elsif (coalesce(qt_tempo_aplic_w::text, '') = '') then
		qt_tempo_aplic_w := '24:00';
	end if;
	
	dt_fim_w := null;
	
	if (dt_inicio_presc_p IS NOT NULL AND dt_inicio_presc_p::text <> '') then
		dt_inicio_w := dt_inicio_presc_p;	
	else	
		dt_inicio_w := clock_timestamp();
	end if;
	
	if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
		dt_inicio_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_w, hr_prim_horario_w);
		if (dt_inicio_w <= clock_timestamp()) then
			dt_inicio_w := dt_inicio_w +1;
		end if;
	else
		dt_inicio_w := trunc(dt_inicio_w,'hh');
		if (dt_inicio_w <= clock_timestamp()) then
			dt_inicio_w := dt_inicio_w +1/24;
		end if;
		
		if (coalesce(dt_inicio_presc_p::text, '') = '') and (cpoe_obter_hor_setor_ps(nm_usuario_p, cd_estabelecimento_p, nr_atendimento_p, cd_perfil_p, cd_intervalo_w) = 'S') then
		
			dt_inicio_w := clock_timestamp();
			ie_urgencia_w := '0';
			hr_prim_horario_w := to_char(dt_inicio_w,'hh24:mi');
		else
			
			hr_prim_horario_w  := substr(cpoe_obter_primeiro_horario(nr_atendimento_p, cd_intervalo_w, null, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_pessoa_fisica_p),1,5);
			
			if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
				dt_inicio_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_w, hr_prim_horario_w);				
			end if;
			
			if (dt_inicio_w < clock_timestamp()) then
				dt_inicio_w := dt_inicio_w + 1;
			end if;
			
			hr_prim_horario_w := to_char(dt_inicio_w,'hh24:mi');
		end if;
	end if;
	
	nr_etapas_w	:= null;
	
	if (coalesce(obter_se_marca_agora(cpoe_obter_setor_atend_prescr(nr_atendimento_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p)),'N') = 'S') then
		cd_intervalo_agora_w := cpoe_busca_intervalo_agora(nr_atendimento_p,'12',cd_estabelecimento_p,cd_perfil_p, nm_usuario_p);
	
		if (cd_intervalo_agora_w IS NOT NULL AND cd_intervalo_agora_w::text <> '') then
			cd_intervalo_w := cd_intervalo_agora_w;
			ie_urgencia_w  := '0';
			hr_prim_horario_w :=  to_char(clock_timestamp(),'hh24:mi');			
		end if;
		
	end if;		
	
	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		select	max(ie_dose_unica_cpoe)
		into STRICT	ie_dose_unica_cpoe_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;
		
		if (coalesce(ie_dose_unica_cpoe_w, 'N') = 'S') then
			ie_duracao_w := 'P';
			ie_evento_unico_w 	:= 'S';
			ie_se_necessario_w := 'N';
			ie_acm_w := 'N';
			ie_administracao_w := 'P';
			ie_urgencia_w  := '0';
		end if;
	end if;
	
	if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
		dt_inicio_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_w, hr_prim_horario_w);
	elsif (coalesce(ie_urgencia_w::text, '') = '') then
		hr_prim_horario_w :=  to_char(dt_inicio_w,'hh24:mi');			
	end if;
	
	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		select	coalesce(max(qt_min_intervalo),0)
		into STRICT	qt_min_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo	= cd_intervalo_w;
		ie_referencia_w	:= 'I';
	else
		ie_referencia_w	:= 'E';
	end if;	
	nr_ocorrencia_w := null;

	SELECT * FROM cpoe_calcular_horario_prescr(nr_atendimento_p, cd_intervalo_w, cd_material_w, dt_inicio_w, 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
									
	ds_horarios_w := cpoe_padroniza_horario(ds_horarios_w||ds_horarios_aux_w);
	
	if (ie_duracao_w = 'P') then
		dt_fim_w := ((dt_inicio_w + 1) +(1/86400));
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

		SELECT * FROM cpoe_calcular_horario_prescr(nr_atendimento_p, cd_intervalo_w, cd_material_w, clock_timestamp(), 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;

		ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;

		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);

		dt_inicio_w	:= ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(hr_prim_horario_w);

		if (dt_inicio_w < clock_timestamp()) then

			dt_inicio_w := dt_inicio_w + 1;

		end if;
	end if;
	
	if (ie_retrogrado_p = 'S' or ie_futuro_p = 'S') then -- retrograde/backward item
		dt_inicio_w := dt_inicio_p;
		dt_fim_w := (dt_inicio_w + 1) - 1/1440;
		nr_ocorrencia_w := null;
		ie_duracao_w := 'P';
		ie_urgencia_w  := null;

		select	max(qt_min_intervalo)
		into STRICT	qt_min_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;
		
		SELECT * FROM cpoe_calcular_horario_prescr(nr_atendimento_p, cd_intervalo_w, cd_material_w, dt_inicio_w, 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
										
		ds_horarios_w := cpoe_padroniza_horario(ds_horarios_w||ds_horarios_aux_w);
		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
	end if;
	
	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '')then
	-- esse select deve ser o mesmo que ata ativando o lookup de intervalo, qualquer alteracao aqui deve ser replicada para o looup e vice-versa
		SELECT coalesce(MAX(cd_intervalo),'N')
		INTO STRICT ie_exibe_w
		FROM intervalo_prescricao
		WHERE 	cd_intervalo = cd_intervalo_w
		AND 	ie_situacao = 'A'
		AND	Obter_se_intervalo(cd_intervalo_w, '12') = 'S'
		and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p))
		AND 	cpoe_obter_se_exibe_interv(nr_atendimento_p,cd_estabelecimento_p,cd_intervalo_w,cd_perfil_p,nm_usuario_p) = 'S'
		and	Obter_se_intervalo_estab(cd_intervalo, cd_estabelecimento_p) = 'S'
		and	obter_se_interv_regra(cd_intervalo_w, 'DS') = 'S'
		and	((coalesce(ie_so_retrograda,'N') = 'N') or (coalesce(ie_retrogrado_p,'N') = 'N'));
		
		if (ie_exibe_w = 'N')then
			cd_intervalo_w := null;
		end if;
	end if;

	if (coalesce(cd_intervalo_w::text, '') = '')  or (cd_intervalo_w = '') then
			ds_horarios_w	:= '';
	end if;
	
	if (ie_se_necessario_w = 'S') or (ie_acm_w = 'S') then
	
		ds_horarios_w	:= '';
		hr_prim_horario_w := '';
		ie_urgencia_w  := null;
		nr_ocorrencia_w := 1;
	end if;
	
	if (ie_check_tipo_interv_w = 'S') and (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		
		Select	coalesce(max(ie_se_necessario),'N'),
			coalesce(max(ie_acm),'N')
		into STRICT	ie_se_necessario_ww,
			ie_acm_ww
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;
		
		if (ie_se_necessario_w = 'N') and (ie_se_necessario_ww = 'S') then
			
			ie_se_necessario_w := 'S';
			ie_acm_w := 'N';
			ie_administracao_w := 'N';
			ie_urgencia_w  := null;
			ds_horarios_w     := '';
			hr_prim_horario_w := '';
			nr_ocorrencia_w := 1;
			
		elsif (ie_acm_w = 'N') and (ie_acm_ww = 'S') then
		
			ie_acm_w := 'S';
			ie_se_necessario_w := 'N';
			ie_administracao_w := 'C';
			ie_urgencia_w  := null;
			ds_horarios_w     := '';
			hr_prim_horario_w := '';
			nr_ocorrencia_w := 1;
		
		end if;
	end if;
	
	select	nextval('cpoe_dieta_seq')
	into STRICT	nr_seq_item_gerado_p
	;
	
	insert into cpoe_dieta(
			nr_sequencia,
			nr_atendimento,
			ie_tipo_dieta,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			ie_via_aplicacao,
			ie_administracao,
			ie_referencia,
			ie_duracao,
			ds_horarios,
			hr_prim_horario,
			dt_inicio,
			cd_material,
			cd_intervalo,
			qt_dose,
			ie_bomba_infusao,
			qt_vel_infusao,
			cd_unidade_medida_dose,
			ie_continuo,
			qt_tempo_aplic,
			qt_tempo_pausa,
			nr_ocorrencia,
			nr_etapas,
			cd_perfil_ativo,
			cd_pessoa_fisica,
			cd_funcao_origem,
			ie_urgencia,
			nr_seq_pend_pac_acao,
			dt_fim,
			ie_item_alta,
			ie_prescritor_aux,
			cd_medico,
			ie_retrogrado,
			ie_futuro,
			nr_seq_pepo,
			nr_cirurgia,
			nr_cirurgia_patologia,
			nr_seq_agenda,
			nr_seq_transcricao,
			nr_seq_conclusao_apae,
			ie_forma_geracao,
			ie_evento_unico,
			ie_acm,
			ie_se_necessario,
			nr_seq_cpoe_order_unit,
			ds_observacao)
		values (
			nr_seq_item_gerado_p,
			nr_atendimento_p,
			'S',
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			ie_via_aplicacao_w,
			ie_administracao_w,
			ie_referencia_w,
			ie_duracao_w,
			ds_horarios_w,
			hr_prim_horario_w,
			dt_inicio_w,
			cd_material_w,
			cd_intervalo_w,
			qt_dose_w,
			ie_bomba_infusao_w,
			qt_vel_infusao_w,
			cd_unidade_medida_w,
			'N',
			qt_tempo_aplic_w,
			null,
			nr_ocorrencia_w,
			nr_etapas_w,
			cd_perfil_p,
			cd_pessoa_fisica_p,
			2314,
			ie_urgencia_w,
			nr_seq_pend_pac_acao_p,
			dt_fim_w,
			ie_item_alta_p,
			ie_prescritor_aux_p,
			cd_medico_p,
			ie_retrogrado_p,
			ie_futuro_p,
			nr_seq_pepo_p,
			nr_cirurgia_p,
			nr_cirurgia_patologia_p,
			nr_seq_agenda_p,
			nr_seq_transcricao_p,
			nr_seq_conclusao_apae_p,
			ie_forma_geracao_p,
			ie_evento_unico_w,
			ie_acm_w,
			ie_se_necessario_w,
			nr_seq_cpoe_order_unit_p,
			ds_observacao_w);
	
		CALL cpoe_gerar_plano_protocolo(nr_atendimento_p, dt_fim_presc_p, nr_seq_item_gerado_p, nm_usuario_p, 'N');

		CALL cpoe_utils_pck.set_list_itens(nr_seq_item_gerado_p, 'N');
	end;
end loop;
close c01;

commit;

exception
   when others then
	rollback;

	ds_stack_w	:= substr(dbms_utility.format_call_stack,1,2000);
	ds_log_cpoe_w := substr('CPOE_GERAR_PROT_SUPLEMENTAR '
		|| chr(13) || ' - cd_estabelecimento_p: ' || cd_estabelecimento_p
		|| chr(13) || ' - cd_perfil_p: ' || cd_perfil_p
		|| chr(13) || ' - nm_usuario_p: ' || nm_usuario_p
		|| chr(13) || ' - cd_protocolo_p: ' || cd_protocolo_p
		|| chr(13) || ' - nr_seq_protocolo_p: ' || nr_seq_protocolo_p
		|| chr(13) || ' - nr_seq_item_p: ' || nr_seq_item_p
		|| chr(13) || ' - nr_atendimento_p: ' || nr_atendimento_p
		|| chr(13) || ' - nr_seq_item_gerado_p: ' || nr_seq_item_gerado_p
		|| chr(13) || ' - cd_pessoa_fisica_p: ' || cd_pessoa_fisica_p
		|| chr(13) || ' - nr_seq_pend_pac_acao_p: ' || nr_seq_pend_pac_acao_p
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
		|| chr(13) || ' - nr_seq_transcricao_p: ' || nr_seq_transcricao_p
		|| chr(13) || ' - nr_seq_conclusao_apae_p: ' || nr_seq_conclusao_apae_p
		|| chr(13) || ' - ie_forma_geracao_p: ' || ie_forma_geracao_p
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
-- REVOKE ALL ON PROCEDURE cpoe_gerar_prot_suplementar ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_protocolo_p protocolo_medic_material.cd_protocolo%type, nr_seq_protocolo_p protocolo_medic_material.nr_sequencia%type, nr_seq_item_p protocolo_medic_material.nr_seq_material%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_item_gerado_p INOUT cpoe_dieta.nr_sequencia%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_pend_pac_acao_p gqa_pend_pac_acao.nr_sequencia%type default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, nr_seq_transcricao_p bigint default null, nr_seq_conclusao_apae_p bigint default null, ie_forma_geracao_p text default null, dt_fim_presc_p timestamp default null, dt_inicio_presc_p timestamp default null, ie_futuro_p text default 'N', nr_seq_cpoe_rp_p cpoe_rp.nr_sequencia%type default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) FROM PUBLIC;
