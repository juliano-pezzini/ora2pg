-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_copia_dieta (nr_prescricao_nova_p bigint, nr_seq_regra_p bigint, nm_usuario_p text, ie_modificar_p text, ds_lista_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, ie_estende_inc_p text) AS $body$
DECLARE


nr_seq_dieta_w				bigint;
nr_seq_dieta_ww				prescr_material.nr_sequencia_dieta%type;
cd_dieta_w					bigint;
qt_parametro_w				double precision;
ds_observacao_w				varchar(4000);
ie_destino_dieta_w			varchar(2);
ie_refeicao_w				varchar(3);
qt_copia_w					bigint;
ie_pos_virgula_w			smallint;
ie_pos_pt_virgula_w			smallint;
ie_pos_espaco_w				smallint;
ds_prescricao_w				varchar(255);
ds_lista_w					varchar(1000);
tam_lista_w					bigint;
cd_refeicao_w				varchar(15);
ie_suspenso_w				varchar(1);
cd_dieta_lista_w			bigint;
tam_prescricao_w			bigint;
nr_prescr_lista_w			bigint;
nr_seq_lista_w				integer;
qt_copiar_w					bigint;
cd_intervalo_w				varchar(7);
dt_inicio_prescr_w			timestamp;
dt_validade_prescr_w		timestamp;
dt_suspensao_progr_w		timestamp;
nr_prescricao_original_w	bigint;
nr_seq_anterior_w			bigint;
nr_prescr_estendido_w		bigint;
ds_horarios_w				varchar(2000);
ds_horarios2_w				varchar(2000);
dt_primeiro_horario_w		timestamp;
nr_horas_validade_w			integer;
nr_ocorrencia_w				bigint;
qt_inconsistencia_w			bigint;
nr_seq_servico_w			bigint;
nr_seq_rep_servico_w		bigint;
ds_horario_w				varchar(255);
hr_prim_horario_w			varchar(8);
dt_horario_servico_w		timestamp;
ie_servico_w				varchar(1)	:= 'N';
ie_zona_cinza_w				varchar(1);
ds_erro_w					varchar(2000);
ie_via_aplicacao_w			prescr_dieta.ie_via_aplicacao%type;
ie_gera_disp_acm_sn_w		parametros_farmacia.ie_gera_disp_acm_sn%type;
cd_material_w				prescr_material.cd_material%type;
nr_sequencia_mat_w			prescr_material.nr_sequencia%type;
ie_agrupador_w				prescr_material.ie_agrupador%type;
nr_seq_mat_w				prescr_material.nr_sequencia%type := 0;
qt_itens_w					bigint;
ie_loop_w					varchar(1);	
ds_horarios_ww			prescr_material.ds_horarios%type;
ie_urgencia_w			prescr_dieta.ie_urgencia%type;
ie_regra_geral_w		rep_regra_copia_crit.ie_regra_geral%type;
ie_manter_intervalo_w		rep_regra_copia_crit.ie_manter_intervalo%type;
ie_operacao_w			intervalo_prescricao.ie_operacao%type;
dt_prim_horario_int_w		timestamp;
dt_prescricao_w			prescr_medica.dt_prescricao%type;
dt_ultimo_horario_w		timestamp;
nr_ocorrencia_aux_w		double precision;
dt_prim_hor_aux_w		timestamp;
hr_prim_horario_aux_w	varchar(5);

c01 CURSOR FOR
SELECT	distinct nr_seq_servico,
		substr(ds_horario,1,5),
		ie_zona_cinza
from	rep_servico
where	nr_prescricao	= nr_prescr_lista_w
and		nr_seq_dieta	= nr_seq_lista_w;

c02 CURSOR FOR
SELECT	to_char(dt_horario,'hh24:mi'),
		dt_horario
from	rep_servico
where	nr_prescricao	= nr_prescricao_nova_p
and		nr_seq_dieta	= nr_seq_dieta_w
order by dt_horario;

