-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clinical_notes_pck.get_soap_nut_guidance ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_record_sub_type_p text, ie_soap_type_p text, ie_stage_p bigint) RETURNS varchar AS $body$
DECLARE

ds_content_w varchar(32000);
clinical_note_fields CURSOR FOR
SELECT *
from table(clinical_notes_pck.get_clinical_note_rule(nr_atendimento_p,ie_record_type_p,ie_record_sub_type_p,ie_soap_type_p,ie_stage_p));

/*Nutritional guidance - Accept and execute */

c01 CURSOR FOR
SELECT obter_valor_dominio(9900,a.ie_status) ds_status_w,
pkg_date_formaters.to_varchar(a.dt_orient_nut,'timestamp',wheb_usuario_pck.get_cd_estabelecimento,wheb_usuario_pck.get_nm_usuario) dt_request_w,
pkg_date_formaters.to_varchar(a.dt_nut_guidance,'timestamp',wheb_usuario_pck.get_cd_estabelecimento,wheb_usuario_pck.get_nm_usuario) dt_guidance_w,
obter_nome_departamento_medico(obter_departamento_setor(a.cd_setor_atendimento)) ds_med_dept,
obter_descricao_dominio(10132, coalesce(a.ie_cont_orient,cng.ie_guidance_count)) nr_count_guid_w,
obter_descricao_dominio(6, coalesce(cng.ie_continuous_guidance,'N')) ds_cont_guidance_w,
coalesce(d2.ds_doenca_cid,d.ds_doenca_cid) ds_doenca_cid,
a.ds_amount_exercise ds_amount_exercise_w,
obter_desc_expressao(CASE WHEN a.ie_guidance_fee='S' THEN 283205  ELSE 1048322 END ) ds_guidance_fee_w,
cr.ds_classificacao ds_classificaca_w,
substr(obter_nome_medico_eup(a.cd_medico_resp, obter_estabelecimento_ativo),1,255) nm_medico_resp_w,
tr.ds_tipo_recomendacao ds_tipo_recomendacao_w,
obter_descricao_dominio(9901, cr.ie_forma_servico) ds_guidance_type_w,
clinical_notes_pck.get_nutritional_guidance(a.nr_seq_recomendacao) ds_guidance_w,
(select max(ds_local_atendimento) from nut_local_atendimento where nr_sequencia = a.cd_nut_location) ds_loc_execution_w,
(select ds_parentesco from grau_parentesco where nr_sequencia = a.cd_companion)ds_companion_w,
cpoe_get_list_of_comments(a.nr_seq_recomendacao, 'CPOE_RECOMENDACAO','DC', null) txt_comment_std
from nut_orientacao_list a
left join cpoe_recomendacao cpr on cpr.nr_sequencia = a.nr_seq_recomendacao
left join recomendacao_doenca rd on rd.nr_seq_recomendacao = cpr.nr_sequencia
left join departamento_medico dpm on dpm.cd_departamento = obter_departamento_setor(a.cd_setor_atendimento)
left join cid_doenca d on d.cd_doenca_cid = rd.cd_doenca_cid
left join cid_doenca d2 on d2.cd_doenca_cid = a.cd_doenca_cid
left join tipo_recomendacao tr on tr.cd_tipo_recomendacao = a.cd_tipo_recomendacao
left join classificacao_recomendacao cr on cr.nr_sequencia = tr.nr_seq_classif
left join setor_atendimento sa on sa.cd_setor_atendimento = a.cd_setor_atendimento
left join cpoe_nut_guidance cng on (cng.nr_seq_recomendacao = a.nr_seq_recomendacao and coalesce(cng.ie_cpoe_rec, 'S') = 'S')
left join nutritional_guidance_pat ngp on ngp.nr_sequencia = cng.nr_seq_nut_guidance
where coalesce(tr.ie_nutritional_guidance,'N') = 'S'
and a.nr_sequencia = nr_sequencia_p;

/*Nutritional guidance - Report */

