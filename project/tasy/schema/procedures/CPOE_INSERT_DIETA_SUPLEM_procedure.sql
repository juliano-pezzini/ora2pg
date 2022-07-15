-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_insert_dieta_suplem ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_material_p bigint, qt_dose_p bigint, cd_unidade_medida_dose_p text, ie_via_aplicacao_p text, cd_intervalo_p text, hr_prim_horario_p text, ds_horarios_p text, ie_se_necessario_p text, ie_acm_p text, nr_ocorrencia_p bigint, ds_observacao_p text, ie_bomba_infusao_p text, ie_aplic_bolus_p text, nr_seq_via_acesso_p bigint, qt_vel_infusao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_origem_inf_p text, ie_urgencia_w text, ds_justificativa_p text default null, ie_regra_disp_p text default null) AS $body$
DECLARE


nr_seq_prescricao_w		prescr_material.nr_sequencia%type;
nr_seq_prescricao_dil_w	prescr_material.nr_sequencia%type;
qt_conversao_dose_w		prescr_material.qt_conversao_dose%type;
nr_agrupamento_w		prescr_material.nr_agrupamento%type;
ie_regra_disp_w			prescr_material.ie_regra_disp%type;
qt_material_w			prescr_material.qt_material%type;
qt_unitaria_w			prescr_material.qt_unitaria%type;
qt_total_dispensar_w		prescr_material.qt_total_dispensar%type;
qt_solucao_w			prescr_material.qt_solucao%type;
nr_atendimento_w		prescr_medica.nr_atendimento%type;

cd_unidade_medida_w		unidade_medida.cd_unidade_medida%type;
cd_mat_dil_w			prescr_material.cd_material%type;
qt_dose_dil_w			prescr_material.qt_dose%type;
ds_justificativa_w		prescr_material.ds_justificativa%type;

cd_unidade_medida_dil_w		unidade_medida.cd_unidade_medida%type;

ds_erro_w			varchar(4000);
ds_erro_ex_w			varchar(2000);	

BEGIN


select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_seq_prescricao_w
from	prescr_material
where	nr_prescricao = nr_prescricao_p;

select	coalesce(max(nr_agrupamento),0) + 1
into STRICT	nr_agrupamento_w
from	prescr_material
where	nr_prescricao = nr_prescricao_p;

ie_regra_disp_w			:= 'S';
cd_unidade_medida_w		:= substr(obter_dados_material_estab( cd_material_p, cd_estabelecimento_p ,'UMS'),1,30);
qt_conversao_dose_w		:= coalesce(obter_conversao_unid_med( cd_material_p, cd_unidade_medida_dose_p ),1);

if (qt_conversao_dose_w <= 0) then
	qt_conversao_dose_w := 1;
end if;


qt_unitaria_w			:= dividir( qt_dose_p, qt_conversao_dose_w);

if (lower(cd_unidade_medida_dose_p) = lower(obter_unid_med_usua('ml'))) then
	qt_solucao_w		:= qt_dose_p;
else
	qt_solucao_w		:= obter_conversao_ml( cd_material_p, qt_dose_p, cd_unidade_medida_dose_p );
end if;

qt_material_w	:= qt_unitaria_w;

SELECT * FROM obter_quant_dispensar(	cd_estabelecimento_p, cd_material_p, nr_prescricao_p, nr_seq_prescricao_w, cd_intervalo_p, ie_via_aplicacao_p, qt_unitaria_w, 0, nr_ocorrencia_p, null, ie_origem_inf_p, cd_unidade_medida_dose_p, 0, qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w, ie_se_necessario_p, ie_acm_p ) INTO STRICT qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w;
						
ds_justificativa_w := cpoe_obter_justificativa_item(nr_sequencia_p, cd_material_p,'N');

if (ie_regra_disp_p IS NOT NULL AND ie_regra_disp_p::text <> '') then
	ie_regra_disp_w := ie_regra_disp_p;
end if;
	
insert into prescr_material(
			nr_prescricao,
			nr_sequencia,
			ie_origem_inf,
			dt_atualizacao,
			nm_usuario,
			ie_agrupador,
			nr_agrupamento,
			cd_material,
			qt_dose,
			cd_unidade_medida_dose,
			ie_via_aplicacao,
			cd_intervalo,
			ds_horarios,
			cd_unidade_medida,
			qt_unitaria,
			qt_material,
			qt_conversao_dose,
			qt_total_dispensar,
			ie_se_necessario,
			ie_acm,
			qt_solucao,
			nr_sequencia_diluicao,
			ie_medicacao_paciente,
			ie_suspenso,
			ie_bomba_infusao,
			ie_aplic_bolus,
			cd_perfil_ativo,
			nr_seq_via_acesso,
			ds_observacao,
			qt_vel_infusao,
			ie_regra_disp,
			nr_seq_dieta_cpoe,
			hr_prim_horario,
			nr_ocorrencia,
			ie_urgencia,
			ds_justificativa
	) values (
			nr_prescricao_p,
			nr_seq_prescricao_w,
			ie_origem_inf_p,
			clock_timestamp(),
			nm_usuario_p,
			12,
			nr_agrupamento_w,
			cd_material_p,
			qt_dose_p,
			cd_unidade_medida_dose_p,
			ie_via_aplicacao_p,
			cd_intervalo_p,
			ds_horarios_p,
			cd_unidade_medida_w,
			qt_unitaria_w,
			qt_material_w,
			qt_conversao_dose_w,
			qt_total_dispensar_w,
			ie_se_necessario_p,
			ie_acm_p,
			qt_solucao_w,
			null,
			'N',
			'N',
			ie_bomba_infusao_p,
			ie_aplic_bolus_p,
			cd_perfil_p,
			nr_seq_via_acesso_p,
			ds_observacao_p,
			qt_vel_infusao_p,
			ie_regra_disp_w,
			nr_sequencia_p,
			hr_prim_horario_p,
			nr_ocorrencia_p,
			CASE WHEN coalesce(ie_urgencia_w::text, '') = '' THEN 'N'  ELSE 'S' END ,
			substr(ds_justificativa_p || chr(13) || ds_justificativa_w,1,2000)
	);

