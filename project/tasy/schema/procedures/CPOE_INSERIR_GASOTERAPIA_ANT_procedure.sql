-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_inserir_gasoterapia_ant ( nr_atendimento_p prescr_medica.nr_atendimento%type, nr_atendimento_ant_p prescr_medica.nr_atendimento%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p prescr_gasoterapia.nr_sequencia%type, nm_usuario_p prescr_medica.nm_usuario%type, cd_perfil_p bigint, cd_estabelecimento_p bigint, nr_seq_item_gerado_p INOUT bigint, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, nr_seq_conclusao_apae_p bigint default null, ie_futuro_p text default 'N', nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) AS $body$
DECLARE



-- Duplicata da procedure CPOE_REP_GERAR_GASOTERAPIA				
cd_intervalo_w					prescr_gasoterapia.cd_intervalo%type;
cd_modalidade_vent_w			prescr_gasoterapia.cd_modalidade_vent%type;
ds_horarios_w					prescr_gasoterapia.ds_horarios%type;
ds_observacao_w					prescr_gasoterapia.ds_observacao%type;
dt_prev_execucao_w				prescr_gasoterapia.dt_prev_execucao%type;
ie_disp_resp_esp_w				prescr_gasoterapia.ie_disp_resp_esp%type;
ie_modo_adm_w					prescr_gasoterapia.ie_modo_adm%type;
ie_respiracao_w					prescr_gasoterapia.ie_respiracao%type;
ie_tipo_onda_w					prescr_gasoterapia.ie_tipo_onda%type;
ie_unidade_medida_w				prescr_gasoterapia.ie_unidade_medida%type;
nr_seq_gas_w					prescr_gasoterapia.nr_seq_gas%type;
nr_seq_gasoterapia_w			prescr_gasoterapia.nr_sequencia%type;
qt_acima_peep_w					prescr_gasoterapia.qt_acima_peep%type;
qt_be_w							prescr_gasoterapia.qt_be%type;
qt_bic_w						prescr_gasoterapia.qt_bic%type;
qt_fluxo_insp_w					prescr_gasoterapia.qt_fluxo_insp%type;
qt_freq_vent_w					prescr_gasoterapia.qt_freq_vent%type;
qt_gasoterapia_w				prescr_gasoterapia.qt_gasoterapia%type;
qt_min_intervalo_w				prescr_gasoterapia.qt_min_intervalo%type;
qt_pco2_w						prescr_gasoterapia.qt_pco2%type;
qt_peep_w						prescr_gasoterapia.qt_peep%type;
qt_ph_w							prescr_gasoterapia.qt_ph%type;
qt_pip_w						prescr_gasoterapia.qt_pip%type;
qt_ps_w							prescr_gasoterapia.qt_ps%type;
qt_referencia_w					prescr_gasoterapia.qt_referencia%type;
qt_sato2_w						prescr_gasoterapia.qt_sato2%type;
qt_sensib_resp_w				prescr_gasoterapia.qt_sensib_resp%type;
qt_tempo_insp_w					prescr_gasoterapia.qt_tempo_insp%type;
qt_ti_te_w						prescr_gasoterapia.qt_ti_te%type;
ie_inicio_w						prescr_gasoterapia.ie_inicio%type;

hr_prim_horario_w				cpoe_gasoterapia.hr_prim_horario%type;
ie_se_necessario_w				cpoe_gasoterapia.ie_se_necessario%type;
ie_acm_w						cpoe_gasoterapia.ie_acm%type;
ie_administracao_w				cpoe_gasoterapia.ie_administracao%type;
nr_ocorrencia_w					cpoe_gasoterapia.nr_ocorrencia%type;
ie_urgencia_w					cpoe_gasoterapia.ie_urgencia%type:='';
ds_horarios_aux_w				cpoe_gasoterapia.ds_horarios%type:='';
ie_duracao_w					cpoe_gasoterapia.ie_duracao%type := 'C';

ie_prescr_alta_agora_w			varchar(1);
ie_continuo_w					char(1);
dt_fim_w						timestamp := null;

