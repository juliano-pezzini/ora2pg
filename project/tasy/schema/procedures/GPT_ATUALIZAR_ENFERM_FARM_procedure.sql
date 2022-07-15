-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpt_atualizar_enferm_farm ( nr_prescricao_p bigint, nm_usuario_lib_p text, ie_enfer_farm_p text, nr_sequencia_p bigint default null) AS $body$
DECLARE



nr_seq_solucao_w			prescr_solucao.nr_seq_solucao%type;
cd_estabelecimento_w		prescr_medica.cd_estabelecimento%type;
hr_prim_horario_w			prescr_material.hr_prim_horario%type;
ds_horarios_ww        		prescr_material.ds_horarios%TYPE;
ds_hor_precr_proc_w      	prescr_material.ds_horarios%TYPE;
ds_horarios_w        		prescr_material.ds_horarios%type;
dt_inicio_medic_w      		prescr_material.dt_inicio_medic%type;
dt_inicio_medic_w2      	prescr_material.dt_inicio_medic%type;
qt_dia_prim_hor_w      		prescr_material.qt_dia_prim_hor%type;
hr_dose_especial_w      	prescr_material.hr_dose_especial%type;
qt_dose_especial_w      	prescr_material.qt_dose_especial%type;
ie_via_aplicacao_w      	prescr_material.ie_via_aplicacao%type;
ie_medicacao_paciente_w    	prescr_material.ie_medicacao_paciente%type;
ie_dose_espec_agora_w    	prescr_material.ie_dose_espec_agora%type;
qt_min_aplic_dose_esp_w    	prescr_material.qt_min_aplic_dose_esp%type;
nr_ocorrencia_w        		prescr_material.nr_ocorrencia%TYPE;
cd_material_w        		prescr_material.cd_material%type;
ds_horarios_medico_w    	prescr_material.ds_horarios_medico%type;
ds_dose_diferenciada_w    	prescr_material.ds_dose_diferenciada%type;
ds_horarios_enf_w      		prescr_material_compl.ds_horario_enf%type;
cd_intervalo_w        		cpoe_material.cd_intervalo%TYPE;
nr_atendimento_w      		cpoe_material.nr_atendimento%TYPE;
dt_inicio_hor_w        		cpoe_material.dt_inicio%type;
qt_min_intervalo_w      	intervalo_prescricao.qt_min_intervalo%TYPE;
dt_prim_horario_w      		cpoe_material.dt_inicio%type;
ie_controle_tempo_w      	cpoe_material.ie_controle_tempo%type;
nr_seq_proc_interno_w    	prescr_procedimento.nr_seq_proc_interno%TYPE;
dt_prev_execucao_w      	prescr_procedimento.dt_prev_execucao%type;
dt_validade_prescr_w		prescr_medica.dt_validade_prescr%type;
hr_prim_horario_ww    		prescr_material.hr_prim_horario%type;
hr_prim_ds_horarios_w		prescr_material.hr_prim_horario%type;
dt_inicio_prescr_w			prescr_medica.dt_inicio_prescr%type;
qt_hora_fase_w				cpoe_gasoterapia.qt_hora_fase%type;
ie_modo_adm_w				cpoe_gasoterapia.ie_modo_adm%type;
nr_seq_cpoe_w    			bigint;
ie_tipo_item_w    			varchar(10);
nr_sequencia_w    			bigint;
dt_inicio_w      			timestamp;
dt_inicio_item_w     		timestamp;
dt_fim_w      				timestamp;
dt_lib_parcial_w			timestamp;
dt_liberacao_w    			timestamp := clock_timestamp();
dt_liberacao_farmacia_w     timestamp := clock_timestamp();
qt_tempo_etapa_w			double precision;
ie_continuo_w				char(1);
ie_atualizar_horarios_w		char(1);
ie_acm_sn_w					char(1);
ie_prim_hor_null_w			boolean;
nr_horas_prox_geracao_w		bigint;
dt_lib_enfermagem_w			prescr_material.dt_lib_enfermagem%type;
dt_lib_farmacia_w			prescr_material.dt_lib_farmacia%type;
cd_farmac_lib_w				cpoe_material.cd_farmac_lib%type;
ie_urgencia_rec_w			prescr_recomendacao.ie_urgencia%type;
dt_liberacao_parc_farm_w	prescr_medica.dt_liberacao_parc_farm%type;
nr_prescricao_vigente_w		prescr_medica.nr_prescricao%type;

