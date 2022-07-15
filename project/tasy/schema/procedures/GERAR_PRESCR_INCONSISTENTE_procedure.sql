-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_inconsistente ( nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_prescricao_w    		timestamp;
nr_prescricao_w    		bigint;
nr_seq_acum_w			bigint;
nr_seq_dieta_w			bigint;
nr_seq_Proc_w			bigint;
nr_seq_Solucao_w		bigint;
nr_agrup_acum_w			bigint;
nr_seq_nut_pac_w		bigint;
nr_seq_nut_pac_ww		bigint;

nr_nut_pac_w			bigint;
nut_pac_elem_w			bigint;
nr_seq_pac_elem_w		bigint;
nr_seq_pac_elem_mat_w		bigint;
cont_w				bigint;
nr_sequencia_w			bigint;
nr_seq_bco_w			bigint;
ie_aux_w			varchar(1);
nm_tabela_w			varchar(255);

c01 CURSOR FOR
SELECT	nr_seq_solucao,
	'PRESCR_SOLUCAO'
from	prescr_solucao
where	nr_prescricao	= nr_prescricao_p
and	ie_suspenso	<> 'S'
and	ie_erro		= 125

union all

select	nr_sequencia,
	'PRESCR_MATERIAL'
From	Material b,
	Prescr_Material a
where	b.cd_material	= a.cd_material
and	a.nr_prescricao = nr_prescricao_p
and	a.ie_suspenso 	<> 'S'
and	a.ie_agrupador = 4
and	(a.nr_sequencia_solucao IS NOT NULL AND a.nr_sequencia_solucao::text <> '')
and	exists (select	1
		from	prescr_solucao x
		where	x.nr_prescricao	= a.nr_prescricao
		and	x.nr_seq_solucao = a.nr_sequencia_solucao
		and	x.ie_erro	= 125)
and	a.ie_origem_inf	<> 'K'

union all

select	nr_sequencia,
	'PRESCR_PROCEDIMENTO'
From	Prescr_Procedimento a
where	nr_prescricao	= nr_prescricao_p
and	ie_suspenso	<> 'S'
and	ie_origem_inf	<> 'L'
and	coalesce(nr_seq_origem::text, '') = ''
and	ie_erro		= 125

union all

select	nr_sequencia,
	'PRESCR_MATERIAL'
From	Material b,
	Prescr_Material a
where	b.cd_material	= a.cd_material
and	a.nr_prescricao = nr_prescricao_p
and	a.ie_suspenso 	<> 'S'
and	a.ie_agrupador = 5
and	(a.nr_sequencia_proc IS NOT NULL AND a.nr_sequencia_proc::text <> '')
and	exists (select	1
		from	prescr_procedimento x
		where	x.nr_prescricao	= a.nr_prescricao
		and	x.nr_sequencia	= a.nr_sequencia_proc
		and	x.ie_erro	= 125)
and	a.ie_origem_inf	<> 'K'

union all

select	nr_sequencia,
	'PRESCR_MATERIAL'
From	Material b,
	Prescr_Material a
where	b.cd_material	= a.cd_material
and	a.nr_prescricao = nr_prescricao_p
and	a.ie_suspenso 	<> 'S'
and	a.ie_agrupador not in (10,11)
and	a.ie_erro	= 125
and	a.ie_origem_inf	<> 'K'

union all

select	nr_sequencia,
	'PRESCR_MATERIAL'
From	Material b,
	Prescr_Material a
where	b.cd_material	= a.cd_material
and	a.nr_prescricao = nr_prescricao_p
and	a.ie_suspenso 	<> 'S'
and	a.ie_agrupador in (3,7,9)
and	(a.nr_sequencia_diluicao IS NOT NULL AND a.nr_sequencia_diluicao::text <> '')
and	exists (select	1
		from	prescr_material x
		where	x.nr_prescricao	= a.nr_prescricao
		and	x.nr_sequencia	= a.nr_sequencia_diluicao
		and	x.ie_erro	= 125)
and	a.ie_origem_inf	<> 'K';


BEGIN

select	count(*)
into STRICT	cont_w
from	Prescr_Solucao
where	nr_prescricao	= nr_prescricao_p
and	ie_erro		= 125
and	ie_suspenso	<> 'S';

if (coalesce(cont_w,0) = 0) then

	select	count(*)
	into STRICT	cont_w
	from	Prescr_Procedimento a
	where	nr_prescricao	= nr_prescricao_p
	and	ie_suspenso	<> 'S'
	and	a.ie_erro	= 125
	and	ie_origem_inf	<> 'L'
	and	coalesce(nr_seq_origem::text, '') = '';

	if (coalesce(cont_w,0) = 0) then
		select	count(*)
		into STRICT	cont_w
		From	Material b,
			Prescr_Material a
		where	a.nr_prescricao = nr_prescricao_p
		and	a.ie_suspenso 	<> 'S'
		and	b.ie_situacao	= 'A'
		and	a.ie_origem_inf	<> 'K'
		and	a.ie_agrupador not in (10,11)
		and	a.ie_erro	= 125
		and	a.cd_material 	= b.cd_material;
	end if;

end if;

if (coalesce(cont_w,0) > 0) then

	select nextval('prescr_medica_seq')
	into STRICT  nr_prescricao_w
	;

	insert into prescr_medica(
	 	nr_prescricao,
	 	cd_pessoa_fisica,
		nr_atendimento,
		cd_medico,
		dt_prescricao,
		dt_atualizacao,
		nm_usuario,
		nm_usuario_original,
		ds_observacao,
		nr_horas_validade,
		cd_motivo_baixa,
		dt_baixa,
		dt_primeiro_horario,
		dt_liberacao,
		dt_emissao_setor,
		dt_emissao_farmacia,
		cd_setor_atendimento,
		dt_entrada_unidade,
		ie_recem_nato,
		ie_origem_inf,
		nr_prescricao_anterior,
		nr_prescricao_mae,
		cd_protocolo,
		nr_seq_protocolo,
		nr_cirurgia,
		nr_seq_agenda,
		cd_estabelecimento,
		ds_medicacao_uso,
		cd_prescritor,
		qt_altura_cm,
		qt_peso,
		ie_adep,
		ie_prescr_emergencia,
		ie_prescricao_alta,
		ie_hemodialise)
	SELECT	nr_prescricao_w,
		cd_pessoa_fisica,
		CASE WHEN nr_atendimento=0 THEN null  ELSE nr_atendimento END ,
		cd_medico,
		dt_prescricao,
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		ds_observacao,
		nr_horas_validade,
		cd_motivo_baixa,
		dt_baixa,
		dt_primeiro_horario,
		null,
		dt_emissao_setor,
		dt_emissao_farmacia,
		cd_setor_atendimento,
		dt_entrada_unidade,
		ie_recem_nato,
		ie_origem_inf,
		nr_prescricao_p,
		nr_prescricao_mae,
		cd_protocolo,
		nr_seq_protocolo,
		nr_cirurgia,
		nr_seq_agenda,
		cd_estabelecimento,
		ds_medicacao_uso,
		cd_prescritor,
		qt_altura_cm,
		qt_peso,
		ie_adep,
		ie_prescr_emergencia,
		ie_prescricao_alta,
		ie_hemodialise
	from	prescr_medica
	where	nr_prescricao = NR_PRESCRICAO_P;

	select	max(dt_prescricao)
	into STRICT	dt_prescricao_w
	from	prescr_medica
	where	nr_prescricao = NR_PRESCRICAO_P;

	-- Solucoes
	Insert into Prescr_Solucao(
		nr_prescricao      ,
		nr_seq_solucao     ,
		ie_via_aplicacao   ,
		cd_intervalo       ,
		dt_atualizacao     ,
		nm_usuario         ,
		cd_unidade_medida  ,
		ie_tipo_dosagem    ,
		qt_dosagem         ,
		qt_solucao_total   ,
		qt_tempo_aplicacao ,
		ds_solucao	 ,
		qt_volume	 ,
		nr_etapas	 ,
		ds_horarios	 ,
		ie_bomba_infusao ,
		ie_suspenso	 ,
	     	nr_agrupamento	 ,
		ie_esquema_alternado,
		ie_calc_aut,
		ie_acm,
		hr_prim_horario,
		qt_hora_fase,
		ie_urgencia,
		ds_orientacao,
		ie_hemodialise,
		ie_tipo_solucao,
		ie_pos_dialisador,
		nr_seq_protocolo,
		ie_unid_vel_inf,
		qt_temp_solucao,
		ie_apap,
		qt_dose_ataque,
		ie_erro,
		ds_cor_erro)
	SELECT	nr_prescricao_w	 ,
		nr_seq_solucao,
		ie_via_aplicacao   ,
		cd_intervalo       ,
		dt_prescricao_w    ,
		nm_usuario_p       ,
		cd_unidade_medida  ,
		ie_tipo_dosagem    ,
		qt_dosagem         ,
		qt_solucao_total   ,
		qt_tempo_aplicacao ,
		ds_solucao ,
		qt_volume,
		nr_etapas ,
		ds_horarios		 ,
		ie_bomba_infusao	 ,
		'N',
		nr_agrupamento,
		ie_esquema_alternado,
		coalesce(ie_calc_aut,'N'),
		coalesce(IE_ACM,'N'),
		hr_prim_horario,
		qt_hora_fase,
		ie_urgencia,
		ds_orientacao,
		ie_hemodialise,
		ie_tipo_solucao,
		ie_pos_dialisador,
		nr_seq_protocolo,
		ie_unid_vel_inf,
		qt_temp_solucao,
		ie_apap,
		qt_dose_ataque,
		ie_erro,
		ds_cor_erro
	from	prescr_solucao
	where	nr_prescricao	= nr_prescricao_p
	and	ie_suspenso	<> 'S'
	and	ie_erro		= 125;

	/*Inserir componentes da solução.*/

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
		qt_solucao,
		hr_dose_especial,
		qt_dose_especial,
		ds_dose_diferenciada,
		ie_medicacao_paciente,
		hr_prim_horario,
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
		dt_inicio_medic,
		qt_dia_prim_hor,
		ie_regra_disp,
		qt_vol_adic_reconst,
		qt_hora_intervalo,
		qt_min_intervalo,
		nr_seq_atendimento,
		nr_seq_material,
		nr_sequencia_solucao,
		ie_erro,
		ds_cor_erro)
	SELECT  nr_prescricao_w,
	      	a.nr_sequencia,
	 	a.ie_origem_inf,
		a.cd_material,
	 	a.cd_unidade_medida,
	 	a.qt_dose,
	 	a.qt_unitaria,
	 	a.qt_material,
		clock_timestamp(),
		nm_usuario_p,
	 	a.cd_intervalo,
	 	a.ds_horarios,
		a.ds_observacao,
		a.ds_observacao_enf,
	 	a.ie_via_aplicacao,
		a.nr_agrupamento,
		coalesce(a.ie_cobra_paciente,'S'),
		a.cd_motivo_baixa,
		a.dt_baixa,
		a.ie_utiliza_kit,
		a.cd_unidade_medida_dose,
		a.qt_conversao_dose,
		ie_urgencia,
		a.nr_ocorrencia,
		a.qt_total_dispensar,
		a.cd_fornec_consignado,
		a.qt_solucao,
		hr_dose_especial,
		qt_dose_especial,
		a.ds_dose_diferenciada,
		a.ie_medicacao_paciente,
		hr_prim_horario,
		a.ie_agrupador,
		a.nr_dia_util,
		ie_suspenso,
		a.ie_se_necessario,
		a.qt_min_aplicacao,
		a.ie_bomba_infusao,
		coalesce(a.IE_APLIC_BOLUS,'N'),
		coalesce(a.IE_APLIC_LENTA,'N'),
		coalesce(a.ie_acm,'N'),
		a.ie_objetivo,
		a.cd_topografia_cih,
		a.ie_origem_infeccao,
		a.cd_amostra_cih,
		a.cd_microorganismo_cih,
		coalesce(a.ie_uso_antimicrobiano,'N'),
		a.cd_protocolo,
		a.nr_seq_protocolo,
		a.nr_seq_mat_protocolo,
		a.qt_hora_aplicacao,
		a.ie_recons_diluente_fixo,
		a.qt_vel_infusao,
		a.ds_justificativa,
		a.ie_sem_aprazamento,
		a.ie_indicacao,
		a.dt_proxima_dose,
		a.qt_total_dias_lib,
		a.nr_seq_substituto,
		a.ie_lado,
		a.dt_inicio_medic,
		a.qt_dia_prim_hor,
		ie_regra_disp,
		a.qt_vol_adic_reconst,
		a.qt_hora_intervalo,
		a.qt_min_intervalo,
		nr_seq_atendimento,
		nr_seq_material,
		nr_sequencia_solucao,
		ie_erro,
		ds_cor_erro
	From	Material b,
		Prescr_Material a
	where	b.cd_material	= a.cd_material
	and	a.nr_prescricao = nr_prescricao_p
	and	a.ie_suspenso 	<> 'S'
	and	a.ie_agrupador = 4
	and	(a.nr_sequencia_solucao IS NOT NULL AND a.nr_sequencia_solucao::text <> '')
	and	exists (SELECT	1
			from	prescr_solucao x
			where	x.nr_prescricao	= a.nr_prescricao
			and	x.nr_seq_solucao = a.nr_sequencia_solucao
			and	x.ie_erro	= 125)
	and	a.ie_origem_inf	<> 'K';


	insert into prescr_solucao_esquema(
		nr_sequencia,
		nr_prescricao,
		nr_seq_solucao,
		dt_atualizacao,
		nm_usuario,
		qt_volume,
		qt_dosagem,
		ds_horario)
	SELECT	nextval('prescr_solucao_esquema_seq'),
		nr_prescricao_w,
		b.nr_seq_solucao,
		clock_timestamp(),
		nm_usuario_p,
		b.qt_volume,
		b.qt_dosagem,
		b.ds_horario
	from	prescr_solucao_esquema b,
		prescr_solucao a
	where	a.nr_prescricao = nr_prescricao_p
	and	a.nr_prescricao	= b.nr_prescricao
	and	a.nr_seq_solucao = b.nr_seq_solucao
	and	a.ie_suspenso	<> 'S'
	and	a.ie_erro	= 125;

	-- Procedimentos
	/*select	nvl(max(nr_sequencia),0)
	into	nr_seq_proc_w
	from	prescr_Procedimento
	where	nr_prescricao = nr_prescricao_w;*/
	Insert  into Prescr_Procedimento(
		nr_prescricao	,
		nr_sequencia      ,
		nr_agrupamento    ,
		ie_executar_leito ,
		ie_amostra	  ,
		cd_procedimento   ,
		qt_procedimento   ,
		dt_atualizacao    ,
		nm_usuario        ,
		ds_horarios       ,
		ds_observacao     ,
		ds_observacao_enf ,
		cd_motivo_baixa   ,
		dt_baixa          ,
		cd_procedimento_aih,
		ie_origem_proced  ,
		cd_intervalo      ,
		ie_urgencia       ,
		cd_setor_atendimento,
		dt_emissao_setor_atend,
		ds_dado_clinico	,
		dt_prev_execucao,
		ie_suspenso,
		cd_material_exame,
		nr_seq_exame,
		ds_material_especial,
		ie_status_atend,
		ie_origem_inf,
		ie_se_necessario,
		ie_acm,
		nr_ocorrencia,
		nr_seq_interno,
		nr_seq_proc_interno,
		qt_peca_ap,
		ds_qualidade_peca_ap,
		ds_diag_provavel_ap,
		ds_exame_anterior_ap,
		nr_seq_derivado,
		nr_seq_exame_sangue,
		nr_seq_solic_sangue,
		cd_unid_med_sangue,
		cd_pessoa_coleta,
		dt_coleta,
		ie_avisar_result,
		qt_vol_hemocomp,
		nr_seq_prot_glic,
		ie_respiracao,
		cd_mod_vent,
		ie_disp_resp_esp,
		qt_fluxo_oxigenio,
		ds_rotina,
		qt_hora_intervalo,
		qt_min_intervalo,
		ie_autorizacao,
		ie_lado,
		ie_erro,
		ds_cor_erro)
	SELECT  nr_prescricao_w,
	      	nr_sequencia,
		coalesce(nr_agrupamento,1),
		ie_executar_leito,
		'N',
		cd_procedimento,
	     	qt_procedimento,
 	  	dt_prescricao_w,
	  	nm_usuario_p,
 	  	ds_horarios,
 	  	ds_observacao,
		ds_observacao_enf,
        	cd_motivo_baixa,
        	dt_baixa,
        	cd_procedimento_aih,
        	ie_origem_proced,
        	cd_intervalo,
        	ie_urgencia,
        	cd_setor_atendimento,
	  	dt_emissao_setor_atend,
	  	ds_dado_clinico,
		dt_prev_execucao,
	  	'N',
		cd_material_exame,
		nr_seq_exame,
		ds_material_especial,
		ie_status_atend,
		ie_origem_inf,
		coalesce(ie_se_necessario,'N'),
		coalesce(ie_acm,'N'),
		nr_ocorrencia,
		nextval('prescr_procedimento_seq'),
		nr_seq_proc_interno,
		qt_peca_ap,
		ds_qualidade_peca_ap,
		ds_diag_provavel_ap,
		ds_exame_anterior_ap,
		nr_seq_derivado,
		nr_seq_exame_sangue,
		null,
		cd_unid_med_sangue,
		cd_pessoa_coleta,
		null,
		'N',
		qt_vol_hemocomp,
		nr_seq_prot_glic,
		ie_respiracao,
		cd_mod_vent,
		ie_disp_resp_esp,
		qt_fluxo_oxigenio,
		ds_rotina,
		a.qt_hora_intervalo,
		a.qt_min_intervalo,
		'L',
		ie_lado,
		ie_erro,
		ds_cor_erro
	From	Prescr_Procedimento a
	where	nr_prescricao	= nr_prescricao_p
	and	ie_suspenso	<> 'S'
	and	ie_origem_inf	<> 'L'
	and	coalesce(nr_seq_origem::text, '') = ''
	and	ie_erro		= 125;

	/*inserir itens associados ao procedimento*/

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
		qt_solucao,
		hr_dose_especial,
		qt_dose_especial,
		ds_dose_diferenciada,
		ie_medicacao_paciente,
		hr_prim_horario,
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
		dt_inicio_medic,
		qt_dia_prim_hor,
		ie_regra_disp,
		qt_vol_adic_reconst,
		qt_hora_intervalo,
		qt_min_intervalo,
		nr_seq_atendimento,
		nr_seq_material,
		nr_sequencia_proc,
		ie_erro,
		ds_cor_erro)
	SELECT  nr_prescricao_w,
	      	a.nr_sequencia,
	 	a.ie_origem_inf,
		a.cd_material,
	 	a.cd_unidade_medida,
	 	a.qt_dose,
	 	a.qt_unitaria,
	 	a.qt_material,
		clock_timestamp(),
		nm_usuario_p,
	 	a.cd_intervalo,
	 	a.ds_horarios,
		a.ds_observacao,
		a.ds_observacao_enf,
	 	a.ie_via_aplicacao,
		a.nr_agrupamento,
		coalesce(a.ie_cobra_paciente,'S'),
		a.cd_motivo_baixa,
		a.dt_baixa,
		a.ie_utiliza_kit,
		a.cd_unidade_medida_dose,
		a.qt_conversao_dose,
		ie_urgencia,
		a.nr_ocorrencia,
		a.qt_total_dispensar,
		a.cd_fornec_consignado,
		a.qt_solucao,
		hr_dose_especial,
		qt_dose_especial,
		a.ds_dose_diferenciada,
		a.ie_medicacao_paciente,
		hr_prim_horario,
		a.ie_agrupador,
		a.nr_dia_util,
		ie_suspenso,
		a.ie_se_necessario,
		a.qt_min_aplicacao,
		a.ie_bomba_infusao,
		coalesce(a.IE_APLIC_BOLUS,'N'),
		coalesce(a.IE_APLIC_LENTA,'N'),
		coalesce(a.ie_acm,'N'),
		a.ie_objetivo,
		a.cd_topografia_cih,
		a.ie_origem_infeccao,
		a.cd_amostra_cih,
		a.cd_microorganismo_cih,
		coalesce(a.ie_uso_antimicrobiano,'N'),
		a.cd_protocolo,
		a.nr_seq_protocolo,
		a.nr_seq_mat_protocolo,
		a.qt_hora_aplicacao,
		a.ie_recons_diluente_fixo,
		a.qt_vel_infusao,
		a.ds_justificativa,
		a.ie_sem_aprazamento,
		a.ie_indicacao,
		a.dt_proxima_dose,
		a.qt_total_dias_lib,
		a.nr_seq_substituto,
		a.ie_lado,
		a.dt_inicio_medic,
		a.qt_dia_prim_hor,
		ie_regra_disp,
		a.qt_vol_adic_reconst,
		a.qt_hora_intervalo,
		a.qt_min_intervalo,
		nr_seq_atendimento,
		nr_seq_material,
		nr_sequencia_proc,
		ie_erro,
		ds_cor_erro
	From	Material b,
		Prescr_Material a
	where	b.cd_material	= a.cd_material
	and	a.nr_prescricao = nr_prescricao_p
	and	a.ie_suspenso 	<> 'S'
	and	a.ie_agrupador = 5
	and	(a.nr_sequencia_proc IS NOT NULL AND a.nr_sequencia_proc::text <> '')
	and	exists (SELECT	1
			from	prescr_procedimento x
			where	x.nr_prescricao	= a.nr_prescricao
			and	x.nr_sequencia	= a.nr_sequencia_proc
			and	x.ie_erro	= 125)
	and	a.ie_origem_inf	<> 'K';

	-- Materiais e Medicamentos
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
		qt_solucao,
		hr_dose_especial,
		qt_dose_especial,
		ds_dose_diferenciada,
		ie_medicacao_paciente,
		hr_prim_horario,
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
		dt_inicio_medic,
		qt_dia_prim_hor,
		ie_regra_disp,
		qt_vol_adic_reconst,
		qt_hora_intervalo,
		qt_min_intervalo,
		nr_seq_atendimento,
		nr_seq_material,
		ie_erro,
		ds_cor_erro)
	SELECT  nr_prescricao_w,
	      	a.nr_sequencia,
	 	a.ie_origem_inf,
		a.cd_material,
	 	a.cd_unidade_medida,
	 	a.qt_dose,
	 	a.qt_unitaria,
	 	a.qt_material,
		clock_timestamp(),
		nm_usuario_p,
	 	a.cd_intervalo,
	 	a.ds_horarios,
		a.ds_observacao,
		a.ds_observacao_enf,
	 	a.ie_via_aplicacao,
		a.nr_agrupamento,
		coalesce(a.ie_cobra_paciente,'S'),
		a.cd_motivo_baixa,
		a.dt_baixa,
		a.ie_utiliza_kit,
		a.cd_unidade_medida_dose,
		a.qt_conversao_dose,
		ie_urgencia,
		a.nr_ocorrencia,
		a.qt_total_dispensar,
		a.cd_fornec_consignado,
		a.qt_solucao,
		hr_dose_especial,
		qt_dose_especial,
		a.ds_dose_diferenciada,
		a.ie_medicacao_paciente,
		hr_prim_horario,
		a.ie_agrupador,
		a.nr_dia_util,
		ie_suspenso,
		a.ie_se_necessario,
		a.qt_min_aplicacao,
		a.ie_bomba_infusao,
		coalesce(a.IE_APLIC_BOLUS,'N'),
		coalesce(a.IE_APLIC_LENTA,'N'),
		coalesce(a.ie_acm,'N'),
		a.ie_objetivo,
		a.cd_topografia_cih,
		a.ie_origem_infeccao,
		a.cd_amostra_cih,
		a.cd_microorganismo_cih,
		coalesce(a.ie_uso_antimicrobiano,'N'),
		a.cd_protocolo,
		a.nr_seq_protocolo,
		a.nr_seq_mat_protocolo,
		a.qt_hora_aplicacao,
		a.ie_recons_diluente_fixo,
		a.qt_vel_infusao,
		a.ds_justificativa,
		a.ie_sem_aprazamento,
		a.ie_indicacao,
		a.dt_proxima_dose,
		a.qt_total_dias_lib,
		a.nr_seq_substituto,
		a.ie_lado,
		a.dt_inicio_medic,
		a.qt_dia_prim_hor,
		ie_regra_disp,
		a.qt_vol_adic_reconst,
		a.qt_hora_intervalo,
		a.qt_min_intervalo,
		nr_seq_atendimento,
		nr_seq_material,
		ie_erro,
		ds_cor_erro
	From	Material b,
		Prescr_Material a
	where	b.cd_material	= a.cd_material
	and	a.nr_prescricao = nr_prescricao_p
	and	a.ie_suspenso 	<> 'S'
	and	a.ie_agrupador not in (10,11)
	and	a.ie_erro	= 125
	and	a.ie_origem_inf	<> 'K';

	/*inserir diluentes e reconstituentes*/

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
		qt_solucao,
		hr_dose_especial,
		qt_dose_especial,
		ds_dose_diferenciada,
		ie_medicacao_paciente,
		hr_prim_horario,
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
		dt_inicio_medic,
		qt_dia_prim_hor,
		ie_regra_disp,
		qt_vol_adic_reconst,
		qt_hora_intervalo,
		qt_min_intervalo,
		nr_seq_atendimento,
		nr_seq_material,
		nr_sequencia_diluicao,
		ie_erro,
		ds_cor_erro)
	SELECT  nr_prescricao_w,
	      	a.nr_sequencia,
	 	a.ie_origem_inf,
		a.cd_material,
	 	a.cd_unidade_medida,
	 	a.qt_dose,
	 	a.qt_unitaria,
	 	a.qt_material,
		clock_timestamp(),
		nm_usuario_p,
	 	a.cd_intervalo,
	 	a.ds_horarios,
		a.ds_observacao,
		a.ds_observacao_enf,
	 	a.ie_via_aplicacao,
		a.nr_agrupamento,
		coalesce(a.ie_cobra_paciente,'S'),
		a.cd_motivo_baixa,
		a.dt_baixa,
		a.ie_utiliza_kit,
		a.cd_unidade_medida_dose,
		a.qt_conversao_dose,
		ie_urgencia,
		a.nr_ocorrencia,
		a.qt_total_dispensar,
		a.cd_fornec_consignado,
		a.qt_solucao,
		hr_dose_especial,
		qt_dose_especial,
		a.ds_dose_diferenciada,
		a.ie_medicacao_paciente,
		hr_prim_horario,
		a.ie_agrupador,
		a.nr_dia_util,
		ie_suspenso,
		a.ie_se_necessario,
		a.qt_min_aplicacao,
		a.ie_bomba_infusao,
		coalesce(a.IE_APLIC_BOLUS,'N'),
		coalesce(a.IE_APLIC_LENTA,'N'),
		coalesce(a.ie_acm,'N'),
		a.ie_objetivo,
		a.cd_topografia_cih,
		a.ie_origem_infeccao,
		a.cd_amostra_cih,
		a.cd_microorganismo_cih,
		coalesce(a.ie_uso_antimicrobiano,'N'),
		a.cd_protocolo,
		a.nr_seq_protocolo,
		a.nr_seq_mat_protocolo,
		a.qt_hora_aplicacao,
		a.ie_recons_diluente_fixo,
		a.qt_vel_infusao,
		a.ds_justificativa,
		a.ie_sem_aprazamento,
		a.ie_indicacao,
		a.dt_proxima_dose,
		a.qt_total_dias_lib,
		a.nr_seq_substituto,
		a.ie_lado,
		a.dt_inicio_medic,
		a.qt_dia_prim_hor,
		ie_regra_disp,
		a.qt_vol_adic_reconst,
		a.qt_hora_intervalo,
		a.qt_min_intervalo,
		nr_seq_atendimento,
		nr_seq_material,
		nr_sequencia_diluicao,
		ie_erro,
		ds_cor_erro
	From	Material b,
		Prescr_Material a
	where	b.cd_material	= a.cd_material
	and	a.nr_prescricao = nr_prescricao_p
	and	a.ie_suspenso 	<> 'S'
	and	a.ie_agrupador in (3,7,9)
	and	(a.nr_sequencia_diluicao IS NOT NULL AND a.nr_sequencia_diluicao::text <> '')
	and	exists (SELECT	1
			from	prescr_material x
			where	x.nr_prescricao	= a.nr_prescricao
			and	x.nr_sequencia	= a.nr_sequencia_diluicao
			and	x.ie_erro	= 125)
	and	a.ie_origem_inf	<> 'K';

	commit;

	open c01;
	loop
	fetch c01 into
		nr_sequencia_w,
		nm_tabela_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		if (nm_tabela_w	= 'PRESCR_SOLUCAO') then
			delete from prescr_solucao
			where	nr_prescricao	= nr_prescricao_p
			and	nr_seq_solucao	= nr_sequencia_w;
		elsif (nm_tabela_w	= 'PRESCR_MATERIAL') then
			delete from prescr_material
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_sequencia_w;
		elsif (nm_tabela_w	= 'PRESCR_PROCEDIMENTO') then
			delete from prescr_procedimento
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_sequencia_w;
		end if;
		commit;
	end loop;
	close c01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_inconsistente ( nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;

