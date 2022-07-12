-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clinical_notes_pck.get_soap_emerg_dept ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type_p text, ie_stage_p bigint) RETURNS varchar AS $body$
DECLARE

    ds_content_w varchar(32000);
    cd_med_dept_w varchar(255);
cd_ward_w varchar(255);
cd_visi_classif_w varchar(255);
cd_classif_w varchar(255);
cd_prior_loc_w varchar(255);
cd_priority_w varchar(255);
cd_arrival_meth_w varchar(255);
cd_doctor_w varchar(255);
cd_counsel_prim_w varchar(255);
cd_counsel_sec_w varchar(255);
ds_complain_w varchar(255);
ds_queixa_princ_w varchar(255);
dt_triage_start_w  varchar(255);
ds_observacao_w   varchar(255);
    c01 CURSOR FOR
    SELECT *
    from table(clinical_notes_pck.get_clinical_note_rule(nr_atendimento_p,ie_record_type_p,null,ie_soap_type_p,ie_stage_p));

BEGIN
 select (select ds_depto from depto_medico x where x.nr_sequencia=cd_depart_medico),
(select ds_setor_atendimento from setor_atendimento x where x.cd_setor_atendimento=a.cd_setor_atendimento),
obter_valor_dominio(1006, nr_seq_vis_classif),
(select ds_classificacao from triagem_classif_risco x where x.nr_sequencia=nr_seq_classif),
(select ds_procedencia from procedencia x where x.cd_procedencia=a.cd_procedencia),
(select ds_classificacao from triagem_classif_prioridade x where x.nr_sequencia =nr_seq_triagem_prioridade),
(select ds_forma from forma_chegada x where x.nr_sequencia= cd_chegada_metodo),
obter_nome_pf(cd_medico) ,
obter_nome_pf(cd_prim_con_med),
obter_nome_pf(cd_sec_con_med),
ds_observacao,
ds_queixa_princ,
pkg_date_formaters.to_varchar(a.dt_inicio_triagem, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)

into STRICT
cd_med_dept_w,
cd_ward_w,
cd_visi_classif_w,
cd_classif_w,
cd_prior_loc_w,
cd_priority_w,
cd_arrival_meth_w,
cd_doctor_w,
cd_counsel_prim_w,
cd_counsel_sec_w,
ds_complain_w,
ds_queixa_princ_w,
dt_triage_start_w
from triagem_pronto_atend a where nr_sequencia=nr_sequencia_p;
    for r_c01 in c01 loop
    if (ie_record_type_p = 'EMERG_SERV_CONS') then
        if (r_c01.ie_field    = 'CD_ARRIVAL_METH' and (cd_arrival_meth_w IS NOT NULL AND cd_arrival_meth_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w    := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w    := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_arrival_meth_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_arrival_meth_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_CLASSIF' and (cd_classif_w IS NOT NULL AND cd_classif_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_classif_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_classif_w;
          end if;
        end if;
		if (r_c01.ie_field   = 'DS_COMPLAIN' and (ds_queixa_princ_w IS NOT NULL AND ds_queixa_princ_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_queixa_princ_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_queixa_princ_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_COUNSEL_PRIM' and (cd_counsel_prim_w IS NOT NULL AND cd_counsel_prim_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_counsel_prim_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_counsel_prim_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_COUNSEL_SEC' and (cd_counsel_sec_w IS NOT NULL AND cd_counsel_sec_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_counsel_sec_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_counsel_sec_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_DOCTOR' and (cd_doctor_w IS NOT NULL AND cd_doctor_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_doctor_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_doctor_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_MED_DEPT' and (cd_med_dept_w IS NOT NULL AND cd_med_dept_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_med_dept_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_med_dept_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_PRIORITY' and (cd_priority_w IS NOT NULL AND cd_priority_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_priority_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_priority_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_PRIOR_LOC' and (cd_prior_loc_w IS NOT NULL AND cd_prior_loc_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_prior_loc_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_prior_loc_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'CD_VISI_CLASSIF' and (cd_visi_classif_w IS NOT NULL AND cd_visi_classif_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_visi_classif_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_visi_classif_w;
          end if;
        end if;
		if (r_c01.ie_field   = 'CD_WARD' and (cd_ward_w IS NOT NULL AND cd_ward_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_ward_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_ward_w;
          end if;
        end if;
		if (r_c01.ie_field   = 'DS_NOTES' and (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_observacao_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_observacao_w;
          end if;
        end if;
		if (r_c01.ie_field   = 'DT_TRIAGE_START' and (dt_triage_start_w IS NOT NULL AND dt_triage_start_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1042365) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| dt_triage_start_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| dt_triage_start_w;
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
-- REVOKE ALL ON FUNCTION clinical_notes_pck.get_soap_emerg_dept ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type_p text, ie_stage_p bigint) FROM PUBLIC;
