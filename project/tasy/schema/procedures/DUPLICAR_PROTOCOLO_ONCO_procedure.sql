-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_protocolo_onco ( nr_seq_paciente_p bigint, cd_medico_p text, ie_inativar_ant_p text, cd_setor_p bigint, nm_usuario_p text, nr_seq_paciente_atual_p INOUT bigint, ds_mensagem_p INOUT text) AS $body$
DECLARE


nr_seq_paciente_w		bigint;
cd_pessoa_fisica_w		varchar(10);
cd_protocolo_w			bigint;
nr_seq_medicacao_w		integer;
ie_situacao_prot_w		varchar(1);
ie_situacao_medic_w		varchar(1);
ds_mensagem_w			varchar(32000);
qt_reg_w				smallint;
cd_medico_w				varchar(10);				


BEGIN


select	max(cd_protocolo),
		max(nr_seq_medicacao),
		max(cd_pessoa_fisica)
into STRICT	cd_protocolo_w,
		nr_seq_medicacao_w,
		cd_pessoa_fisica_w
from	paciente_setor
where	nr_seq_paciente	= nr_seq_paciente_p;

cd_medico_w := null;
if (obter_se_medico(cd_medico_p, 'M') = 'S') then
	cd_medico_w := cd_medico_p;
end if;

select	max(coalesce(ie_situacao,'A'))
into STRICT	ie_situacao_prot_w
from	protocolo
where	cd_protocolo	= cd_protocolo_w;

if (ie_situacao_prot_w = 'I') or (ie_situacao_prot_w = 'F') then
	-- O protocolo esta inativo no cadastro.#@#@
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264628);
end if;

select	max(coalesce(ie_situacao,'A'))
into STRICT	ie_situacao_medic_w
from	protocolo_medicacao
where	cd_protocolo	= cd_protocolo_w
and		nr_sequencia	= nr_seq_medicacao_w;

if (ie_situacao_medic_w = 'I') then
	-- A medicacao/subtipo do protocolo esta inativa no cadastro.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(264629);
end if;

select	nextval('paciente_setor_seq')
into STRICT	nr_seq_paciente_w
;

nr_seq_paciente_atual_p := nr_seq_paciente_w;

if (ie_inativar_ant_p = 'Q') then
	ds_mensagem_w := Consistir_inativar_protocolo(cd_pessoa_fisica_w, nr_seq_paciente_w, 'AB', ds_mensagem_w);
	if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then
		ds_mensagem_p := ds_mensagem_w;
		goto final;
	end if;
end if;

insert into paciente_setor(
		nr_seq_paciente,
		cd_estabelecimento,
		cd_pessoa_fisica,
		cd_setor_atendimento,
		cd_protocolo,
		nr_seq_medicacao,
		ie_status,
		dt_atualizacao,
		nm_usuario,
		cd_medico_resp,
		ie_terapia_renal_subst,
		cd_convenio,
		cd_motivo_inativ,
		qt_dias_intervalo,
		nr_ciclos,
		DT_PROTOCOLO,
		nr_seq_acesso,
		qt_peso,
		qt_altura,
		ie_formula_sup_corporea,
		qt_redutor_sc,
		qt_creatinina,
		qt_clearance_creatinina,
		qt_redutor_clcr,
		qt_auc,
		qt_mg_carboplatina,
		pr_reducao,
		qt_tempo_medic,
		ie_l_dl_creatinina,
		ie_finalidade,
		ie_modalidade_trat,
		ie_definicao_trat,
		nr_seq_definidor,
		nr_seq_loco_regional,
		nr_seq_referencia,
		ds_observacao,
		ie_regra_disp)
SELECT	nr_seq_paciente_w,
		cd_estabelecimento,
		cd_pessoa_fisica,
		CASE WHEN cd_setor_p=0 THEN cd_setor_atendimento  ELSE cd_setor_p END ,
		cd_protocolo,
		nr_seq_medicacao,
		'A',
		clock_timestamp(),
		nm_usuario_p,
		cd_medico_w,
		ie_terapia_renal_subst,
		cd_convenio,
		cd_motivo_inativ,
		qt_dias_intervalo,
		nr_ciclos,
		clock_timestamp(),
		nr_seq_acesso,
		qt_peso,
		qt_altura,
		ie_formula_sup_corporea,
		qt_redutor_sc,
		qt_creatinina,
		qt_clearance_creatinina,
		qt_redutor_clcr,
		qt_auc,
		qt_mg_carboplatina,
		pr_reducao,
		qt_tempo_medic,
		ie_l_dl_creatinina,
		ie_finalidade,
		ie_modalidade_trat,
		ie_definicao_trat,
		nr_seq_definidor,
		nr_seq_loco_regional,
		nr_seq_referencia,
		ds_observacao,
		ie_regra_disp
