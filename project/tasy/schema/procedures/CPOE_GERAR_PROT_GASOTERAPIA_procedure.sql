-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_prot_gasoterapia ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_protocolo_p protocolo.cd_protocolo%type, nr_seq_protocolo_p protocolo_medicacao.nr_sequencia%type, nr_seq_item_p protocolo_medic_gas.nr_sequencia%type, nr_atendimento_p cpoe_gasoterapia.nr_atendimento%type, cd_pessoa_fisica_p cpoe_gasoterapia.cd_pessoa_fisica%type, nr_seq_item_gerado_p INOUT cpoe_gasoterapia.nr_sequencia%type, nr_seq_pend_pac_acao_p gqa_pend_pac_acao.nr_sequencia%type default null, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, nr_seq_conclusao_apae_p bigint default null, ie_forma_geracao_p text default null, dt_fim_presc_p timestamp default null, dt_inicio_presc_p timestamp default null, ie_futuro_p text default 'N', cd_intervalo_p text default null, qt_dose_p bigint default null, cd_unidade_medida_p text default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) AS $body$
DECLARE


ds_stack_w				log_cpoe.ds_stack%type;
ds_log_cpoe_w			log_cpoe.ds_log%type;
ie_respiracao_w			protocolo_medic_gas.ie_respiracao%type;
ie_disp_resp_esp_w		protocolo_medic_gas.ie_disp_resp_esp%type;
cd_modalidade_vent_w	protocolo_medic_gas.cd_modalidade_vent%type;
nr_seq_gas_w			protocolo_medic_gas.nr_seq_gas%type;
ie_modo_adm_w			protocolo_medic_gas.ie_modo_adm%type;
ie_inicio_w				protocolo_medic_gas.ie_inicio%type;
ie_unidade_medida_w		protocolo_medic_gas.ie_unidade_medida%type;
qt_gasoterapia_w		protocolo_medic_gas.qt_gasoterapia%type;
qt_freq_vent_w			protocolo_medic_gas.qt_freq_vent%type;
ds_observacao_w			protocolo_medic_gas.ds_observacao%type;
cd_intervalo_w			protocolo_medic_gas.cd_intervalo%type;
cd_intervalo_agora_w	protocolo_medic_gas.cd_intervalo%type;
cd_protocolo_w			protocolo_medic_gas.cd_protocolo%type;
nr_seq_protocolo_w		protocolo_medic_gas.nr_seq_protocolo%type;
ie_duracao_w			protocolo_medic_gas.ie_duracao%type;

dt_prev_execucao_w		cpoe_gasoterapia.dt_prev_execucao%type;
hr_prim_horario_w		cpoe_gasoterapia.hr_prim_horario%type;
ie_administracao_w		cpoe_gasoterapia.ie_administracao%type;
ie_urgencia_w			cpoe_gasoterapia.ie_urgencia%type;
ds_horarios_w			cpoe_gasoterapia.ds_horarios%type;
ds_horarios_aux_w		cpoe_gasoterapia.ds_horarios%type;
cd_material_w			cpoe_gasoterapia.cd_mat_equip1%type;
cd_unidade_medida_w		cpoe_gasoterapia.cd_unid_med_dose1%type;
qt_dose_w				cpoe_gasoterapia.qt_dose_mat1%type;
dt_fim_w				cpoe_gasoterapia.dt_fim%type;

qt_min_intervalo_w		intervalo_prescricao.qt_min_intervalo%type;
nr_ocorrencia_w			intervalo_prescricao.nr_etapas%type;

qt_mat_gas_w			integer;
ie_continuo_w			char(1);
ie_prescr_alta_agora_w	varchar(1);
ie_exibe_w			intervalo_prescricao.CD_INTERVALO%type;

c01 CURSOR FOR
SELECT	ie_respiracao,
		ie_disp_resp_esp,
		cd_modalidade_vent,
		nr_seq_gas,
		coalesce(ie_modo_adm,'C'),
		ie_inicio,
		coalesce(cd_unidade_medida_p,ie_unidade_medida),
		coalesce(qt_dose_p, qt_gasoterapia),
		qt_freq_vent,
		ds_observacao,
		coalesce(cd_intervalo_p, cd_intervalo),
		cd_protocolo,
		nr_seq_protocolo,
		coalesce(ie_duracao,'C')
