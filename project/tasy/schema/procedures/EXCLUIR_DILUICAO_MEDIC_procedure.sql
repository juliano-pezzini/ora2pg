-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_diluicao_medic ( nr_prescricao_p bigint, nr_seq_material_p bigint) AS $body$
DECLARE

						 
nr_atendimento_w			prescr_medica.nr_atendimento%type;
cd_setor_atendimento_w 		prescr_medica.cd_setor_atendimento%type;
cd_pessoa_fisica_w 			prescr_medica.cd_pessoa_fisica%type;
qt_peso_w					prescr_medica.qt_peso%type;

cd_material_w 				prescr_material.cd_material%type;
ie_via_w 					prescr_material.ie_via_aplicacao%type;
cd_intervalo_w		 		prescr_material.cd_intervalo%type;
qt_hora_aplicacao_w 		prescr_material.qt_hora_aplicacao%type;
qt_min_aplicacao_w 			prescr_material.qt_min_aplicacao%type;
qt_solucao_w 				prescr_material.qt_solucao%type;
ie_bomba_infusao_w			prescr_material.ie_bomba_infusao%type;
nr_seq_diluicao_w			prescr_material.nr_sequencia%type;
			
qt_idade_w 					bigint;			

BEGIN 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then 
	 
	select 	max(nr_sequencia) 
	into STRICT	nr_seq_diluicao_w 
	from	prescr_material 
	where	nr_prescricao = nr_prescricao_p 
	and		nr_sequencia_diluicao = nr_seq_material_p 
	and		ie_agrupador = 3;
	 
	delete	FROM prescr_material 
	where	nr_prescricao = nr_prescricao_p 
	and		nr_seq_kit = nr_seq_diluicao_w;
	 
	delete	FROM prescr_material 
	where	nr_prescricao = nr_prescricao_p 
	and		nr_sequencia_diluicao = nr_seq_material_p 
	and		ie_agrupador = 3;
 
	delete	FROM prescr_mat_diluicao 
	where	nr_prescricao = nr_prescricao_p 
	and		nr_seq_material = nr_seq_material_p;
	 
	Select	coalesce(max(nr_atendimento),0), 
			coalesce(max(cd_setor_atendimento),0), 
			coalesce(max(cd_pessoa_fisica),''), 
			coalesce(max(Obter_Idade_PF(cd_pessoa_fisica, clock_timestamp(), 'A')),0), 
			coalesce(max(qt_peso),0) 
	into STRICT 	nr_atendimento_w, 
			cd_setor_atendimento_w, 
			cd_pessoa_fisica_w, 
			qt_idade_w, 
			qt_peso_w 
	from  	prescr_medica 
	where 	nr_prescricao = nr_prescricao_p;
	 
	select 	coalesce(max(cd_material),0), 
			coalesce(max(ie_via_aplicacao),''), 
			coalesce(max(cd_intervalo),''), 
			coalesce(max(ie_bomba_infusao),'') 
	into STRICT	cd_material_w, 
			ie_via_w, 
			cd_intervalo_w, 
			ie_bomba_infusao_w 
	from	prescr_material 
	where	nr_prescricao = nr_prescricao_p 
	and		nr_sequencia = nr_seq_material_p;
	 
	qt_hora_aplicacao_w := Obter_Padrao_Param_Prescr(nr_atendimento_w,cd_material_w,ie_via_w,cd_setor_atendimento_w,cd_pessoa_fisica_w,qt_idade_w,qt_peso_w,'N','HA', cd_intervalo_w);
	qt_min_aplicacao_w	:= Obter_Padrao_Param_Prescr(nr_atendimento_w,cd_material_w,ie_via_w,cd_setor_atendimento_w,cd_pessoa_fisica_w,qt_idade_w,qt_peso_w,'N','MA', cd_intervalo_w);	
	qt_solucao_w		:= Obter_Padrao_Param_Prescr(nr_atendimento_w,cd_material_w,ie_via_w,cd_setor_atendimento_w,cd_pessoa_fisica_w,qt_idade_w,qt_peso_w,'N','S', cd_intervalo_w);
 
	update	prescr_material 
	set		qt_hora_aplicacao = qt_hora_aplicacao_w, 
			qt_min_aplicacao = qt_min_aplicacao_w, 
			qt_solucao = qt_solucao_w, 
			ds_diluicao_edit  = NULL 
	where	nr_prescricao = nr_prescricao_p 
	and		nr_sequencia = nr_seq_material_p;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_diluicao_medic ( nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

