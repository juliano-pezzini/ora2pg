-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION recommendation_json_pck.get_recomm_times (nr_cpoe_recomm_p bigint) RETURNS PHILIPS_JSON_LIST AS $body$
DECLARE

	json_item_w		philips_json;
	json_item_list_w	philips_json_list;
	
	C01 CURSOR FOR
		SELECT  a.nr_sequencia prescription_item_sequence,
				a.cd_recomendacao recommendation_code,
				elimina_acentuacao(OBTER_DESC_RECOMENDACAO(a.CD_RECOMENDACAO)) recommendation_name,
				Obter_Pessoa_Fisica_Usuario(a.nm_usuario_nrec,'C') ordering_user_id_number,
				obter_conv_envio('INTERVALO_PRESCRICAO', 'CD_INTERVALO', a.CD_INTERVALO, 'E')  interval_code_value,
				elimina_acentuacao(OBTER_DESC_TOPOGRAFIA(a.NR_SEQ_TOPOGRAFIA))  topography_name,
				a.NR_SEQ_TOPOGRAFIA topography_code,
				CASE WHEN coalesce(a.DS_RECOMENDACAO::text, '') = '' THEN ''  ELSE '. ' ||elimina_acentuacao(a.DS_RECOMENDACAO) END  relevant_clinical_information,
				a.cd_medico ordering_provider_id_number,
				obter_dados_pf(a.cd_medico,'PNG') ordering_provider_given_name,
				obter_dados_pf(a.cd_medico,'PNL') ordering_provider_last_name,
				obter_dados_pf(a.cd_medico,'PNM') ordering_provider_middle_name,
				cpoe_obter_dt_suspensao(nr_sequencia,'R') dt_suspensao,
				Obter_Pessoa_Fisica_Usuario(a.nm_usuario_susp,'C') order_prov_susp_id_number,
				a.dt_liberacao	requested_date_time,
				a.dt_inicio,
				a.dt_fim end_date_time,
				a.dt_lib_suspensao suspended_lib_time,
				substr(obter_nome_pf(a.cd_medico),1,80) nm_medico_solicitante,
				clock_timestamp() actual_date,
				a.ie_urgencia ie_urgencia,
				a.ie_administracao,
				a.dt_atualizacao,
				a.cd_setor_atendimento recomm_department_code,				
				obter_conv_envio('TIPO_RECOMENDACAO', 'CD_TIPO_RECOMENDACAO', a.CD_RECOMENDACAO, 'E')  code_value,
				obter_conv_envio('TIPO_RECOMENDACAO', 'CD_TIPO_RECOMENDACAO', a.CD_RECOMENDACAO, 'S')  code_system
		FROM cpoe_recomendacao a
		WHERE nr_sequencia = nr_cpoe_recomm_p;
		
	
BEGIN
	json_item_list_w	:= philips_json_list();
	
	for r_c01 in c01 loop
		begin
		json_item_w		:= philips_json();
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'prescriptionItemSequence', r_c01.prescription_item_sequence);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'recommendationCode', r_c01.recommendation_code);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'recommendationName', r_c01.recommendation_name);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'orderingProviderIdNumber', r_c01.ordering_provider_id_number);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'intervalCodeValue', r_c01.interval_code_value);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'topographyName', r_c01.topography_name);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'topographyCode', r_c01.topography_code);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'relevantClinicalInformation', r_c01.relevant_clinical_information);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'orderingUserIdNumber', r_c01.ordering_user_id_number);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'orderingProviderGivenName', r_c01.ordering_provider_given_name);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'orderingProviderLastName', r_c01.ordering_provider_last_name);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'orderingProviderMiddleName', r_c01.ordering_provider_middle_name);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'dtSuspensao', r_c01.dt_suspensao);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'orderProvSuspIdNumber', r_c01.order_prov_susp_id_number);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'requestedDateTime', r_c01.requested_date_time);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'dtInicio', r_c01.dt_inicio);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'endDateTime', r_c01.end_date_time);
		
		if (r_c01.end_date_time IS NOT NULL AND r_c01.end_date_time::text <> '') then
				json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'numberOfDays', OBTER_DIAS_ENTRE_DATAS(r_c01.dt_inicio, r_c01.end_date_time));
		end if;
		
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'suspendedLibTime', r_c01.suspended_lib_time);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'nmMedicoSolicitante', r_c01.nm_medico_solicitante);
		
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'actualDate', r_c01.actual_date);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'ieUrgencia', r_c01.ie_urgencia);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'ieDdministracao', r_c01.ie_administracao);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'dtAtualizacao', r_c01.dt_atualizacao);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'recommDepartmentCode', r_c01.recomm_department_code);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'codeValue', r_c01.code_value);
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'codeSystem', r_c01.code_system);
		
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'effectiveDate', coalesce(r_c01.suspended_lib_time, r_c01.requested_date_time));
		
		json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'cdPrescritor', coalesce(r_c01.order_prov_susp_id_number, r_c01.ordering_user_id_number));
		
		if (r_c01.ie_administracao in ('N', 'C')) then
			json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'priority', 'PRN');
		elsif (r_c01.ie_urgencia = '0') then
			json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'priority', 'S');
		elsif (r_c01.ie_urgencia = '5') then
			json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'priority', 'TM5');
		elsif (r_c01.ie_urgencia = '10') then
			json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'priority', 'TM10');
		elsif (r_c01.ie_urgencia = '15') then
			json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'priority', 'TM15');
		else
			json_item_w := recommendation_json_pck.add_json_value(json_item_w, 'priority', 'R');
		end if;
		
		json_item_list_w.append(json_item_w.to_json_value());
		end;
	end loop;
	
	return json_item_list_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION recommendation_json_pck.get_recomm_times (nr_cpoe_recomm_p bigint) FROM PUBLIC;