from	protocolo_medic_gas
where	cd_protocolo = cd_protocolo_p
and		nr_seq_protocolo = nr_seq_protocolo_p
and		nr_sequencia = coalesce(nr_seq_item_p,nr_sequencia);

c02 CURSOR FOR
SELECT	cd_material,
		qt_dose,
		cd_unidade_medida,
		row_number() OVER () AS qt_mat_gas
from	protocolo_medic_material
where 	cd_protocolo = cd_protocolo_w
and		nr_sequencia = nr_seq_protocolo_w
and		nr_seq_gas	 = coalesce(nr_seq_item_p,nr_sequencia)
and		ie_agrupador = 15  LIMIT 3;	


BEGIN

ie_prescr_alta_agora_w := obter_param_usuario(924, 409, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_prescr_alta_agora_w);
open c01;
loop
fetch c01 into	
	ie_respiracao_w,
	ie_disp_resp_esp_w,
	cd_modalidade_vent_w,
	nr_seq_gas_w,
	ie_modo_adm_w,
	ie_inicio_w,
	ie_unidade_medida_w,
	qt_gasoterapia_w,
	qt_freq_vent_w,
	ds_observacao_w,
	cd_intervalo_w,
	cd_protocolo_w,
	nr_seq_protocolo_w,
	ie_duracao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_urgencia_w := '';
	dt_fim_w := null;
	
	if (coalesce(obter_se_marca_agora(cpoe_obter_setor_atend_prescr(nr_atendimento_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p)),'N') = 'S') then
		select	max(a.cd_intervalo)
        into STRICT    cd_intervalo_agora_w
        from 	intervalo_prescricao a
        where	a.ie_situacao = 'A'
        and 	Obter_se_intervalo(a.cd_intervalo,'G') = 'S'
        and     coalesce(a.ie_continuo, 'N') = CASE WHEN ie_modo_adm_w='I' THEN 'N' WHEN ie_modo_adm_w='C' THEN 'S' END
        and 	((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estabelecimento_p))
        and 	a.ie_agora = 'S'
        and 	cpoe_obter_se_exibe_interv(nr_atendimento_p, cd_estabelecimento_p, a.cd_intervalo, cd_perfil_p, nm_usuario_p) = 'S'
        order by 
                coalesce(a.nr_seq_apresent,999), 
                a.ds_intervalo;
	
		if (cd_intervalo_agora_w IS NOT NULL AND cd_intervalo_agora_w::text <> '') then
			cd_intervalo_w := cd_intervalo_agora_w;
			ie_inicio_w  := 'A';
		end if;
		
	end if;
	
	if (dt_inicio_presc_p IS NOT NULL AND dt_inicio_presc_p::text <> '') then
		dt_prev_execucao_w := dt_inicio_presc_p;	
	else
		dt_prev_execucao_w := trunc(clock_timestamp(),'HH');
		if (dt_prev_execucao_w < clock_timestamp()) then
			dt_prev_execucao_w := dt_prev_execucao_w  + 1/24;
		end if;	
	end if;
	
	if (coalesce(dt_inicio_presc_p::text, '') = '') and (cpoe_obter_hor_setor_ps(nm_usuario_p, cd_estabelecimento_p, nr_atendimento_p, cd_perfil_p, cd_intervalo_w) = 'S') then
	
		dt_prev_execucao_w := clock_timestamp();
		ie_urgencia_w := '0';
	else
		
		if (coalesce(dt_inicio_presc_p::text, '') = '') then
			hr_prim_horario_w  := substr(cpoe_obter_primeiro_horario(nr_atendimento_p, cd_intervalo_w, null, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_pessoa_fisica_p),1,5);
		end if;
			
		if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
			dt_prev_execucao_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prev_execucao_w, hr_prim_horario_w);				
		end if;
		
		if (dt_prev_execucao_w < clock_timestamp()) then
			dt_prev_execucao_w := dt_prev_execucao_w + 1;
		end if;	
	end if;
	
	hr_prim_horario_w := to_char(dt_prev_execucao_w,'hh24:mi');

    if (ie_inicio_w = 'A') then
		ie_urgencia_w := 0;
		ie_administracao_w := 'P';
		dt_prev_execucao_w := clock_timestamp();
		hr_prim_horario_w := to_char(clock_timestamp(),'hh24:mi');
	elsif (ie_inicio_w = 'ACM') then
        hr_prim_horario_w := '';
		ie_administracao_w := 'C';
	elsif (ie_inicio_w = 'D') then
        hr_prim_horario_w := '';
		ie_administracao_w := 'N';
	else
		ie_administracao_w := 'P';
	end if;
		
	select	coalesce(max(qt_min_intervalo),0)
	into STRICT	qt_min_intervalo_w
	from	intervalo_prescricao
	where	cd_intervalo	= cd_intervalo_w;

	if (ie_modo_adm_w = 'IN') then
		ie_modo_adm_w 	:= 'I';
	elsif (ie_modo_adm_w not in ('C','I')) then
		ie_modo_adm_w	:= 'C';
	end if;
	
	if (ie_modo_adm_w = 'C') then
		ie_continuo_w	:= 'S';
	else
		ie_continuo_w	:= 'N';
	end if;
	
	nr_ocorrencia_w := null;
	ds_horarios_w	:= '';

	SELECT * FROM CPOE_Calcula_horarios_etapas(	nm_usuario_p, dt_prev_execucao_w, ie_continuo_w, nr_ocorrencia_w, cd_intervalo_w, 24, null, null, 'N') INTO STRICT nr_ocorrencia_w, ds_horarios_w;

	if (ie_duracao_w = 'P') then
		dt_fim_w := ((dt_prev_execucao_w + 1) +(1/86400));
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

    dt_prev_execucao_w	:= ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(hr_prim_horario_w);	

		if (dt_prev_execucao_w < clock_timestamp()) then

			dt_prev_execucao_w := dt_prev_execucao_w + 1;

		end if;
	end if;
	
	if (ie_retrogrado_p = 'S' or ie_futuro_p = 'S' ) then -- retrograde/backward item
		dt_prev_execucao_w := dt_inicio_p;
		dt_fim_w := (dt_prev_execucao_w + 1) - 1/1440;
		ie_urgencia_w := null;		
		ie_duracao_w := 'P';
		nr_ocorrencia_w := null;
		ds_horarios_w	:= '';

		SELECT * FROM CPOE_Calcula_horarios_etapas(	nm_usuario_p, dt_prev_execucao_w, ie_continuo_w, nr_ocorrencia_w, cd_intervalo_w, 24, null, null, 'N', ie_duracao_w, dt_fim_w) INTO STRICT nr_ocorrencia_w, ds_horarios_w;
										
		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
	end if;
	
	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '')then
	-- esse select deve ser o mesmo que esta ativando o lookup de intervalo, qualquer alteracao aqui deve ser replicada para o looup e vice-versa
		SELECT coalesce(MAX(cd_intervalo),'N')
		INTO STRICT ie_exibe_w
		FROM intervalo_prescricao
		WHERE 	cd_intervalo = cd_intervalo_w
		AND 	ie_situacao = 'A'
		AND (obter_se_intervalo(cd_intervalo,'G')) = 'S'
		AND	obter_se_interv_regra(cd_intervalo, case to_char('G') when 'G' then 'GAS' when '15' then '15' when '8' then 'DE' end) = 'S'
		and 	cpoe_obter_se_exibe_interv(nr_atendimento_p,cd_estabelecimento_p,cd_intervalo_w,cd_perfil_p,nm_usuario_p) = 'S'
		AND	((coalesce(cd_estabelecimento::text, '') = '') OR (cd_estabelecimento = cd_estabelecimento_p))
		AND	Obter_se_exibe_intervalo(0, cd_intervalo_w, NULL) = 'S'
		AND	Obter_se_intervalo_estab(cd_intervalo, cd_estabelecimento_p) = 'S'
		AND	Obter_se_intervalo_lib_mat(cd_material_w, cd_intervalo_w) = 'S'
		AND	Obter_se_intervalo_material(cd_material_w, cd_intervalo_w) = 'S'
		AND	((coalesce(ie_so_retrograda,'N') = 'N') OR (coalesce(ie_retrogrado_p,'N') = 'N'));
		
		if (ie_exibe_w = 'N')then
			cd_intervalo_w := null;
		end if;
	end if;
	
	if (coalesce(cd_intervalo_w::text, '') = '')  or (cd_intervalo_w = '') then
		ds_horarios_w	:= '';
	end if;
	
	select	nextval('cpoe_gasoterapia_seq')
	into STRICT	nr_seq_item_gerado_p
	;
	
	insert into cpoe_gasoterapia(
				nr_sequencia,
				nr_atendimento,
				cd_pessoa_fisica,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec,
				ie_respiracao,
				ie_disp_resp_esp,
				nr_seq_gas,
				qt_gasoterapia,
				ie_unidade_medida,
				dt_inicio,
				hr_prim_horario,
				dt_prev_execucao,
				qt_freq_vent,
				ie_inicio,
				ie_administracao,
				ie_urgencia,
				ie_modo_adm,
				cd_modalidade_vent,
				cd_intervalo,
				ds_observacao,
				ds_horarios,
				nr_ocorrencia,
				ie_duracao,
				cd_perfil_ativo,
				cd_funcao_origem,
				nr_seq_pend_pac_acao,
				dt_fim,
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
				nr_seq_conclusao_apae,
				cd_protocolo,
				nr_seq_protocolo,
				ie_forma_geracao,
				nr_seq_cpoe_order_unit)
		values (
				nr_seq_item_gerado_p,
				nr_atendimento_p,
				cd_pessoa_fisica_p,
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				ie_respiracao_w,
				ie_disp_resp_esp_w,
				nr_seq_gas_w,
				qt_gasoterapia_w,
				ie_unidade_medida_w,
				dt_prev_execucao_w,
				hr_prim_horario_w,
				dt_prev_execucao_w,
				qt_freq_vent_w,
				ie_inicio_w,
				ie_administracao_w,
				ie_urgencia_w,
				ie_modo_adm_w,
				cd_modalidade_vent_w,
				cd_intervalo_w,
				ds_observacao_w,
				ds_horarios_w,
				nr_ocorrencia_w,
				ie_duracao_w,
				cd_perfil_p,
				2314,
				nr_seq_pend_pac_acao_p,
				dt_fim_w,
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
				nr_seq_conclusao_apae_p,
				cd_protocolo_p,
				nr_seq_protocolo_p,
				ie_forma_geracao_p,
				nr_seq_cpoe_order_unit_p);
	commit;
	
	open c02;
	loop
	fetch c02 into
		cd_material_w,
		qt_dose_w,
		cd_unidade_medida_w,
		qt_mat_gas_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		case qt_mat_gas_w
		when 1 then
			begin
			update	cpoe_gasoterapia
			set		cd_mat_equip1 		= cd_material_w,
					cd_intervalo_mat1	= cd_intervalo_w,
					cd_unid_med_dose1	= cd_unidade_medida_w,
					ds_horarios_mat1	= ds_horarios_w,
					hr_prim_hor_mat1	= hr_prim_horario_w,
					qt_dose_mat1		= qt_dose_w
			where	nr_sequencia		= nr_seq_item_gerado_p;
			end;
		when 2 then
			begin
			update	cpoe_gasoterapia
			set		cd_mat_equip2 		= cd_material_w,
					cd_intervalo_mat2	= cd_intervalo_w,
					cd_unid_med_dose2	= cd_unidade_medida_w,
					ds_horarios_mat2	= ds_horarios_w,
					hr_prim_hor_mat2	= hr_prim_horario_w,
					qt_dose_mat2		= qt_dose_w
			where	nr_sequencia		= nr_seq_item_gerado_p;
			end;
		when 3 then
			begin
			update	cpoe_gasoterapia
			set		cd_mat_equip3 		= cd_material_w,
					cd_intervalo_mat3	= cd_intervalo_w,
					cd_unid_med_dose3	= cd_unidade_medida_w,
					ds_horarios_mat3	= ds_horarios_w,
					hr_prim_hor_mat3	= hr_prim_horario_w,
					qt_dose_mat3		= qt_dose_w
			where	nr_sequencia		= nr_seq_item_gerado_p;
			end;
		end case;
		end;
	end loop;
	close c02;

	CALL cpoe_gerar_plano_protocolo(nr_atendimento_p, dt_fim_presc_p, nr_seq_item_gerado_p, nm_usuario_p, 'G');

    CALL cpoe_utils_pck.set_list_itens(nr_seq_item_gerado_p, 'G');
	end;
