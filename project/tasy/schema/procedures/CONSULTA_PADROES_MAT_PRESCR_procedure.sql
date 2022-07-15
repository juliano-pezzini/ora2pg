-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consulta_padroes_mat_prescr ( cd_material_p bigint, cd_estabelecimento_p bigint, ie_via_aplicacao_p INOUT text, cd_setor_atendimento_p bigint, cd_pessoa_fisica_p text, qt_peso_p bigint, ie_se_necessario_p INOUT text, ie_dias_util_medic_p INOUT text, cd_um_consumo_p INOUT text, ie_tipo_material_p INOUT text, ie_disp_infusao_p INOUT text, qt_min_aplic_p INOUT bigint, ds_justificativa_p INOUT text, qt_hor_aplic_p INOUT bigint, qt_solucao_p INOUT bigint, cd_intervalo_p INOUT text, ie_urgente_p INOUT text) AS $body$
DECLARE

						 
qt_idade_w	double precision;

BEGIN
 
 select max(ie_dias_util_medic), 
		max(substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMS'),1,30)) cd_unidade_medida_consumo, 
		max(ie_via_aplicacao), 
		max(ie_tipo_material), 
		max(ie_bomba_infusao), 
		max(Obter_Idade_PF(cd_pessoa_fisica_p, clock_timestamp(), 'A')), 
		coalesce(max(cd_intervalo_padrao), cd_intervalo_p) 
into STRICT	ie_dias_util_medic_p, 
		cd_um_consumo_p, 
		ie_via_aplicacao_p, 
		ie_tipo_material_p, 
		ie_disp_infusao_p, 
		qt_idade_w, 
		cd_intervalo_p 
from	material 
where	cd_material = cd_material_p;
 
select	coalesce(Obter_Padrao_Param_Prescr(null,cd_material_p, ie_via_aplicacao_p, cd_setor_atendimento_p, cd_pessoa_fisica_p, qt_idade_w, qt_peso_p, 'N', 'V', cd_intervalo_p), ie_via_aplicacao_p), 
		coalesce(Obter_Padrao_Param_Prescr(null,cd_material_p, ie_via_aplicacao_p, cd_setor_atendimento_p, cd_pessoa_fisica_p, qt_idade_w, qt_peso_p, 'N', 'DI', cd_intervalo_p), ie_disp_infusao_p), 
		Obter_Padrao_Param_Prescr(null,cd_material_p, ie_via_aplicacao_p, cd_setor_atendimento_p, cd_pessoa_fisica_p, qt_idade_w, qt_peso_p, 'N', 'MA', cd_intervalo_p), 
		Obter_Padrao_Param_Prescr(null,cd_material_p, ie_via_aplicacao_p, cd_setor_atendimento_p, cd_pessoa_fisica_p, qt_idade_w, qt_peso_p, 'N', 'J', cd_intervalo_p), 
		Obter_Padrao_Param_Prescr(null,cd_material_p, ie_via_aplicacao_p, cd_setor_atendimento_p, cd_pessoa_fisica_p, qt_idade_w, qt_peso_p, 'N', 'HA', cd_intervalo_p), 
		Obter_Padrao_Param_Prescr(null,cd_material_p, ie_via_aplicacao_p, cd_setor_atendimento_p, cd_pessoa_fisica_p, qt_idade_w, qt_peso_p, 'N', 'S', cd_intervalo_p), 
		Obter_Padrao_Param_Prescr(null,cd_material_p, ie_via_aplicacao_p, cd_setor_atendimento_p, cd_pessoa_fisica_p, qt_idade_w, qt_peso_p, 'N', 'SN', cd_intervalo_p), 
		Obter_Padrao_Param_Prescr(null,cd_material_p, ie_via_aplicacao_p, cd_setor_atendimento_p, cd_pessoa_fisica_p, qt_idade_w, qt_peso_p, 'N', 'I', cd_intervalo_p), 
		Obter_Padrao_Param_Prescr(null,cd_material_p, ie_via_aplicacao_p, cd_setor_atendimento_p, cd_pessoa_fisica_p, qt_idade_w, qt_peso_p, 'N', 'A', cd_intervalo_p) 
into STRICT	ie_via_aplicacao_p, 
		ie_disp_infusao_p, 
		qt_min_aplic_p, 
		ds_justificativa_p, 
		qt_hor_aplic_p, 
		qt_solucao_p, 
		ie_se_necessario_p, 
		cd_intervalo_p, 
		ie_urgente_p
;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consulta_padroes_mat_prescr ( cd_material_p bigint, cd_estabelecimento_p bigint, ie_via_aplicacao_p INOUT text, cd_setor_atendimento_p bigint, cd_pessoa_fisica_p text, qt_peso_p bigint, ie_se_necessario_p INOUT text, ie_dias_util_medic_p INOUT text, cd_um_consumo_p INOUT text, ie_tipo_material_p INOUT text, ie_disp_infusao_p INOUT text, qt_min_aplic_p INOUT bigint, ds_justificativa_p INOUT text, qt_hor_aplic_p INOUT bigint, qt_solucao_p INOUT bigint, cd_intervalo_p INOUT text, ie_urgente_p INOUT text) FROM PUBLIC;