C03 CURSOR FOR
	SELECT	a.cd_material,
			a.nr_sequencia,
			a.ie_agrupador
	From	Material b,
			Prescr_Material a
	where	a.nr_prescricao 	= nr_prescr_lista_w
	and		b.ie_situacao	= 'A'
	and		a.ie_origem_inf	<> 'K'			
	and		a.ie_agrupador not in (10,11, 15)
	and		((a.nr_sequencia	<> a.nr_sequencia_diluicao) or (coalesce(a.nr_sequencia_diluicao::text, '') = ''))
	and		a.cd_material 		= b.cd_material
	and		a.nr_sequencia_dieta	= nr_seq_dieta_w
	and		((coalesce(a.ie_suspenso,'N') <> 'S')
	and		((coalesce(a.nr_sequencia_diluicao::text, '') = '') or
			a.nr_sequencia_diluicao not in (
					SELECT	x.nr_sequencia
					from	material y,
							prescr_material x
					where	y.cd_material = x.cd_material
					and		y.ie_situacao <> 'A'
					and		x.nr_prescricao = nr_prescr_lista_w))
	and		not exists (
			select	nr_prescricao
			from	prescr_dieta b
			where	a.nr_prescricao	= b.nr_prescricao
			and		a.nr_sequencia_dieta = b.nr_sequencia
			and	coalesce(b.ie_suspenso,'N')	= 'S')
	and 	not exists (
			select	nr_prescricao
			from	prescr_solucao c
			where	a.nr_prescricao	= c.nr_prescricao
			and		a.nr_sequencia_solucao = c.nr_seq_solucao
			and	coalesce(c.ie_suspenso,'N')	= 'S')
	and 	not exists (
			select	nr_prescricao
			from	prescr_procedimento d
			where	a.nr_prescricao	= d.nr_prescricao
			and		a.nr_sequencia_proc	= d.nr_sequencia
			and	coalesce(d.ie_suspenso,'N')	= 'S')
	and 	not exists (
			select	nr_prescricao
			from	prescr_material e
			where	a.nr_prescricao	= e.nr_prescricao
			and	a.nr_sequencia_diluicao = e.nr_sequencia
			and	coalesce(e.ie_suspenso,'N')	= 'S') or (ie_modificar_p = 'S'));

c04 CURSOR FOR
	SELECT		coalesce(ie_regra_geral,'H'),
			coalesce(ie_manter_intervalo,'N')
	from		rep_regra_copia_crit
	where		nr_seq_regra = nr_seq_regra_p
	and		ie_tipo_item = 'DO'
	and		ie_copiar = 'S'
	and (coalesce(ie_agora,'S') = 'S' or coalesce(ie_urgencia_w,'N') <> 'S')
	order by	nr_seq_apres;


BEGIN

select	dt_inicio_prescr,
		dt_validade_prescr,
		dt_primeiro_horario,
		coalesce(nr_horas_validade,24),
		dt_prescricao
into STRICT	dt_inicio_prescr_w,
		dt_validade_prescr_w,
		dt_primeiro_horario_w,
		nr_horas_validade_w,
		dt_prescricao_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_nova_p  LIMIT 1;

select	max(ie_gera_disp_acm_sn)
into STRICT	ie_gera_disp_acm_sn_w
from	parametros_farmacia
where	cd_estabelecimento	= cd_estabelecimento_p;

ds_lista_w := ds_lista_p;

