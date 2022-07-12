-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clinical_notes_pck.get_soap_med_discharge ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type_p text, ie_stage_p bigint) RETURNS varchar AS $body$
DECLARE

    ds_content_w varchar(32000);
    ds_alta_medica_w varchar(255);
    ds_motivo_alta_w varchar(255);
	ds_seq_classif_medico_w varchar(255);
    ds_probabilidade_alta_w varchar(255);
    ds_previsto_alta_w varchar(255);
    ds_observacao_w varchar(255);
    ds_dias_prev_alta_w varchar(255);
    ds_suspencao_dieta_w varchar(255);
    ds_classif_susp_dieta_w varchar(255);
    cd_process_dsch varchar(255);
	ds_hopsital_discharge varchar(255);
    c01 CURSOR FOR
    SELECT *
    from table(clinical_notes_pck.get_clinical_note_rule(nr_atendimento_p,ie_record_type_p,null,ie_soap_type_p,ie_stage_p));

BEGIN
	select
    pkg_date_formaters.to_varchar(a.dt_alta_medica, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),
    (select	ds_motivo_alta from	motivo_alta x where	x.cd_motivo_alta =a.cd_motivo_alta),
    ( select ds_classificacao from	medico_classif_atend x where x.nr_sequencia= a.nr_seq_classif_medico),
    obter_valor_dominio(1267, a.ie_probabilidade_alta) ,
    pkg_date_formaters.to_varchar(a.dt_previsto_alta, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),
    a.nr_dias_prev_alta,
    (SELECT max(z.ds_intervalo) FROM intervalo_prescricao z WHERE z.ds_horarios = a.IE_REFEICAO),
    pkg_date_formaters.to_varchar(a.DT_SUSPENCAO_DIETA, 'shortDate', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),
    (select max(x.nm_processo) from	processo x where x.cd_processo = a.CD_PROCESSO_ALTA),
    a.DS_OBSERVACAO,
    obter_valor_dominio(6,a.ie_alta_hospitalar)
    into STRICT
    ds_alta_medica_w,
    ds_motivo_alta_w ,
    ds_seq_classif_medico_w,
    ds_probabilidade_alta_w,
    ds_previsto_alta_w ,
    ds_dias_prev_alta_w ,
    ds_classif_susp_dieta_w,
    ds_suspencao_dieta_w,
    cd_process_dsch,
    ds_observacao_w,
    ds_hopsital_discharge
    from atend_previsao_alta a where a.nr_sequencia = nr_sequencia_p;
	for r_c01 in c01 loop
    if (ie_record_type_p = 'MED_DSCHG_REQ') then
        if (r_c01.ie_field    = 'DT_DISCHARGE' and (ds_alta_medica_w IS NOT NULL AND ds_alta_medica_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w    := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w    := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_alta_medica_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_alta_medica_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_REASON_DSCHG' and (ds_motivo_alta_w IS NOT NULL AND ds_motivo_alta_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_motivo_alta_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_motivo_alta_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_MED_PERF_CLS' and (ds_seq_classif_medico_w IS NOT NULL AND ds_seq_classif_medico_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_seq_classif_medico_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_seq_classif_medico_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_PROB_DSCHG' and (ds_probabilidade_alta_w IS NOT NULL AND ds_probabilidade_alta_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_probabilidade_alta_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_probabilidade_alta_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DT_ESTIMATED' and (ds_previsto_alta_w IS NOT NULL AND ds_previsto_alta_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_previsto_alta_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_previsto_alta_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_SUSP_MEAL' and (ds_classif_susp_dieta_w IS NOT NULL AND ds_classif_susp_dieta_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_classif_susp_dieta_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_classif_susp_dieta_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'NR_EST_DAYS' and (ds_dias_prev_alta_w IS NOT NULL AND ds_dias_prev_alta_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_dias_prev_alta_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_dias_prev_alta_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DT_SUSP_MEALS' and (ds_suspencao_dieta_w IS NOT NULL AND ds_suspencao_dieta_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_suspencao_dieta_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_suspencao_dieta_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DS_NOTES' and (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_observacao_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_observacao_w;
          end if;
        end if;
		if (r_c01.ie_field   = 'IE_HOSP_DSCHG' and (ds_hopsital_discharge IS NOT NULL AND ds_hopsital_discharge::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1048603) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_hopsital_discharge;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_hopsital_discharge;
          end if;
        end if;
        end if;
    end loop;
    return ds_content_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION clinical_notes_pck.get_soap_med_discharge ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type_p text, ie_stage_p bigint) FROM PUBLIC;