c02 CURSOR FOR
SELECT pkg_date_formaters.to_varchar(a.dt_nut_guidance,'timestamp',wheb_usuario_pck.get_cd_estabelecimento,wheb_usuario_pck.get_nm_usuario) dt_guidance_w,
pkg_date_formaters.to_varchar(a.dt_report,'timestamp',wheb_usuario_pck.get_cd_estabelecimento,wheb_usuario_pck.get_nm_usuario) dt_report_w,
Obter_Pf_Usuario(a.nm_usuario_rep,'N')nm_reporter_w,
clinical_notes_pck.get_nutritional_guidance(a.nr_seq_recomendacao) ds_guidance_w
from nut_orientacao_list a
left join cpoe_recomendacao cpr on cpr.nr_sequencia = a.nr_seq_recomendacao
left join recomendacao_doenca rd on rd.nr_seq_recomendacao = cpr.nr_sequencia
left join departamento_medico dpm on dpm.cd_departamento = obter_departamento_setor(a.cd_setor_atendimento)
left join cid_doenca d on d.cd_doenca_cid = rd.cd_doenca_cid
left join cid_doenca d2 on d2.cd_doenca_cid = a.cd_doenca_cid
left join tipo_recomendacao tr on tr.cd_tipo_recomendacao = a.cd_tipo_recomendacao
left join classificacao_recomendacao cr on cr.nr_sequencia = tr.nr_seq_classif
left join setor_atendimento sa on sa.cd_setor_atendimento = a.cd_setor_atendimento
left join cpoe_nut_guidance cng on (cng.nr_seq_recomendacao = a.nr_seq_recomendacao and coalesce(cng.ie_cpoe_rec, 'S') = 'S')
left join nutritional_guidance_pat ngp on ngp.nr_sequencia = cng.nr_seq_nut_guidance
where coalesce(tr.ie_nutritional_guidance,'N') = 'S'
and a.nr_sequencia = nr_sequencia_p;



