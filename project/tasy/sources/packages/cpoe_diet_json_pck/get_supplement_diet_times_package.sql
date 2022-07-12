-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION cpoe_diet_json_pck.get_supplement_diet_times (nr_cpoe_diet_p bigint) RETURNS PHILIPS_JSON_LIST AS $body$
DECLARE

	json_item_w		philips_json;
	json_item_list_w	philips_json_list;
	
	json_component_item_list_w	philips_json_list;	
	json_component_item_w		philips_json;
	
	C01 CURSOR FOR
		SELECT a.NR_SEQUENCIA,
			a.IE_TIPO_DIETA,
			a.DT_INICIO, 
			a.DT_FIM, 
			a.DT_ATUALIZACAO,
			a.IE_DURACAO, 
			a.IE_URGENCIA,
			a.IE_ADMINISTRACAO, 
			a.NR_SEQ_OBJETIVO,
			a.CD_MATERIAL ,
			a.IE_VIA_APLICACAO,
			a.QT_DOSE,
			a.CD_UNIDADE_MEDIDA_DOSE, 
			a.QT_VOLUME_TOTAL,
			a.QT_TEMPO_APLIC,
			a.QT_VEL_INFUSAO,
			a.IE_TIPO_DOSAGEM ,
			a.IE_BOMBA_INFUSAO, 
			a.CD_INTERVALO,
			a.DT_LIBERACAO       requested_date_time, 
			a.DT_LIB_SUSPENSAO   suspended_time, 
			cpoe_obter_dt_suspensao(a.nr_sequencia,'N') dt_suspensao,
			substr(OBTER_DESC_material(a.CD_MATERIAL),1,200) desc_material, 
			obter_conv_envio('CPOE_MATERIAL', 'IE_TIPO_DOSAGEM', a.IE_TIPO_DOSAGEM, 'S')  rate_unit_code_system,
			obter_conv_envio('CPOE_MATERIAL', 'IE_TIPO_DOSAGEM', a.IE_TIPO_DOSAGEM, 'E')  rate_unit_code_value,
			Obter_Descricao_Dominio(93, a.IE_TIPO_DOSAGEM) rate_unit_text,
			obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', a.CD_UNIDADE_MEDIDA_DOSE, 'S')  unidade_medida_code_system,
			obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', a.CD_UNIDADE_MEDIDA_DOSE, 'E')  unidade_medida_code_value, 
			obter_desc_unidade_medida(a.CD_UNIDADE_MEDIDA_DOSE)  unidade_medida_text,
			obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', a.IE_VIA_APLICACAO, 'S')  via_code_system,
			obter_conv_envio('VIA_APLICACAO', 'IE_VIA_APLICACAO', a.IE_VIA_APLICACAO, 'E')  via_code_value, 
			Obter_Desc_via(a.IE_VIA_APLICACAO)   desc_via,
			obter_minutos_hora(a.QT_TEMPO_APLIC)  QT_MINUTE_TEMPO_APLIC,
			obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', 'Min', 'S')  minute_code_system,
			obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', 'Min', 'E')  minute_code_value,
			obter_conv_envio('CPOE_MATERIAL', 'IE_BOMBA_INFUSAO', a.IE_BOMBA_INFUSAO, 'S')  infusion_pump_code_system,
			obter_conv_envio('CPOE_MATERIAL', 'IE_BOMBA_INFUSAO', a.IE_BOMBA_INFUSAO, 'E')  infusion_pump_code_value,
			Obter_Descricao_Dominio(1537, a.IE_BOMBA_INFUSAO) infusion_pump_text,
			-- Diluente
			substr(OBTER_DESC_material(a.CD_MAT_PROD1),1,200) desc_diluente,
			obter_conv_envio('MATERIAL', 'CD_MATERIAL', a.CD_MAT_PROD1, 'E')  dil_code_value,
			obter_conv_envio('MATERIAL', 'CD_MATERIAL', a.CD_MAT_PROD1, 'S')  dil_code_system,
			a.QT_DOSE_PROD1 QT_DOSE_DIL,
			obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', a.CD_UNID_MED_DOSE_DIL, 'S')  unid_dil_code_system,
			obter_conv_envio('UNIDADE_MEDIDA', 'CD_UNIDADE_MEDIDA', a.CD_UNID_MED_DOSE_DIL, 'E')  unid_dil_code_value, 
			obter_desc_unidade_medida(a.CD_UNID_MED_DOSE_DIL)  unid_dil_text,
			-- Diluente
			obter_conv_envio('INTERVALO_PRESCRICAO', 'CD_INTERVALO', a.CD_INTERVALO, 'E')  interval_code_value,     
			CASE WHEN coalesce(a.DS_ORIENTACAO::text, '') = '' THEN ''  ELSE '. ' ||elimina_acentuacao(a.DS_ORIENTACAO) END  DS_ORIENTACAO,  
			CASE WHEN coalesce(a.DS_OBSERVACAO::text, '') = '' THEN ''  ELSE '. ' ||elimina_acentuacao(a.DS_OBSERVACAO) END  DS_OBSERVACAO, 
			CASE WHEN coalesce(a.DS_JUSTIFICATIVA::text, '') = '' THEN ''  ELSE '. ' ||elimina_acentuacao(a.DS_JUSTIFICATIVA) END  DS_JUSTIFICATIVA, 
			a.cd_medico ordering_provider_id_number,
			obter_dados_pf(a.cd_medico,'PNG') ordering_provider_given_name,
			obter_dados_pf(a.cd_medico,'PNL') ordering_provider_last_name,
			obter_dados_pf(a.cd_medico,'PNM') ordering_provider_middle_name, 
			substr(obter_nome_pf(a.cd_medico),1,80) nm_medico_solicitante,
			Obter_Pessoa_Fisica_Usuario(a.nm_usuario_nrec,'C') ordering_user_id_number,
			Obter_Pessoa_Fisica_Usuario(a.nm_usuario_susp,'C') order_prov_susp_id_number,
			obter_conv_envio('MATERIAL', 'CD_MATERIAL', a.CD_MATERIAL, 'E')  code_value,
			obter_conv_envio('MATERIAL', 'CD_MATERIAL', a.CD_MATERIAL, 'S')  code_system
		from CPOE_DIETA a
		where NR_SEQUENCIA = nr_cpoe_diet_p 
		AND IE_TIPO_DIETA = 'S';
		
	
