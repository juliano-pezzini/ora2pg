-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_dia_ciclo_inte (dt_novo_ciclo_p timestamp, nr_seq_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_interromper_p text default null) AS $body$
DECLARE


nr_seq_atendimento_w	bigint;
nr_prescricao_w		bigint;
nr_seq_quimio_w		bigint;
ie_gerar_pend_quimio_w		varchar(1);

C05 CURSOR FOR
	SELECT	*
	from	paciente_atend_soluc
	where	nr_seq_atendimento = nr_seq_atendimento_p;

c05_w c05%rowtype;



BEGIN

ie_gerar_pend_quimio_w := obter_param_usuario(865, 255, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_pend_quimio_w);

if (dt_novo_ciclo_p IS NOT NULL AND dt_novo_ciclo_p::text <> '') and (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then


	if (ie_interromper_p	= 'S') then
		CALL INTERROMPER_TRATAMENTO(nr_seq_atendimento_p,nm_usuario_p);

	end if;


	select	coalesce(max(nr_prescricao),0)
	into STRICT	nr_prescricao_w
	from	paciente_Atendimento
	where	nr_seq_atendimento	 = nr_seq_atendimento_p;

	if (nr_prescricao_w > 0) then
		CALL suspender_prescricao(nr_prescricao_w, null, null, nm_usuario_p, 'N');
	end if;

	select	max(nr_sequencia)
	into STRICT	nr_seq_quimio_w
	from	agenda_quimio
	where	nr_seq_atendimento = nr_seq_atendimento_p;

	if (nr_seq_quimio_w > 0) then
		CALL Qt_Alterar_Status_Agenda(nr_seq_quimio_w,
					'S',
					nm_usuario_p,
					'N',
					null,
					null,
					cd_estabelecimento_p,
					'');
	end if;

	select	nextval('paciente_atendimento_seq')
	into STRICT	nr_seq_atendimento_w
	;

	insert into paciente_atendimento(
				nr_seq_atendimento,
				nr_seq_paciente,
				nr_ciclo,
				ds_dia_ciclo,
				dt_prevista,
				dt_real,
				dt_atualizacao,
				nm_usuario,
				qt_peso,
				nr_seq_protocolo,
				ie_exige_liberacao,
				nr_atendimento,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				qt_superf_corporal,
				qt_altura,
				nr_seq_pend_agenda,
				dt_liberacao_atend,
				nm_usuario_lib_atend)
	SELECT				nr_seq_atendimento_w,
				nr_seq_paciente,
				nr_ciclo,
				ds_dia_ciclo,
				dt_novo_ciclo_p,
				dt_novo_ciclo_p,
				clock_timestamp(),
				nm_usuario_p,
				qt_peso,
				nr_seq_protocolo,
				ie_exige_liberacao,
				null,
				clock_timestamp(),
				nm_usuario_p,
				qt_superf_corporal,
				qt_altura,
				nr_seq_pend_agenda,
				dt_liberacao_atend,
				nm_usuario_lib_atend
	from paciente_atendimento
	where nr_seq_atendimento = nr_seq_atendimento_p;


	open C05;
loop
fetch C05 into
	c05_w;
EXIT WHEN NOT FOUND; /* apply on C05 */
	begin
	insert into paciente_atend_soluc(
		nr_seq_atendimento,
		nr_seq_solucao,
		nr_agrupamento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo_dosagem,
		qt_dosagem,
		qt_solucao_total,
		qt_tempo_aplicacao,
		nr_etapas,
		ie_bomba_infusao,
		ie_esquema_alternado,
		ie_calc_aut,
		ie_acm,
		qt_hora_fase,
		ds_solucao,
		ds_orientacao,
		ie_se_necessario,
		ie_solucao_pca,
		ie_tipo_analgesia,
		ie_pca_modo_prog,
		qt_dose_inicial_pca,
		qt_vol_infusao_pca,
		qt_bolus_pca,
		qt_intervalo_bloqueio,
		qt_limite_quatro_hora,
		qt_dose_ataque,
		ie_tipo_sol,
		ie_pre_medicacao,
		pr_reducao,
		cd_intervalo,
		ie_cancelada,
		ie_local_adm)
	values (nr_seq_atendimento_w,
		c05_w.nr_seq_solucao,
		c05_w.nr_agrupamento,
		clock_timestamp(),
		c05_w.nm_usuario,
		c05_w.dt_atualizacao_nrec,
		c05_w.nm_usuario_nrec,
		c05_w.ie_tipo_dosagem,
		c05_w.qt_dosagem,
		c05_w.qt_solucao_total,
		c05_w.qt_tempo_aplicacao,
		c05_w.nr_etapas,
		c05_w.ie_bomba_infusao,
		c05_w.ie_esquema_alternado,
		c05_w.ie_calc_aut,
		c05_w.ie_acm,
		c05_w.qt_hora_fase,
		c05_w.ds_solucao,
		c05_w.ds_orientacao,
		c05_w.ie_se_necessario,
		c05_w.ie_solucao_pca,
		c05_w.ie_tipo_analgesia,
		c05_w.ie_pca_modo_prog,
		c05_w.qt_dose_inicial_pca,
		c05_w.qt_vol_infusao_pca,
		c05_w.qt_bolus_pca,
		c05_w.qt_intervalo_bloqueio,
		c05_w.qt_limite_quatro_hora,
		c05_w.qt_dose_ataque,
		c05_w.ie_tipo_sol,
		c05_w.ie_pre_medicacao,
		c05_w.pr_reducao,
		c05_w.cd_intervalo,
		'N',
		CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(c05_w.IE_LOCAL_ADM,'H')  ELSE coalesce(c05_w.IE_LOCAL_ADM,'') END );
	end;
end loop;
close C05;

	insert into paciente_atend_medic(
		nr_seq_atendimento,
		nr_seq_material,
		cd_material,
		dt_atualizacao,
		nm_usuario,
		nr_agrupamento,
		qt_dose,
		cd_unid_med_dose,
		ds_recomendacao,
		ds_observacao,
		ie_via_aplicacao,
		qt_min_aplicacao,
		ie_bomba_infusao,
		cd_intervalo,
		qt_hora_aplicacao,
		qt_dias_util,
		nr_seq_interno,
		nr_seq_prot_medic,
		ie_cancelada,
		ie_administracao,
		ie_checado,
		ie_se_necessario,
		ie_urgencia,
		ie_aplic_bolus,
		ie_aplic_lenta,
		qt_dose_prescricao,
		cd_unid_med_prescr,
		NR_SEQ_DILUICAO,
		nr_seq_solucao,
		ie_medicacao_paciente,
                ie_pre_medicacao)
	SELECT 	nr_seq_atendimento_w,
		nr_seq_material,
		cd_material,
		dt_atualizacao,
		nm_usuario,
		nr_agrupamento,
		qt_dose,
		cd_unid_med_dose,
		ds_recomendacao,
		ds_observacao,
		ie_via_aplicacao,
		qt_min_aplicacao,
		ie_bomba_infusao,
		cd_intervalo,
		qt_hora_aplicacao,
		qt_dias_util,
		nextval('paciente_atend_medic_seq'),
		nr_seq_prot_medic,
		ie_cancelada,
		ie_administracao,
		ie_checado,
		ie_se_necessario,
		ie_urgencia,
		ie_aplic_bolus,
		ie_aplic_lenta,
		qt_dose_prescricao,
		cd_unid_med_prescr,
		NR_SEQ_DILUICAO,
		nr_seq_solucao,
		coalesce(ie_medicacao_paciente,'N'),
                ie_pre_medicacao
	from 	paciente_atend_medic
	where   nr_seq_atendimento = nr_seq_atendimento_p;

end if;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_dia_ciclo_inte (dt_novo_ciclo_p timestamp, nr_seq_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_interromper_p text default null) FROM PUBLIC;