commit;
	

	
select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_seq_prescricao_dil_w
from	prescr_material
where	nr_prescricao = nr_prescricao_p;	


select 	max(CD_MAT_PROD1),
	max(QT_DOSE_PROD1),
	max(CD_UNID_MED_DOSE_DIL)	
into STRICT	cd_mat_dil_w,
	qt_dose_dil_w,
	cd_unidade_medida_dil_w
from	cpoe_dieta
where	nr_sequencia = nr_sequencia_p;


if (cd_mat_dil_w IS NOT NULL AND cd_mat_dil_w::text <> '') then

insert into prescr_material(
			nr_prescricao,
			nr_sequencia,
			ie_origem_inf,
			dt_atualizacao,
			nm_usuario,
			ie_agrupador,
			nr_agrupamento,
			cd_material,
			qt_dose,
			cd_unidade_medida_dose,
			ie_via_aplicacao,
			cd_intervalo,
			ds_horarios,
			cd_unidade_medida,
			qt_unitaria,
			qt_material,
			qt_conversao_dose,
			qt_total_dispensar,
			ie_se_necessario,
			ie_acm,
			qt_solucao,
			nr_sequencia_diluicao,
			ie_medicacao_paciente,
			ie_suspenso,
			ie_bomba_infusao,
			ie_aplic_bolus,
			cd_perfil_ativo,
			nr_seq_via_acesso,
			ds_observacao,
			qt_vel_infusao,
			ie_regra_disp,
			nr_seq_dieta_cpoe,
			hr_prim_horario,
			nr_ocorrencia,
			ie_urgencia
	) values (
			nr_prescricao_p,
			nr_seq_prescricao_dil_w,
			ie_origem_inf_p,
			clock_timestamp(),
			nm_usuario_p,
			3,
			nr_agrupamento_w,
			cd_mat_dil_w,
			qt_dose_dil_w,
			cd_unidade_medida_dil_w,
			ie_via_aplicacao_p,
			cd_intervalo_p,
			ds_horarios_p,
			cd_unidade_medida_w,
			qt_unitaria_w,
			qt_material_w,
			qt_conversao_dose_w,
			qt_total_dispensar_w,
			ie_se_necessario_p,
			ie_acm_p,
			qt_solucao_w,
			nr_seq_prescricao_w,
			'N',
			'N',
			ie_bomba_infusao_p,
			ie_aplic_bolus_p,
			cd_perfil_p,
			nr_seq_via_acesso_p,
			ds_observacao_p,
			qt_vel_infusao_p,
			ie_regra_disp_w,
			nr_sequencia_p,
			hr_prim_horario_p,
			nr_ocorrencia_p,
			CASE WHEN coalesce(ie_urgencia_w::text, '') = '' THEN 'N'  ELSE 'S' END 
	);

commit;
end if;

exception when others then

	if (coalesce(nr_prescricao_p,0) > 0) then
		select max(nr_atendimento)
		into STRICT nr_atendimento_w
		from prescr_medica
		where nr_prescricao = nr_prescricao_p;
	end if;
	
	CALL gravar_log_cpoe(substr('CPOE_INSERT_DIETA_SUPLEM EXCEPTION:'|| substr(to_char(sqlerrm),1,2000)
		||'nr_sequencia_p: '||nr_sequencia_p||' nr_prescricao_p :'||nr_prescricao_p||'cd_material_p:'||cd_material_p||'qt_dose_p:'||qt_dose_p
		||'cd_unidade_medida_dose_p:'||cd_unidade_medida_dose_p||'ie_via_aplicacao_p:'||ie_via_aplicacao_p||'cd_intervalo_p:'||cd_intervalo_p
		||'hr_prim_horario_p:'|| hr_prim_horario_p||'ds_horarios_p : '||ds_horarios_p||'ie_se_necessario_p:'||ie_se_necessario_p
		||'ie_acm_p:'||ie_acm_p||'nr_ocorrencia_p:'||nr_ocorrencia_p
		||'ds_observacao_p:'||ds_observacao_p||'ie_bomba_infusao_p:'||ie_bomba_infusao_p||'ie_aplic_bolus_p:'||ie_aplic_bolus_p
		||'nr_seq_via_acesso_p:'||nr_seq_via_acesso_p||'qt_vel_infusao_p:'||qt_vel_infusao_p||'qt_vel_infusao_p:'||qt_vel_infusao_p
		||'cd_estabelecimento_p:'||cd_estabelecimento_p||'cd_perfil_p :'|| cd_perfil_p||'nm_usuario_p:'|| nm_usuario_p||'ie_origem_inf_p:'||ie_origem_inf_p,1,2000),
		nr_atendimento_w, 'N', nr_sequencia_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_insert_dieta_suplem ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_material_p bigint, qt_dose_p bigint, cd_unidade_medida_dose_p text, ie_via_aplicacao_p text, cd_intervalo_p text, hr_prim_horario_p text, ds_horarios_p text, ie_se_necessario_p text, ie_acm_p text, nr_ocorrencia_p bigint, ds_observacao_p text, ie_bomba_infusao_p text, ie_aplic_bolus_p text, nr_seq_via_acesso_p bigint, qt_vel_infusao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_origem_inf_p text, ie_urgencia_w text, ds_justificativa_p text default null, ie_regra_disp_p text default null) FROM PUBLIC;