from	paciente_setor
where	nr_seq_paciente	= nr_seq_paciente_p;

insert into paciente_protocolo_soluc(
		nr_seq_paciente,
		nr_seq_solucao,
		nr_agrupamento,
		nm_usuario,
		ie_esquema_alternado,
		ie_calc_aut,
		ie_acm,
		dt_atualizacao,
		ds_dias_aplicacao,
		ds_ciclos_aplicacao,
		cd_intervalo,
		cd_protocolo_adic,
		ds_orientacao,
		ds_solucao,
		ie_bomba_infusao,
		ie_pca_modo_prog,
		ie_pre_medicacao,
		ie_se_necessario,
		ie_solucao_pca,
		ie_tipo_analgesia,
		ie_tipo_dosagem,
		ie_tipo_sol,
		nr_etapas,
		nr_seq_medicacao_adic,
		pr_reducao,
		qt_bolus_pca,
		qt_dosagem,
		qt_dose_ataque,
		qt_dose_inicial_pca,
		qt_hora_fase,
		qt_intervalo_bloqueio,
		qt_limite_quatro_hora,
		qt_solucao_total,
		qt_tempo_aplicacao,
		qt_vol_infusao_pca,
		ie_via_aplicacao,
		nr_seq_ordem_adep)
SELECT	nr_seq_paciente_w,
		nr_seq_solucao,
		nr_agrupamento,
		nm_usuario_p,
		ie_esquema_alternado,
		ie_calc_aut,
		ie_acm,
		clock_timestamp(),
		ds_dias_aplicacao,
		ds_ciclos_aplicacao,
		cd_intervalo,
		cd_protocolo_adic,
		ds_orientacao,
		ds_solucao,
		ie_bomba_infusao,
		ie_pca_modo_prog,
		ie_pre_medicacao,
		ie_se_necessario,
		ie_solucao_pca,
		ie_tipo_analgesia,
		ie_tipo_dosagem,
		ie_tipo_sol,
		nr_etapas,
		nr_seq_medicacao_adic,
		pr_reducao,
		qt_bolus_pca,
		qt_dosagem,
		qt_dose_ataque,
		qt_dose_inicial_pca,
		qt_hora_fase,
		qt_intervalo_bloqueio,
		qt_limite_quatro_hora,
		qt_solucao_total,
		qt_tempo_aplicacao,
		qt_vol_infusao_pca,
		ie_via_aplicacao,
		nr_seq_ordem_adep
from	paciente_protocolo_soluc
where	nr_seq_paciente = nr_seq_paciente_p;

insert into paciente_protocolo_proc(
		cd_procedimento,
		ds_dias_aplicacao,
		dt_atualizacao,
		nm_usuario,
		nr_agrupamento,
		nr_seq_paciente,
		nr_seq_procedimento,
		qt_procedimento,
		ie_lado,
		cd_intervalo,
		ie_se_necessario,
		ie_acm,
		ds_ciclos_aplicacao,
		nr_seq_proc_interno,
		ie_origem_proced
		)
SELECT	cd_procedimento,
		ds_dias_aplicacao,
		clock_timestamp(),
		nm_usuario_p,
		nr_agrupamento,
		nr_seq_paciente_w,
		nr_seq_procedimento,
		qt_procedimento,
		ie_lado,
		cd_intervalo,
		ie_se_necessario,
		ie_acm,
		ds_ciclos_aplicacao,
		nr_seq_proc_interno,
		ie_origem_proced		
from	paciente_protocolo_proc
where	nr_seq_paciente = nr_seq_paciente_p;

