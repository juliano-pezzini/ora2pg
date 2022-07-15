-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_medic_uso ( nr_seq_plano_versao_p bigint, nr_seq_plano_versao_medic_p bigint) AS $body$
DECLARE


plano_versao_w				plano_versao%rowtype;
plano_versao_medic_w		plano_versao_medic%rowtype;
nr_seq_paciente_medic_uso_w	paciente_medic_uso.nr_sequencia%type;
ie_exibir_plano_medic_w 	varchar(1);
	
C01 CURSOR FOR
	SELECT 	nr_sequencia,
			cd_pessoa_fisica, 
			nr_atendimento, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_material, 
			ds_observacao, 
			ds_medicamento, 
			ie_classificacao, 
			ds_descricao_complementar, 
			ds_princ_ativo, 
			ds_dose_diferenciada, 
			ds_forma_desc, 
			ds_unid_med_desc, 
			ds_horario_especial, 
			cd_unidade_medida, 
			ds_forma_medicamento, 
			ds_potencia, 
			ds_motivo, 
			nr_seq_versao, 
			qt_dose_manha,
			qt_dose_almoco,
			qt_dose_noite,
			qt_dose_tarde,
			ie_tipo_medicamento, 
			ds_orientacao, 
			ie_exibir_plano_medic, 
			ds_intervalo_item, 
			dt_registro, 
			cd_profissional
	from 	plano_versao_medic
	where	nr_seq_versao = nr_seq_plano_versao_p;