while (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') loop
	begin
	tam_lista_w		:= length(ds_lista_w);
	ie_pos_virgula_w	:= position(',' in ds_lista_w);
	ds_prescricao_w		:= substr(ds_lista_w,1,(ie_pos_virgula_w - 1));	
	tam_prescricao_w	:= length(ds_prescricao_w);
	ie_pos_espaco_w		:= position(' ' in ds_prescricao_w);
	nr_prescr_lista_w	:= (substr(ds_prescricao_w,1,(ie_pos_espaco_w - 1)))::numeric;
	ds_prescricao_w		:= substr(ds_prescricao_w,(ie_pos_espaco_w + 1),tam_prescricao_w);
	ie_pos_pt_virgula_w	:= position(';' in ds_prescricao_w);
	nr_seq_lista_w		:= (substr(ds_prescricao_w,1, (ie_pos_pt_virgula_w - 1)))::numeric;
	cd_refeicao_w		:= substr(ds_prescricao_w,(ie_pos_pt_virgula_w + 1), tam_prescricao_w);
	
	CALL PLT_consiste_extensao_item(dt_inicio_prescr_w, dt_validade_prescr_w, nr_prescr_lista_w, nr_seq_lista_w, 'D', nr_seq_regra_p, nm_usuario_p, cd_perfil_p, cd_estabelecimento_p);	
	
	select	count(nr_sequencia)
	into STRICT	qt_inconsistencia_w
	from	w_copia_plano
	where	nr_prescricao	= nr_prescr_lista_w
	and		nr_seq_item	= nr_seq_lista_w
	and		ie_tipo_item	= 'D'
	and		nm_usuario	= nm_usuario_p
	and		((ie_permite	= 'N') or (ie_estende_inc_p = 'N'))  LIMIT 1;
	
	select	max(cd_dieta)
	into STRICT	cd_dieta_lista_w
	from	prescr_dieta
	where	nr_prescricao 	= nr_prescr_lista_w
	and		nr_sequencia 	= nr_seq_lista_w  LIMIT 1;

	select	max(to_char(dt_primeiro_horario,'hh24:mi'))
	into STRICT	hr_prim_horario_w
	from	prescr_medica
	where	nr_prescricao = nr_prescr_lista_w;
	
	if	((qt_inconsistencia_w	= 0) or (ie_modificar_p 	= 'S')) then			
		
		select	count(*)
		into STRICT	qt_copiar_w
		from	prescr_dieta
		where	nr_prescricao	= nr_prescr_lista_w
		and	nr_sequencia 	= nr_seq_lista_w
		and	cd_dieta 	= cd_dieta_lista_w
		and	not exists (	SELECT	1
					from	prescr_dieta
					where	nr_prescricao = nr_prescricao_nova_p
					and	cd_dieta = cd_dieta_lista_w)  LIMIT 1;
		
		if	((qt_copiar_w > 0)  or (ie_modificar_p = 'S')) then
		
			select	cd_dieta,
					qt_parametro,
					ds_horarios,
					ds_observacao,
					ie_destino_dieta,
					ie_refeicao,
					coalesce(ie_suspenso,'N'),
					cd_intervalo,
					dt_suspensao_progr,
					coalesce(nr_prescricao_original,nr_prescricao),
					coalesce(nr_seq_anterior,nr_sequencia),
					coalesce(ie_urgencia,'N'),
					coalesce(hr_prim_horario, hr_prim_horario_w),
					ie_via_aplicacao
			into STRICT	cd_dieta_w,
					qt_parametro_w,
					ds_horarios_w,
					ds_observacao_w,
					ie_destino_dieta_w,
					ie_refeicao_w,
					ie_suspenso_w,
					cd_intervalo_w,
					dt_suspensao_progr_w,
					nr_prescricao_original_w,
					nr_seq_anterior_w,
					ie_urgencia_w,
					hr_prim_horario_w,
					ie_via_aplicacao_w
			from	prescr_dieta
			where	nr_prescricao = nr_prescr_lista_w
			and		nr_sequencia = nr_seq_lista_w;

			if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then

				select	max(ie_operacao)
				into STRICT	ie_operacao_w
				from 	intervalo_prescricao
				where 	cd_intervalo = cd_intervalo_w;

				open C04;
				loop
				fetch C04 into
					ie_regra_geral_w,
					ie_manter_intervalo_w;
				EXIT WHEN NOT FOUND; /* apply on C04 */
				end loop;
				close C04;

				ds_horarios_ww := ds_horarios_w;

				if (ie_regra_geral_w = 'I') and (obter_se_intervalo_agora(cd_intervalo_w) = 'N') then
						hr_prim_horario_w := null;
						ds_horarios_w := reordenar_horarios(dt_inicio_prescr_w, ds_horarios_w);

						hr_prim_horario_w := coalesce(obter_prim_dshorarios(ds_horarios_w),to_char(dt_inicio_prescr_w,'hh24:mi'));

				else
					nr_ocorrencia_w := 0;
					if (ie_operacao_w in ('F','V')) then
						hr_prim_horario_w := obter_primeiro_horario(cd_intervalo_w,nr_prescricao_nova_p,null,null);

					elsif (ie_manter_intervalo_w = 'N') then

						dt_ultimo_horario_w := plt_obter_ultimo_horario(nr_prescr_lista_w, nr_seq_lista_w, 'D', nm_usuario_p);

						if (dt_ultimo_horario_w IS NOT NULL AND dt_ultimo_horario_w::text <> '') and
							(dt_ultimo_horario_w > (clock_timestamp() - interval '1 days')) then
							nr_ocorrencia_aux_w := obter_ocorrencia_intervalo(cd_intervalo_w, coalesce(nr_horas_validade_w,24),'H')/ 24;
							dt_prim_hor_aux_w := dt_ultimo_horario_w + nr_ocorrencia_aux_w;

							if (dt_prim_hor_aux_w < dt_inicio_prescr_w) and (dt_inicio_prescr_w < (clock_timestamp() + interval '1 days')) then
								while dt_prim_hor_aux_w < dt_inicio_prescr_w loop
									dt_prim_hor_aux_w := dt_prim_hor_aux_w + nr_ocorrencia_aux_w;
								end loop;
							end if;

							hr_prim_horario_aux_w := to_char(dt_prim_hor_aux_w,'hh24:mi');

							if (hr_prim_horario_aux_w <> '  :  ') and (hr_prim_horario_aux_w IS NOT NULL AND hr_prim_horario_aux_w::text <> '') then
								hr_prim_horario_w := hr_prim_horario_aux_w;

							end if;
						end if;
					end if;

					dt_prim_horario_int_w := converte_char_data(to_char(dt_primeiro_horario_w,'dd/mm/yyyy'),hr_prim_horario_w ||':00',dt_primeiro_horario_w);

					SELECT * FROM calcular_horario_prescricao(nr_prescricao_nova_p, cd_intervalo_w, dt_prim_horario_int_w, coalesce(dt_prim_horario_int_w, dt_primeiro_horario_w), nr_horas_validade_w, null, 0, 0, nr_ocorrencia_w, ds_horarios_w, ds_horarios2_w, 'N', null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios2_w;

					ds_horarios_w := ds_horarios_w || ds_horarios2_w;

				end if;

				ds_horarios_w := eliminar_horarios_vigencia(ds_horarios_w, cd_intervalo_w, dt_inicio_prescr_w, dt_inicio_prescr_w, 0, 0, nr_prescricao_nova_p);

				if (coalesce(ds_horarios_w::text, '') = '') and (ds_horarios_ww IS NOT NULL AND ds_horarios_ww::text <> '') and (coalesce(ie_regra_geral_w,'XPTO') <> 'I') and (ie_operacao_w not in ('F','V')) then

					nr_ocorrencia_w := 0;

					SELECT * FROM calcular_horario_prescricao(nr_prescricao_nova_p, cd_intervalo_w, dt_primeiro_horario_w, dt_primeiro_horario_w, nr_horas_validade_w, cd_material_w, 0, 0, nr_ocorrencia_w, ds_horarios_w, ds_horarios2_w, 'N', null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios2_w;

					ds_horarios_w := ds_horarios_w || ds_horarios2_w;

					ds_horarios_w := eliminar_horarios_vigencia(ds_horarios_w, cd_intervalo_w, dt_inicio_prescr_w, dt_inicio_prescr_w, 0, 0, nr_prescricao_nova_p);

					if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
						hr_prim_horario_w := coalesce(obter_prim_dshorarios(ds_horarios_w),to_char(dt_inicio_prescr_w,'hh24:mi'));

					end if;
				end if;

				if (hr_prim_horario_w <> '') then
					dt_prim_horario_int_w := converte_char_data(to_char(dt_prescricao_w,'dd/mm/yyyy'),hr_prim_horario_w ||':00',null);
				end if;
			else
				ds_horarios_w := eliminar_horarios_vigencia(ds_horarios_w, null, converte_char_data(to_char(dt_inicio_prescr_w,'dd/mm/yyyy'),hr_prim_horario_w,null), dt_inicio_prescr_w, 0, 0, nr_prescricao_nova_p);

			end if;

			select	coalesce(max(nr_sequencia),0) + 1
			into STRICT	nr_seq_dieta_w
			from	prescr_dieta
			where	nr_prescricao = nr_prescricao_nova_p;
		
			Insert  into Prescr_Dieta(
				nr_prescricao,
				nr_sequencia,
				cd_dieta,
				dt_atualizacao,
				nm_usuario,
				qt_parametro,
				ds_horarios,
				ds_observacao,
				cd_motivo_baixa,
				dt_baixa,
				ie_destino_dieta,
				ie_refeicao,
				ie_suspenso,
				cd_intervalo,
				dt_suspensao_progr,
				nr_prescricao_original,
				nr_seq_anterior,
				ie_via_aplicacao,
				hr_prim_horario)
			values (nr_prescricao_nova_p,
				nr_seq_dieta_w,
				cd_dieta_w,
				clock_timestamp(),
				nm_usuario_p,
				qt_parametro_w,
				ds_horarios_w,
				ds_observacao_w,
				null,
				null,
				ie_destino_dieta_w,
				ie_refeicao_w,
				'N',
				cd_intervalo_w,
				dt_suspensao_progr_w,
				nr_prescricao_original_w,
				nr_seq_anterior_w,
				ie_via_aplicacao_w,
				hr_prim_horario_w);
			
			ds_erro_w := Consistir_prescr_dieta(nr_prescricao_nova_p, nr_seq_dieta_w, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, ds_erro_w);
						
			open C03;
			loop
			fetch C03 into
				cd_material_w,
				nr_sequencia_mat_w,
				ie_agrupador_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin

				ie_loop_w	:= 'S';
				while(ie_loop_w = 'S') loop
					select	count(*)
					into STRICT	qt_itens_w
					from	prescr_material where		nr_prescricao	= nr_prescricao_nova_p
					and	nr_sequencia	= nr_seq_mat_w LIMIT 1;


					if (qt_itens_w	= 0) then
						ie_loop_w	:= 'N';
					else
						nr_seq_mat_w	:= nr_seq_mat_w + 1;
					end if;
				end loop;

				Insert  into Prescr_Material(
					nr_prescricao,
					nr_sequencia,
					ie_origem_inf,
					cd_material,
					cd_unidade_medida,
					qt_dose,
					qt_unitaria,
					qt_material,
					dt_atualizacao,
					nm_usuario,
					cd_intervalo,
					ds_horarios,
					ds_observacao,
					ds_observacao_enf,
					ie_via_aplicacao,
					nr_agrupamento,
					ie_cobra_paciente,
					cd_motivo_baixa,
					dt_baixa,
					ie_utiliza_kit,
					cd_unidade_medida_dose,
					qt_conversao_dose,
					ie_urgencia,
					nr_ocorrencia,
					qt_total_dispensar,
					cd_fornec_consignado,
					nr_sequencia_solucao,
					nr_sequencia_proc,
					qt_solucao,
					hr_dose_especial,
					qt_dose_especial,
					ds_dose_diferenciada,
					ie_medicacao_paciente,
					nr_sequencia_diluicao,
					hr_prim_horario,
					nr_sequencia_dieta,
					ie_agrupador,
					nr_dia_util,
					ie_suspenso,
					ie_se_necessario,
					qt_min_aplicacao,
					ie_bomba_infusao,
					ie_aplic_bolus,
					ie_aplic_lenta,
					ie_acm,
					ie_objetivo,
					cd_topografia_cih,
					ie_origem_infeccao,
					cd_amostra_cih,
					cd_microorganismo_cih,
					ie_uso_antimicrobiano,
					cd_protocolo,
					nr_seq_protocolo,
					nr_seq_mat_protocolo,
					qt_hora_aplicacao,
					ie_recons_diluente_fixo,
					qt_vel_infusao,
					ds_justificativa,
					ie_sem_aprazamento,
					ie_indicacao,
					dt_proxima_dose,
					qt_total_dias_lib,
					nr_seq_substituto,
					ie_lado,
					qt_dia_prim_hor,
					ie_regra_disp,
					qt_vol_adic_reconst,
					qt_hora_intervalo,
					qt_min_intervalo,
					ie_permite_substituir,
					nr_prescricao_original,
					ie_gerar_lote)
				SELECT  nr_prescricao_nova_p,
					nr_seq_mat_w,
					a.ie_origem_inf,
					a.cd_material,
					a.cd_unidade_medida,
					a.qt_dose,
					a.qt_unitaria,
					a.qt_material,
					clock_timestamp(),
					nm_usuario_p,
					a.cd_intervalo,
					a.DS_HORARIOS,
					a.ds_observacao,
					a.ds_observacao_enf,
					a.ie_via_aplicacao,
					a.nr_agrupamento,
					coalesce(a.ie_cobra_paciente,'S'),
					CASE WHEN coalesce(a.ie_regra_disp,'X')='D' THEN  a.cd_motivo_baixa  ELSE CASE WHEN coalesce(a.ie_cobra_paciente,'S')='S' THEN  0  ELSE a.cd_motivo_baixa END  END ,
					CASE WHEN coalesce(a.ie_regra_disp,'X')='D' THEN  clock_timestamp()  ELSE CASE WHEN coalesce(a.ie_cobra_paciente,'S')='S' THEN  null  ELSE clock_timestamp() END  END ,
					a.IE_UTILIZA_KIT,
					a.CD_UNIDADE_MEDIDA_DOSE,
					a.QT_CONVERSAO_DOSE,
					'N',
					a.NR_OCORRENCIA,
					a.qt_total_dispensar,
					a.CD_FORNEC_CONSIGNADO,
					null,
					null,
					a.qt_solucao,
					null,
					null,
					a.ds_dose_diferenciada,
					a.ie_medicacao_paciente,
					null,
					CASE WHEN a.ie_se_necessario='S' THEN  null  ELSE a.HR_PRIM_HORARIO END ,
					CASE WHEN coalesce(a.NR_SEQUENCIA_DIETA::text, '') = '' THEN null  ELSE nr_seq_dieta_w END ,
					a.IE_AGRUPADOR,
					a.nr_dia_util,
					CASE WHEN b.ie_situacao='A' THEN  'N'  ELSE 'S' END ,
					a.ie_se_necessario,
					a.qt_min_aplicacao,
					a.ie_bomba_infusao,
					coalesce(a.IE_APLIC_BOLUS,'N'),
					coalesce(a.IE_APLIC_LENTA,'N'),
					a.ie_acm,
					a.IE_OBJETIVO,
					a.CD_TOPOGRAFIA_CIH,
					a.IE_ORIGEM_INFECCAO,
					a.CD_AMOSTRA_CIH,
					a.CD_MICROORGANISMO_CIH,
					coalesce(a.IE_USO_ANTIMICROBIANO,'N'),
					A.CD_PROTOCOLO,
					A.NR_SEQ_PROTOCOLO,
					A.NR_SEQ_MAT_PROTOCOLO,
					A.QT_HORA_APLICACAO,
					'N',
					A.QT_VEL_INFUSAO,
					a.ds_justificativa,
					a.ie_sem_aprazamento,
					a.ie_indicacao,
					a.dt_proxima_dose,
					a.qt_total_dias_lib,
					a.nr_seq_substituto,
					a.ie_lado,
					a.qt_dia_prim_hor,
					CASE WHEN coalesce(a.ie_regra_disp,'X')='D' THEN  a.ie_regra_disp  ELSE null END ,
					a.qt_vol_adic_reconst,
					a.qt_hora_intervalo,
					a.qt_min_intervalo,
					ie_permite_substituir,
					nr_prescricao_original_w,
					obter_se_disp_acm_sn(a.ie_acm, a.ie_se_necessario,ie_gera_disp_acm_sn_w)
				From	Material b,
					Prescr_Material a
				where	a.cd_material 	= b.cd_material
				and		a.nr_prescricao = nr_prescr_lista_w
				and		a.cd_material 	= cd_material_w
				and		a.nr_sequencia =  nr_sequencia_mat_w;

        select CASE WHEN coalesce(a.nr_sequencia_dieta::text, '') = '' THEN null  ELSE nr_seq_dieta_w END
        into STRICT  nr_seq_dieta_ww
				from	prescr_material a
				where	a.nr_prescricao = nr_prescr_lista_w
				and		a.cd_material 	= cd_material_w
				and		a.nr_sequencia =  nr_sequencia_mat_w;
				
        CALL ajustar_suplementos_dieta(nr_prescricao_nova_p, nr_seq_dieta_ww, nm_usuario_p);

				if (ie_agrupador_w = 8) then
					CALL gerar_elemento_mat_sne( nr_prescricao_nova_p, nr_seq_mat_w, 'G', nm_usuario_p);
				end if;

				end;
			end loop;
			close C03;
			
			open C01;
			loop
			fetch C01 into	
				nr_seq_servico_w,
				ds_horario_w,
				ie_zona_cinza_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin

				dt_horario_servico_w	:= converte_char_data(to_char(dt_inicio_prescr_w,'dd/mm/yyyy'),ds_horario_w||':00',null);
				
				if (dt_inicio_prescr_w	> dt_horario_servico_w) then
					dt_horario_servico_w	:= dt_horario_servico_w + 1;
				end if;
				
				select	nextval('rep_servico_seq')
				into STRICT	nr_seq_rep_servico_w
				;

				insert	into rep_servico(	nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_servico,
								ds_horario,
								nr_seq_registro,
								nr_seq_dieta,
								nr_prescricao,
								dt_horario,
								ie_zona_cinza)
					values (nr_seq_rep_servico_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_servico_w,
						ds_horario_w,
						null,
						nr_seq_dieta_w,
						nr_prescricao_nova_p,
						dt_horario_servico_w,
						ie_zona_cinza_w);
						
				ie_servico_w	:= 'S';
				
				end;
			end loop;
			close C01;
			
			if (ie_servico_w	= 'S') then
			
				ds_horarios_w 		:= '';

				--Ordenar os horarios para a geracao do DS_HORARIOS
				open C02;
				loop
				fetch C02 into	
					ds_horario_w,
					dt_horario_servico_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					if (coalesce(ds_horarios_w::text, '') = '') then
						ds_horarios_w := ds_horario_w;
					else
						ds_horarios_w := substr(ds_horarios_w||' '||ds_horario_w,1,255);
					end if;			
					end;
				end loop;
				close C02;
			
				update	prescr_dieta
				set	ds_horarios	= ds_horarios_w
				where	nr_prescricao	= nr_prescricao_nova_p
				and	nr_sequencia	= nr_seq_dieta_w;
			
			end if;

		else
			select  coalesce(max(ie_suspenso),'N')
			into STRICT	ie_suspenso_w
			from	prescr_dieta
			where	nr_prescricao	= nr_prescr_lista_w
			and		nr_sequencia = nr_seq_lista_w;
		
			select	max(nr_sequencia)
			into STRICT	nr_seq_dieta_w
			from	prescr_dieta
			where	nr_prescricao = nr_prescricao_nova_p
			and		cd_dieta = cd_dieta_lista_w;
		end if;
				
		if (ie_suspenso_w <> 'S') then
			CALL Gerar_prescr_dieta_hor_sem_lib(nr_prescricao_nova_p,nr_seq_dieta_w,cd_perfil_p,'N',cd_refeicao_w,'N',nm_usuario_p);
		end if;
	end if;		
	ds_lista_w			:= substr(ds_lista_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end;
end loop;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_copia_dieta (nr_prescricao_nova_p bigint, nr_seq_regra_p bigint, nm_usuario_p text, ie_modificar_p text, ds_lista_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, ie_estende_inc_p text) FROM PUBLIC;