end loop;
close c01;

exception
   when others then
	rollback;

	ds_stack_w	:= substr(dbms_utility.format_call_stack,1,2000);
	ds_log_cpoe_w := substr('CPOE_GERAR_PROT_GASOTERAPIA '
		|| chr(13) || ' - cd_estabelecimento_p: ' || cd_estabelecimento_p
		|| chr(13) || ' - cd_perfil_p: ' || cd_perfil_p
		|| chr(13) || ' - nm_usuario_p: ' || nm_usuario_p
		|| chr(13) || ' - cd_protocolo_p: ' || cd_protocolo_p
		|| chr(13) || ' - nr_seq_protocolo_p: ' || nr_seq_protocolo_p
		|| chr(13) || ' - nr_seq_item_p: ' || nr_seq_item_p
		|| chr(13) || ' - nr_atendimento_p: ' || nr_atendimento_p
		|| chr(13) || ' - cd_pessoa_fisica_p: ' || cd_pessoa_fisica_p
		|| chr(13) || ' - nr_seq_item_gerado_p: ' || nr_seq_item_gerado_p
		|| chr(13) || ' - nr_seq_pend_pac_acao_p: ' || nr_seq_pend_pac_acao_p
		|| chr(13) || ' - ie_item_alta_p: ' || ie_item_alta_p
		|| chr(13) || ' - ie_prescritor_aux_p: ' || ie_prescritor_aux_p
		|| chr(13) || ' - cd_medico_p: ' || cd_medico_p
		|| chr(13) || ' - ie_retrogrado_p: ' || ie_retrogrado_p
		|| chr(13) || ' - ie_futuro_p: ' || ie_futuro_p
		|| chr(13) || ' - dt_inicio_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_inicio_p,'timestamp',ESTABLISHMENT_TIMEZONE_UTILS.GETTIMEZONE)
		|| chr(13) || ' - nr_seq_pepo_p: ' || nr_seq_pepo_p
		|| chr(13) || ' - nr_cirurgia_p: ' || nr_cirurgia_p
		|| chr(13) || ' - nr_cirurgia_patologia_p: ' || nr_cirurgia_patologia_p
		|| chr(13) || ' - nr_seq_agenda_p: ' || nr_seq_agenda_p
		|| chr(13) || ' - nr_seq_transcricao_p: ' || nr_seq_transcricao_p
		|| chr(13) || ' - nr_seq_conclusao_apae_p: ' || nr_seq_conclusao_apae_p
		|| chr(13) || ' - ie_forma_geracao_p: ' || ie_forma_geracao_p
		|| chr(13) || ' - dt_fim_presc_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_fim_presc_p,'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.GETTIMEZONE)
		|| chr(13) || ' - dt_inicio_presc_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_inicio_presc_p,'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.GETTIMEZONE)
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
-- REVOKE ALL ON PROCEDURE cpoe_gerar_prot_gasoterapia ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_protocolo_p protocolo.cd_protocolo%type, nr_seq_protocolo_p protocolo_medicacao.nr_sequencia%type, nr_seq_item_p protocolo_medic_gas.nr_sequencia%type, nr_atendimento_p cpoe_gasoterapia.nr_atendimento%type, cd_pessoa_fisica_p cpoe_gasoterapia.cd_pessoa_fisica%type, nr_seq_item_gerado_p INOUT cpoe_gasoterapia.nr_sequencia%type, nr_seq_pend_pac_acao_p gqa_pend_pac_acao.nr_sequencia%type default null, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, nr_seq_conclusao_apae_p bigint default null, ie_forma_geracao_p text default null, dt_fim_presc_p timestamp default null, dt_inicio_presc_p timestamp default null, ie_futuro_p text default 'N', cd_intervalo_p text default null, qt_dose_p bigint default null, cd_unidade_medida_p text default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) FROM PUBLIC;
