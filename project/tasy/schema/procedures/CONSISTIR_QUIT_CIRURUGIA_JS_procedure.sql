-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_quit_cirurugia_js ( ie_opcao_p bigint, cd_material_p bigint, cd_unidade_medida_p text, cd_intervalo_p bigint, ds_horarios_p text, qt_dose_p bigint, qt_Unitaria_p bigint, nr_seq_lote_fornec_p bigint, ie_consistido_agenda_p text, cd_fornec_consignado_p text, nr_prescricao_p bigint, ie_origem_inf_p bigint, ie_medicacao_paciente_p text, ie_utiliza_kit_p text, ie_urgencia_p text, ie_bomba_infusao_p text, ie_suspenso_p text, ie_se_necessario_p text, ie_status_cirurgia_p text, hr_prim_horario_p text, cd_motivo_baixa_p bigint, nr_ocorrencia_p bigint, qt_material_p bigint, qt_total_dispensar_p bigint, nr_agrupamento_p bigint, nr_seq_lote_p bigint, nr_seq_item_prescr_p bigint, ie_restringe_item_prescr_p text, ie_atualiza_saldo_lote_p text, ds_materiais_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w				bigint;
sql_qtde_material_w			varchar(4000) := '';
sql_w					varchar(4000) := '';
ds_parametros_w				varchar(4000) := '';
ds_sep_w				varchar(255) := '';
nr_seq_lote_fornec_w			bigint;


BEGIN

ds_sep_w	:= substr(obter_separador_bv,1,255);
if (nr_seq_lote_fornec_p <> 0) then
	nr_seq_lote_fornec_w := nr_seq_lote_fornec_p;
end if;

if (coalesce(ie_opcao_p, -1) = 1) then

	delete	FROM prescr_material
	where	nr_prescricao = nr_prescricao_p;

elsif (coalesce(ie_opcao_p, -1) = 2) then

	select	coalesce(max(nr_sequencia), 0) + 1
	into STRICT	nr_sequencia_w
	from	prescr_material
	where	nr_prescricao	= nr_prescricao_p;

	--insert da prescricao_material_q(atepac_qm)
	insert into prescr_material(
		nr_prescricao,				nr_sequencia,		ie_origem_inf,
		cd_material,				cd_unidade_medida,	qt_dose,
		qt_unitaria,				qt_material,		dt_atualizacao,
		nm_usuario,				cd_intervalo,		ds_horarios,
		ds_observacao,				ie_via_aplicacao,		nr_agrupamento,
		cd_motivo_baixa,				dt_baixa,			ie_utiliza_kit,
		cd_unidade_medida_dose,			qt_conversao_dose, 	ie_urgencia,
		nr_ocorrencia, 				qt_total_dispensar, 		cd_fornec_consignado,
		nr_sequencia_solucao,			nr_sequencia_proc,		qt_solucao,
		hr_dose_especial,				qt_dose_especial,		ds_dose_diferenciada,
		ie_medicacao_paciente,			nr_sequencia_diluicao, 	hr_prim_horario,
		nr_dia_util,				nr_sequencia_dieta,	ie_agrupador,
		dt_emissao_setor_atend,			ie_suspenso,		ds_justificativa,
		qt_dias_solicitado,				qt_dias_liberado,		nm_usuario_liberacao,
		dt_liberacao,				ie_se_necessario,		qt_min_aplicacao,
		nr_seq_lote_fornec,				ie_status_cirurgia,		ie_bomba_infusao,
		cd_kit_material,				nr_doc_interno,		ie_consistido_agenda)
	values (	nr_prescricao_p,				nr_sequencia_w,		ie_origem_inf_p,
		cd_material_p,				cd_unidade_medida_p,	qt_dose_p,
		qt_unitaria_p,				qt_material_p,		clock_timestamp(),
		nm_usuario_p,				cd_intervalo_p,		ds_horarios_p,
		null,					null,			nr_agrupamento_p,
		cd_motivo_baixa_p,				null,			ie_utiliza_kit_p,
		null,					null,			ie_urgencia_p,
		nr_ocorrencia_p,				qt_total_dispensar_p,	cd_fornec_consignado_p,
		null,					null,			null,
		null,					null,			null,
		ie_medicacao_paciente_p,			null,			hr_prim_horario_p,
		null	,				null,			null,
		null,					ie_suspenso_p,		null,
		null,					null,			null,
		null,					ie_se_necessario_p,	null,
		nr_seq_lote_fornec_w,			ie_status_cirurgia_p,	ie_bomba_infusao_p,
		null,					null,			ie_consistido_agenda_p);

elsif (coalesce(ie_opcao_p, -1) = 3) then

	if (coalesce(nr_seq_lote_p, 0) <> 0) then
		if (coalesce(ie_restringe_item_prescr_p, 'N') = 'S') then
			update	prescr_material
			set	ie_status_cirurgia	= 'CB',
				nr_seq_lote_fornec	= nr_seq_lote_p,
				NM_USUARIO_CONSIST	= nm_usuario_p,
				DT_ATUALIZACAO_CONSIST	= clock_timestamp(),
				ie_consistido_agenda	= ie_consistido_agenda_p
			where	cd_material   		= cd_material_p
			and	nr_sequencia		= nr_seq_item_prescr_p
			and	nr_prescricao		= nr_prescricao_p;
		else
			update	prescr_material
			set	ie_status_cirurgia	= 'CB',
				nr_seq_lote_fornec	= nr_seq_lote_p,
				NM_USUARIO_CONSIST	= nm_usuario_p,
				DT_ATUALIZACAO_CONSIST	= clock_timestamp(),
				ie_consistido_agenda	= ie_consistido_agenda_p
			where	cd_material   		= cd_material_p
			and	nr_prescricao		= nr_prescricao_p;
		end if;
	else

		if (coalesce(ie_restringe_item_prescr_p, 'N') = 'S') then
			update	prescr_material
			set	ie_status_cirurgia	= 'CB',
				NM_USUARIO_CONSIST	= nm_usuario_p,
				DT_ATUALIZACAO_CONSIST	= clock_timestamp(),
				ie_consistido_agenda	= ie_consistido_agenda_p
			where	cd_material   		= cd_material_p
			and	nr_sequencia		= nr_seq_item_prescr_p
			and	nr_prescricao		= nr_prescricao_p;
		else
			update	prescr_material
			set	ie_status_cirurgia	= 'CB',
				NM_USUARIO_CONSIST	= nm_usuario_p,
				DT_ATUALIZACAO_CONSIST	= clock_timestamp(),
				ie_consistido_agenda	= ie_consistido_agenda_p
			where	cd_material   		= cd_material_p
			and	nr_prescricao		= nr_prescricao_p;
		end if;

	end if;

elsif (coalesce(ie_opcao_p, -1) = 4) then

	if (ie_atualiza_saldo_lote_p = 'S') then

		sql_qtde_material_w	:=	'     qt_material      		= :qt_material, ' ||
						'     qt_Total_Dispensar	= :qt_material, ' ||
						'     qt_dose			= :qt_material, ';
	end if;

	if (coalesce(nr_seq_lote_p, 0) <> 0) then
		if (coalesce(ie_restringe_item_prescr_p, 'N') = 'S') then

			sql_w	:=	' update	prescr_material '						||
					' set		ie_status_cirurgia 		= ''CB'','			||
					'		nr_seq_lote_fornec 		= :nr_seq_lote_fornec,'	||
					'		nm_usuario_consist 	= :nm_usuario,'		||
					sql_qtde_material_w						||
					'		dt_atualizacao_consist	= sysdate, '		||
					'		ie_consistido_agenda	= :ie_consistido_agenda'	||
					' where		cd_material		= :cd_material'		||
					' and		nr_sequencia		= :nr_seq_item_prescr'	||
					' and		nr_prescricao		= :nr_prescricao';
		else

			sql_w	:=	' update	prescr_material '						||
					' set		ie_status_cirurgia 		= ''CB'','			||
					'		nr_seq_lote_fornec 		= :nr_seq_lote_fornec,'	||
					'		nm_usuario_consist 		= :nm_usuario,'	||
					sql_qtde_material_w						||
					'		dt_atualizacao_consist		= sysdate, '	||
					'		ie_consistido_agenda		= :ie_consistido_agenda'||
					' where		cd_material			= :cd_material'	||
					' and		nr_prescricao			= :nr_prescricao';

		end if;

		ds_parametros_w		:=	'NR_SEQ_LOTE_FORNEC='	|| nr_seq_lote_fornec_w		|| ds_sep_w ||
						'NM_USUARIO='		|| nm_usuario_p			|| ds_sep_w ||
						'IE_CONSISTIDO_AGENDA='	|| ie_consistido_agenda_p		|| ds_sep_w ||
						'NR_SEQ_ITEM_PRESCR='	|| nr_seq_item_prescr_p		|| ds_sep_w ||
						'NR_PRESCRICA='		|| nr_prescricao_p			|| ds_sep_w ||
						'QT_MATERIAL='		|| qt_material_p;

		CALL exec_sql_dinamico_bv(	'CONSISTIR_QUIT_CIRURUGIA',
					sql_w,
					ds_parametros_w);

	else
		if (coalesce(ie_restringe_item_prescr_p, 'N') = 'S') then

			sql_w	:=	' update	prescr_material 		' 				||
					' set		ie_status_cirurgia		= ''CB'','			||
					'     		qt_material        		= :qt_material,'		||
					'     		qt_total_dispensar 		= :qt_material,'		||
					'     		qt_dose            		= :qt_material,'		||
					'     		nm_usuario_consist 		= :nm_usuario,'	||
					sql_qtde_material_w						||
					'     		dt_atualizacao_consist 		= sysdate,'	||
					'     		ie_consistido_agenda 		= :ie_consistido_agenda'||
					' where		cd_material   			= :cd_material'	||
					' and		nr_sequencia			= :nr_seq_item_prescr'	||
					' and		nr_prescricao			= :nr_prescricao';
		else
			sql_w	:=	' update	prescr_material 		' 				||
					' set		ie_status_cirurgia		= ''CB'','			||
					'     		qt_material        		= :qt_material,'		||
					'     		qt_total_dispensar 		= :qt_material,'		||
					'     		qt_dose            		= :qt_material,'		||
					'     		nm_usuario_consist 		= :nm_usuario,'	||
					sql_qtde_material_w						||
					'     		dt_atualizacao_consist	 	= sysdate,'	||
					'     		ie_consistido_agenda 		= :ie_consistido_agenda'||
					' where		cd_material   			= :cd_material'	||
					' and		nr_prescricao			= :nr_prescricao';
		end if;

		ds_parametros_w		:=	'NR_SEQ_LOTE_FORNEC='	|| nr_seq_lote_fornec_w		|| ds_sep_w ||
						'NM_USUARIO='		|| nm_usuario_p			|| ds_sep_w ||
						'IE_CONSISTIDO_AGENDA='	|| ie_consistido_agenda_p		|| ds_sep_w ||
						'NR_SEQ_ITEM_PRESCR='	|| nr_seq_item_prescr_p		|| ds_sep_w ||
						'NR_PRESCRICA='		|| nr_prescricao_p			|| ds_sep_w ||
						'QT_MATERIAL='		|| qt_material_p;

		CALL exec_sql_dinamico_bv(	'CONSISTIR_QUIT_CIRURUGIA',
					sql_w,
					ds_parametros_w);

	end if;

elsif (coalesce(ie_opcao_p, -1) = 5) then

	delete	FROM prescr_material
	where	nr_prescricao	= nr_prescricao_p
	and	substr(obter_se_contido(cd_material, ds_materiais_p),1,1) = 'N';


end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_quit_cirurugia_js ( ie_opcao_p bigint, cd_material_p bigint, cd_unidade_medida_p text, cd_intervalo_p bigint, ds_horarios_p text, qt_dose_p bigint, qt_Unitaria_p bigint, nr_seq_lote_fornec_p bigint, ie_consistido_agenda_p text, cd_fornec_consignado_p text, nr_prescricao_p bigint, ie_origem_inf_p bigint, ie_medicacao_paciente_p text, ie_utiliza_kit_p text, ie_urgencia_p text, ie_bomba_infusao_p text, ie_suspenso_p text, ie_se_necessario_p text, ie_status_cirurgia_p text, hr_prim_horario_p text, cd_motivo_baixa_p bigint, nr_ocorrencia_p bigint, qt_material_p bigint, qt_total_dispensar_p bigint, nr_agrupamento_p bigint, nr_seq_lote_p bigint, nr_seq_item_prescr_p bigint, ie_restringe_item_prescr_p text, ie_atualiza_saldo_lote_p text, ds_materiais_p text, nm_usuario_p text) FROM PUBLIC;