c01 CURSOR FOR
SELECT	cd_intervalo,
		cd_modalidade_vent,
		ds_horarios,
		ds_observacao,
		dt_prev_execucao,
		ie_disp_resp_esp,
		ie_modo_adm,
		ie_respiracao,
		ie_tipo_onda,
		ie_unidade_medida,
		nr_seq_gas,
		nr_sequencia,
		qt_acima_peep,
		qt_be,
		qt_bic,
		qt_fluxo_insp,
		qt_freq_vent,
		qt_gasoterapia,
		qt_min_intervalo,
		qt_pco2,
		qt_peep,
		qt_ph,
		qt_pip,
		qt_ps,
		qt_referencia,
		qt_sato2,
		qt_sensib_resp,
		qt_tempo_insp,
		qt_ti_te,
		ie_inicio
from	prescr_gasoterapia
where	nr_prescricao = nr_prescricao_p
and		nr_sequencia = nr_sequencia_p;


BEGIN

ie_prescr_alta_agora_w := obter_param_usuario(924, 409, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_prescr_alta_agora_w);

open c01;
loop
fetch c01 into	cd_intervalo_w,
				cd_modalidade_vent_w,
				ds_horarios_w,
				ds_observacao_w,
				dt_prev_execucao_w,
				ie_disp_resp_esp_w,
				ie_modo_adm_w,
				ie_respiracao_w,
				ie_tipo_onda_w,
				ie_unidade_medida_w,
				nr_seq_gas_w,
				nr_seq_gasoterapia_w,
				qt_acima_peep_w,
				qt_be_w,
				qt_bic_w,
				qt_fluxo_insp_w,
				qt_freq_vent_w,
				qt_gasoterapia_w,
				qt_min_intervalo_w,
				qt_pco2_w,
				qt_peep_w,
				qt_ph_w,
				qt_pip_w,
				qt_ps_w,
				qt_referencia_w,
				qt_sato2_w,
				qt_sensib_resp_w,
				qt_tempo_insp_w,
				qt_ti_te_w,
				ie_inicio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_administracao_w	:= 'P';
	ie_acm_w			:= 'N';
	ie_se_necessario_w	:= 'N';
	nr_ocorrencia_w		:= null;
	
	if (ie_modo_adm_w = 'C') then
		ie_continuo_w	:= 'S';
	else
		ie_continuo_w	:= 'N';
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
		dt_prev_execucao_w	:= to_date(to_char(clock_timestamp(),'dd/mm/yyyy ') || hr_prim_horario_w, 'dd/mm/yyyy hh24:mi');
	
		if (dt_prev_execucao_w < clock_timestamp()) then
			dt_prev_execucao_w := dt_prev_execucao_w + 1;
		end if;
		
		
		
	else	
		ie_urgencia_w := '';
		SELECT * FROM cpoe_atualizar_periodo_vig_ant(ds_horarios_w, hr_prim_horario_w, dt_prev_execucao_w) INTO STRICT ds_horarios_w, hr_prim_horario_w, dt_prev_execucao_w;
	end if;
	
	
	if (ie_inicio_w = 'ACM') then
		ie_acm_w			:= 'S';
		ds_horarios_w		:= '';
		ie_administracao_w	:= 'C';
	elsif (ie_inicio_w = 'D') then
		ie_se_necessario_w	:= 'S';
		ds_horarios_w		:= '';
		ie_administracao_w	:= 'N';
	end if;
	
	if (ie_retrogrado_p = 'S' or ie_futuro_p = 'S') then -- retrograde/backward item
		dt_prev_execucao_w := dt_inicio_p;
		dt_fim_w := (dt_prev_execucao_w + 1) - 1/1440;
		
		ie_urgencia_w := null;		
		ie_duracao_w := 'P';
		nr_ocorrencia_w := null;
		ds_horarios_w	:= '';

		SELECT * FROM CPOE_Calcula_horarios_etapas(	nm_usuario_p, dt_prev_execucao_w, ie_continuo_w, nr_ocorrencia_w, cd_intervalo_w, 24, null, null, 'N', ie_duracao_w, dt_fim_w) INTO STRICT nr_ocorrencia_w, ds_horarios_w;
		
		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);								
	end if;

	select	nextval('cpoe_gasoterapia_seq')
	into STRICT	nr_seq_item_gerado_p
	;
	
	insert into cpoe_gasoterapia(
				nr_sequencia,
				nr_atendimento,
				ie_administracao,
				ie_duracao,
				ie_urgencia,
				ie_se_necessario,
				ie_acm,
				dt_inicio,
				dt_fim,
				hr_prim_horario,
				cd_intervalo,
				cd_modalidade_vent,
				ds_horarios,
				ds_observacao,
				dt_prev_execucao,
				ie_disp_resp_esp,
				ie_inicio,
				ie_modo_adm,
				ie_respiracao,
				ie_tipo_onda,
				ie_unidade_medida,
				nr_seq_gas,
				qt_acima_peep,
				qt_be,
				qt_bic,
				qt_fluxo_insp,
				qt_freq_vent,
				qt_gasoterapia,
				qt_min_intervalo,
				qt_pco2,
				qt_peep,
				qt_ph,
				qt_pip,
				qt_ps,
				qt_referencia,
				qt_sato2,
				qt_sensib_resp,
				qt_tempo_insp,
				qt_ti_te,
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nr_ocorrencia,
				cd_pessoa_fisica,
				cd_perfil_ativo,
				cd_funcao_origem,
				nr_seq_transcricao,
				ie_item_alta,
				ie_prescritor_aux,
				cd_medico,
				ie_retrogrado,
				nr_seq_pepo,
				nr_cirurgia,
				nr_cirurgia_patologia,
				nr_seq_agenda,
				nr_seq_conclusao_apae,
				ie_futuro,
				nr_seq_cpoe_order_unit)
			values (
				nr_seq_item_gerado_p,
				nr_atendimento_p,
				ie_administracao_w,
				ie_duracao_w,
				null,
				ie_se_necessario_w,
				ie_acm_w,
				dt_prev_execucao_w,
				dt_fim_w,
				hr_prim_horario_w,
				cd_intervalo_w,
				cd_modalidade_vent_w,
				ds_horarios_w,
				ds_observacao_w,
				dt_prev_execucao_w,				
				ie_disp_resp_esp_w,
				ie_inicio_w,
				ie_modo_adm_w,
				ie_respiracao_w,
				ie_tipo_onda_w,
				ie_unidade_medida_w,
				nr_seq_gas_w,
				qt_acima_peep_w,
				qt_be_w,
				qt_bic_w,
				qt_fluxo_insp_w,
				qt_freq_vent_w,
				qt_gasoterapia_w,
				qt_min_intervalo_w,
				qt_pco2_w,
				qt_peep_w,
				qt_ph_w,
				qt_pip_w,
				qt_ps_w,
				qt_referencia_w,
				qt_sato2_w,
				qt_sensib_resp_w,
				qt_tempo_insp_w,
				qt_ti_te_w,
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				nr_ocorrencia_w,
				obter_cd_paciente_prescricao(nr_prescricao_p),
				cd_perfil_p,
				2314,
				nr_seq_transcricao_p,
				ie_item_alta_p,
				ie_prescritor_aux_p,
				cd_medico_p,
				ie_retrogrado_p,
				nr_seq_pepo_p,
				nr_cirurgia_p,
				nr_cirurgia_patologia_p,
				nr_seq_agenda_p,
				nr_seq_conclusao_apae_p,
				ie_futuro_p,
				nr_seq_cpoe_order_unit_p);
				
	CALL CPOE_REP_Gerar_mat_assoc_gas( nr_prescricao_p, nr_atendimento_p, nr_seq_gasoterapia_w, nr_seq_item_gerado_p);
	
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_inserir_gasoterapia_ant ( nr_atendimento_p prescr_medica.nr_atendimento%type, nr_atendimento_ant_p prescr_medica.nr_atendimento%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p prescr_gasoterapia.nr_sequencia%type, nm_usuario_p prescr_medica.nm_usuario%type, cd_perfil_p bigint, cd_estabelecimento_p bigint, nr_seq_item_gerado_p INOUT bigint, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, nr_seq_conclusao_apae_p bigint default null, ie_futuro_p text default 'N', nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) FROM PUBLIC;