BEGIN
	json_item_list_w	:= philips_json_list();
	
	for r_c01 in c01 loop
		begin
		json_item_w		:= philips_json();
		
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'nrSequencia', r_c01.nr_sequencia);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'ieTipoDieta', r_c01.ie_tipo_dieta);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'dtInicio', r_c01.dt_inicio);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'dtFim', r_c01.dt_fim);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'dtAtualizacao', r_c01.dt_atualizacao);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'ieDuracao', r_c01.ie_duracao);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'ieUrgencia', r_c01.ie_urgencia);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'ieAdministracao', r_c01.ie_administracao);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'nrSeqObjetivo', r_c01.nr_seq_objetivo);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'cdMaterial', r_c01.cd_material);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'ieViaAplicacao', r_c01.ie_via_aplicacao);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'qtDose', r_c01.qt_dose);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'cdUnidadeMedidaDose', r_c01.cd_unidade_medida_dose);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'qtVolumeTotal', r_c01.qt_volume_total);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'qtTempoAplic', r_c01.qt_tempo_aplic);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'qtVelInfusao', r_c01.qt_vel_infusao);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'ieTipoDosagem', r_c01.ie_tipo_dosagem);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'ieBombaInfusao', r_c01.ie_bomba_infusao);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'cdIntervalo', r_c01.cd_intervalo);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'requestedDateTime', r_c01.requested_date_time);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'suspendedTime', r_c01.suspended_time);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'dtSuspensao', r_c01.dt_suspensao);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'descMaterial', r_c01.desc_material);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'rateUnitCodeSystem', r_c01.rate_unit_code_system);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'rateUnitCodeValue', r_c01.rate_unit_code_value);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'rateUnitText', r_c01.rate_unit_text);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'unidadeMedidaCodeSystem', r_c01.unidade_medida_code_system);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'unidadeMedidaCodeValue', r_c01.unidade_medida_code_value);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'unidadeMedidaText', r_c01.unidade_medida_text);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'viaCodeSystem', r_c01.via_code_system);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'viaCodeValue', r_c01.via_code_value);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'descVia', r_c01.desc_via);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'qtMinuteTempoAplic', r_c01.qt_minute_tempo_aplic);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'minuteCodeSystem', r_c01.minute_code_system);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'minuteCodeValue', r_c01.minute_code_value);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'infusionPumpCodeSystem', r_c01.infusion_pump_code_system);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'infusionPumpCodeValue', r_c01.infusion_pump_code_value);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'infusionPumpText', r_c01.infusion_pump_text);
		
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'intervalCodeValue', r_c01.interval_code_value);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'dsOrientacao', r_c01.ds_orientacao);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'dsObservacao', r_c01.ds_observacao);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'dsJustificativa', r_c01.ds_justificativa);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'orderingProviderIdNumber', r_c01.ordering_provider_id_number);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'orderingProviderGivenName', r_c01.ordering_provider_given_name);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'orderingProviderLastName', r_c01.ordering_provider_last_name);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'orderingProviderMiddleName', r_c01.ordering_provider_middle_name);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'nmMedicoSolicitante', r_c01.nm_medico_solicitante);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'orderingUserIdNumber', r_c01.ordering_user_id_number);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'orderProvSuspIdNumber', r_c01.order_prov_susp_id_number);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'codeValue', r_c01.code_value);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'codeSystem', r_c01.code_system);
		
		
		json_component_item_list_w	:= philips_json_list();	
		
		-- Componente principal
		json_component_item_w		:= philips_json();
		json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'componentType', 'A');
		json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'codeValue', r_c01.code_value);
		json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'descMaterial', r_c01.desc_material);
		json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'codeSystem', r_c01.code_system);
		json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'qtDose', r_c01.qt_dose);
		json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'unidadeMedidaCodeValue', r_c01.unidade_medida_code_value);
		json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'unidadeMedidaText', r_c01.unidade_medida_text);
		json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'unidadeMedidaCodeSystem', r_c01.unidade_medida_code_system);
		json_component_item_list_w.append(json_component_item_w.to_json_value());
		
		-- Diluente
		if (r_c01.qt_dose_dil IS NOT NULL AND r_c01.qt_dose_dil::text <> '') then
			json_component_item_w		:= philips_json();
			json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'componentType', 'B');
			json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'codeValue', r_c01.dil_code_value);
			json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'descMaterial', r_c01.desc_diluente);
			json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'codeSystem', r_c01.dil_code_system);
			json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'qtDose', r_c01.qt_dose_dil);
			json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'unidadeMedidaCodeValue', r_c01.unid_dil_code_value);
			json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'unidadeMedidaText', r_c01.unid_dil_text);
			json_component_item_w := cpoe_diet_json_pck.add_json_value(json_component_item_w, 'unidadeMedidaCodeSystem', r_c01.unid_dil_code_system);
			json_component_item_list_w.append(json_component_item_w.to_json_value());
		end if;
		
		json_item_w.put('componentList', json_component_item_list_w.to_json_value());
		
		
		if (r_c01.dt_fim IS NOT NULL AND r_c01.dt_fim::text <> '') then
				json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'numberOfDays', OBTER_DIAS_ENTRE_DATAS(r_c01.dt_inicio, r_c01.dt_fim));
		end if;
		
		if (r_c01.ie_administracao in ('N', 'C')) then
			json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'priority', 'PRN');
		elsif (r_c01.ie_urgencia = '0') then
			json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'priority', 'S');
		elsif (r_c01.ie_urgencia = '5') then
			json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'priority', 'TM5');
		elsif (r_c01.ie_urgencia = '10') then
			json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'priority', 'TM10');
		elsif (r_c01.ie_urgencia = '15') then
			json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'priority', 'TM15');
		else
			json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'priority', 'R');
		end if;

		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'occurrenceDurationId', (r_c01.minute_code_value || r_c01.qt_minute_tempo_aplic));
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'occurrenceDurationCodeSystem', r_c01.minute_code_system);
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'enteredBy', coalesce(r_c01.order_prov_susp_id_number, r_c01.ordering_user_id_number));
		json_item_w := cpoe_diet_json_pck.add_json_value(json_item_w, 'effectiveDate', coalesce(r_c01.suspended_time, r_c01.requested_date_time));

		json_item_list_w.append(json_item_w.to_json_value());
		end;
	end loop;
	
	return json_item_list_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION cpoe_diet_json_pck.get_supplement_diet_times (nr_cpoe_diet_p bigint) FROM PUBLIC;