C01 CURSOR FOR
SELECT	'M' ie_tipo_item,        --Medicamento
		nr_seq_mat_cpoe,
		nr_sequencia,
		dt_lib_enfermagem,
        dt_lib_farmacia
from    prescr_material
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and     ie_agrupador = 1
and		coalesce(nr_seq_mat_cpoe,0) > 0

union all

SELECT	'SOL' ie_tipo_item,        --Solucao
		nr_seq_mat_cpoe,
		nr_sequencia,
		dt_lib_enfermagem,
        dt_lib_farmacia
from    prescr_material
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and     ie_agrupador = 4
and		coalesce(nr_seq_mat_cpoe,0) > 0

union all

select	'D' ie_tipo_item,        --Dieta Oral
		nr_seq_dieta_cpoe,
		nr_sequencia,
		null,
		null
from    prescr_dieta
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_dieta_cpoe,0) > 0

union all

select	'J' ie_tipo_item,        --Jejum
		nr_seq_dieta_cpoe,
		nr_sequencia,
		null,
		null
from    rep_jejum
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_dieta_cpoe,0) > 0

union all

select	'SNE' ie_tipo_item,        --Enteral
		nr_seq_dieta_cpoe,
		nr_sequencia,
		dt_lib_enfermagem,
        dt_lib_farmacia
from    prescr_material
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		ie_agrupador = 8
and		coalesce(nr_seq_dieta_cpoe,0) > 0

union all

select	'S' ie_tipo_item,        --Suplemento
		nr_seq_dieta_cpoe,
		nr_sequencia,
	    dt_lib_enfermagem,
        dt_lib_farmacia
from    prescr_material
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		ie_agrupador = 12
and		coalesce(nr_seq_dieta_cpoe,0) > 0

union all

select	'LD' ie_tipo_item,        --Leites e derivados
		nr_seq_dieta_cpoe,
		nr_sequencia,
		null,
		null
from    prescr_leite_deriv
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_dieta_cpoe,0) > 0

union all

select	'NPTI' ie_tipo_item,        --Parenteral Infantil
		nr_seq_npt_cpoe,
		nr_sequencia,
		null,
		null
from    nut_pac
where   nr_prescricao = nr_prescricao_p
and     ie_npt_adulta = 'P'
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_npt_cpoe,0) > 0

union all

select	'NPTA' ie_tipo_item,        --Parenteral Adulta
		nr_seq_npt_cpoe,
		nr_sequencia,
		null,
		null
from    nut_pac
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and     ie_npt_adulta = 'S'
and		coalesce(nr_seq_npt_cpoe,0) > 0

union all

select	'R' ie_tipo_item,        --Recomendacao
		nr_seq_rec_cpoe,
		nr_sequencia,
		null,
		null
from    prescr_recomendacao
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_rec_cpoe,0) > 0

union all

select	'O' ie_tipo_item,        --Gasoterapia
		nr_seq_gas_cpoe,
		nr_sequencia,
		null,
		null
from    prescr_gasoterapia
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_gas_cpoe,0) > 0

union all

select	'P' ie_tipo_item,        --Procedimento
		nr_seq_proc_cpoe,
		nr_sequencia,
		null,
		null
from    prescr_procedimento
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_solic_sangue::text, '') = ''
and		Obter_tipo_proc_interno(nr_seq_proc_interno) in ('IVC','O','G')
and		coalesce(nr_seq_proc_cpoe,0) > 0

union all

select	CASE WHEN ie_tipo_dialise='P' THEN 'DP'  ELSE 'DI' END  ie_tipo_item,  --Dialise
		nr_seq_dialise_cpoe,
		nr_sequencia,
		null,
		null
from    hd_prescricao
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_dialise_cpoe,0) > 0

union all