BEGIN
	
	if (nr_seq_plano_versao_p IS NOT NULL AND nr_seq_plano_versao_p::text <> '') then
		select	*
		into STRICT	plano_versao_w
		from	plano_versao
		where	nr_sequencia = nr_seq_plano_versao_p;
		
		for	plano_versao_medic in C01 loop
		
			select	nextval('paciente_medic_uso_seq')
			into STRICT	nr_seq_paciente_medic_uso_w
			;
			
			ie_exibir_plano_medic_w := obter_se_exibe_plano_medic(
											plano_versao_medic.ds_descricao_complementar,
											plano_versao_medic.ie_classificacao,
											plano_versao_medic.cd_material,
											plano_versao_medic.qt_dose_manha,
											plano_versao_medic.qt_dose_almoco,
											plano_versao_medic.qt_dose_tarde,
											plano_versao_medic.qt_dose_noite,
											plano_versao_medic.cd_unidade_medida,
											plano_versao_medic.ds_observacao,
											plano_versao_medic.ds_motivo,
											plano_versao_medic.ds_horario_especial,
											plano_versao_medic.cd_pessoa_fisica,
											plano_versao_medic.ds_orientacao,
											plano_versao_medic.ds_medicamento,
											plano_versao_medic.ds_forma_medicamento,
											plano_versao_medic.ds_dose_diferenciada,
											plano_versao_medic.ds_potencia,
											plano_versao_medic.ds_forma_desc,
											plano_versao_medic.ds_unid_med_desc,
											plano_versao_medic_w.ds_princ_ativo);

			if (ie_exibir_plano_medic_w <> 'N') then
				insert into paciente_medic_uso(
					nr_sequencia,
					cd_pessoa_fisica,
					dt_registro,
					nm_usuario,
					dt_atualizacao,
					qt_dose_manha,
					qt_dose_almoco,
					qt_dose_tarde,
					qt_dose_noite,
					ds_unidade_medida_consumo,
					ds_descricao_complementar,
					ie_classificacao,
					ds_utc_atualizacao,
					cd_profissional,
					ie_horario_verao,
					ds_motivo,
					nr_seq_versao,
					ds_intervalo_item,
					cd_unidade_medida_plano,
					ds_orientacao,
					ds_unidade_medida_estoque,
					ds_utc,
					cd_material,
					ds_unidade_medida,
					cd_intervalo,
					qt_dose,
					dt_inicio,
					dt_fim,
					ds_reacao,
					ds_observacao,
					ds_medicamento,
					nr_atendimento,
					ie_intensidade,
					dt_atualizacao_nrec,
					nm_usuario_nrec,		
					nm_usuario_liberacao,
					nr_seq_nivel_seg,
					nr_seq_saep,
					dt_inativacao,
					nm_usuario_inativacao,
					ds_justificativa,
					nr_seq_reg_elemento,
					dt_ultima_dose,
					ie_nao_sabe_inicio,
					ie_nao_sabe_fim,
					ie_nao_sabe_ult_dose,
					ie_nega_medicamentos,
					ie_motivo_termino,
					ie_procedencia,
					ie_auto_medicacao,
					nr_seq_assinatura,
					dt_revisao,
					nm_usuario_revisao,
					nr_seq_assinat_inativacao,
					ie_alerta,
					cd_setor_atendimento,
					cd_setor_revisao,
					nm_usuario_termino,
					ds_just_termino,
					ie_nao_sabe_medicamentos,
					ie_nao_sabe_dose,
					ie_via_aplicacao,
					ds_horarios,
					ds_forma_desc,
					ds_unid_med_desc,
					ie_tipo_medicamento,
					ds_dose_diferenciada,
					ds_princ_ativo,
					ds_potencia,
					ds_horario_especial,
					ie_exibir_plano_medic,
					ds_forma_medicamento)
				values (
					nr_seq_paciente_medic_uso_w,
					plano_versao_medic.cd_pessoa_fisica,
					plano_versao_medic.dt_registro,
					wheb_usuario_pck.get_nm_usuario,
					clock_timestamp(),
					plano_versao_medic.qt_dose_manha,
					plano_versao_medic.qt_dose_almoco,
					plano_versao_medic.qt_dose_tarde,
					plano_versao_medic.qt_dose_noite,
					plano_versao_medic.cd_unidade_medida,
					plano_versao_medic.ds_descricao_complementar,
					plano_versao_medic.ie_classificacao,
					null,
					plano_versao_medic.cd_profissional,
					null,--ie_horario_verao,
					plano_versao_medic.ds_motivo,
					plano_versao_medic.nr_seq_versao,
					plano_versao_medic.ds_intervalo_item,
					plano_versao_medic.cd_unidade_medida,
					plano_versao_medic.ds_orientacao,
					plano_versao_medic.cd_unidade_medida,
					null,--ds_utc,
					plano_versao_medic.cd_material,
					plano_versao_medic.cd_unidade_medida,
					null,--cd_intervalo,
					null,--qt_dose,
					null,--dt_inicio,
					null,--dt_fim,
					null,--ds_reacao,
					plano_versao_medic.ds_observacao,
					plano_versao_medic.ds_medicamento,
					coalesce(plano_versao_medic.nr_atendimento, plano_versao_w.nr_atendimento),
					null,--ie_intensidade,
					clock_timestamp(),
					plano_versao_medic.nm_usuario_nrec,		
					wheb_usuario_pck.get_nm_usuario,--nm_usuario_liberacao,
					null,--nr_seq_nivel_seg,
					null,--nr_seq_saep,
					null,--dt_inativacao,
					null,--nm_usuario_inativacao,
					null,--ds_justificativa,
					null,--nr_seq_reg_elemento,
					null,--dt_ultima_dose,
					null,--ie_nao_sabe_inicio,
					null,--ie_nao_sabe_fim,
					null,--ie_nao_sabe_ult_dose,
					null,--ie_nega_medicamentos,
					null,--ie_motivo_termino,
					null,--ie_procedencia,
					null,--ie_auto_medicacao,
					null,--nr_seq_assinatura,
					null,--dt_revisao,
					null,--nm_usuario_revisao,
					null,--nr_seq_assinat_inativacao,
					null,--ie_alerta,
					wheb_usuario_pck.get_cd_setor_atendimento,
					null,--cd_setor_revisao,
					null,--nm_usuario_termino,
					null,--ds_just_termino,
					null,--ie_nao_sabe_medicamentos,
					null,--ie_nao_sabe_dose,
					null,--ie_via_aplicacao,
					null,--ds_horarios,
					null,--ds_forma_desc,
					null,--ds_unid_med_desc,
					plano_versao_medic.ie_tipo_medicamento,
					plano_versao_medic.ds_dose_diferenciada,
					plano_versao_medic.ds_princ_ativo,
					plano_versao_medic.ds_potencia,
					plano_versao_medic.ds_horario_especial,
					'S',
					plano_versao_medic.ds_forma_medicamento
				);
				commit;
			end if;
		end loop;
		
	else
		select 	*
		into STRICT	plano_versao_medic_w
		from 	plano_versao_medic
		where	nr_sequencia = nr_seq_plano_versao_medic_p;
		
		select	nextval('paciente_medic_uso_seq')
		into STRICT	nr_seq_paciente_medic_uso_w
		;
		
		if (plano_versao_medic_w.nr_sequencia IS NOT NULL AND plano_versao_medic_w.nr_sequencia::text <> '') then
			select	nr_atendimento
			into STRICT	plano_versao_w.nr_atendimento
			from	plano_versao
			where	nr_sequencia = plano_versao_medic_w.nr_seq_versao;
			
			ie_exibir_plano_medic_w := obter_se_exibe_plano_medic(
											plano_versao_medic_w.ds_descricao_complementar,
											plano_versao_medic_w.ie_classificacao,
											plano_versao_medic_w.cd_material,
											plano_versao_medic_w.qt_dose_manha,
											plano_versao_medic_w.qt_dose_almoco,
											plano_versao_medic_w.qt_dose_tarde,
											plano_versao_medic_w.qt_dose_noite,
											plano_versao_medic_w.cd_unidade_medida,
											plano_versao_medic_w.ds_observacao,
											plano_versao_medic_w.ds_motivo,
											plano_versao_medic_w.ds_horario_especial,
											plano_versao_medic_w.cd_pessoa_fisica,
											plano_versao_medic_w.ds_orientacao,
											plano_versao_medic_w.ds_medicamento,
											plano_versao_medic_w.ds_forma_medicamento,
											plano_versao_medic_w.ds_dose_diferenciada,
											plano_versao_medic_w.ds_potencia,
											plano_versao_medic_w.ds_forma_desc,
											plano_versao_medic_w.ds_unid_med_desc,
											plano_versao_medic_w.ds_princ_ativo);
			
			if (ie_exibir_plano_medic_w <> 'N') then
				insert into paciente_medic_uso(
					nr_sequencia,
					cd_pessoa_fisica,
					dt_registro,
					nm_usuario,
					dt_atualizacao,
					qt_dose_manha,
					qt_dose_almoco,
					qt_dose_tarde,
					qt_dose_noite,
					ds_unidade_medida_consumo,
					ds_descricao_complementar,
					ie_classificacao,
					ds_utc_atualizacao,
					cd_profissional,
					ie_horario_verao,
					ds_motivo,
					nr_seq_versao,
					ds_intervalo_item,
					cd_unidade_medida_plano,
					ds_orientacao,
					ds_unidade_medida_estoque,
					ds_utc,
					cd_material,
					cd_unid_med,
					cd_intervalo,
					qt_dose,
					dt_inicio,
					dt_fim,
					ds_reacao,
					ds_observacao,
					ds_medicamento,
					nr_atendimento,
					ie_intensidade,
					dt_atualizacao_nrec,
					nm_usuario_nrec,		
					nm_usuario_liberacao,
					nr_seq_nivel_seg,
					nr_seq_saep,
					dt_inativacao,
					nm_usuario_inativacao,
					ds_justificativa,
					nr_seq_reg_elemento,
					dt_ultima_dose,
					ie_nao_sabe_inicio,
					ie_nao_sabe_fim,
					ie_nao_sabe_ult_dose,
					ie_nega_medicamentos,
					ie_motivo_termino,
					ie_procedencia,
					ie_auto_medicacao,
					nr_seq_assinatura,
					dt_revisao,
					nm_usuario_revisao,
					nr_seq_assinat_inativacao,
					ie_alerta,
					cd_setor_atendimento,
					cd_setor_revisao,
					nm_usuario_termino,
					ds_just_termino,
					ie_nao_sabe_medicamentos,
					ie_nao_sabe_dose,
					ie_via_aplicacao,
					ds_horarios,
					ds_forma_desc,
					ds_unid_med_desc,
					ie_tipo_medicamento,
					ds_dose_diferenciada,
					ds_princ_ativo,
					ds_potencia,
					ds_horario_especial,
					ie_exibir_plano_medic,
					ds_forma_medicamento)
				values (
					nr_seq_paciente_medic_uso_w,
					plano_versao_medic_w.cd_pessoa_fisica,
					plano_versao_medic_w.dt_registro,
					wheb_usuario_pck.get_nm_usuario,
					clock_timestamp(),
					plano_versao_medic_w.qt_dose_manha,
					plano_versao_medic_w.qt_dose_almoco,
					plano_versao_medic_w.qt_dose_tarde,
					plano_versao_medic_w.qt_dose_noite,
					plano_versao_medic_w.cd_unidade_medida,
					plano_versao_medic_w.ds_descricao_complementar,
					plano_versao_medic_w.ie_classificacao,
					null,
					plano_versao_medic_w.cd_profissional,
					null,--ie_horario_verao,
					plano_versao_medic_w.ds_motivo,
					plano_versao_medic_w.nr_seq_versao,
					plano_versao_medic_w.ds_intervalo_item,
					plano_versao_medic_w.cd_unidade_medida,
					plano_versao_medic_w.ds_orientacao,
					plano_versao_medic_w.cd_unidade_medida,
					null,--ds_utc,
					plano_versao_medic_w.cd_material,
					plano_versao_medic_w.cd_unidade_medida,
					null,--cd_intervalo,
					null,--qt_dose,
					null,--dt_inicio,
					null,--dt_fim,
					null,--ds_reacao,
					plano_versao_medic_w.ds_observacao,
					plano_versao_medic_w.ds_medicamento,
					coalesce(plano_versao_medic_w.nr_atendimento, plano_versao_w.nr_atendimento),
					null,--ie_intensidade,
					clock_timestamp(),
					plano_versao_medic_w.nm_usuario_nrec,		
					wheb_usuario_pck.get_nm_usuario,--nm_usuario_liberacao,
					null,--nr_seq_nivel_seg,
					null,--nr_seq_saep,
					null,--dt_inativacao,
					null,--nm_usuario_inativacao,
					null,--ds_justificativa,
					null,--nr_seq_reg_elemento,
					null,--dt_ultima_dose,
					null,--ie_nao_sabe_inicio,
					null,--ie_nao_sabe_fim,
					null,--ie_nao_sabe_ult_dose,
					null,--ie_nega_medicamentos,
					null,--ie_motivo_termino,
					null,--ie_procedencia,
					null,--ie_auto_medicacao,
					null,--nr_seq_assinatura,
					null,--dt_revisao,
					null,--nm_usuario_revisao,
					null,--nr_seq_assinat_inativacao,
					null,--ie_alerta,
					wheb_usuario_pck.get_cd_setor_atendimento,
					null,--cd_setor_revisao,
					null,--nm_usuario_termino,
					null,--ds_just_termino,
					null,--ie_nao_sabe_medicamentos,
					null,--ie_nao_sabe_dose,
					null,--ie_via_aplicacao,
					null,--ds_horarios,
					null,--ds_forma_desc,
					null,--ds_unid_med_desc,
					plano_versao_medic_w.ie_tipo_medicamento,
					plano_versao_medic_w.ds_dose_diferenciada,
					plano_versao_medic_w.ds_princ_ativo,
					plano_versao_medic_w.ds_potencia,
					plano_versao_medic_w.ds_horario_especial,
					'S',
					plano_versao_medic_w.ds_forma_medicamento
				);
				commit;
				
			end if;
		end if;
	
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_medic_uso ( nr_seq_plano_versao_p bigint, nr_seq_plano_versao_medic_p bigint) FROM PUBLIC;