BEGIN
   if ( ie_record_type_p ='NUT_GUIDANCE' and ie_record_sub_type_p = '2') then
    for r_c01 in c01
	loop
      for r_clinical_note_fields in clinical_note_fields loop
        begin
              if (r_clinical_note_fields.ie_field = 'DT_REQUEST' and (r_c01.dt_request_w IS NOT NULL AND r_c01.dt_request_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.dt_request_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.dt_request_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DT_GUIDANCE' and (r_c01.dt_guidance_w IS NOT NULL AND r_c01.dt_guidance_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.dt_guidance_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.dt_guidance_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DS_LOCATION' and (r_c01.ds_loc_execution_w IS NOT NULL AND r_c01.ds_loc_execution_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_loc_execution_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_loc_execution_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DS_COMPANION' and (r_c01.ds_companion_w IS NOT NULL AND r_c01.ds_companion_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_companion_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_companion_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'NR_COUNT_GUID' and (r_c01.nr_count_guid_w IS NOT NULL AND r_c01.nr_count_guid_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.nr_count_guid_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.nr_count_guid_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'IE_CONT_GUID' and (r_c01.ds_cont_guidance_w IS NOT NULL AND r_c01.ds_cont_guidance_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_cont_guidance_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_cont_guidance_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DS_DOENCA' and (r_c01.ds_doenca_cid IS NOT NULL AND r_c01.ds_doenca_cid::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_doenca_cid;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_doenca_cid;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DS_AMOUNT_EXER' and (r_c01.ds_amount_exercise_w IS NOT NULL AND r_c01.ds_amount_exercise_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_amount_exercise_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_amount_exercise_w;
                end if;
              end;
			  end if;
              if (r_clinical_note_fields.ie_field = 'DS_GUID_FEE' and (r_c01.ds_guidance_fee_w IS NOT NULL AND r_c01.ds_guidance_fee_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_fee_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_fee_w;
                end if;
              end;
			  end if;
              if (r_clinical_note_fields.ie_field = 'DS_CLASSIFICACA' and (r_c01.ds_classificaca_w IS NOT NULL AND r_c01.ds_classificaca_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_classificaca_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_classificaca_w;
                end if;
              end;
			  end if;
              if (r_clinical_note_fields.ie_field = 'NM_PHYSICIAN' and (r_c01.nm_medico_resp_w IS NOT NULL AND r_c01.nm_medico_resp_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.nm_medico_resp_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.nm_medico_resp_w;
                end if;
              end;
			  end if;
              if (r_clinical_note_fields.ie_field = 'DS_TIPO_RECOMND' and (r_c01.ds_tipo_recomendacao_w IS NOT NULL AND r_c01.ds_tipo_recomendacao_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_tipo_recomendacao_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_tipo_recomendacao_w;
                end if;
              end;
			  end if;
              if (r_clinical_note_fields.ie_field = 'GUIDANCE_STATUS' and (r_c01.ds_status_w IS NOT NULL AND r_c01.ds_status_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_status_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_status_w;
                end if;
              end;
			  end if;
              if (r_clinical_note_fields.ie_field = 'MED_DEPT' and (r_c01.ds_med_dept IS NOT NULL AND r_c01.ds_med_dept::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_med_dept;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_med_dept;
                end if;
              end;
			  end if;
              if (r_clinical_note_fields.ie_field = 'GUIDANCE_TYPE' and (r_c01.ds_guidance_type_w IS NOT NULL AND r_c01.ds_guidance_type_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_type_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_type_w;
                end if;
              end;
			  end if;
              if (r_clinical_note_fields.ie_field = 'GUIDANCE_PATRN' and (r_c01.ds_guidance_w IS NOT NULL AND r_c01.ds_guidance_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1046730) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_w;
                end if;
              end;
			  end if;
        end;
      end loop;
	  end loop;
    elsif ( ie_record_type_p ='NUT_GUIDANCE' and ie_record_sub_type_p = '1') then
    for r_c01 in c01 loop
      for r_clinical_note_fields in clinical_note_fields loop
        begin

              if (r_clinical_note_fields.ie_field = 'NM_GUIDANCE' and (r_c01.ds_guidance_w IS NOT NULL AND r_c01.ds_guidance_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DT_APPOINTMENT' and (r_c01.dt_guidance_w IS NOT NULL AND r_c01.dt_guidance_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.dt_guidance_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.dt_guidance_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DS_DOENCA' and (r_c01.ds_doenca_cid IS NOT NULL AND r_c01.ds_doenca_cid::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_doenca_cid;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_doenca_cid;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DS_GUID_FEE' and (r_c01.ds_guidance_fee_w IS NOT NULL AND r_c01.ds_guidance_fee_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_fee_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_fee_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'NR_COUNT_GUID' and (r_c01.nr_count_guid_w IS NOT NULL AND r_c01.nr_count_guid_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.nr_count_guid_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.nr_count_guid_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DS_COMMENTS' and (r_c01.txt_comment_std IS NOT NULL AND r_c01.txt_comment_std::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.txt_comment_std;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.txt_comment_std;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'GUIDANCE_STATUS' and (r_c01.ds_status_w IS NOT NULL AND r_c01.ds_status_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_status_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_status_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'MED_DEPT' and (r_c01.ds_med_dept IS NOT NULL AND r_c01.ds_med_dept::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_med_dept;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_med_dept;
                end if;
              end;
			  end if;
              if (r_clinical_note_fields.ie_field = 'GUIDANCE_TYPE' and (r_c01.ds_guidance_type_w IS NOT NULL AND r_c01.ds_guidance_type_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_type_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.ds_guidance_type_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'NM_PHYSICIAN' and (r_c01.nm_medico_resp_w IS NOT NULL AND r_c01.nm_medico_resp_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1044995) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.nm_medico_resp_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c01.nm_medico_resp_w;
                end if;
              end;
			  end if;
        end;
      end loop;
	  end loop;
    elsif ( ie_record_type_p ='NUT_GUIDANCE' and ie_record_sub_type_p = '3') then
    for r_c02 in c02 loop
      for r_clinical_note_fields in clinical_note_fields loop
        begin

              if (r_clinical_note_fields.ie_field = 'NM_GUIDANCE' and (r_c02.ds_guidance_w IS NOT NULL AND r_c02.ds_guidance_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1067284) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c02.ds_guidance_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c02.ds_guidance_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DT_GUIDANCE' and (r_c02.dt_guidance_w IS NOT NULL AND r_c02.dt_guidance_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1067284) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c02.dt_guidance_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c02.dt_guidance_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DT_REPORT' and (r_c02.dt_report_w IS NOT NULL AND r_c02.dt_report_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1067284) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c02.dt_report_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c02.dt_report_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'NM_REPORTER' and (r_c02.nm_reporter_w IS NOT NULL AND r_c02.nm_reporter_w::text <> '')) then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1067284) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c02.nm_reporter_w;
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - '|| r_c02.nm_reporter_w;
                end if;
              end;
			  end if;
			  if (r_clinical_note_fields.ie_field = 'DS_REPORT') then
              begin
                if ( coalesce(ds_content_w::text, '') = '' ) then
                  ds_content_w    := '<b>' || obter_desc_expressao(1067284) || '</b>';
                  ds_content_w    := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - ';
                else
                  ds_content_w := ds_content_w|| '</br>' || coalesce(r_clinical_note_fields.nm_field,r_clinical_note_fields.ds_expressao) || ' - ';
                end if;
              end;
			  end if;
        end;
      end loop;
	  end loop;
    end if;
    return ds_content_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION clinical_notes_pck.get_soap_nut_guidance ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_record_sub_type_p text, ie_soap_type_p text, ie_stage_p bigint) FROM PUBLIC;