insert into paciente_protocolo_medic(
		nr_seq_paciente,
		nr_seq_solucao,
		nr_seq_procedimento,
		nr_seq_material,
		cd_material,
		qt_dose,
		cd_unidade_medida,
		ds_dias_aplicacao,
		dt_atualizacao,
		nm_usuario,
		nr_agrupamento,
		ds_recomendacao,
		ie_via_aplicacao,
		nr_seq_diluicao,
		qt_min_aplicacao,
		ie_bomba_infusao,
		cd_intervalo,
		qt_hora_aplicacao,
		qt_dias_util,
		nr_seq_interno,
		ie_se_necessario,
		ie_aplic_lenta,
		ie_urgencia,
		ie_aplic_bolus ,
		ie_pre_medicacao,
		ie_local_adm,
		ie_uso_continuo,
		ie_agrupador,
		ie_aplica_reducao,
		ie_gerar_solucao,
		ie_tipo_dosagem,
		cd_unid_med_prescr,
		ds_ciclos_aplicacao,
		qt_dias_receita,
		ds_justificativa,
		ie_objetivo,
		cd_topografia_cih,
		cd_amostra_cih,
		cd_microorganismo_cih,
		ie_origem_infeccao,
		nr_seq_medic_material,
		qt_dose_prescr,
		nr_seq_ordem_adep,
		cd_unid_medida_ref,
		qt_dose_ref)
SELECT	nr_seq_paciente_w,
		nr_seq_solucao,
		nr_seq_procedimento,
		nr_seq_material,
		cd_material,
		qt_dose,
		cd_unidade_medida,
		ds_dias_aplicacao,
		dt_atualizacao,
		nm_usuario,
		nr_agrupamento,
		ds_recomendacao,
		ie_via_aplicacao,
		nr_seq_diluicao,
		qt_min_aplicacao,
		ie_bomba_infusao,
		cd_intervalo,
		qt_hora_aplicacao,
		qt_dias_util,
		nextval('paciente_protocolo_medic_seq'),
		ie_se_necessario,
		ie_aplic_lenta,
		ie_urgencia,
		ie_aplic_bolus,
		ie_pre_medicacao,
		ie_local_adm,
		ie_uso_continuo,
		ie_agrupador,
		ie_aplica_reducao,
		ie_gerar_solucao,
		ie_tipo_dosagem,
		cd_unid_med_prescr,
		ds_ciclos_aplicacao,
		qt_dias_receita,
		ds_justificativa,
		ie_objetivo,
		cd_topografia_cih,
		cd_amostra_cih,
		cd_microorganismo_cih,
		ie_origem_infeccao,
		nr_seq_medic_material,
		qt_dose_prescr,
		nr_seq_ordem_adep,
		cd_unid_medida_ref,
		qt_dose_ref
from	paciente_protocolo_medic
where	nr_seq_paciente	= nr_seq_paciente_p;

insert into paciente_setor_convenio(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		cd_convenio,
		cd_categoria,
		cd_plano,
		cd_usuario_convenio,
		nr_seq_paciente,
		ie_tipo_atendimento,
		nr_doc_convenio)
SELECT	nextval('paciente_setor_convenio_seq'),
		clock_timestamp(),
		nm_usuario,
		cd_convenio,
		cd_categoria,
		cd_plano,
		cd_usuario_convenio,
		nr_seq_paciente_w,
		ie_tipo_atendimento,
		nr_doc_convenio
from	paciente_setor_convenio
where	nr_seq_paciente = nr_seq_paciente_p;

if (ie_inativar_ant_p = 'S') then

	update	paciente_setor
	set		ie_status = 'I'
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and		ie_status 			<> 'F'
	and		nr_seq_paciente		<> nr_seq_paciente_w;

elsif (ie_inativar_ant_p = 'M') and (cd_protocolo_w IS NOT NULL AND cd_protocolo_w::text <> '') and (nr_seq_medicacao_w IS NOT NULL AND nr_seq_medicacao_w::text <> '') then

	update	paciente_setor
	set		ie_status = 'I'
	where	cd_pessoa_fisica = cd_pessoa_fisica_w
	and		nr_seq_paciente <> nr_seq_paciente_w
	and		nr_seq_medicacao = nr_seq_medicacao_w
	and		ie_status <> 'F'
	and		cd_protocolo = 	cd_protocolo_w;

elsif ( ie_inativar_ant_p = 'T') then

	ds_mensagem_w := Consistir_inativar_protocolo(cd_pessoa_fisica_w, nr_seq_paciente_w, 'I', ds_mensagem_w);

end if;

commit;

<<Final>>

qt_reg_w := 0;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_protocolo_onco ( nr_seq_paciente_p bigint, cd_medico_p text, ie_inativar_ant_p text, cd_setor_p bigint, nm_usuario_p text, nr_seq_paciente_atual_p INOUT bigint, ds_mensagem_p INOUT text) FROM PUBLIC;