select  'MAT' ie_tipo_item,        --Materiais
		nr_seq_mat_cpoe,
		nr_sequencia,
	    dt_lib_enfermagem,
        dt_lib_farmacia
from    prescr_material
where	nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		ie_agrupador = 2
and		coalesce(nr_seq_mat_cpoe,0) > 0

union all

select	'HM' ie_tipo_item,        --Hemoterapia
		nr_seq_hemo_cpoe,
		nr_sequencia,
		null,
		null
from    prescr_solic_bco_sangue
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_hemo_cpoe,0) > 0

union all

select	'AP' ie_tipo_item,        -- Anatomia Patologica
		nr_seq_proc_cpoe,
		nr_sequencia,
		null,
		null
from    prescr_procedimento
where   nr_prescricao = nr_prescricao_p
and     ((nr_sequencia = nr_sequencia_p) or (coalesce(nr_sequencia_p::text, '') = ''))
and		coalesce(nr_seq_solic_sangue::text, '') = ''
and		Obter_tipo_proc_interno(nr_seq_proc_interno) in ('AP','APC','APH')
and		coalesce(nr_seq_proc_cpoe,0) > 0

union all

select	'IA' ie_tipo_item,		-- Item associado ao procedimento
		nr_seq_mat_cpoe,
		nr_sequencia,
		dt_lib_enfermagem,
		dt_lib_farmacia
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and (nr_sequencia = nr_sequencia_p or coalesce(nr_sequencia_p::text, '') = '')
and		ie_agrupador = 5
and		coalesce(nr_seq_mat_cpoe,0) > 0;



BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	select  max(dt_liberacao),
			max(dt_liberacao_farmacia),
			max(nr_atendimento),
			max(cd_estabelecimento),
			max(dt_inicio_prescr),
			max(dt_validade_prescr),
			max(dt_liberacao_parc_farm)
	into STRICT	dt_liberacao_w,
			dt_liberacao_farmacia_w,
			nr_atendimento_w,
			cd_estabelecimento_w,
			dt_inicio_prescr_w,
			dt_validade_prescr_w,
			dt_liberacao_parc_farm_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	if (upper(ie_enfer_farm_p) = 'ENFERMAGEM')  then

		--Atualizar enfermagem
		open C01;
		loop
		fetch C01 into
		  ie_tipo_item_w,
		  nr_seq_cpoe_w,
		  nr_sequencia_w,
		  dt_lib_enfermagem_w,
		  dt_lib_farmacia_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			nr_prescricao_vigente_w := gpt_obter_prescricao_vigente(nr_sequencia_p => nr_seq_cpoe_w, ie_tipo_item_p => ie_tipo_item_w);

			if (nr_prescricao_p = nr_prescricao_vigente_w) then

				if (ie_tipo_item_w in ('M', 'SOL')) then

						select  coalesce(max(ie_controle_tempo),'N')
						into STRICT  ie_controle_tempo_w
						from  cpoe_material
						where  nr_sequencia = nr_seq_cpoe_w;

						/*Caso modificar lembrar de atualizar na rotina de Farmacia*/

						if (ie_controle_tempo_w = 'N') then --Medicamento
							update	cpoe_material
							set   	nm_usuario_lib_enf    = coalesce(nm_usuario_lib_p, nm_usuario_lib_enf),
									dt_liberacao_enf    = coalesce(coalesce(dt_lib_enfermagem_w,dt_liberacao_w), dt_liberacao_enf)									
							where	nr_sequencia = nr_seq_cpoe_w
							and		coalesce(dt_liberacao_enf::text, '') = '';
						else
								update	cpoe_material
								set   	nm_usuario_lib_enf	= coalesce(nm_usuario_lib_p, nm_usuario_lib_enf),
										dt_liberacao_enf    = coalesce(coalesce(dt_lib_enfermagem_w,dt_liberacao_w), dt_liberacao_enf)										
								where   nr_sequencia       	= nr_seq_cpoe_w
								and		coalesce(dt_liberacao_enf::text, '') = '';

						end if;

				elsif (ie_tipo_item_w in ('D','J','S','LD','NPTI','NPTA')) then

					update 	cpoe_dieta
					set 	nm_usuario_lib_enf	= nm_usuario_lib_p,
							dt_liberacao_enf 	= dt_liberacao_w
					where   nr_sequencia     	= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_enf::text, '') = '';

				elsif (ie_tipo_item_w = 'SNE') then

					select	max(CASE WHEN obter_se_acm_sn(ie_acm, ie_se_necessario)='N' THEN  ds_horarios  ELSE null END ),
							max(hr_prim_horario)
					into STRICT	ds_horarios_w,
							hr_prim_horario_w
					from	prescr_material
					where	nr_prescricao = nr_prescricao_p
					and		nr_sequencia = nr_sequencia_w;

					select	max(dt_inicio)
					into STRICT  	dt_inicio_medic_w
					from  	cpoe_dieta
					where	nr_sequencia = nr_seq_cpoe_w;

					if (position('A' in padroniza_horario_prescr(obter_prim_dsHorarios(ds_horarios_w), to_Char(dt_inicio_medic_w,'dd/mm/yyyy hh24:mi'))) > 0) then
						dt_inicio_medic_w := dt_inicio_medic_w + 1;
					end if;

					update	cpoe_dieta
					set		nm_usuario_lib_enf  = coalesce(nm_usuario_lib_p, nm_usuario_lib_enf),
							dt_liberacao_enf  = coalesce(dt_liberacao_w, dt_liberacao_enf),
							dt_inicio      = coalesce(dt_inicio_medic_w, dt_inicio),
							ds_horarios      = coalesce(ds_horarios_w,ds_horarios),
							hr_prim_horario    = coalesce(hr_prim_horario_w,hr_prim_horario)
					where	nr_sequencia     = nr_seq_cpoe_w
					and		coalesce(dt_liberacao_enf::text, '') = '';
				
				elsif (ie_tipo_item_w = 'R') then

					update  cpoe_recomendacao
					set		nm_usuario_lib_enf  = nm_usuario_lib_p,
							dt_liberacao_enf  = dt_liberacao_w
					where   nr_sequencia     = nr_seq_cpoe_w
					and		coalesce(dt_liberacao_enf::text, '') = '';

				elsif (ie_tipo_item_w = 'O') then

					update	cpoe_gasoterapia
					set		nm_usuario_lib_enf	= nm_usuario_lib_p,
							dt_liberacao_enf  	= dt_liberacao_w
					where   nr_sequencia     	= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_enf::text, '') = '';

				elsif (ie_tipo_item_w = 'P') then

					select  max(a.dt_inicio_prescr),
							max(b.cd_intervalo),
							max(a.nr_atendimento),
							max(b.nr_seq_proc_interno),
							max(b.dt_prev_execucao),
							max(b.ds_horarios)
					into STRICT	dt_inicio_w,
							cd_intervalo_w,
							nr_atendimento_w,
							nr_seq_proc_interno_w,
							dt_prev_execucao_w,
							ds_hor_precr_proc_w
					from	prescr_procedimento b,
							prescr_medica a
					where	a.nr_prescricao  = nr_prescricao_p
					and		a.nr_prescricao  = b.nr_prescricao
					and		b.nr_sequencia   = nr_sequencia_w;
					
					hr_prim_horario_w := obter_prim_dshorarios(ds_hor_precr_proc_w);

					select	max(qt_min_intervalo)
					into STRICT	qt_min_intervalo_w
					from	intervalo_prescricao
					where	cd_intervalo = cd_intervalo_w;

					nr_ocorrencia_w := 0;
					if (obter_se_eh_cig(nr_seq_proc_interno_w) = 'S') then
						nr_ocorrencia_w := 1;
					end if;
					
					cpoe_calcular_horario_prescr(  nr_atendimento_w, cd_intervalo_w, null, dt_prev_execucao_w,
							  0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w,
							  ds_horarios_ww, nm_usuario_lib_p, wheb_usuario_pck.get_cd_estabelecimento, obter_perfil_ativo,
							  null, null, null, null,
							  nr_seq_proc_interno_w, ceil((dt_fim_w - dt_prev_execucao_w)*24) );

					ds_horarios_w := ds_horarios_w||ds_horarios_ww;

					update  cpoe_procedimento
					set		nm_usuario_lib_enf	= nm_usuario_lib_p,
							dt_liberacao_enf	= dt_liberacao_w,
							dt_prev_execucao	= coalesce(dt_prev_execucao_w,dt_prev_execucao),
							dt_inicio			= coalesce(dt_prev_execucao_w, dt_inicio),
							hr_prim_horario		= coalesce(hr_prim_horario_w, hr_prim_horario),
							ds_horarios			= CASE WHEN ds_hor_precr_proc_w=ds_horarios THEN  ds_horarios  ELSE ds_horarios_w END
					where   nr_sequencia		= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_enf::text, '') = '';

				elsif (ie_tipo_item_w in ('DI', 'DP')) then

					update	cpoe_dialise
					set		nm_usuario_lib_enf	= nm_usuario_lib_p,
							dt_liberacao_enf	= dt_liberacao_w
					where   nr_sequencia		= nr_seq_cpoe_w
					and    	coalesce(dt_liberacao_enf::text, '') = '';

				elsif (ie_tipo_item_w = 'MAT') then

					update	cpoe_material
					set   	nm_usuario_lib_enf    = coalesce(nm_usuario_lib_p, nm_usuario_lib_enf),
							dt_liberacao_enf    = coalesce(coalesce(dt_lib_enfermagem_w,dt_liberacao_w), dt_liberacao_enf)
					where	nr_sequencia = nr_seq_cpoe_w
					and		coalesce(dt_liberacao_enf::text, '') = '';
					
				elsif (ie_tipo_item_w = 'HM') then

					update  cpoe_hemoterapia
					set		nm_usuario_lib_enf  = nm_usuario_lib_p,
							dt_liberacao_enf  = dt_liberacao_w
					where   nr_sequencia     = nr_seq_cpoe_w
					and		coalesce(dt_liberacao_enf::text, '') = '';
				elsif (ie_tipo_item_w = 'AP') then

					update	cpoe_anatomia_patologica
					set   	nm_usuario_lib_enf    = coalesce(nm_usuario_lib_p, nm_usuario_lib_enf),
							dt_liberacao_enf    = coalesce(dt_liberacao_w, dt_liberacao_enf)
					where	nr_sequencia = nr_seq_cpoe_w
					and		coalesce(dt_liberacao_enf::text, '') = '';

				elsif (ie_tipo_item_w = 'IA') then

					update	cpoe_material
					set		nm_usuario_lib_enf = coalesce(nm_usuario_lib_p, nm_usuario_lib_enf),
							dt_liberacao_enf = coalesce(dt_lib_enfermagem_w, dt_liberacao_w, dt_liberacao_enf)
					where	nr_sequencia = nr_seq_cpoe_w
					and		coalesce(dt_liberacao_enf::text, '') = '';

				end if;
			end if;
			end;
		end loop;
		close C01;
	elsif (upper(ie_enfer_farm_p) = 'FARM') then

		--Atualizar Farmacia
		open C01;
		loop
		fetch C01 into
			  ie_tipo_item_w,
			  nr_seq_cpoe_w,
			  nr_sequencia_w,
			  dt_lib_enfermagem_w,
			  dt_lib_farmacia_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			cd_farmac_lib_w := obter_pf_usuario(nm_usuario_lib_p,'C');
			nr_prescricao_vigente_w := gpt_obter_prescricao_vigente(nr_sequencia_p => nr_seq_cpoe_w, ie_tipo_item_p => ie_tipo_item_w);

			if (nr_prescricao_p = nr_prescricao_vigente_w) then
				if (ie_tipo_item_w in ('M', 'SOL')) then
					if ((dt_lib_farmacia_w IS NOT NULL AND dt_lib_farmacia_w::text <> '') or (dt_liberacao_farmacia_w IS NOT NULL AND dt_liberacao_farmacia_w::text <> '')) then
						update	cpoe_material
						set	cd_farmac_lib = cd_farmac_lib_w,
							nm_usuario_lib_farm = coalesce(nm_usuario_lib_p, nm_usuario_lib_farm),
							dt_liberacao_farm = coalesce(coalesce(dt_liberacao_farmacia_w, dt_lib_farmacia_w), dt_liberacao_farm)
						where	nr_sequencia = nr_seq_cpoe_w
						and	coalesce(dt_liberacao_farm::text, '') = '';
					end if;
					
				elsif (ie_tipo_item_w in ('D','J','S','LD','NPTI','NPTA')) then

					update  cpoe_dieta
					set		cd_farmac_lib    	= cd_farmac_lib_w,
							nm_usuario_lib_farm = nm_usuario_lib_p,
							dt_liberacao_farm	= dt_liberacao_farmacia_w
					where	nr_sequencia     	= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_farm::text, '') = '';

				elsif (ie_tipo_item_w = 'SNE') then

					select	max(CASE WHEN obter_se_acm_sn(ie_acm, ie_se_necessario)='N' THEN  ds_horarios  ELSE null END ),
							max(hr_prim_horario)
					into STRICT	ds_horarios_w,
							hr_prim_horario_w
					from	prescr_material
					where	nr_prescricao = nr_prescricao_p
					and		nr_sequencia = nr_sequencia_w;

					select	max(dt_inicio)
					into STRICT  	dt_inicio_medic_w
					from  	cpoe_dieta
					where	nr_sequencia = nr_seq_cpoe_w;

					if (position('A' in padroniza_horario_prescr(obter_prim_dsHorarios(ds_horarios_w), to_Char(dt_inicio_medic_w,'dd/mm/yyyy hh24:mi'))) > 0) then
						dt_inicio_medic_w := dt_inicio_medic_w + 1;
					end if;

					update  cpoe_dieta						
					set		cd_farmac_lib       = coalesce(cd_farmac_lib_w, cd_farmac_lib),
							nm_usuario_lib_farm  = nm_usuario_lib_p,	
							dt_liberacao_farm	= dt_liberacao_farmacia_w,
							dt_inicio			= coalesce(dt_inicio_medic_w, dt_inicio),
							ds_horarios			= coalesce(ds_horarios_w, ds_horarios),
							hr_prim_horario		= coalesce(hr_prim_horario_w, hr_prim_horario)
					where	nr_sequencia		= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_farm::text, '') = '';
					
				elsif (ie_tipo_item_w = 'R') then

					select	max(dt_inicio)
					into STRICT	dt_inicio_w
					from	cpoe_recomendacao
					where	nr_sequencia = nr_seq_cpoe_w;

					select	max(dt_inicio_prescr)
					into STRICT	dt_inicio_prescr_w
					from	prescr_medica
					where	nr_prescricao = nr_prescricao_p;

					select	max(hr_prim_horario),
							max(ds_horarios),
							coalesce(max(ie_urgencia),'N')
					into STRICT	hr_prim_horario_w,
							ds_horarios_w,
							ie_urgencia_rec_w
					from	prescr_recomendacao
					where	nr_prescricao = nr_prescricao_p
					and		nr_seq_rec_cpoe = nr_seq_cpoe_w;

					if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
						dt_inicio_item_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_w,hr_prim_horario_w);
						if (((dt_inicio_item_w > dt_inicio_prescr_w) and (dt_inicio_item_w > clock_timestamp()))
								or (ie_urgencia_rec_w = 'S')) then
							dt_inicio_w := dt_inicio_item_w;
						else
							dt_inicio_w := dt_inicio_item_w + 1;
						end if;
					end if;

					update	cpoe_recomendacao
					set		cd_farmac_lib = coalesce(cd_farmac_lib_w, cd_farmac_lib),
							nm_usuario_lib_farm = nm_usuario_lib_p,
							dt_liberacao_farm = dt_liberacao_farmacia_w,
							hr_prim_horario = coalesce(hr_prim_horario_w, hr_prim_horario),
							dt_inicio = coalesce(dt_inicio_w, dt_inicio),
							ds_horarios = coalesce(ds_horarios_w, ds_horarios)
					where	nr_sequencia = nr_seq_cpoe_w
					and		coalesce(dt_liberacao_farm::text, '') = '';

				elsif (ie_tipo_item_w = 'O') then
				
					select	max(qt_hora_fase),
						max(cd_intervalo),
						max(ie_modo_adm)
					into STRICT	qt_hora_fase_w,
						cd_intervalo_w,
						ie_modo_adm_w
					from	cpoe_gasoterapia
					where	nr_sequencia = nr_seq_cpoe_w;
				
					select	max(dt_prev_execucao),
						max(ds_horarios),
						CASE WHEN coalesce(max(a.nr_seq_inconsistencia)::text, '') = '' THEN  max(b.dt_liberacao_parc_farm)  ELSE null END
					into STRICT	dt_inicio_item_w,
						ds_horarios_w,
						dt_lib_parcial_w
					from	prescr_gasoterapia a,
						prescr_medica b
					where	a.nr_prescricao = nr_prescricao_p
					and	a.nr_seq_gas_cpoe = nr_seq_cpoe_w
					and	a.nr_prescricao = b.nr_prescricao;
					
					hr_prim_horario_w := obter_prim_dshorarios(ds_horarios_w);
					
					if (ie_modo_adm_w = 'C') then
						ie_continuo_w	:= 'S';
					else
						ie_continuo_w	:= 'N';
					end if;
					
					nr_ocorrencia_w		:= null;
					qt_tempo_etapa_w	:= null;
					if (qt_hora_fase_w IS NOT NULL AND qt_hora_fase_w::text <> '') then
						qt_tempo_etapa_w	:= dividir(obter_minutos_hora(qt_hora_fase_w),60);
					end if;
					
					SELECT * FROM CPOE_Calcula_horarios_etapas(	nm_usuario_lib_p, dt_inicio_item_w, ie_continuo_w, nr_ocorrencia_w, cd_intervalo_w, 24, qt_tempo_etapa_w, null, 'N') INTO STRICT nr_ocorrencia_w, ds_horarios_w;

					if ((dt_lib_parcial_w IS NOT NULL AND dt_lib_parcial_w::text <> '') or (dt_liberacao_farmacia_w IS NOT NULL AND dt_liberacao_farmacia_w::text <> '')) then
						update	cpoe_gasoterapia
						set		cd_farmac_lib       = coalesce(cd_farmac_lib_w, cd_farmac_lib),
								nm_usuario_lib_farm	= nm_usuario_lib_p,
								dt_liberacao_farm  	= coalesce(dt_lib_parcial_w, dt_liberacao_farmacia_w),
								dt_inicio			= coalesce(dt_inicio_item_w,dt_inicio),
								hr_prim_horario     = coalesce(hr_prim_horario_w,hr_prim_horario),
								ds_horarios         = coalesce(ds_horarios_w,ds_horarios)
						where   nr_sequencia     	= nr_seq_cpoe_w
						and		coalesce(dt_liberacao_farm::text, '') = '';
					end if;
					
				elsif (ie_tipo_item_w = 'P') then

					select  max(a.dt_inicio_prescr),
							max(b.cd_intervalo),
							max(a.nr_atendimento),
							max(b.nr_seq_proc_interno),
							max(b.dt_prev_execucao),
							max(b.ds_horarios)
					into STRICT	dt_inicio_w,
							cd_intervalo_w,
							nr_atendimento_w,
							nr_seq_proc_interno_w,
							dt_prev_execucao_w,
							ds_hor_precr_proc_w
					from	prescr_procedimento b,
							prescr_medica a
					where	a.nr_prescricao   = nr_prescricao_p
					and		a.nr_prescricao   = b.nr_prescricao
					and		b.nr_sequencia = nr_sequencia_w;
					
					hr_prim_horario_w := obter_prim_dshorarios(ds_hor_precr_proc_w);

					select	max(qt_min_intervalo)
					into STRICT	qt_min_intervalo_w
					from	intervalo_prescricao
					where	cd_intervalo = cd_intervalo_w;

					nr_ocorrencia_w := 0;
					if (obter_se_eh_cig(nr_seq_proc_interno_w) = 'S') then
						nr_ocorrencia_w := 1;
					end if;
					
					cpoe_calcular_horario_prescr(	nr_atendimento_w, cd_intervalo_w, null, dt_prev_execucao_w,
													0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w,
													ds_horarios_ww, nm_usuario_lib_p, wheb_usuario_pck.get_cd_estabelecimento, obter_perfil_ativo,
													null, null, null, null,
													nr_seq_proc_interno_w, ceil((dt_fim_w - dt_prev_execucao_w)*24) );
					ds_horarios_w := ds_horarios_w||ds_horarios_ww;

					update	cpoe_procedimento
					set		cd_farmac_lib    	= cd_farmac_lib_w,
							nm_usuario_lib_farm	= nm_usuario_lib_p,
							dt_liberacao_farm	= coalesce(dt_liberacao_parc_farm_w, dt_liberacao_farmacia_w),
							dt_prev_execucao	= coalesce(dt_prev_execucao_w, dt_prev_execucao),
							dt_inicio			= coalesce(dt_prev_execucao_w, dt_inicio),
							hr_prim_horario		= coalesce(hr_prim_horario_w, hr_prim_horario),
							ds_horarios			= CASE WHEN ds_hor_precr_proc_w=ds_horarios THEN  ds_horarios  ELSE ds_horarios_w END
					where	nr_sequencia		= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_farm::text, '') = '';

					commit;
				
				elsif (ie_tipo_item_w in ('DI', 'DP')) then

					update  cpoe_dialise
					set		cd_farmac_lib 		= cd_farmac_lib_w,
							nm_usuario_lib_farm = nm_usuario_lib_p,
							dt_liberacao_farm 	= dt_liberacao_farmacia_w
					where	nr_sequencia 		= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_farm::text, '') = '';
					
				elsif (ie_tipo_item_w = 'MAT') then
			
					update	cpoe_material
					set   	cd_farmac_lib      	= coalesce(cd_farmac_lib_w, cd_farmac_lib),
							nm_usuario_lib_farm = coalesce(nm_usuario_lib_p, nm_usuario_lib_farm),
							dt_liberacao_farm  	= coalesce(coalesce(dt_lib_farmacia_w,dt_liberacao_farmacia_w), dt_liberacao_farm)
					where	nr_sequencia 		= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_farm::text, '') = '';
					
				elsif (ie_tipo_item_w = 'HM') then

					update  cpoe_hemoterapia
					set   	nm_usuario_lib_farm = coalesce(nm_usuario_lib_p, nm_usuario_lib_farm),
							dt_liberacao_farm  	= coalesce(dt_liberacao_farmacia_w, dt_liberacao_farm)
					where   nr_sequencia     	= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_farm::text, '') = '';
					
				elsif (ie_tipo_item_w = 'AP') then

					update  cpoe_anatomia_patologica
					set   	dt_liberacao_farm  	= coalesce(dt_liberacao_farmacia_w, dt_liberacao_farm)
					where   nr_sequencia     	= nr_seq_cpoe_w
					and		coalesce(dt_liberacao_farm::text, '') = '';

				elsif (ie_tipo_item_w = 'IA') then

					update	cpoe_material
					set		cd_farmac_lib = cd_farmac_lib_w,
							nm_usuario_lib_farm = coalesce(nm_usuario_lib_p, nm_usuario_lib_farm),
							dt_liberacao_farm = coalesce(dt_lib_farmacia_w, dt_liberacao_farmacia_w, dt_liberacao_farm)
					where	nr_sequencia = nr_seq_cpoe_w
					and		coalesce(dt_liberacao_farm::text, '') = '';

				end if;
			end if;
			end;
		end loop;
		close C01;
	end if;
	
	nr_horas_prox_geracao_w	:= get_qt_hours_after_copy_cpoe(obter_perfil_ativo, nm_usuario_lib_p, cd_estabelecimento_w);
	
	CALL cpoe_gerar_data_copia_item( nr_prescricao_p, nr_horas_prox_geracao_w, dt_inicio_prescr_w, 'S' );
	
end if;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpt_atualizar_enferm_farm ( nr_prescricao_p bigint, nm_usuario_lib_p text, ie_enfer_farm_p text, nr_sequencia_p bigint default null) FROM PUBLIC;

